//
//  IJAppDelegate.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/1/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (void)updateDeviceWithNotificationToken:(NSData *)deviceToken callBack:(void (^)(BOOL))success;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
