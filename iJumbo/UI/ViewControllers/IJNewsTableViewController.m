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

static NSString * const kNewsDailyActionSheetText = @"Daily";
static NSString * const kNewsObserverActionSheetText = @"Observer";

@interface IJNewsTableViewController () <UIActionSheetDelegate>
@property(nonatomic) NSArray *articles;
@property(nonatomic) NSArray *dailyArtilces;
@property(nonatomic) NSArray *observerArticles;
@property(nonatomic) UIBarButtonItem *sourceBarButton;
@end

@implementation IJNewsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.28];
  self.tableView.backgroundColor = self.view.backgroundColor;
  self.tableView.separatorColor = [UIColor clearColor];
  self.title = @"News";
  self.dailyArtilces = [NSArray array];
  self.observerArticles = [NSArray array];
  self.articles = self.dailyArtilces;
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

- (void)setDatasourceFromUI {
  if ([self.sourceBarButton.title isEqualToString:kNewsDailyActionSheetText]) {
    self.articles = self.dailyArtilces;
  } else {
    self.articles = self.observerArticles;
  }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)loadData {
  [IJArticle getDailyArticlesWithSuccessBlock:^(NSArray *articles) {
    self.dailyArtilces = articles;
    [self setDatasourceFromUI];
  } failureBlock:^(NSError *error) {
    NSLog(@"News Daily Error: %@", error);
  }];
  [IJArticle getObserverArticlesWithSuccessBlock:^(NSArray *articles) {
    self.observerArticles = articles;
    [self setDatasourceFromUI];
  } failureBlock:^(NSError *error) {
    NSLog(@"News Observer Error: %@", error);
  }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"Action sheet index: %i", buttonIndex);
  NSString *selectedText = [actionSheet buttonTitleAtIndex:buttonIndex];
  if ([selectedText isEqualToString:kNewsDailyActionSheetText]) {
    self.sourceBarButton.title = kNewsDailyActionSheetText;
    self.articles = self.dailyArtilces;
  } else if ([selectedText isEqualToString:kNewsObserverActionSheetText]) {
    self.sourceBarButton.title = kNewsObserverActionSheetText;
    self.articles = self.observerArticles;
  }
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"NewsCell";
  IJNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
  }
  IJArticle *article = self.articles[indexPath.row];
  [cell addDataFromArticle:article];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kNewsTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJArticle *article = self.articles[indexPath.row];
  NSLog(@"Article: %@", article);
}

- (void)setArticles:(NSArray *)articles {
  _articles = articles;
  [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
