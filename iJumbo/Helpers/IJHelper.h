//
//  IJHelper.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJAppDelegate.h"

@interface IJHelper : NSObject
+ (NSManagedObjectContext *)mainContext;
+ (UIImageView *)backGroundImage;
+ (void)printFontNames;
@end
