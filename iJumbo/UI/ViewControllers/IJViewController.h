//
//  IJViewController.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

static const double kIJViewControllerAnimationTime = 0.30;

@interface IJViewController : UIViewController

@property(nonatomic)UITableView *tableView;

- (void)animateHideView;
- (void)animateShowView;
/// Call this to view controllers that really should be UITableViewControllers
- (void)addTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate;
@end
