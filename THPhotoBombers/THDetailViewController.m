//
//  THDetailViewController.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/19/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "THDetailViewController.h"
#import "UIColor+FlatUI.h"
#import "THPhotoController.h"

@interface THDetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIDynamicAnimator *animator;


@end

@implementation THDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.9];
    CGRect fullScreen         = [UIScreen mainScreen].bounds;
    CGRect offScreen          = CGRectMake(0, -320.0, fullScreen.size.width, fullScreen.size.width);
    self.imageView            = [[UIImageView alloc] initWithFrame:offScreen];
    [self.view addSubview:self.imageView];
    [THPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tapToDismiss];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

-(void)viewDidAppear:(BOOL)animated {
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    [self.animator addBehavior:snap];
}

-(void)close {
    [self.animator removeAllBehaviors];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0f)];
    [self.animator addBehavior:snap];

    [self dismissViewControllerAnimated:YES completion:nil];
}

    ///No longer needed, thanks to snapBehavior.
//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    CGSize size = self.view.bounds.size;
//    CGSize imageSize = CGSizeMake(size.width, size.width);
//    
//    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
