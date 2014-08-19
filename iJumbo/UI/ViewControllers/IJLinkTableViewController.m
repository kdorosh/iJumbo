//
//  IJLinkTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLinkTableViewController.h"

#import "IJLinkTableViewCell.h"
#import "IJWebViewController.h"

@interface IJLinkTableViewController ()
@property(nonatomic) NSArray *links;
@end

@implementation IJLinkTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addTableViewWithDelegate:self];
  self.tableView.backgroundColor = [UIColor clearColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJLink *link = self.links[indexPath.row];
  [self.navigationController pushViewController:[[IJWebViewController alloc] initWithURL:link.url] animated:YES];
}

@end
