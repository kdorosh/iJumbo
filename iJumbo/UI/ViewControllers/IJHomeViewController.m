//
//  IJHomeViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJHomeViewController.h"

#import "IJEventTableViewController.h"
#import "IJLocationTableViewController.h"
#import "IJNewsTableViewController.h"

#import "UIView+AddSubviews.h"

static const CGFloat kSeparatorBarWidth = 1.5;

@interface IJHomeViewController ()
@property(nonatomic) UIButton *newsButton;
@property(nonatomic) UIButton *locationsButton;
@property(nonatomic) UIButton *menusButton;
@property(nonatomic) UIButton *transportationButton;
@property(nonatomic) UIButton *eventsButton;
@property(nonatomic) UIButton *linksButton;
@property(nonatomic) UIView *separatorView;
@end

@implementation IJHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeAll;
  self.view.backgroundColor = [UIColor clearColor];
  [self addSeparators];
  [self setupButtons];
}

- (void)viewWillDisappear:(BOOL)animated {
  self.separatorView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  self.separatorView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  self.separatorView.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
  self.separatorView.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)setupButtons {
  CGSize size = self.view.frame.size;
  CGFloat width = size.width / 2;
  CGFloat height = size.height /3;

  // Create the buttons.
  self.newsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  self.locationsButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
  self.menusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height, width, height)];
  self.transportationButton = [[UIButton alloc] initWithFrame:CGRectMake(width, height, width, height)];
  self.eventsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2 * height, width, height)];
  self.linksButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 2 * height, width, height)];
  
  // Set actions for the buttons.
  [self.newsButton addTarget:self action:@selector(pushNews) forControlEvents:UIControlEventTouchUpInside];
  [self.locationsButton addTarget:self action:@selector(pushLocations) forControlEvents:UIControlEventTouchUpInside];
  [self.menusButton addTarget:self action:@selector(pushMenus) forControlEvents:UIControlEventTouchUpInside];
  [self.transportationButton addTarget:self action:@selector(pushTransportation) forControlEvents:UIControlEventTouchUpInside];
  [self.eventsButton addTarget:self action:@selector(pushEvents) forControlEvents:UIControlEventTouchUpInside];
  [self.linksButton addTarget:self action:@selector(pushLinks) forControlEvents:UIControlEventTouchUpInside];

  self.newsButton.titleLabel.text = @"News";
  self.locationsButton.titleLabel.text = @"Places";
  self.menusButton.titleLabel.text = @"Menus";
  self.transportationButton.titleLabel.text = @"Transportation";
  self.eventsButton.titleLabel.text = @"Events";
  self.linksButton.titleLabel.text = @"Links";
  
  [self.view addSubviews:@[
      self.newsButton,
      self.locationsButton,
      self.menusButton,
      self.transportationButton,
      self.eventsButton,
      self.linksButton
  ]];
}

- (void)addSeparators {
  CGSize size = self.view.frame.size;
  UIView *middleBar = [[UIView alloc] initWithFrame:CGRectMake(size.width/2 - kSeparatorBarWidth/2, 0, kSeparatorBarWidth, size.height)];
  UIView *firstBar = [[UIView alloc] initWithFrame:CGRectMake(0, size.height/3 - kSeparatorBarWidth/2, size.width, kSeparatorBarWidth)];
  UIView *secondBar = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * (size.height/3) - kSeparatorBarWidth/2, size.width, kSeparatorBarWidth)];
  middleBar.backgroundColor = [UIColor whiteColor];
  firstBar.backgroundColor = [UIColor whiteColor];
  secondBar.backgroundColor = [UIColor whiteColor];
  self.separatorView = [[UIView alloc] initWithFrame:self.view.frame];
  [self.separatorView addSubviews:@[middleBar, firstBar, secondBar]];
  [self.view addSubview:self.separatorView];
}

- (void)pushNews {
  [self.navigationController pushViewController:[[IJNewsTableViewController alloc] init]
                                       animated:YES];
}

- (void)pushLocations {
  [self.navigationController pushViewController:[[IJLocationTableViewController alloc] init]
                                       animated:YES];
}

- (void)pushMenus {
  [self.navigationController pushViewController:nil animated:YES];
}

- (void)pushTransportation {
  [self.navigationController pushViewController:nil animated:YES];
}

- (void)pushEvents {
  [self.navigationController pushViewController:[[IJEventTableViewController alloc] init]
                                       animated:YES];
}

- (void)pushLinks {
  [self.navigationController pushViewController:nil animated:YES];
}

@end
