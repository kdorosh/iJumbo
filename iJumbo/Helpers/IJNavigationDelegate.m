//
//  IJNavigationDelegate.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJNavigationDelegate.h"

#import "IJHomeViewController.h"

@interface IJToHomeViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface IJFromHomeViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end

@implementation IJNavigationDelegate

// When 
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

@implementation IJToHomeViewControllerTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.35;
}

@end

@implementation IJFromHomeViewControllerTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.35;
}

@end
