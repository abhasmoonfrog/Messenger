//
//  FacebookMessngerHelper.h
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerURLHandlerOpenFromComposerContext.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerURLHandlerReplyContext.h>

// helper enum i made to define the state
enum MessengerShareMode { MessengerShareModeSend,
    MessengerShareModeComposer,
    MessengerShareModeReply};

@interface FacebookMessengerHelper : NSObject

@property (nonatomic, strong) FBSDKMessengerURLHandlerOpenFromComposerContext *composerContext;
@property (nonatomic, strong) FBSDKMessengerURLHandlerReplyContext *replyContext;
@property (nonatomic, strong) NSString* uuid;

- (FBSDKMessengerContext *) getContextForShareMode;
- (void) setShareMode: (enum MessengerShareMode) shareMode;

+ (FacebookMessengerHelper*) getInstance;
+ (void) assertMessengerApp;
+ (void) shareImage:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options;
+ (void) shareGif:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options;
+ (void) shareAudio:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options;
+ (void) shareVideo:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options;

@end

