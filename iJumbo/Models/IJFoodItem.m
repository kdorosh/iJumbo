//
//  IJFoodItem.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/8/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJFoodItem.h"

#import "IJServer.h"
#import "UIAlertView+Blocks.h"

static NSString * const kAllowNotificationsAlertButtonTitle = @"Yes!";

@implementation IJFoodItem

@dynamic allergens;
@dynamic calories;
@dynamic carbs;
@dynamic cholestoral;
@dynamic fatCalories;
@dynamic fiber;
@dynamic id;
@dynamic ingredients;
@dynamic name;
@dynamic protein;
@dynamic saturatedFat;
@dynamic servingSize;
@dynamic sodium;
@dynamic sugar;
@dynamic totalFat;
@dynamic transFat;
@dynamic menuSections;

+ (void)subscribeToFoodItem:(IJFoodItem *)foodItem {
  NSString *url =
      [kBaseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"food/%@/subscribe", foodItem.id]];
  NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceIdUserDefaultsKey];
  if (!deviceID) {
    NSLog(@"Ask user to allow notifications.");
    // Ask for permission to send notifications.
    [UIAlertView showWithTitle:@"Want Food Alerts?"
                       message:@"Can we have permission to send you notifications?"
             cancelButtonTitle:@"Not Now"
             otherButtonTitles:@[kAllowNotificationsAlertButtonTitle]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        // If they say yes, start the push notification pipeline.
                        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAllowNotificationsAlertButtonTitle]) {
                          UIUserNotificationSettings *pushSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
                          [[UIApplication sharedApplication] registerUserNotificationSettings:pushSettings];
                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                        }
                      }];
  } else {
    [IJServer postData:@{@"device_id": deviceID} toURL:url success:^(id object) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [IJFoodItem addFoodItemToSubscribed:foodItem];
      });
    } failure:^(NSError *error) {
      NSLog(@"Could not subscribe to food %@", foodItem);
    }];
  }
}

// Make this and the above function use another helper function to stop code duplication.
+ (void)unsubscribeFromFoodItem:(IJFoodItem *)foodItem {
  NSString *url =
  [kBaseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"food/%@/subscribe", foodItem.id]];
  NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceIdUserDefaultsKey];
  [IJServer deleteData:@{@"device_id": deviceID} toURL:url success:^(id object) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [IJFoodItem removeFoodItemFromSubscribed:foodItem];
    });
  } failure:^(NSError *error) {
    NSLog(@"Could not unsubscribe to food %@", foodItem);
  }];
}

// If this device is subscribed to this given food item.
+ (BOOL)isSubscribedToFoodItem:(IJFoodItem *)foodItem {
  return NO;
}

+ (void)addFoodItemToSubscribed:(IJFoodItem *)foodItem {
  NSArray *subscribedFood = [self subscribedFoodIds];
  NSMutableSet *set = [NSMutableSet setWithArray:subscribedFood];
  [set addObject:foodItem.id];
  [self writeSubscribedFoodsToDisk:[set allObjects]];
}

+ (void)removeFoodItemFromSubscribed:(IJFoodItem *)foodItem {
  NSArray *food = [self subscribedFoodIds];
  NSMutableSet *set = [NSMutableSet setWithArray:food];
  [set removeObject:foodItem.id];
  NSArray *list = [set allObjects];
  [self writeSubscribedFoodsToDisk:list];
}

+ (NSArray *)subscribedFoodIds {
  NSString *file = [IJFoodItem subscribedFoodFile];
  NSArray *subscribedFoodIds = [NSArray arrayWithContentsOfFile:file];
  return subscribedFoodIds;
}

// An array of ids from the database.
+ (NSArray *)subscribedFood {
  NSArray *subscribedFoodIds = [self subscribedFoodIds];
  if (subscribedFoodIds == nil) {
    return nil;
  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:NSStringFromClass([IJFoodItem class])
                  inManagedObjectContext:[IJHelper mainContext]];
  [fetchRequest setEntity:entity];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.id IN %@", subscribedFoodIds];
  [fetchRequest setPredicate:predicate];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                 ascending:YES];
  [fetchRequest setSortDescriptors:@[sortDescriptor]];
  NSError *error = nil;
  NSArray *fetchedObjects = [[IJHelper mainContext] executeFetchRequest:fetchRequest error:&error];
  if (fetchedObjects == nil) {
    NSLog(@"Error: %@", error);
  }
  return fetchedObjects;
}

// @param subscribedFood An array of food item ids that are stored on the phone.
+ (void)writeSubscribedFoodsToDisk:(NSArray *)subscribedFood {
  NSString *file = [self subscribedFoodFile];
  [subscribedFood writeToFile:file atomically:YES];
}

// Array of managed object ids.
+ (NSString *)subscribedFoodFile {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *foodFile = [documentsDirectory stringByAppendingPathComponent:@"subscribed_food.data"];
  return foodFile;
}

#pragma mark - Network stuff

+ (void)fetchSubscribedFoodWithSuccessBlock:(void (^)(NSArray *foodItems))successBlock
                               failureBlock:(void (^)(NSError *error))errorBlock {
  NSString *device_id = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceIdUserDefaultsKey];
  if (!device_id) {
    NSError *error = [[NSError alloc] initWithDomain:@"Has not enabled notifications" code:9 userInfo:nil];
    errorBlock(error);
    return;
  }
  [IJFoodItem startRequestWithURN:@"/device/subscribed_food"
                             data:@{@"device_id": device_id} /* should pass in the device object mongo id */
                          context:[IJHelper mainContext]
                           domain:nil
                      resultBlock:successBlock
                     failureBlock:errorBlock];
}

@end
