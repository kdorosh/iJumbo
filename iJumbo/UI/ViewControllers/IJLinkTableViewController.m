//
//  IJLinkTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLinkTableViewController.h"

#import "IJLinkTableViewCell.h"

@interface IJLinkTableViewController ()
@property(nonatomic) NSArray *links;
@end

@implementation IJLinkTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.28];
  self.tableView.separatorColor = [UIColor clearColor];
  [self loadData];
}

- (void)loadData {
  [IJLink getLinksWithSuccessBlock:^(NSArray *links) {
    self.links = links;
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"There was an error getting the link: %@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.links count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * const cellID = @"LinkTableCell";
  IJLinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  IJLink *link = self.links[indexPath.row];
  [cell addDataFromLink:link];
  return cell;
}

@end
