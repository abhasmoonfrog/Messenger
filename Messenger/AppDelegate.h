//
//  AppDelegate.h
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerURLHandler.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSDKMessengerURLHandler *messengerUrlHandler;

@end

