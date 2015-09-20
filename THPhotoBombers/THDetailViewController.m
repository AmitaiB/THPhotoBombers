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

    self.view.backgroundColor = [UIColor turquoiseColor];
    
    CGRect fullScreen = [UIScreen mainScreen].bounds;
    self.imageView = [[UIImageView alloc] initWithFrame:fullScreen];
//    [self.view addSubview:self.imageView];
    
    [THPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
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
