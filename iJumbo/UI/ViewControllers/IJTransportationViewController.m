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
@property(nonatomic) NSMutableDictionary *mbtaTimes;
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
  NSString *url = @"http://realtime.mbta.com/developer/api/v2/predictionsbystop?"
                  @"api_key=CvuMAlPRQkKWxdmB_v9FCg&stop=place-davis&format=json";
  [IJServer getJSONAtURL:url success:^(NSDictionary *object) {
    NSArray *modes = object[@"mode"];
    // Loop through all MBTA data for stops at Davis (Bus and Subway).
    for (NSDictionary *dict in modes) {
      // Use the subway data.
      if ([dict[@"mode_name"] isEqualToString:@"Subway"]) {
        NSArray *directions = dict[@"route"][@"direction"];
        for (NSDictionary *direction in directions) {
          // What direction the train is going, Southbound or Northbound.
          NSString *dir_name = direction[@"direction_name"];
          // A list of the trips going in this direction
          NSArray *trips = direction[@"trip"];
          // A list of the departure times.
          NSMutableArray *departureTimes = [NSMutableArray arrayWithCapacity:[trips count]];
          // Get every estimated time of departure for this direction
          for (NSDictionary *trip in trips) {
            NSNumber *dateInSeconds = (NSNumber*)trip[@"sch_dep_dt"];
            [departureTimes addObject:dateInSeconds];
          }
          // Sort the array so the closest time is at index 0.
          NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
          [departureTimes sortUsingDescriptors:@[sort]];
          self.mbtaTimes[dir_name] = departureTimes;
        }
      }
    }
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
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
