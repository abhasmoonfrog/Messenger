//
//  MessengerMessage.h
//  Messenger
//
//  Created by abhas saroha on 3/31/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoardView.h"


@interface MessengerMessage : NSObject

- (BOOL) isValidMessage;

+(MessengerMessage*) createWithDict:(NSDictionary*) dict;

@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSArray *state;
@property (nonatomic, strong) NSNumber *rows;
@property (nonatomic, strong) NSNumber *cols;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSNumber *marker;
@end