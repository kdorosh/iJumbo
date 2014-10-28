//
//  IJFoodItem.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/8/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

static NSString * const kSubscribedToFoodItemNotification = @"SubscribedToFoodItemNotification";
static NSString * const kUnsubscribedToFoodItemNotification = @"UnsubscribedToFoodItemNotification";

@interface IJFoodItem : IJRecord

// Attributes.
@property(nonatomic) NSString *allergens;
@property(nonatomic) NSNumber *calories;
@property(nonatomic) NSString *carbs;
@property(nonatomic) NSString *cholestoral;
@property(nonatomic) NSNumber *fatCalories;
@property(nonatomic) NSString *fiber;
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *ingredients;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *protein;
@property(nonatomic) NSString *saturatedFat;
@property(nonatomic) NSString *servingSize;
@property(nonatomic) NSString *sodium;
@property(nonatomic) NSString *sugar;
@property(nonatomic) NSString *totalFat;
@property(nonatomic) NSString *transFat;

// Relationships.
@property(nonatomic) NSMutableSet *menuSections;

// Functions.
+ (void)subscribeToFoodItem:(IJFoodItem *)foodItem;
// Make this and the above function use another helper function to stop code duplication.
+ (void)unsubscribeFromFoodItem:(IJFoodItem *)foodItem;

/// If this device is subscribed to this foot item.
+ (BOOL)isSubscribedToFoodItem:(IJFoodItem *)foodItem;

+ (NSArray *)subscribedFood;

+ (NSArray *)subscribedFoodIds;

+ (void)writeSubscribedFoodsToDisk:(NSArray *)subscribedFood;

+ (void)fetchSubscribedFoodWithSuccessBlock:(void (^)(NSArray *foodItems))successBlock
                               failureBlock:(void (^)(NSError *error))errorBlock;

@end
