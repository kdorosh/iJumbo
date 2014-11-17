//
//  IJHelper.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJHelper.h"

@implementation IJHelper

+ (NSManagedObjectContext *)mainContext {
  IJAppDelegate *appDelegate = (IJAppDelegate *)[[UIApplication sharedApplication] delegate];
  return appDelegate.managedObjectContext;
}

+ (UIImageView *)backGroundImage {
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
  imageView.image = [UIImage imageNamed:@"background-image.png"];
  return imageView;
}

+ (void)printFontNames {
  for (NSString* family in [UIFont familyNames]) {
    NSLog(@"%@", family);
    for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
      NSLog(@"  %@", name);
    }
  }
}

@end
