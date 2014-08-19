//
//  UIView+Position.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

// origin.y + size.height
- (CGFloat)maxY;
// origin.x + size.width
- (CGFloat)maxX;

@end
