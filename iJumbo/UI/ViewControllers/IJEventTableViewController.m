//
//  IJEventTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventTableViewController.h"

#import "IJEvent.h"
#import "IJEventTableViewCell.h"
#import "IJHelper.h"

static const int kEventsDateNavigationBarHeight = 44;

@interface IJEventTableViewController ()
@property(nonatomic) NSArray *events;
@property(nonatomic) UILabel *dateLabel;
@end

@implementation IJEventTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Events";
  self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.28];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kEventsDateNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - kEventsDateNavigationBarHeight)];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  [self.view addSubview:self.tableView];
  
  UIView *dateNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kEventsDateNavigationBarHeight)];
  self.dateLabel = [[UILabel alloc] initWithFrame:dateNavigationBar.frame];
  self.dateLabel.textAlignment = NSTextAlignmentCenter;
  self.dateLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
  self.dateLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
  self.dateLabel.text = @"08/08";
  [dateNavigationBar addSubview:self.dateLabel];
  [self.view addSubview:dateNavigationBar];
  [self.tableView reloadData];
  [self loadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)loadData {
  [IJEvent getEventsWithSuccessBlock:^(NSArray *events) {
    self.events = events;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  } failureBlock:^(NSError *error) {
    NSLog(@"Error getting events: %@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"EventCell";
  IJEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  IJEvent *event = self.events[indexPath.row];
  [cell addDataFromEvent:event];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJEvent* event = self.events[indexPath.row];
  NSLog(@"%@", event);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kEventTableViewCellHeight;
}

@end
