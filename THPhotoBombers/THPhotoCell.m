//
//  THPhotoCell.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/10/15.
//  Copyright (c) 2015 Amitai Blickstein, LLC. All rights reserved.
//
#define DBLG NSLog(@"<%@:%@:line %d, reporting!>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);

#import "THPhotoCell.h"
#import <SAMCache.h>

@implementation THPhotoCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
//    self.imageView .image = [UIImage imageNamed:@"food-restaurant-eat-snack"];
    return self;
}

-(void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
        //download it in the setter!
//    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    [self downloadPhotoWithURL:url];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

    // Sam explains the whole function here: http://bit.ly/1UFS9GA around 3+ minutes in.
-(void)downloadPhotoWithURL:(NSURL*)url {
        // First check to see if the image is already local on the cache.
    NSString *key = [NSString stringWithFormat:@"%@-thumbnail", self.photo[@"id"]];
    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
    if (photo) {
        self.imageView.image = photo;
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    }];
    [task resume];
    
}

-(void)like {
    DBLG
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"♡ Liked!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        
    });
}

@end
