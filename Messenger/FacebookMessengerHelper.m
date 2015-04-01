//
//  FacebookMessengerHelper.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "FacebookMessengerHelper.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@implementation FacebookMessengerHelper

// Below is all example code.

// shareMode holds state indicating which flow the user is in.
// Return the corresponding FBSDKMessengerContext based on that state.
enum MessengerShareMode _shareMode;

// some copy paste stuff for singleton.
+ (FacebookMessengerHelper*) getInstance {
    static dispatch_once_t onceToken;
    static FacebookMessengerHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FacebookMessengerHelper alloc] init];
        instance.uuid = [[NSUUID UUID] UUIDString];
    });
    return instance;
}

+ (void) assertMessengerApp {
    // check if messenger is installed.
    BOOL result = [FBSDKMessengerSharer messengerPlatformCapabilities];
    if (!(result & FBSDKMessengerPlatformCapabilityImage)) {
        // Messenger isn't installed. Redirect the person to the App Store.
        NSString *iTunesLink = @"itms://itunes.apple.com/us/app/facebook-messenger/id454638411?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    } else if (result & FBSDKMessengerPlatformCapabilityOpen) {
        [FBSDKMessengerSharer openMessenger];
    }
}

- (FBSDKMessengerContext *) getContextForShareMode
{
    // shareMode holds state indicating which flow the user is in.
    // Return the corresponding FBSDKMessengerContext based on that state.
    
    if (_shareMode == MessengerShareModeSend) {
        // Force a send flow by returning a broadcast context.
        return [[FBSDKMessengerBroadcastContext alloc] init];
        
    } else if (_shareMode == MessengerShareModeComposer) {
        // Force the composer flow by returning the composer context.
        return _composerContext;
        
    } else if (_shareMode == MessengerShareModeReply) {
        // Force the reply flow by returning the reply context.
        return _replyContext;
    }
    
    
    return nil;
}

- (void) setShareMode: (enum MessengerShareMode) shareMode {
    _shareMode = shareMode;
}

+ (void) shareImage:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options {
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityImage) {
        UIImage *image = [UIImage imageWithContentsOfFile:location];
        
        [FBSDKMessengerSharer shareImage:image withOptions:options];
    }
}

+ (void) shareGif:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options {
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityAnimatedGIF) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:location ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:filepath];
        
        [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:options];
    }
}

+ (void) shareAudio:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options {
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityAudio) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:location ofType:@"mp3"];
        NSData *mp3Data = [NSData dataWithContentsOfFile:filepath];
        [FBSDKMessengerSharer shareAudio:mp3Data withOptions:options];
    }
}

+ (void) shareVideo:(NSString*) location withOptions:(FBSDKMessengerShareOptions*) options {
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityVideo) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:location ofType:@"mp4"];
        NSData *videoData = [NSData dataWithContentsOfFile:filepath];
        
        [FBSDKMessengerSharer shareVideo:videoData withOptions:options];
    }
}

@end