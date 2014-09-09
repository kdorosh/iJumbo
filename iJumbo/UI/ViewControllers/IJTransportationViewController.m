//
//  IJTransportationViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJTransportationViewController.h"

#import "IJServer.h"

@interface IJTransportationViewController ()
/// @{ @"Campus Center" : @[ hours... ], "Davis Square" : @[ hours... ] };
@property(nonatomic) NSDictionary *schedule;
@end

@implementation IJTransportationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addTableViewWithDelegate:self];
  [self loadJoeySchedule];
  [self loadMBTATimes];
}

#pragma mark - UITableView Delegate/Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[UITableViewCell alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 40;
  }
  return 90;  // tableview
}

#pragma mark - Network

- (void)loadJoeySchedule {
  [IJServer getJSONAtURL:[kBaseURL stringByAppendingPathComponent:@"joey/schedule"]
  success:^(NSDictionary *joeySchedule) {
    self.schedule = joeySchedule;
    [self writeScheduleToDisk:self.schedule];
    [self.tableView mainThreadReload];
  } failure:^(NSError *error) {
    NSLog(@"Error getting joey schedule: %@", error);
  }];
}

// TOOD(amadou): Get the time going to alewife?
- (void)loadMBTATimes {
  
}

#pragma mark - Reading and Writing

- (void)writeScheduleToDisk:(NSDictionary *)schedule {
  // Check if they schedules are different before updating. - Is that really needed tho?
  // TODO(amadou): Implement this.
}

- (NSDictionary *)readScheduleFromDisk {
  // TODO(amadou): DO THIS!!!
  return nil;
}

- (void)updateTimesWithSchedule:(NSDictionary *)schedule {
  
}


@end
