//
//  IJAllFoodViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/26/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJAllFoodViewController.h"

#import "IJFoodItem.h"
#import "IJFoodItemTableViewCell.h"
#import "UIAlertView+Blocks.h"

static NSString * const kAllFoodFirstShowUserDefaultsKey = @"AllFoodFirstShowUserDefaultsKey";

@interface IJAllFoodViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) NSSet *subscribedFood;
@end

@implementation IJAllFoodViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addTableViewWithDelegate:self];
  self.subscribedFood = [NSSet setWithArray:[IJFoodItem subscribedFood]];
  self.tableView.backgroundColor = [UIColor clearColor];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(foodSubscriptionsChanged)
                                               name:kSubscribedToFoodItemNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(foodSubscriptionsChanged)
                                               name:kUnsubscribedToFoodItemNotification
                                             object:nil];
  if (![[NSUserDefaults standardUserDefaults] boolForKey:kAllFoodFirstShowUserDefaultsKey]) {
    [UIAlertView showWithTitle:@"Click a food item to subscribe to or unsubscribe from it"
                       message:@"You are subscribed to bold items!"
             cancelButtonTitle:@"Okay!"
             otherButtonTitles:nil
                      tapBlock:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAllFoodFirstShowUserDefaultsKey];
  }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[self.fetchedResultsController sections] count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"FoodItemCell";
  IJFoodItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJFoodItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellID];
  }
  IJFoodItem *foodItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromFoodItem:foodItem];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJFoodItem* foodItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
  if ([self.subscribedFood member:foodItem]) {
    [IJFoodItem unsubscribeFromFoodItem:foodItem];
  } else {
    [IJFoodItem subscribeToFoodItem:foodItem];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kFoodItemTableViewCellHeight;
}
   
#pragma mark - Notification Center

- (void)foodSubscriptionsChanged {
  self.subscribedFood = [NSSet setWithArray:[IJFoodItem subscribedFood]];
  [self.tableView mainThreadReload];
}

#pragma mark - Setters and Getters

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJFoodItem class])];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 25;
    
    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error getting events from core data: %@", error);
    }
  }
  return _fetchedResultsController;
}

@end
