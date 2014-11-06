//
//  IJNavigationDelegate.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJNavigationDelegate.h"

#import "IJAppDelegate.h"
#import "IJHomeViewController.h"
#import "IJAllFoodViewController.h"

@implementation IJNavigationDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  if (operation == UINavigationControllerOperationPush && [fromVC isKindOfClass:[IJHomeViewController class]]) {
    return nil;//[[IJFromHomeViewControllerTransition alloc] init];
  } else if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[IJHomeViewController class]]) {
    return nil;//[[IJToHomeViewControllerTransition alloc] init];
  }
  return nil;
}

@end

@implementation IJPushViewControllerTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *whiteView = [[[[UIApplication sharedApplication] delegate] window] viewWithTag:kWhiteViewBackgroundTag];
  CGSize whiteViewSize = whiteView.frame.size;
  UIView *container = [transitionContext containerView];
  UIView *toView = toVC.view;
  CGSize toSize = toView.frame.size;
  CGFloat originalY = toView.frame.origin.y;
  CGFloat x = ([toVC class] == [IJAllFoodViewController class]) ? 0 : container.maxX;
  CGFloat y = ([toVC class] == [IJAllFoodViewController class]) ? container.maxY : toView.frame.origin.y;
  toView.frame = CGRectMake(x, y, toSize.width, toSize.height);
  BOOL fromHome = [fromVC isKindOfClass:[IJHomeViewController class]];
  if (fromHome) {
    whiteView.alpha = 1;
    whiteView.frame = CGRectMake(container.maxX, 0, whiteViewSize.width, whiteViewSize.height);
  }
  CGPoint newFromCenter = CGPointMake(fromVC.view.center.x - fromVC.view.frame.size.width / 4.0f, fromVC.view.center.y);
  [container addSubview:toView];
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    toView.frame = CGRectMake(0, originalY, toSize.width, toSize.height);
    fromVC.view.center = newFromCenter;
    fromVC.view.alpha = 0;
    if (fromHome) {
      whiteView.frame = CGRectMake(0, 0, whiteViewSize.width, whiteViewSize.height);
    }
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end

@implementation IJPopViewControllerTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *whiteView = [[[[UIApplication sharedApplication] delegate] window] viewWithTag:kWhiteViewBackgroundTag];
  CGSize whiteViewSize = whiteView.frame.size;

  UIView *container = [transitionContext containerView];
  CGRect origFrame = toVC.view.frame;
  toVC.view.frame = CGRectMake(-origFrame.size.width / 4.0f, origFrame.origin.y, origFrame.size.width, origFrame.size.height);
  [container insertSubview:toVC.view belowSubview:fromVC.view];
  CGSize fromSize = fromVC.view.frame.size;
  BOOL toHome = [toVC isKindOfClass:[IJHomeViewController class]];
  CGFloat x = ([fromVC class] == [IJAllFoodViewController class]) ? 0 : container.maxX;
  CGFloat y = ([fromVC class] == [IJAllFoodViewController class]) ? container.maxY : fromVC.view.frame.origin.y;
  CGRect poppedFrame = CGRectMake(x, y, fromSize.width, fromSize.height);
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    fromVC.view.frame = poppedFrame;
    toVC.view.alpha = 1;
    toVC.view.frame = origFrame;
    if (toHome) {
      whiteView.frame = CGRectMake(container.maxX, 0, whiteViewSize.width, whiteViewSize.height);
    }
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  if ([fromVC class] == [IJAllFoodViewController class])  {
    return 0.35;
  }
  return 0.2;
}

@end
