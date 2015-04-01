//
//  MessengerMessage.m
//  Messenger
//
//  Created by abhas saroha on 3/31/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "MessengerMessage.h"

#import "GameViewController.h"
#import "FacebookMessengerHelper.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>

@implementation MessengerMessage

+(MessengerMessage*) createWithDict:(NSDictionary *)dict {
    MessengerMessage* msg = [[MessengerMessage alloc] init];
    msg.uuid = [dict objectForKey:@"uuid"];
    msg.type = [dict objectForKey:@"type"];
    // only field which is a misnomer.
    msg.state = [dict objectForKey:@"content"];
    msg.rows = [dict objectForKey:@"rows"];
    msg.cols = [dict objectForKey:@"cols"];
    msg.sender = [dict objectForKey:@"sender"];
    // we have sender's marker.
    msg.marker = [dict objectForKey:@"marker"];
    return msg;
}

-(BOOL) isValidMessage {
    BOOL result = YES;
    int rows = [self.rows intValue];
    int cols = [self.cols intValue];
    NSLog(@"StartGame: %d ContinueGame: %d", StartGame, ContinueGame);
    if ([self.uuid compare:[FacebookMessengerHelper getInstance].uuid] == NSOrderedSame) {
        result = NO;
    } else if ([self.type intValue] < (int)StartGame && [self.type intValue] > (int)ContinueGame) {
        result = NO;
    } else if ([self.state count] != rows*cols) {
        result = NO;
    } else if (rows == 0 || cols == 0) {
        result = NO;
    } else if ([self.sender compare:[[FBSDKAccessToken currentAccessToken] userID]] == NSOrderedSame) {
        result = NO;
    }
    return result;
}

@end