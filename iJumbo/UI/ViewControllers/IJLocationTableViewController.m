//
//  IJLocationTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocationTableViewController.h"

#import "IJLocation.h"

@interface IJLocationTableViewController ()
@property(nonatomic) NSArray *locations;
@end

@implementation IJLocationTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.title = @"Places";
  self.navigationController.navigationBarHidden = NO;
  [self.tableView reloadData];
  [self loadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)loadData {
  [IJLocation getLocationsWithSuccessBlock:^(NSArray *locations) {
    self.locations = locations;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.locations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"LocationCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  IJLocation *location = self.locations[indexPath.row];
  cell.textLabel.text = location.name;
  return cell;
}

@end
