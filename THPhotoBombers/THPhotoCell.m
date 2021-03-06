//
//  THPhotoCell.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/10/15.
//  Copyright (c) 2015 Amitai Blickstein, LLC. All rights reserved.
//
#define DBLG NSLog(@"<%@:%@:line %d, reporting!>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);

#import "THPhotoBombersCollectionViewController.h"
#import "THPhotoCell.h"
#import "THPhotoController.h"
#import <SSKeychain.h>

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
    
    [THPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

-(void)like {
    DBLG
    NSLog(@"Link: %@", self.photo[@"link"]);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [SSKeychain passwordForService:@"instagram" account:@"blickstein@gmail.com"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });

    } ];
    [task resume];

}

- (void)showLikeCompletion {
    THPhotoBombersCollectionViewController *superVC = (THPhotoBombersCollectionViewController*)self.parentViewController;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"♡ Liked!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [superVC presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [superVC dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
