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


@end

@implementation THDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


//    UIColor *seeThruCloudsColor = [UIColor colorFromHexCode:@"ECF0F1"];
    
    self.view.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.9];
    
    CGRect fullScreen = [UIScreen mainScreen].bounds;
    self.imageView = [[UIImageView alloc] initWithFrame:fullScreen];
    [self.view addSubview:self.imageView];
    
    [THPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tapToDismiss];
}

-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
