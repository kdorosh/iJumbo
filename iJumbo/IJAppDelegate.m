//
//  IJAppDelegate.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/1/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJAppDelegate.h"

#import <MMRecord/MMRecord.h>

#import "IJHomeViewController.h"
#import "IJNavigationDelegate.h"
#import "IJServer.h"
#import "IJHelper.h"

@interface IJAppDelegate () <UINavigationControllerDelegate>
@property(nonatomic) UINavigationController *navcon;
@end

@implementation IJAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
  [MMRecord registerServerClass:[IJServer class]];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self addBackgroundImage];
  // Override point for customization after application launch.
  [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
  IJHomeViewController *home = [[IJHomeViewController alloc] init];
  self.navcon = [[UINavigationController alloc] initWithRootViewController:home];
  self.navcon.delegate = self;
  self.navcon.navigationBar.barTintColor = kIJumboBlue;
  self.navcon.navigationBar.tintColor = [UIColor whiteColor];
  self.navcon.navigationBar.shadowImage = [[UIImage alloc] init];
  self.navcon.navigationBar.translucent = NO;
  [self.navcon setNavigationBarHidden:YES animated:NO];
  UIView *whiteView =
      [[UIView alloc] initWithFrame:CGRectMake(self.window.maxX, 0, self.window.frame.size.width, self.window.frame.size.height)];
  whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.65];
  [whiteView setTag:4];
  whiteView.alpha = 0;
  [self.window addSubview:whiteView];

  self.navcon.navigationBar.translucent = NO;

  [self.navcon.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  [self.window setRootViewController:self.navcon];
  UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 20)];
  statusBar.backgroundColor = kIJumboBlue;
  [self.window makeKeyAndVisible];
  [self.window addSubview:statusBar];

  return YES;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {  
  if (operation == UINavigationControllerOperationPush) {
    if ([fromVC isKindOfClass:[IJHomeViewController class]]) {
      [self.navcon setNavigationBarHidden:NO animated:YES];
    }
    return [[IJPushViewControllerTransition alloc] init];
  } else if (operation == UINavigationControllerOperationPop) {
    if ([toVC isKindOfClass:[IJHomeViewController class]]) {
      [self.navcon setNavigationBarHidden:YES animated:YES];
    }
    return [[IJPopViewControllerTransition alloc] init];
  }
  
  return nil;
}

- (void)addBackgroundImage {
  UIImage *image = [UIImage imageNamed:@"west-olin-blur.png"];
  UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.window.frame];
  backgroundImage.image = image;
  [self.window addSubview:backgroundImage];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iJumbo" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
    
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iJumbo.sqlite"];
    
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask] lastObject];
}

@end
