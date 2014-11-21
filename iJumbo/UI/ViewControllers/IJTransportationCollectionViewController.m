//
//  IJTransportationCollectionViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJTransportationCollectionViewController.h"

#import "IJJoeyTimeCollectionViewCell.h"
#import "IJMinutesTillCollectionViewCell.h"
#import "IJServer.h"
#import "IJRecord.h"

#import "UIActionSheet+Blocks.h"
#import "UIColor+iJumboColors.h"

static const int kTimeLowerBound = 2 * 60;
static const int kHeaderLabelTag = 2;
static const int kDateHeaderButtonTag = 4;

typedef NS_ENUM(NSInteger, IJTransportationSection) {
  IJTransportationSectionMBTA = 0,
  IJTransportationSectionJoeyTime,
  IJTransportationSectionJoeySchedule,
  IJTransportationSectionNumberOfSections
};

@interface IJTransportationCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic) NSMutableDictionary *mbtaTimes;
@property(nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic) NSArray *joeySchedule;
@property(nonatomic) NSInteger weekday;
@end

@implementation IJTransportationCollectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Transportation";
  self.view.backgroundColor = [UIColor transparentWhiteBackground];
  self.weekday = [IJTransportationCollectionViewController weekdayForScheduleOnDate:[NSDate date]];
  self.mbtaTimes = [NSMutableDictionary dictionaryWithCapacity:2];
  self.joeySchedule =
      [NSArray arrayWithContentsOfFile:[IJTransportationCollectionViewController joeyScheduleFile]];
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  layout.headerReferenceSize = CGSizeMake(self.view.width, 40);
  self.collectionView =
      [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.maxY)
                         collectionViewLayout:layout];
  self.collectionView.alwaysBounceVertical = YES;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor clearColor];

  [self.collectionView registerClass:[IJMinutesTillCollectionViewCell class]
          forCellWithReuseIdentifier:@"JoeyTimeID"];
  [self.collectionView registerClass:[IJMinutesTillCollectionViewCell class]
          forCellWithReuseIdentifier:@"MBTATimeID"];
  [self.collectionView registerClass:[IJJoeyTimeCollectionViewCell class]
          forCellWithReuseIdentifier:@"JoeyScheduleCell"];
  [self.collectionView registerClass:[UICollectionReusableView class]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"MinutesTillHeader"];
  [self.collectionView registerClass:[UICollectionReusableView class]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"ScheduleHeader"];
  
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

- (void)viewDidAppear:(BOOL)animated {
  [self.collectionView reloadData];
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
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
              NSNumber *timeTillDeparture = (NSNumber*)trip[@"pre_away"];
              [departureTimes addObject:timeTillDeparture];
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
      [times sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.integerValue > obj2.integerValue) {
          return (NSComparisonResult)NSOrderedDescending;
        } else if (obj1.integerValue < obj2.integerValue) {
          return (NSComparisonResult)NSOrderedAscending;
        } else {
          return (NSComparisonResult)NSOrderedSame;
        }
      }];
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
  return IJTransportationSectionNumberOfSections;
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
    NSArray *times = self.joeySchedule[self.weekday][@"Olin Center"];
    if (times) {
      return  3 * [times count] + 1;
    }
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
    return [self joeyScheduleCellAtIndex:indexPath forCollectionView:collectionView];
  }
  NSString *cellIdentifier =
      (indexPath.section == IJTransportationSectionJoeyTime) ? @"JoeyTimeID" : @"MBTATimeID";
  IJMinutesTillCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                forIndexPath:indexPath];

  NSNumber *minutesTill = (indexPath.row == 0) ? @(3) : @(7);
  NSString *detailText = (indexPath.row == 0) ? @"to Boston" : @"to Alewife";
  if (indexPath.section == IJTransportationSectionMBTA) {
    NSString *directionKey = (indexPath.row == 0) ? @"Southbound" : @"Northbound";
    NSNumber *time = [self getNextTimeForDirection:directionKey];
    minutesTill =  (time) ? @(ceil(time.doubleValue / 60.0f)) : nil;
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    NSString *locationKey = (indexPath.row == 0) ? @"Campus Center" : (indexPath.row == 1) ? @"Davis Square" : @"Olin Center";
    minutesTill = [self getTimeUntilNextJoeyForStop:locationKey];
    detailText = locationKey;
  }
  [cell updateWithMinutes:minutesTill detailText:detailText];
  return cell;
}

- (UICollectionViewCell *)joeyScheduleCellAtIndex:(NSIndexPath *)indexPath
                                forCollectionView:(UICollectionView *)collectionView {
  // give the cell the schedule data (maybe do that in the cell.
  // return it.
  
  IJJoeyTimeCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"JoeyScheduleCell"
                                                forIndexPath:indexPath];
  
  NSString *location;
  if (indexPath.row % 3 == 0) {
    location = @"Campus Center";
  } else if (indexPath.row % 3 == 1) {
    location = @"Davis Square";
  } else if (indexPath.row % 3 == 2) {
    location = @"Olin Center";
  }
  cell.timeLabel.textColor = [UIColor iJumboBlackText];
  if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
    cell.timeLabel.numberOfLines = 0;
    cell.timeLabel.textAlignment = NSTextAlignmentCenter;
    cell.timeLabel.font = [UIFont regularFontWithSize:14];
    cell.timeLabel.text = location;
    return cell;
  } else {
    cell.timeLabel.numberOfLines = 1;
    cell.timeLabel.font = [UIFont lightFontWithSize:14];
  }
  
  NSArray *times = self.joeySchedule[self.weekday][location];
  int index = ((int)indexPath.row - 3) / 3;
  if (index < [times count]) {
    NSNumber *time = times[index];
    [cell setTimeSinceMidnight:time];
  } else {
    cell.timeLabel.text = @"";
  }
  return cell;
}

+ (NSInteger)weekdayForDate:(NSDate *)date {
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components =
  [gregorian components:NSWeekdayCalendarUnit fromDate:date];
  NSInteger weekday = [components weekday] - 1;
  return weekday;
}

+ (NSInteger)weekdayForScheduleOnDate:(NSDate*)date {
  NSInteger weekday = [self weekdayForDate:date];
  NSInteger minutesSinceMidnight = [self minutesSinceMidnight:date];
  if (minutesSinceMidnight < kTimeLowerBound) {
    weekday = (weekday - 1) % 7;
  }
  return weekday;
}

- (NSNumber *)getTimeUntilNextJoeyForStop:(NSString *)stop {
  NSDate *date = [NSDate date];
  long minutesSinceMidnight = [IJTransportationCollectionViewController minutesSinceMidnight:date];
  NSInteger weekday = [IJTransportationCollectionViewController weekdayForDate:date];
  NSNumber *lastTime = [self.joeySchedule[weekday][stop] lastObject];
  if (minutesSinceMidnight < kTimeLowerBound && minutesSinceMidnight > lastTime.integerValue) {
    date = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    weekday = [IJTransportationCollectionViewController weekdayForDate:date];
  }

  NSArray *times = self.joeySchedule[weekday][stop];
  NSNumber *nextTime = nil;
  if (times == nil) {
    return nil;
  } else {
    int distance = 24 * 60;
    for (NSNumber *time in times) {
      NSInteger minutes = (time.integerValue <= kTimeLowerBound) ? time.integerValue + (24 * 60) : time.integerValue;
      if (minutes > minutesSinceMidnight &&
          minutes - minutesSinceMidnight < distance) {
        distance = (int)minutes - (int)minutesSinceMidnight;
        nextTime = time;
      }
    }
  }
  if (!nextTime) {
    return nil;
  }
  if (nextTime.integerValue < minutesSinceMidnight) {
    return @((24 * 60) - minutesSinceMidnight + nextTime.integerValue);
  }
  return @(nextTime.integerValue - minutesSinceMidnight);
}

+ (long)minutesSinceMidnight:(NSDate *)date {
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
  return [times firstObject];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = kMinutesTillCellHeight;
  if (indexPath.section == IJTransportationSectionMBTA) {
    return CGSizeMake(self.view.width/2.0f - 1, height);
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    return CGSizeMake(self.view.width, height);
  } else if (indexPath.section == IJTransportationSectionJoeySchedule) {
    return CGSizeMake(self.view.width/3.0f - 2, 30);
  }
  return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
    return nil;
  }
  NSString *identifier = (indexPath.section == IJTransportationSectionJoeySchedule) ? @"ScheduleHeader" : @"MinutesTillHeader";
  UICollectionReusableView *header =
      [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                         withReuseIdentifier:identifier
                                                forIndexPath:indexPath];
  
  UILabel *headerLabel = (UILabel*)[header viewWithTag:kHeaderLabelTag];
  if (!headerLabel) {
    const int padding = 20;
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, header.width - (2 * padding), header.height)];
    [headerLabel setTag:kHeaderLabelTag];
    headerLabel.font = [UIFont regularFontWithSize:18];
    headerLabel.textColor = (indexPath.section == IJTransportationSectionJoeySchedule) ? [UIColor iJumboBlackText] : [UIColor whiteColor];
    [header addSubview:headerLabel];
    UIColor *backgroundColor;
    if (indexPath.section == IJTransportationSectionJoeySchedule) {
      backgroundColor = [UIColor colorWithWhite:1 alpha:0.65];
      headerLabel.textAlignment = NSTextAlignmentCenter;
      headerLabel.font = [UIFont regularFontWithSize:14];
      headerLabel.numberOfLines = 2;
      const CGFloat buttonWidth = 100;
      UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(header.width -  buttonWidth, 0, buttonWidth, header.height)];
      [dateButton setTag:kDateHeaderButtonTag];
      [dateButton setTitle:[NSString stringWithFormat:@"Day (%@)", [IJTransportationCollectionViewController textForWeekday:self.weekday]]
                  forState:UIControlStateNormal];
      [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      dateButton.titleLabel.font = [UIFont lightFontWithSize:13];
      dateButton.backgroundColor = [UIColor clearColor];
      [dateButton addTarget:self action:@selector(showActionSheetForWeekdays) forControlEvents:UIControlEventTouchUpInside];
      [header addSubview:dateButton];
    } else {
      backgroundColor = [UIColor iJumboBlue];
    }
    header.backgroundColor = backgroundColor;
  }
  if (indexPath.section == IJTransportationSectionMBTA) {
    headerLabel.text = @"MBTA | Davis Square T Stop";
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    headerLabel.text = @"Joey | Based on Schedule";
  } else if (indexPath.section == IJTransportationSectionJoeySchedule) {
    // Look at mocks for bar that helps select the the date for the schedule.
    headerLabel.text = @"Joey Schedule";
    UIButton *dateButton = (UIButton *)[header viewWithTag:kDateHeaderButtonTag];
    dateButton.frame = CGRectMake(header.width - dateButton.width, 0, dateButton.width, header.height);
    [dateButton setTitle:[NSString stringWithFormat:@"Day (%@)", [IJTransportationCollectionViewController textForWeekday:self.weekday]]
                forState:UIControlStateNormal];
  }
  return header;
}

- (void)showActionSheetForWeekdays {
  NSArray *dateTitles = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
  [UIActionSheet showInView:self.view
                  withTitle:@"Schedule Day"
          cancelButtonTitle:@"Cancel"
     destructiveButtonTitle:nil
          otherButtonTitles:dateTitles
                   tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                     NSLog(@"%li", (long)buttonIndex);
                     const int cancelButtonIndex = 7;
                     if (buttonIndex < cancelButtonIndex) {
                       self.weekday = buttonIndex;
                       dispatch_async(dispatch_get_main_queue(), ^{
                         [self.collectionView reloadData];
                        });
                     }
                   }];
}

// This gives the abbreviated name of the weekday.
+ (NSString *)textForWeekday:(NSInteger)weekday {
  IJAssert(weekday >= 0 && weekday < 7, @"Must provide a valid weekday");
  switch (weekday) {
    case 0:
      return @"Sun";
      break;
    case 1:
      return @"Mon";
    case 2:
      return @"Tues";
    case 3:
      return @"Wed";
    case 4:
      return @"Thurs";
    case 5:
      return @"Fri";
    case 6:
      return @"Sat";
    default:
      IJAssert(NO, @"This should never happen");
  }
  return @"";
}

//+ (UICollectionReusableView *)joeyScheduleHeader:(UICollectionView *)collectionView
//                                    forIndexPath:(NSIndexPath *)indexPath {
//  NSString *headerID = @"JoeyScheduleHeaderID";
//  UICollectionReusableView *header =
//      [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                         withReuseIdentifier:headerID
//                                                forIndexPath:indexPath];
//  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, header.width, header.height /2.0f)];
//  titleLabel.text = @"Joey Schedule";
//  titleLabel.textAlignment = NSTextAlignmentCenter;
//  
//  CGRect detailFrame = CGRectMake(0, header.height / 2.0f, header.width, header.height / 2.0f);
//  
//  UILabel *leftDetail = [[UILabel alloc] initWithFrame:detailFrame];
//  leftDetail.textAlignment = NSTextAlignmentLeft;
//  UILabel *centerDetail = [[UILabel alloc] initWithFrame:detailFrame];
//  centerDetail.textAlignment = NSTextAlignmentCenter;
//  UILabel *rightDetail = [[UILabel alloc] initWithFrame:detailFrame];
//  rightDetail.textAlignment = NSTextAlignmentRight;
//  
//  
//  
//  
//  
//  
//  
//  
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
      minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
      minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 2.0f;
}

@end
