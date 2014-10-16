//
//  UINavigationController+Orientations.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/10/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UINavigationController+Orientations.h"

@implementation UINavigationController (Orientations)

- (BOOL)shouldAutorotate {
  return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
  return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
}

@end
