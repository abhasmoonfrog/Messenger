//
//  BoardView.h
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <UIKit/UIKit.h>

IBInspectable

enum GameState {
    StartGame,
    ContinueGame
};

@interface BoardView : UIView

- (void) initBoardWithRows:(int) r Cols:(int) c Default:(BOOL) firstTurn;
- (NSArray*) getBoardState;
- (void) setBoardState:(NSArray*) data WithMarker:(NSNumber*) marker;
- (void) handleTouch: (CGPoint) pos;
- (void) makeMoveAtRow:(int) r Column:(int) c Type:(int) type;
- (BOOL) moveComplete;
- (enum GameState) getGameState;
- (int) getMarker;
- (void) setChallenger:(NSString*) challenger;
@property (nonatomic, readonly) NSNumber *rows;
@property (nonatomic, readonly) NSNumber *cols;

@property (weak, nonatomic) IBOutlet UIImageView *victoryScreen;

// set state to form for the other player
+ (NSArray*) convertStateToReceivers:(NSArray*) data;
+(NSString*) getImageNameForMarker:(int) marker;
+ (void) setImageForView: (UIImageView*) view ForUserId:(NSString*) userId WithMarker:(NSString*) marker;
- (NSString*) getChallenger;

@end