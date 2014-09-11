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

@interface IJLinkTableViewController () <NSFetchedResultsControllerDelegate>
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
// dictionary<NSString url, IJWebViewController webView>
@property(nonatomic) NSMutableDictionary *urlWebViewMap;
@end

@implementation IJLinkTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Links";
  [self addTableViewWithDelegate:self];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  [self loadData];
}

- (void)loadData {
  [IJLink getLinksWithSuccessBlock:^(NSArray *links) {
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"There was an error getting the link: %@", error);
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
  static NSString * const cellID = @"LinkTableCell";
  IJLinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  IJLink *link = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromLink:link];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJLink *link = [self.fetchedResultsController objectAtIndexPath:indexPath];
  IJWebViewController *webVC = self.urlWebViewMap[link.url];
  if (!webVC) {
    webVC = [[IJWebViewController alloc] initWithURL:link.url];
    self.urlWebViewMap[link.url] = webVC;
  }
  webVC.title = link.name;
  [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSError *error;
  if (![self.fetchedResultsController performFetch:&error] || error) {
    NSLog(@"There was as error updating the links.");
    NSLog(@"%@", error);
  } else {
    [self.tableView mainThreadReload];
  }
}

#pragma mark - Getters/Setters

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest =
        [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJLink class])];
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *idSort = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                             ascending:YES];
    [fetchRequest setSortDescriptors:@[idSort]];

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
    [self.tableView mainThreadReload];
  }
  return _fetchedResultsController;
}

- (NSMutableDictionary *)urlWebViewMap {
  if (!_urlWebViewMap) {
    _urlWebViewMap = [NSMutableDictionary dictionary];
  }
  return _urlWebViewMap;
}


@end
