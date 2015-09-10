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
    self.imageView.image = [UIImage imageNamed:@"food-restaurant-eat-snack"];
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}


@end
