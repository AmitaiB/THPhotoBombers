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
        // First check to see if the image is already local on the cache.
    NSString *key = [NSString stringWithFormat:@"%@-%@", photo[@"id"], size];
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    if (image) {
        completion(image);
        return;
    }
    
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
