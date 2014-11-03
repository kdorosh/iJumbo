//
//  IJHelper.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJAppDelegate.h"

#define IJNSNumberToString(number) [NSString stringWithFormat:@"%@", number]
#define IJAssertNotNil(object) NSAssert(object, @"%s cannot be nil in %s. Line: %i", #object, __func__, __LINE__)
#define IJAssert(conditional) NSAssert(conditional, @"assert in %s. Line: %i", __func__, __LINE__)

@interface IJHelper : NSObject
+ (NSManagedObjectContext *)mainContext;
+ (UIImageView *)backGroundImage;
+ (void)printFontNames;
@end
