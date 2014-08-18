//
//  IJLocationTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocationTableViewController.h"

#import "IJLocation.h"
#import "IJLocationTableViewCell.h"

@interface IJLocationTableViewController ()
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation IJLocationTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.28];
  self.tableView.separatorColor = [UIColor clearColor];
  // TODO(amadou): Get search bar up there.
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
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[self.fetchedResultsController sections] count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"LocationCell";
  IJLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[IJLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  IJLocation *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromLocation:location];
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  static NSString *headerIdentifier = @"LocationHeader";
  UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
  if (!header) {
    header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
    header.contentView.backgroundColor = [UIColor colorWithRed:26/255.0f green:191/255.0f blue:237/255.0 alpha:0.5];
    const int padding = 20;
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, tableView.frame.size.width - (2 * padding), kLocationTableViewCellHeight)];
    [sectionTitle setTextColor:[UIColor whiteColor]];
    [sectionTitle setTag:1];
    [sectionTitle setBackgroundColor:[UIColor clearColor]];
    [header addSubview:sectionTitle];
  }
  UILabel *title = (UILabel*)[header viewWithTag:1];
  id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
  title.text = [sectionInfo name];
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kLocationTableViewCellHeight;
}

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJLocation class])];
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 25;
    
    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:@"section"
                                                       cacheName:nil];
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error getting events from core data: %@", error);
    }
  }
  return _fetchedResultsController;
}




@end
