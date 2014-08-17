//
//  UIView+AddSubviews.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UIView+AddSubviews.h"

@implementation UIView (AddSubviews)

- (void)addSubviews:(NSArray *)subviews {
  for (UIView *view in subviews) {
    if (view) {
      [self addSubview:view];
    }
  }
}


@end
