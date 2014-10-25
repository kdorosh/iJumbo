//
//  IJHelper.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJAppDelegate.h"

#define IJNSNumberToString(n) [NSString stringWithFormat:@"%@", n]
#define IJAssertNotNil(a) NSAssert(a, @"%s cannot be nil in %s. Line: %i", #a, __func__, __LINE__)

@interface IJHelper : NSObject
+ (NSManagedObjectContext *)mainContext;
+ (UIImageView *)backGroundImage;
+ (void)printFontNames;
@end
