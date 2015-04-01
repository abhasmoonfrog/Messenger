//
//  FetchFacebookImage.h
//  Messenger
//
//  Created by abhas saroha on 4/1/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImageView.h>

@interface FetchFacebookImage : NSObject

+ (void) downLoadImageForView:(UIImageView*) view FromId:(NSString*) fbid PlaceHolder:(NSString*)holder;
    
@end