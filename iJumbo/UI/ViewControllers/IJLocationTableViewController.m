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
#import "IJMapViewController.h"
#import "IJTableViewHeaderFooterView.h"

@interface IJLocationTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, IJLocationTableViewCellDelegate, IJMapViewControllerDelegate>
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) UISearchBar *searchBar;
@end

@implementation IJLocationTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
  self.searchBar.delegate = self;
  self.searchBar.barTintColor = kIJumboBlue;
  self.searchBar.tintColor = [UIColor whiteColor];
  [self.view addSubview:self.searchBar];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.maxY, self.view.width, self.view.height - self.searchBar.height - self.navigationController.navigationBar.maxY)];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  self.view.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  
  UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(showMap)];
  self.navigationItem.rightBarButtonItem = mapButton;

  // TODO(amadou): Get search bar up there.
  self.title = @"Places";
  self.navigationController.navigationBarHidden = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBarCancelButton) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSearchBarCancelButton) name:UIKeyboardWillHideNotification object:nil];
  [self.tableView reloadData];
  [self loadData];
}

- (void)showMap {
  // TODO(amadou): Have the map zoomed into the campus.
  // TODO(amadou): Map should show current location.
  // Ask for permission the first time the map launches.
  [self.navigationController pushViewController:[[IJMapViewController alloc] init] animated:YES];
}

- (void)showSearchBarCancelButton {
  [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)hideSearchBarCancelButton {
  [self.searchBar setShowsCancelButton:NO animated:YES];
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
  [IJLocation getLocationsWithSuccessBlock:^(NSArray *locations) { }
                              failureBlock:^(NSError *error) {
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
    cell = [[IJLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    cell.delegate = self;
  }
  IJLocation *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromLocation:location];
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  static NSString *headerIdentifier = @"LocationHeader";
  IJTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
  if (!header) {
    header = [[IJTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
  }
  id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
  header.sectionTitleLabel.text = [sectionInfo name];
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kTableViewHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJLocation *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
  NSLog(@"%@", location);
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
    
    fetchRequest.predicate = [IJLocationTableViewController defaultPredicate];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self.searchBar isFirstResponder]) {
    [self.searchBar resignFirstResponder];
  }
}

#pragma mark - IJTableViewCellDelegate

- (void)didClickInfoButton:(IJLocationTableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didClickMapButton:(IJLocationTableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  // TODO(amadou): Should pass this location to mapVC to display.
  // Map VC should take an arary of IJLocations and display them on the map in viewDidLoad.
  IJLocation *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
  IJMapViewController *mapVC = [[IJMapViewController alloc] initWithLocations:@[location]];
  mapVC.delegate = self;
  [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - IJMapViewControllerDelegate

- (void)mapViewController:(IJMapViewController *)mapVC didSearchForText:(NSString *)text {
  [self.navigationController popViewControllerAnimated:YES];
  self.searchBar.text = text;
  [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  self.searchBar.text = @"";
  [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  self.fetchedResultsController.fetchRequest.predicate =
      [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", self.searchBar.text];
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  [self.tableView reloadData];
  [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (searchText.length == 0) {
    self.fetchedResultsController.fetchRequest.predicate =
        [IJLocationTableViewController defaultPredicate];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
  }
}

// TODO(amadou): Create ophan checker to delete objects that do not match this predicate.
+ (NSPredicate*)defaultPredicate {
  return [NSPredicate predicateWithFormat:@"name != nil AND section != nil"];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSError *error;
  if (![self.fetchedResultsController performFetch:&error] || error) {
    NSLog(@"There was as error updating the locations.");
    NSLog(@"%@", error);
  } else {
    [self.tableView mainThreadReload];
  }
}

@end
