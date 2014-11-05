//
//  IJHelper.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJAppDelegate.h"

#define ENV_DEVELOPMENT 1
#define IJNSNumberToString(number) [NSString stringWithFormat:@"%@", number]
// Stop asserts from being called when in production.
#if ENV_DEVELOPMENT
#define IJAssertNotNil(object) NSAssert(object, @"%s cannot be nil in %s. Line: %i", #object, __func__, __LINE__)
#define IJAssert(conditional) NSAssert(conditional, @"assert in %s. Line: %i", __func__, __LINE__)
#else
#define IJAssertNotNil(object) NSLog(object, @"%s cannot be nil in %s. Line: %i", #object, __func__, __LINE__)
#define IJAssert(conditional) NSLog(conditional, @"assert in %s. Line: %i", __func__, __LINE__)
#endif

static NSString * const kAllowNotificationsAlertButtonTitle = @"Yes!";

@interface IJHelper : NSObject
+ (NSManagedObjectContext *)mainContext;
+ (UIImageView *)backGroundImage;
+ (void)printFontNames;
@end
