//
//  UIView+Position.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UIView+Position.h"


@implementation UIView (Position)

- (CGFloat)maxX {
  return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)maxY {
  return self.frame.origin.y + self.frame.size.height;
}

@end
