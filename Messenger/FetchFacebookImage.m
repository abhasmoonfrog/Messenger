//
//  FetchFacebokImage.m
//  Messenger
//
//  Created by abhas saroha on 4/1/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "FetchFacebookImage.h"
#import <UIKit/UIKit.h>

@implementation FetchFacebookImage

+ (NSURL *)documentsDirectoryURL
{
    NSError *error = nil;
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                        inDomain:NSUserDomainMask
                                               appropriateForURL:nil
                                                          create:NO
                                                           error:&error];
    if (error) {
        // Figure out what went wrong and handle the error.
    }
    
    return url;
}

+ (void) downLoadImageForView:(UIImageView*) view FromId:(NSString*) fbid PlaceHolder:(NSString*)holder {
    // Start the activity indicator before moving off the main thread
    // Move off the main thread to start our blocking tasks.
    
    
    // Get the path of the application's documents directory.
    NSURL *documentsDirectoryURL = [self documentsDirectoryURL];
    // Append the desired file name to the documents directory path.
    NSString *filename = [NSString stringWithFormat:@"%@", fbid];
    NSURL *saveLocation = [documentsDirectoryURL URLByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[saveLocation path]]) {
        view.image = [UIImage imageNamed:[saveLocation path]];
    } else {
        view.image = [UIImage imageNamed:holder];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            // Create the image URL from some known string.
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=150&height=150", fbid]];
            
            NSError *downloadError = nil;
            // Create an NSData object from the contents of the given URL.
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL
                                                      options:kNilOptions
                                                        error:&downloadError];
            // ALWAYS utilize the error parameter!
            if (downloadError) {
                // Something went wrong downloading the image. Figure out what went wrong and handle the error.
                // Don't forget to return to the main thread if you plan on doing UI updates here as well.
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",[downloadError localizedDescription]);
                });
            } else {
                
                NSError *saveError = nil;
                BOOL writeWasSuccessful = [imageData writeToURL:saveLocation
                                                        options:kNilOptions
                                                          error:&saveError];
                // Successful or not we need to stop the activity indicator, so switch back the the main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Now that we're back on the main thread, you can make changes to the UI.
                    // This is where you might display the saved image in some image view, or
                    // stop the activity indicator.
                    
                    // Check if saving the file was successful, once again, utilizing the error parameter.
                    if (writeWasSuccessful) {
                        // Get the saved image data from the file.
                        NSData *imageData = [NSData dataWithContentsOfURL:saveLocation];
                        // Set the imageView's image to the image we just saved.
                        view.image = [UIImage imageWithData:imageData];
                    } else {
                        NSLog(@"%@",[saveError localizedDescription]);
                        // Something went wrong saving the file. Figure out what went wrong and handle the error.
                    }
                    
                });
            }
        });
    }
}

@end