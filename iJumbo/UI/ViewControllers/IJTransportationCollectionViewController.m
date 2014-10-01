//
//  IJTransportationCollectionViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJTransportationCollectionViewController.h"

#import "IJMinutesTillCollectionViewCell.h"
#import "IJServer.h"
#import "IJRecord.h"

static const int kTimeLowerBound = 4 * 60;

typedef NS_ENUM(NSInteger, IJTransportationSection) {
  IJTransportationSectionMBTA = 0,
  IJTransportationSectionJoeyTime,
  IJTransportationSectionJoeySchedule
};

@interface IJTransportationCollectionViewController ()
@property(nonatomic) NSMutableDictionary *mbtaTimes;
@property(nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic) NSArray *joeySchedule;
@end

@implementation IJTransportationCollectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Transportation";
  self.mbtaTimes = [NSMutableDictionary dictionaryWithCapacity:2];
  self.joeySchedule =
      [NSArray arrayWithContentsOfFile:[IJTransportationCollectionViewController joeyScheduleFile]];
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  layout.headerReferenceSize = CGSizeMake(self.view.width, 40);
  self.collectionView =
      [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.maxY)
                         collectionViewLayout:layout];
  self.collectionView.backgroundColor = [UIColor lightGrayColor];
  self.collectionView.alwaysBounceVertical = YES;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor clearColor];
  [self.collectionView registerClass:[IJMinutesTillCollectionViewCell class]
          forCellWithReuseIdentifier:@"TransportationMinutesTillCell"];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:@"JoeyScheduleCell"];
  [self.collectionView registerClass:[UICollectionReusableView class]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"MinutesTillHeader"];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor blackColor];
  [self.refreshControl addTarget:self
                          action:@selector(loadData)
                forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:self.refreshControl];
  [self.view addSubview:self.collectionView];
  [self loadJoeySchedule];
  [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [self loadDataAnimated:NO];
}

#pragma mark - Network Calls

- (void)loadData {
  [self loadDataAnimated:YES];
}

- (void)loadDataAnimated:(BOOL)animated {
  if (animated) {
    [self.refreshControl beginRefreshing];
  }
  [IJRecord startBatchedRequestsInExecutionBlock:^{
    [self loadMBTATimes];
    [self loadJoeySchedule];
  } withCompletionBlock:^{
    [self.refreshControl endRefreshing];
  }];
}

// TOOD(amadou): Get the time going to alewife?
- (void)loadMBTATimes {
  NSString *url = @"http://realtime.mbta.com/developer/api/v2/predictionsbystop?"
  @"api_key=CvuMAlPRQkKWxdmB_v9FCg&stop=place-davis&format=json";
  [IJServer getJSONAtURL:url success:^(NSDictionary *object) {
    NSArray *modes = object[@"mode"];
    // Loop through all MBTA data for stops at Davis (Bus and Subway).
    self.mbtaTimes = @{@"Southbound": @[].mutableCopy, @"Northbound": @[].mutableCopy}.mutableCopy;
    for (NSDictionary *dict in modes) {
      // Use the subway data.
      if ([dict[@"mode_name"] isEqualToString:@"Subway"]) {
        NSArray *routes = dict[@"route"];
        for (NSDictionary *route in routes) {
          NSDictionary *directions = route[@"direction"];
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
            NSMutableArray *times = self.mbtaTimes[dir_name];
            [times addObjectsFromArray:departureTimes];
          }
        }
      }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.mbtaTimes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *times, BOOL *stop) {
      [times sortUsingDescriptors:@[sort]];
    }];
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

- (void)loadJoeySchedule {
  [IJServer getJSONAtURL:[kBaseURL stringByAppendingPathComponent:@"joey_schedule"]
  success:^(NSArray *schedule) {
    self.joeySchedule = schedule;
    [self.joeySchedule writeToFile:[IJTransportationCollectionViewController joeyScheduleFile]
                        atomically:YES];
    [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                          withObject:nil
                                       waitUntilDone:YES];
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

+ (NSString *)joeyScheduleFile {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *joeyFile = [documentsDirectory stringByAppendingPathComponent:@"joey_file.data"];
  return joeyFile;
}

#pragma mark - CollectionView Delegate & DataSource

// MBTA.
// Joey estimation.
// Full Joey Schedule.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  // TODO(amadou): Change this once the MBTA stuff works.
  return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (section == IJTransportationSectionMBTA) {
    // To Alewife and To Boston.
    return 2;
  } else if (section == IJTransportationSectionJoeyTime) {
    // should always have these 4 times pulled from the schedule.
    return 3;
  } else if (section == IJTransportationSectionJoeySchedule) {
    // The big cell that has the schedule.
    return 1;
  }
  return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == IJTransportationSectionMBTA) {
    // push to map of the davis stop.
    NSLog(@"Where is the Davis stop?");
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    // push to map of the location they selected.
    NSLog(@"The Campus whaa...???");
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == IJTransportationSectionJoeySchedule) {
    // give the cell the schedule data (maybe do that in the cell.
    // return it.
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"JoeyScheduleCell"
                                                  forIndexPath:indexPath];
    // THIS CELL SHOULD BE GIANT.
    return cell;
  }
  NSString *cellIdentifier = @"TransportationMinutesTillCell";
  IJMinutesTillCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                forIndexPath:indexPath];

  NSNumber *minutesTill = (indexPath.row == 0) ? @(3) : @(7);
  NSString *detailText = (indexPath.row == 0) ? @"to Boston" : @"to Alewife";
  if (indexPath.section == IJTransportationSectionMBTA) {
    NSString *directionKey = (indexPath.row == 0) ? @"Southbound" : @"Northbound";
    NSNumber *time = [self getNextTimeForDirection:directionKey];
    if (time) {
      NSTimeInterval secondsSince1970 = [[NSDate date] timeIntervalSince1970];
      NSInteger minutesTillTrain = (time.doubleValue - secondsSince1970) / 60.0f;
      minutesTill = @(minutesTillTrain);
    } else {
      minutesTill = nil;
    }
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    NSString *locationKey = (indexPath.row == 0) ? @"Campus Center" : (indexPath.row == 1) ? @"Davis Square" : @"Olin Center";
    minutesTill = [self getTimeUntilNextJoeyForStop:locationKey];
    detailText = locationKey;
  }
  [cell updateWithMinutes:minutesTill detailText:detailText];
  return cell;
}

- (NSNumber *)getTimeUntilNextJoeyForStop:(NSString *)stop {
  long minutesSinceMidnight = [self minutesSinceMidnight:[NSDate date]];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components =
      [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
  NSInteger weekdays = [components weekday] - 1;
  if (minutesSinceMidnight < kTimeLowerBound) {
    weekdays = (weekdays - 1) % 7;
  }
  NSArray *times = self.joeySchedule[weekdays][stop];
  NSNumber *nextTime = nil;
  if (times == nil) {
    return nil;
  } else {
    int distance = 24 * 60;
    for (NSNumber *time in times) {
      NSInteger minutes = (time.integerValue <= kTimeLowerBound) ? time.integerValue + (24 * 60) : time.integerValue;
      if (minutes - minutesSinceMidnight > 0 &&
          minutes - minutesSinceMidnight < distance) {
        distance = (int)minutes - (int)minutesSinceMidnight;
        nextTime = time;
      }
    }
  }
  if (!nextTime)
    return nil;
  return @(nextTime.integerValue - minutesSinceMidnight);
}

- (long)minutesSinceMidnight:(NSDate *)date {
  NSCalendar *gregorian =
      [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  unsigned unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
  NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
  
  return 60 * [components hour] + [components minute];
}

- (NSNumber *)getNextTimeForDirection:(NSString *)direction {
  NSMutableArray *times = self.mbtaTimes[direction];
  if (!times || [times count] == 0) {
    return nil;
  }
  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
  for (NSNumber *time in times) {
    if (time.doubleValue > timeInterval) {
      return time;
    }
  }
  return nil;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
    return nil;
  }
  NSString *identifier = @"MinutesTillHeader";
  UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:identifier
                                                                               forIndexPath:indexPath];
  header.backgroundColor = [UIColor colorWithRed:26/255.0f
                                           green:191/255.0f
                                            blue:237/255.0
                                           alpha:0.65];
  UILabel *headerLabel = (UILabel*)[header viewWithTag:2];
  if (!headerLabel) {
    const int padding = 20;
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, header.width - (2 * padding), header.height)];
    [headerLabel setTag:2];
    headerLabel.font = [UIFont regularFontWithSize:18];
    headerLabel.textColor = [UIColor whiteColor];
    [header addSubview:headerLabel];
  }
  if (indexPath.section == IJTransportationSectionMBTA) {
    headerLabel.text = @"MBTA | Davis Square T Stop";
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    headerLabel.text = @"Joey | Based on Calendar";
  } else if (indexPath.section == IJTransportationSectionJoeySchedule) {
    // Look at mocks for bar that helps select the the date for the schedule.
  }
  return header;
}

@end
