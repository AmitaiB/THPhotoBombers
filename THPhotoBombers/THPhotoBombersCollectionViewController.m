//
//  THPhotoBombersCollectionViewController.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/10/15.
//  Copyright (c) 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "THPhotoBombersCollectionViewController.h"
#import "THPhotoCell.h"
#import "THPConstants.h"
#import "THPhotoController.h"
#import "THDetailViewController.h"
#import "THPresentDetailTransition.h"
#import "THDismissDetailTransition.h"
#import <SAMCache.h>
#import <SimpleAuth.h>
#import <SSKeychain.h>

@interface THPhotoBombersCollectionViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *coverArtImages;

@end

@implementation THPhotoBombersCollectionViewController

-(instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize                = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing      = 1.0;

    
    return [self initWithCollectionViewLayout:layout];
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Photos Bombers";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[THPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSError *error = nil;
    self.accessToken = [SSKeychain passwordForService:@"instagram" account:@"blickstein@gmail.com" error:&error];
    if (error) {
        self.accessToken = [userDefaults objectForKey:@"accessToken"];
    }
    
    if (self.accessToken == nil) {
        SimpleAuth.configuration[@"instagram"] = @{
                                                   @"client_id" : kInstagramClientID,
                                                   SimpleAuthRedirectURIKey : @"https://www.getpostman.com/oauth2/callback"
                                                   };
        [SimpleAuth authorize:@"instagram" options:@{@"scope" : @[@"likes"]}
                   completion:^(NSDictionary *responseObject, NSError *error) {
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [SSKeychain setPassword:self.accessToken forService:@"instagram" account:@"blickstein@gmail.com" error:&error];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
                       [self refresh];
        }];
    } else {
        [self refresh];
        
    }
    

}

-(void)refresh {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"Response Dictionary: %@", responseDictionary);
        
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        NSLog(@"Photos: %@", self.photos);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
    
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

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    cell.parentViewController = self;
    
    return cell;
}

#pragma mark -
#pragma mark - === UICollectionViewDelegate ===
#pragma mark -

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *photo = self.photos[indexPath.row];
    THDetailViewController *viewController = [THDetailViewController new];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.photo = photo;
    NSString *size = @"standard-resolution";
        ///I added this myself:
    [THPhotoController imageForPhoto:photo size:size completion:^(UIImage *image) {
        NSString *key = [NSString stringWithFormat:@"%@-%@", photo[@"id"], size];
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }];
    
    
    
}

#pragma mark -
#pragma mark - === UIViewControllerTransitioningDelegate ===
#pragma mark -

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [THPresentDetailTransition new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [THDismissDetailTransition new];
}


@end
