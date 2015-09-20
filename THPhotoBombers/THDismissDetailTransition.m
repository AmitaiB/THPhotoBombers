//
//  THDismissDetailTransition.m
//  THPhotoBombers
//
//  Created by Amitai Blickstein on 9/20/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "THDismissDetailTransition.h"

@implementation THDismissDetailTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


@end
