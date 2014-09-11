//
//  IJMenuSection.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/8/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"
#import "IJFoodItem.h"

@interface IJMenuSection : IJRecord

// Attributes.
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *date;
@property(nonatomic) NSString *diningHall;
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *meal;
// Order the sections based on how the appear online.
@property(nonatomic) NSNumber *sectionNum;

// Relationships.
@property(nonatomic) NSSet *foodItems;

// Functions.
+ (void)getTodaysMenusWithSuccessBlock:(void (^)(NSArray *menuSections))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;

+ (void)getMenusForDate:(NSString *)date
       withSuccessBlock:(void (^)(NSArray *menuSections))successBlock
           failureBlock:(void (^)(NSError *error))failureBlock;

@end
