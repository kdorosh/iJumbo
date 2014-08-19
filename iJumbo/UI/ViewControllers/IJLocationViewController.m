//
//  IJLocationViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//
#define IJ_SetTextForLabel(text, label) if (text) { label.text = text; } else { label.text = @"N/A"; }


#import "IJLocationViewController.h"

#import "IJLocation.h"
#import "IJHours.h"
#import "IJRange.h"

#import "UIView+AddSubviews.h"

@interface IJLocationViewController ()
@property(nonatomic) IJLocation *location;
@property(nonatomic) UIScrollView *scrollView;
@end

@implementation IJLocationViewController

- (instancetype)initWithLocation:(IJLocation *)location {
  self = [super init];
  if (self) {
    _location = location;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSAssert(self.location, @"Must initialize with -initWithLocation: with a valid location.");
  CGSize viewSize = self.view.frame.size;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.maxY, viewSize.width, viewSize.height)];
  _scrollView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_scrollView];
  const int padding_x = 20;
  const int padding_y = 25;
  const int titleHeight = 20;
  const int labelWidth = viewSize.width - (2 * padding_x);
  UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, padding_y, labelWidth, titleHeight)];
  addressTitle.text = @"Address";
  UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, addressTitle.maxY + 5, labelWidth, 20)];
  addressLabel.text = (self.location.address) ? self.location.address : @"N/A";
  addressLabel.numberOfLines = 0;
  [addressLabel sizeToFit];
  [_scrollView addSubview:addressTitle];
  [_scrollView addSubview:addressLabel];
  
  UILabel *websiteTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, addressLabel.maxY + padding_y, labelWidth, titleHeight)];
  websiteTitle.text = @"Website";
  UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, websiteTitle.maxY + 5, labelWidth, 20)];
  websiteLabel.text = (self.location.website) ? self.location.website : @"N/A";
  websiteLabel.numberOfLines = 0;
  [websiteLabel sizeToFit];
  [_scrollView addSubview:websiteTitle];
  [_scrollView addSubview:websiteLabel];
  
  UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, websiteLabel.maxY + padding_y, labelWidth, titleHeight)];
  phoneTitle.text = @"Phone";
  UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, phoneTitle.maxY + 5, labelWidth, 20)];
  phoneLabel.text = (self.location.phone) ? self.location.phone : @"N/A";
  phoneLabel.numberOfLines = 0;
  [phoneLabel sizeToFit];
  [_scrollView addSubview:phoneTitle];
  [_scrollView addSubview:phoneLabel];
  
  if (self.location.hours) {
    UILabel *hoursTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, phoneLabel.maxY, labelWidth, titleHeight)];
    hoursTitle.text = @"Hours";
    [_scrollView addSubview:hoursTitle];
    UILabel *sundayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, hoursTitle.maxY + 5, labelWidth, titleHeight)];
    sundayLabel.text = [NSString stringWithFormat:@"Sunday:    %@", [IJLocationViewController hoursForRange:self.location.hours.sunday]];
    UILabel *mondayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, sundayLabel.maxY + 5, labelWidth, titleHeight)];
    mondayLabel.text = [NSString stringWithFormat:@"Monday:    %@", [IJLocationViewController hoursForRange:self.location.hours.monday]];
    UILabel *tuesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, mondayLabel.maxY + 5, labelWidth, titleHeight)];
    tuesdayLabel.text = [NSString stringWithFormat:@"Tuesday:   %@", [IJLocationViewController hoursForRange:self.location.hours.tuesday]];
    UILabel *wednesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, tuesdayLabel.maxY + 5, labelWidth, titleHeight)];
    wednesdayLabel.text = [NSString stringWithFormat:@"Wednesday: %@", [IJLocationViewController hoursForRange:self.location.hours.wednesday]];
    UILabel *thursdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, wednesdayLabel.maxY + 5, labelWidth, titleHeight)];
    thursdayLabel.text = [NSString stringWithFormat:@"Thursday:  %@", [IJLocationViewController hoursForRange:self.location.hours.thursday]];
    UILabel *fridayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, thursdayLabel.maxY + 5, labelWidth, titleHeight)];
    fridayLabel.text = [NSString stringWithFormat:@"Friday:    %@", [IJLocationViewController hoursForRange:self.location.hours.friday]];
    UILabel *saturdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding_x, fridayLabel.maxY + 5, labelWidth, titleHeight)];
    saturdayLabel.text = [NSString stringWithFormat:@"Saturday:  %@", [IJLocationViewController hoursForRange:self.location.hours.saturday]];
    [_scrollView addSubviews:@[sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel]];
  }
}

+ (NSString *)hoursForRange:(IJRange *)range {
  if (!range) {
    return @"Closed";
  }
  return [NSString stringWithFormat:@"%@ - %@", [self timeFromSeconds:range.start], [self timeFromSeconds:range.end]];
}

/// Converts seconds from midnight into time.
+ (NSString *)timeFromSeconds:(NSNumber*)seconds {
  NSString *apm = (seconds.integerValue > (12 * 60 * 60)) ? @"pm" : @"am";
  NSUInteger hours = seconds.integerValue / (60.0f * 60.0f);
  NSUInteger minutes = (seconds.integerValue - (hours * (60.0f * 60.0f))) / 60.0f;
  hours %= 12;
  if (hours == 0) hours = 12;
  return [NSString stringWithFormat:@"%02lu:%02lu%@", hours, (unsigned long)minutes, apm];
}

@end
