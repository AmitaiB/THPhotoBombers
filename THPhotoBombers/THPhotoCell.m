//
//  THPhotoCell.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/10/15.
//  Copyright (c) 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "THPhotoCell.h"

@implementation THPhotoCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
//    self.imageView .image = [UIImage imageNamed:@"food-restaurant-eat-snack"];
    return self;
}

-(void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
        //download it in the setter!
    NSURL *url = [NSURL URLWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    [self downloadPhotoWithURL:url];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

-(void)downloadPhotoWithURL:(NSURL*)url {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    }];
    [task resume];
    
}


@end
