//
//  IJMenuSection.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/8/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMenuSection.h"

static NSDateFormatter *dateFormatter;

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
  IJAssertNotNil(date);
  [IJMenuSection startRequestWithURN:[@"menus/date/" stringByAppendingPathComponent:date]
                                data:nil
                             context:[IJHelper mainContext]
                              domain:nil
                         resultBlock:successBlock
                        failureBlock:failureBlock];
}

+ (void)getMenusForDateObject:(NSDate *)date
             withSuccessBlock:(void (^)(NSArray *))successBlock
                 failureBlock:(void (^)(NSError *))failureBlock {
  IJAssertNotNil(date);
  NSString *dateString = [[self dateFormatter] stringFromDate:date];
  [self getMenusForDate:dateString withSuccessBlock:successBlock failureBlock:failureBlock];
}

- (NSString *)description {
  NSString *regular_desc = [super description];
  NSString *desc = [NSString stringWithFormat:@"\nDate: %@\nDining Hall: %@\nMeal: %@",
                        self.date,
                        self.diningHall,
                        self.meal];
  return [regular_desc stringByAppendingString:desc];
}

+ (NSDateFormatter *)dateFormatter {
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d"];
  }
  return dateFormatter;
}

@end
