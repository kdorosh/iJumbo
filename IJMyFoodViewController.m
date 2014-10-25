//
//  IJMyFoodViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMyFoodViewController.h"

#import "IJFoodItem.h"
#import "IJFoodItemTableViewCell.h"

@interface IJMyFoodViewController ()
@property(nonatomic) NSArray *subscribedFoods;
@end

@implementation IJMyFoodViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  [self addTableViewWithDelegate:self];
  self.tableView.backgroundColor = [UIColor clearColor];
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self
                     action:@selector(loadData)
           forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:refreshControl];
  self.subscribedFoods = [IJFoodItem subscribedFood];
  UIBarButtonItem *addBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(showAllFoodItemsList)];
  self.navigationItem.rightBarButtonItem = addBarButtonItem;
  __weak IJMyFoodViewController *weakSelf = self;
  [IJFoodItem fetchSubscribedFoodWithSuccessBlock:^(NSArray *foodItems) {
    NSArray *ids = [foodItems valueForKey:@"id"];
    [IJFoodItem writeSubscribedFoodsToDisk:ids];
    weakSelf.subscribedFoods = foodItems;
  } failureBlock:^(NSError *error) {
    NSLog(@"fetch my food error: %@", error);
  }];
}

- (void)loadData {
  __weak IJMyFoodViewController *weakSelf = self;
  [IJFoodItem fetchSubscribedFoodWithSuccessBlock:^(NSArray *foodItems) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.subscribedFoods count];
}

- (void)showAllFoodItemsList {
  UIViewController *vc = [[UIViewController alloc] init];
  vc.title = @"All Food";
  [self.navigationController pushViewController:vc animated:YES];
}

@end
