//
//  MessageGenerator.h
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSArray *boardState;
@end

@interface MessageGenerator : NSObject

+ (NSDictionary*) receive: (NSString*) msg;

+ (NSString*) respondWithMsgType: (NSNumber*) type
                            rows:(int)r columns:(int) c
                      andContent: (NSArray*) content
                       andMarker: (NSNumber*) marker
                   andChallenger: (NSString*) challenger;
@end