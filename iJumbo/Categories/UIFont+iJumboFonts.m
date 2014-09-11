//
//  UIFont+iJumboFonts.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/11/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UIFont+iJumboFonts.h"

@implementation UIFont (iJumboFonts)

+ (UIFont *)lightFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

+ (UIFont *)regularFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

@end
