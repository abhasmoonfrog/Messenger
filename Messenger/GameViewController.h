//
//  GameViewController.h
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"


@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet BoardView* board;
@property (weak, nonatomic) IBOutlet UIButton* endGame;
@property (weak, nonatomic) IBOutlet UIButton* challenge;
@property (weak, nonatomic) IBOutlet UIImageView* player;
@property (weak, nonatomic) IBOutlet UIImageView* opponent;

-(IBAction)onChallenge:(id)sender;

@end