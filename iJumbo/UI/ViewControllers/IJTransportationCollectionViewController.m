//
//  IJTransportationCollectionViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJTransportationCollectionViewController.h"

#import "IJMinutesTillCollectionViewCell.h"

typedef NS_ENUM(NSInteger, IJTransportationSection) {
  IJTransportationSectionMBTA = 0,
  IJTransportationSectionJoeyTime,
  IJTransportationSectionJoeySchedule
};

@interface IJTransportationCollectionViewController ()
@property(nonatomic) NSArray *mbtaData;
@end

@implementation IJTransportationCollectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Transportation";
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
  
  [self.view addSubview:self.collectionView];
  [self.collectionView reloadData];
}

#pragma mark - Network Calls

- (void)loadMBTAData {
  
}

- (void)loadJoeySchedule {
  
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
    return 0;
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
    
  } else if (indexPath.section == IJTransportationSectionJoeyTime) {
    
  }
  [cell updateWithMinutes:minutesTill detailText:detailText];
  return cell;
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
