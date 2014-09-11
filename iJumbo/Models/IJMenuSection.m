//
//  IJMenuSection.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/8/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMenuSection.h"

@implementation IJMenuSection

@dynamic name;
@dynamic date;
@dynamic diningHall;
@dynamic id;
@dynamic meal;
@dynamic sectionNum;
@dynamic foodItems;

+ (void)getTodaysMenusWithSuccessBlock:(void (^)(NSArray *menuSections))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock {
  [IJMenuSection startRequestWithURN:@"/menus"
                                data:nil
                             context:[IJHelper mainContext]
                              domain:nil
                         resultBlock:successBlock
                        failureBlock:failureBlock];
}

+ (void)getMenusForDate:(NSString *)date
       withSuccessBlock:(void (^)(NSArray *menuSections))successBlock
           failureBlock:(void (^)(NSError *error))failureBlock {
  NSAssert(date, @"date must not be nil.");
  [IJMenuSection startRequestWithURN:[@"menus/date/" stringByAppendingPathComponent:date]
                                data:nil
                             context:[IJHelper mainContext]
                              domain:nil
                         resultBlock:successBlock
                        failureBlock:failureBlock];
}

- (NSString *)description {
  NSString *regular_desc = [super description];
  NSString *desc = [NSString stringWithFormat:@"\nDate: %@\nDining Hall: %@\nMeal: %@",
                        self.date,
                        self.diningHall,
                        self.meal];
  return [regular_desc stringByAppendingString:desc];
}

@end
