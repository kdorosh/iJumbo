//
//  IJHomeViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJHomeViewController.h"

#import "IJEventTableViewController.h"
#import "IJLinkTableViewController.h"
#import "IJLocationTableViewController.h"
#import "IJMenuTableViewController.h"
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
@property(nonatomic) IJEventTableViewController *eventsVC;
@property(nonatomic) IJNewsTableViewController *newsVC;
@property(nonatomic) IJMenuTableViewController *menusVC;
@property(nonatomic) IJLinkTableViewController *linksVC;
@property(nonatomic) IJLocationTableViewController *locationsVC;
@end

@implementation IJHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeAll;
  self.view.backgroundColor = [UIColor clearColor];
  // TODO(amadou): get gesture pop to work. This is a hack to make it work but there needs to be a
  // new implementation because the animations are done custom now.
  // self.navigationController.interactivePopGestureRecognizer.delegate = self;
  [self addSeparators];
  [self setupButtons];
  [self setupIcons];
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
  
  [self.eventsButton setImage:[UIImage imageNamed:@"events.png"] forState:UIControlStateNormal];
  [self.newsButton setImage:[UIImage imageNamed:@"news.png"] forState:UIControlStateNormal];
  [self.locationsButton setImage:[UIImage imageNamed:@"maps.png"] forState:UIControlStateNormal];
  [self.menusButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
  [self.transportationButton setImage:[UIImage imageNamed:@"transportation.png"] forState:UIControlStateNormal];
  [self.linksButton setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
  
  CGFloat labelWidth = self.view.frame.size.width/2.0f;
  CGFloat labelHeight = 28;

  UILabel *newsLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.newsButton.imageView maxY] + 5, labelWidth, labelHeight}];
  UILabel *placesLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.newsButton.imageView maxY] + 5, labelWidth, labelHeight}];
  UILabel *menuLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.menusButton.imageView maxY] + 5, labelWidth, labelHeight}];
  UILabel *transportLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.menusButton.imageView maxY] + 5, labelWidth, labelHeight}];
  UILabel *eventLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.eventsButton.imageView maxY] + 5, labelWidth, labelHeight}];
  UILabel *linksLabel = [[UILabel alloc] initWithFrame:(CGRect){0, [self.eventsButton.imageView maxY] + 5, labelWidth, labelHeight}];
  
  newsLabel.text = @"News";
  newsLabel.textAlignment = NSTextAlignmentCenter;
  placesLabel.text = @"Places";
  placesLabel.textAlignment = NSTextAlignmentCenter;
  menuLabel.text = @"Menus";
  menuLabel.textAlignment = NSTextAlignmentCenter;
  transportLabel.text = @"Transportation";
  transportLabel.textAlignment = NSTextAlignmentCenter;
  eventLabel.text = @"Events";
  eventLabel.textAlignment = NSTextAlignmentCenter;
  linksLabel.text = @"Links";
  linksLabel.textAlignment = NSTextAlignmentCenter;
  
  UIFont *labelFont = [UIFont regularFontWithSize:12];
  newsLabel.font = labelFont;
  placesLabel.font = labelFont;
  menuLabel.font = labelFont;
  transportLabel.font = labelFont;
  eventLabel.font = labelFont;
  linksLabel.font = labelFont;
  
  newsLabel.textColor = [UIColor whiteColor];
  placesLabel.textColor = [UIColor whiteColor];
  menuLabel.textColor = [UIColor whiteColor];
  transportLabel.textColor = [UIColor whiteColor];
  eventLabel.textColor = [UIColor whiteColor];
  linksLabel.textColor = [UIColor whiteColor];
  
  [self.newsButton addSubview:newsLabel];
  [self.locationsButton addSubview:placesLabel];
  [self.menusButton addSubview:menuLabel];
  [self.transportationButton addSubview:transportLabel];
  [self.eventsButton addSubview:eventLabel];
  [self.linksButton addSubview:linksLabel];
  
  [self.view addSubviews:@[
      self.newsButton,
      self.locationsButton,
      self.menusButton,
      self.transportationButton,
      self.eventsButton,
      self.linksButton
  ]];
}
   
- (void)setupIcons {
  UIImageView *eventsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"events.png"]];
  eventsIcon.center = self.eventsButton.center;
  [self.eventsButton setImage:[UIImage imageNamed:@"events.png"] forState:UIControlStateNormal];
  //[self.view addSubview:eventsIcon];
 // UIImageView * = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news.png"]];
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
  [self.navigationController pushViewController:self.newsVC
                                       animated:YES];
}

- (void)pushLocations {
  [self.navigationController pushViewController:self.locationsVC
                                       animated:YES];
}

- (void)pushMenus {
  [self.navigationController pushViewController:self.menusVC
                                       animated:YES];
}

- (void)pushTransportation {
  NSLog(@"why y no code me?");
}

- (void)pushEvents {
  [self.navigationController pushViewController:self.eventsVC
                                       animated:YES];
}

- (void)pushLinks {
  [self.navigationController pushViewController:self.linksVC
                                       animated:YES];
}

#pragma mark - Getters/Setters

- (IJEventTableViewController *)eventsVC {
  if (!_eventsVC) {
    _eventsVC = [[IJEventTableViewController alloc] init];
  }
  return _eventsVC;
}

- (IJNewsTableViewController *)newsVC {
  if (!_newsVC) {
    _newsVC = [[IJNewsTableViewController alloc] init];
  }
  return _newsVC; 
}

- (IJLocationTableViewController *)locationsVC {
  if (!_locationsVC) {
    _locationsVC = [[IJLocationTableViewController alloc] init];
  }
  return _locationsVC;
}

- (IJMenuTableViewController *)menusVC {
  if (!_menusVC) {
    _menusVC = [[IJMenuTableViewController alloc] init];
  }
  return _menusVC;
}

- (IJLinkTableViewController *)linksVC {
  if (!_linksVC) {
    _linksVC = [[IJLinkTableViewController alloc] init];
  }
  return _linksVC;
}

@end
