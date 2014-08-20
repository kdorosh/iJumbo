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
#import "IJLocationViewController.h"

@interface IJLocationTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) UISearchBar *searchBar;
@end

@implementation IJLocationTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
  self.searchBar.delegate = self;
  self.searchBar.barTintColor = kIJumboBlue;
  [self.view addSubview:self.searchBar];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.maxY, self.view.width, self.view.height - self.searchBar.height - self.navigationController.navigationBar.maxY)];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  self.view.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  // TODO(amadou): Get search bar up there.
  self.title = @"Places";
  self.navigationController.navigationBarHidden = NO;
  [self.tableView reloadData];
  [self loadData];
}

- (void)animateHideView {
  [UIView animateWithDuration:kIJViewControllerAnimationTime animations:^{
    self.view.alpha = 0;
  }];
}

- (void)animateShowView {
  [UIView animateWithDuration:kIJViewControllerAnimationTime animations:^{
    self.view.alpha = 1;
  }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)loadData {
  [IJLocation getLocationsWithSuccessBlock:^(NSArray *locations) {
    NSError* error;
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
    header.contentView.backgroundColor = [UIColor colorWithRed:26/255.0f green:191/255.0f blue:237/255.0 alpha:0.75];
    header.tintColor = header.contentView.backgroundColor;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    header.backgroundView = backView;
    header.alpha = 0.1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJLocation *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
  IJLocationViewController *locationViewController = [[IJLocationViewController alloc] initWithLocation:location];
  [self.navigationController pushViewController:locationViewController animated:YES];
}

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJLocation class])];
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sectionSort = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSArray *sortDescriptors = @[sectionSort, nameSort];
    [fetchRequest setSortDescriptors:sortDescriptors];
    // TODO(amadou): Create ophan checker to delete objects that do not match this predicate.
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name != nil AND section != nil"];
    
    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:@"section"
                                                       cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error getting events from core data: %@", error);
    }
    [self.tableView mainThreadReload];
  }
  return _fetchedResultsController;
}

@end
