//
//  GameViewController.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//


#import "GameViewController.h"
#import "FacebookMessengerHelper.h"
#import "MessageGenerator.h"
#import "MessengerMessage.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>



@implementation GameViewController


const int WIDTH = 320;
const int HEIGHT = 320;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add Share button
//    //Define the size of the circular button at creation time
//    CGFloat buttonWidth = 50;
//    _share = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue];
//    [_share addTarget:self action:@selector(onChallenge:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_share];
//    NSLocalizedString(@"Send", @"Button label for sending a message");
//    CGRect frame = _share.frame;
//    frame.origin = _endGame.frame.origin;
//    frame.size.width = buttonWidth;
//    frame.size.height = buttonWidth;
//    _share.frame = frame;
//    _share.hidden = YES;
    _challenge.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGameView) name:@"ShowGameView" object:nil];
    [self showGameView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [_board addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onChallenge:(id)sender {
    NSString *location = [GameViewController drawGameBoard:_board];
    FBSDKMessengerShareOptions *options = [[FBSDKMessengerShareOptions alloc] init];
    options.contextOverride = [[FacebookMessengerHelper getInstance] getContextForShareMode];
    
    options.metadata = [MessageGenerator respondWithMsgType:[NSNumber numberWithInt:[_board getGameState]]
                                                       rows:[[_board rows] intValue]
                                                    columns:[[_board cols] intValue]
                                                 andContent:[_board getBoardState]
                                                  andMarker:[NSNumber numberWithInt:[_board getMarker]]
                                              andChallenger:[_board getChallenger]];
    [FacebookMessengerHelper shareImage:location withOptions:options];
}

+ (NSString*) drawGameBoard:(UIView*) view {
    // create board image
    CGSize size = {WIDTH, HEIGHT};
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // store image to disk
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    NSString *path = [basePath stringByAppendingPathComponent:@"board.png"];
    if (![data writeToFile:path atomically:YES]){
        NSLog(@"File write failed to path: %@", path);
    }
    return path;
}

- (void) initGameBoardFromMessage: (MessengerMessage*) msg {
    NSLog(@"Starting game from fb message");
    [_board setChallenger:msg.sender];
    [_board initBoardWithRows:[msg rows].intValue Cols:[msg cols].intValue Default:NO];
    [_board setBoardState:msg.state WithMarker:msg.marker];
}

- (void) initDefaultGame {
    NSLog(@"Starting default game");
    // set sharing context
    [[FacebookMessengerHelper getInstance] setShareMode:MessengerShareModeSend];
    // create board
    [_board initBoardWithRows:3 Cols:3 Default:YES];
}

- (void)onTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pos = [gestureRecognizer locationInView:_board];
        [_board handleTouch:pos];
        [self setButtonsForGame];
    }
}

-(void) setButtonsForGame {
    _endGame.hidden = [_board moveComplete];
    _challenge.hidden = ![_board moveComplete];
}

- (void) showGameView {
    FBSDKMessengerURLHandlerReplyContext *context = [[FacebookMessengerHelper getInstance] replyContext];
    [_board reset];
    if (context != nil) {
        NSDictionary *dict = [MessageGenerator receive:context.metadata];
        MessengerMessage *msg = [MessengerMessage createWithDict:dict];
        if ([msg isValidMessage]) {
            [self initGameBoardFromMessage:msg];
        } else {
            [self initDefaultGame];
        }
        // destroy context
        [FacebookMessengerHelper getInstance].replyContext = nil;
    } else {
        [self initDefaultGame];
    }
    [self setButtonsForGame];
    [BoardView  setImageForView:_player ForUserId:[[FBSDKAccessToken currentAccessToken] userID]
                     WithMarker:[BoardView getImageNameForMarker:[_board getMarker]]];
    [BoardView  setImageForView:_opponent ForUserId:[_board getChallenger]
                     WithMarker:[BoardView getImageNameForMarker:-1*[_board getMarker]]];
}

@end