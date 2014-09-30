//
//  IJLinkTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLinkTableViewController.h"

#import "IJLinkTableViewCell.h"
#import "IJLinkCollectionViewCell.h"
#import "IJWebViewController.h"

const int kNumberOfColumns = 2;

@interface IJLinkTableViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
// dictionary<NSString url, IJWebViewController webView>
@property(nonatomic) NSMutableDictionary *urlWebViewMap;
@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) UIRefreshControl *refreshControl;
@end

@implementation IJLinkTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Links";
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)
                                           collectionViewLayout:layout];
  [self.collectionView registerClass:[IJLinkCollectionViewCell class]
          forCellWithReuseIdentifier:@"LinkTableViewCell"];
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.bounces = YES;
  self.collectionView.alwaysBounceVertical = YES;
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor blackColor];
  [self.refreshControl addTarget:self action:@selector(loadData)
                forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:self.refreshControl];
  
  [self.view addSubview:self.collectionView];
  [self.collectionView reloadData];
  [self loadDataAnimate:NO];
}

- (void)loadData {
  [self loadDataAnimate:YES];
}

- (void)loadDataAnimate:(BOOL)animate {
  if (animate) {
    [self.refreshControl beginRefreshing];
  }
  [IJLink getLinksWithSuccessBlock:^(NSArray *links) {
    [self.refreshControl endRefreshing];
    [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                          withObject:nil
                                       waitUntilDone:YES];
  } failureBlock:^(NSError *error) {
    [self.refreshControl endRefreshing];
    NSLog(@"There was an error getting the link: %@", error);
  }];
}

#pragma mark - CollectionView Delegate & DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = indexPath.section * kNumberOfColumns;
  index += indexPath.row;
  IJLink *link = [[self.fetchedResultsController fetchedObjects] objectAtIndex:index];
  IJWebViewController *webVC = self.urlWebViewMap[link.url];
  if (!webVC) {
    webVC = [[IJWebViewController alloc] initWithURL:link.url];
    self.urlWebViewMap[link.url] = webVC;
  }
  webVC.title = link.name;
  [self.navigationController pushViewController:webVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSArray *links = [self.fetchedResultsController fetchedObjects];
  return [links count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  IJLinkCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"LinkTableViewCell"
                                                forIndexPath:indexPath];
  IJLink *link = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromLink:link];
  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.view.width/2.0f - 10, self.view.width/3.0f);
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSError *error;
  if (![self.fetchedResultsController performFetch:&error] || error) {
    NSLog(@"There was as error updating the links.");
    NSLog(@"%@", error);
  } else {
    [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                          withObject:nil
                                       waitUntilDone:YES];
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
    [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                          withObject:nil
                                       waitUntilDone:YES];
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
