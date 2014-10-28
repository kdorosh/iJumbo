//
//  IJMyFoodViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMyFoodViewController.h"

#import "IJAllFoodViewController.h"
#import "IJFoodItem.h"
#import "IJFoodItemTableViewCell.h"

@interface IJMyFoodViewController ()
@property(nonatomic) NSArray *subscribedFoods;
@property(nonatomic) UIRefreshControl *refreshControl;
@end

@implementation IJMyFoodViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"My Food";
  self.view.backgroundColor = [UIColor clearColor];
  [self addTableViewWithDelegate:self];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(loadData)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  self.subscribedFoods = [IJFoodItem subscribedFood];
  UIBarButtonItem *addBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(showAllFoodItemsList)];
  self.navigationItem.rightBarButtonItem = addBarButtonItem;
  __weak IJMyFoodViewController *weakSelf = self;
  [self getSubscriptionNotifications];
  [IJFoodItem fetchSubscribedFoodWithSuccessBlock:^(NSArray *foodItems) {
    NSArray *ids = [foodItems valueForKey:@"id"];
    [IJFoodItem writeSubscribedFoodsToDisk:ids];
    weakSelf.subscribedFoods = foodItems;
  } failureBlock:^(NSError *error) {
    NSLog(@"fetch my food error: %@", error);
  }];
}

- (void)getSubscriptionNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateSubscribedFood)
                                               name:kSubscribedToFoodItemNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateSubscribedFood)
                                               name:kUnsubscribedToFoodItemNotification
                                             object:nil];
}

- (void)updateSubscribedFood {
  self.subscribedFoods = [IJFoodItem subscribedFood];
  [self.tableView mainThreadReload];
}

- (void)loadData {
  if (![self.refreshControl isRefreshing]) {
    [self.refreshControl beginRefreshing];
  }
  __weak IJMyFoodViewController *weakSelf = self;
  [IJFoodItem fetchSubscribedFoodWithSuccessBlock:^(NSArray *foodItems) {
    [self.refreshControl endRefreshing];
    weakSelf.subscribedFoods = foodItems;
    NSArray *ids = [foodItems valueForKey:@"id"];
    [IJFoodItem writeSubscribedFoodsToDisk:ids];
  } failureBlock:^(NSError *error) {
    NSLog(@"ERoRRYBP: %@", error);
  }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * const cellID = @"MyFoodItemTableCell";
  IJFoodItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJFoodItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  IJFoodItem *foodItem = self.subscribedFoods[indexPath.row];
  [cell addDataFromFoodItem:foodItem];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJFoodItem *foodItem = self.subscribedFoods[indexPath.row];
  [IJFoodItem unsubscribeFromFoodItem:foodItem];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.subscribedFoods count];
}

- (void)showAllFoodItemsList {
  IJAllFoodViewController *allFoodVC = [[IJAllFoodViewController alloc] init];
  allFoodVC.title = @"Food";
  [self.navigationController pushViewController:allFoodVC animated:YES];
}

@end
