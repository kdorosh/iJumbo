//
//  IJViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJViewController.h"

@interface IJViewController ()

@end

@implementation IJViewController

- (void)animateShowView {
  [UIView animateWithDuration:kIJViewControllerAnimationTime animations:^{
    self.view.alpha = 0;
  }];
}

- (void)animateHideView {
  [UIView animateWithDuration:kIJViewControllerAnimationTime animations:^{
    self.view.alpha = 1;
  }];
}

- (void)addTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
  CGSize viewSize = self.view.frame.size;
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.maxY, viewSize.width, viewSize.height)];
  // Subclasses might implement these functions
  self.tableView.delegate = delegate;
  self.tableView.dataSource = delegate;
  [self.view addSubview:self.tableView];
}

@end
