//
//  THPhotoController.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/19/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "THPhotoController.h"
#import <SAMCache.h>

@implementation THPhotoController
     ///When imageForPhoto is called, we pass in the photo dictionary from Instagram API, the requested size, and completion.
+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {

    if (photo == nil || size == nil || completion == nil) {
        NSLog(@"Silent error: photo, size, or completion is nil.");
        return;
    }
    
        // First check to see if the image is already local on the cache.
    NSString *key = [NSString stringWithFormat:@"%@-%@", photo[@"id"], size];
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    if (image) {
        completion(image);
        return;
    }
    
        /// Sam explains the whole function here: http://bit.ly/1UFS9GA around 3+ minutes in.
        ///(This is then moved to this function, explained here: http://bit.ly/1LFRB9w between minutes 4-5.
    NSURL *url = [NSURL URLWithString:photo[@"images"][size][@"url"]];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
        
    }];
    [task resume];
    
}

@end
