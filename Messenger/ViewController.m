//
//  ViewController.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import "FacebookMessengerHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGameView) name:@"ShowGameView" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    if ([[FBSDKAccessToken currentAccessToken] userID]) {
        // User is logged in, do work such as go to next view controller.
        // TODO: hide button on login
        self.loginButton.hidden = YES;
        self.playButton.hidden = NO;
    } else {
        self.loginButton.hidden = NO;
        self.playButton.hidden = YES;
    }
    CGSize size = self.view.bounds.size;
    NSLog(@"Size: %f, %f", size.width, size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_shareButtonPressed: (id) sender {
    // do something here
    [FacebookMessengerHelper assertMessengerApp];
}

- (void) showGameView {
    [self performSegueWithIdentifier:@"GameScreen" sender:self];
}

@end
