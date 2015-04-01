//
//  MessageGenerator.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//


#import "MessageGenerator.h"
#import <Foundation/Foundation.h>
#import "FacebookMessengerHelper.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>


@implementation MessageGenerator

+ (NSDictionary*) receive:(NSString *)msg {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization
                          JSONObjectWithData:[msg
                                              dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0 error:&error];
    if (error != nil) {
        NSLog(@"Error decoding json: %@",error);
    }
    return dict;
}

+ (NSString*) respondWithMsgType: (NSNumber*) type rows:(int) r columns:(int) c
                      andContent: (NSArray*) content
                       andMarker: (NSNumber*) marker
                   andChallenger: (NSString*) challenger
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:r] forKey:@"rows"];
    [dict setObject:[NSNumber numberWithInt:c] forKey:@"cols"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:[[FacebookMessengerHelper getInstance] uuid] forKey:@"uuid"];
    [dict setObject:[FBSDKAccessToken currentAccessToken].userID forKey:@"sender"];
    if (challenger != nil) {
        [dict setObject:challenger forKey:@"receiver"];
    }
    // send my marker to the receiver
    [dict setObject:marker forKey:@"marker"];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (error != nil) {
        NSLog(@"Error in decoding json: %@", error);
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end