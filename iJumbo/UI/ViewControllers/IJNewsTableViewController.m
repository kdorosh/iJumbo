//
//  IJNewsTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJNewsTableViewController.h"

#import "IJArticle.h"
#import "IJNewsTableViewCell.h"
#import "IJWebViewController.h"

static NSString * const kNewsDailyActionSheetText = @"Daily";
static NSString * const kNewsObserverActionSheetText = @"Observer";

@interface IJNewsTableViewController () <UIActionSheetDelegate>
@property(nonatomic) UIBarButtonItem *sourceBarButton;
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation IJNewsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self addTableViewWithDelegate:self];
  self.tableView.backgroundColor = self.view.backgroundColor;
  self.tableView.separatorColor = [UIColor clearColor];
  self.title = @"News";
  self.sourceBarButton = [[UIBarButtonItem alloc] initWithTitle:kNewsDailyActionSheetText
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(displaySources)];
  [self.navigationItem setRightBarButtonItem:self.sourceBarButton];
  [self.tableView reloadData];
  [self loadData];
}

- (void)displaySources {
  UIActionSheet *sourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select News Source"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:kNewsDailyActionSheetText, kNewsObserverActionSheetText, nil];
  [sourceActionSheet showFromRect:CGRectMake(320 - 60, 0, 60, 60) inView:self.view animated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

// TODO(amadou): when articles load for the first time ever, they do not show after loading
// and also causes a crash.
- (void)loadData {
  [self loadDailyArticles];
  [self loadObserverArticles];
}

- (void)loadDailyArticles {
  [IJArticle getDailyArticlesWithSuccessBlock:^(NSArray *articles) {
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"News Daily Error: %@", error);
  }];
}

- (void)loadObserverArticles {
  [IJArticle getObserverArticlesWithSuccessBlock:^(NSArray *articles) {
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"News Observer Error: %@", error);
  }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *selectedText = [actionSheet buttonTitleAtIndex:buttonIndex];
  if ([selectedText isEqualToString:kNewsDailyActionSheetText]) {
    self.sourceBarButton.title = kNewsDailyActionSheetText;
    [self updateFetchRequestForSource:selectedText];
  } else if ([selectedText isEqualToString:kNewsObserverActionSheetText]) {
    self.sourceBarButton.title = kNewsObserverActionSheetText;
    [self updateFetchRequestForSource:selectedText];
  }
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
  static NSString *cellID = @"NewsCell";
  IJNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
  }
  IJArticle *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromArticle:article];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kNewsTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJArticle *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
  IJWebViewController *webVC = [[IJWebViewController alloc] initWithURL:article.link];
  webVC.title = article.source;
  [self.navigationController pushViewController:webVC animated:YES];
}

- (void)updateFetchRequestForSource:(NSString *)source {
  self.fetchedResultsController.fetchRequest.predicate =
      [NSPredicate predicateWithFormat:@"source == %@", source];
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  if (error) {
    NSLog(@"error updating news fetch request: %@", error);
  }
  [self.tableView mainThreadReload];
}

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJArticle class])];
    // Configure the request's entity, and optionally its predicate.
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source == %@", self.sourceBarButton.title];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posted" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 10;
    
    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
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
