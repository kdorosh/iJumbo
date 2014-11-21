//
//  UIColor+iJumboColors.m
//  iJumbo
//
//  Created by Amadou Crookes on 11/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UIColor+iJumboColors.h"

@implementation UIColor (iJumboColors)

+ (UIColor *)iJumboBlue {
  return [UIColor iJumboBlueWithAlpha:1];
}

+ (UIColor *)iJumboBlueWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:68/255.0f green:138/255.0f blue:255/255.0 alpha:alpha];
}

+ (UIColor *)iJumboGrey {
  return [UIColor colorWithRed:240/255.0f green:240/255.0f blue:238/255.0f alpha:1];
}

+ (UIColor *)iJumboBlackText {
  return [UIColor colorWithWhite:0 alpha:0.65];
}

+ (UIColor *)iJumboDarkBlackText {
  return [UIColor colorWithWhite:0 alpha:0.8];
}

// basically grey but is translucent black.
+ (UIColor *)iJumboLightBlackText {
  return [UIColor colorWithWhite:0 alpha:0.5];
}

+ (UIColor *)transparentWhiteBackground {
  return [UIColor clearColor];
}

@end
