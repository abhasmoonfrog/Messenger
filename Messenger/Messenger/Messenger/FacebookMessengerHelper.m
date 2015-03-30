//
//  FacebookMessengerHelper.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "FacebookMessengerHelper.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

//@interface FacebookMessengerHelper ()
//
//@end

@implementation FacebookMessengerHelper

+ (void) assertMessengerApp {
    if (![FBSDKMessengerSharer messengerPlatformCapabilities]) {
        // Messenger isn't installed. Redirect the person to the App Store.
        NSString *iTunesLink = @"itms://itunes.apple.com/us/app/facebook-messenger/id454638411?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

@end