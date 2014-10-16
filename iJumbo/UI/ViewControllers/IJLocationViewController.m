//
//  IJLocationViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/18/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//
#define IJ_SetTextForLabel(text, label) if (text) { label.text = text; } else { label.text = @"N/A"; }
#define titleFont [UIFont regularFontWithSize:17];
#define labelFont [UIFont lightFontWithSize:17];


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

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Info";
  NSAssert(self.location, @"Must initialize with -initWithLocation: with a valid location.");
  CGSize viewSize = self.view.frame.size;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
  _scrollView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_scrollView];
  const int padding_x = 20;
  const int padding_y = 25;
  const int titleHeight = 20;
  const int labelWidth = viewSize.width - (2 * padding_x);
  UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, padding_y, labelWidth, titleHeight)];
  addressTitle.text = @"Address";
  addressTitle.font = titleFont;
  UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, addressTitle.maxY + 5, labelWidth, 20)];
  addressLabel.text = (self.location.address) ? self.location.address : @"N/A";
  addressLabel.font = labelFont;
  addressLabel.numberOfLines = 0;
  [addressLabel sizeToFit];
  [_scrollView addSubview:addressTitle];
  [_scrollView addSubview:addressLabel];
  
  UILabel *websiteTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, addressLabel.maxY + padding_y, labelWidth, titleHeight)];
  websiteTitle.text = @"Website";
  websiteTitle.font = titleFont;
  UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, websiteTitle.maxY + 5, labelWidth, 20)];
  websiteLabel.text = (self.location.website) ? self.location.website : @"N/A";
  websiteLabel.font = labelFont;
  websiteLabel.numberOfLines = 0;
  [websiteLabel sizeToFit];
  [_scrollView addSubview:websiteTitle];
  [_scrollView addSubview:websiteLabel];
  
  UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, websiteLabel.maxY + padding_y, labelWidth, titleHeight)];
  phoneTitle.text = @"Phone";
  phoneTitle.font = titleFont;
  UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, phoneTitle.maxY + 5, labelWidth, 20)];
  phoneLabel.text = (self.location.phone) ? self.location.phone : @"N/A";
  phoneLabel.font = labelFont;
  phoneLabel.numberOfLines = 0;
  [phoneLabel sizeToFit];
  [_scrollView addSubview:phoneTitle];
  [_scrollView addSubview:phoneLabel];
  
  if (self.location.hours) {
    UILabel *hoursTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding_x, phoneLabel.maxY + padding_y, labelWidth, titleHeight)];
    hoursTitle.text = @"Hours";
    hoursTitle.font = titleFont;
    [_scrollView addSubview:hoursTitle];
    // Sunday.
    CGFloat y = hoursTitle.maxY;
    y = [self addTitle:@"Sunday:" withRange:self.location.hours.sunday atY:y];
    y = [self addTitle:@"Monday:" withRange:self.location.hours.monday atY:y];
    y = [self addTitle:@"Tuesday:" withRange:self.location.hours.tuesday atY:y];
    y = [self addTitle:@"Wednesday:" withRange:self.location.hours.wednesday atY:y];
    y = [self addTitle:@"Thursday:" withRange:self.location.hours.thursday atY:y];
    y = [self addTitle:@"Friday:" withRange:self.location.hours.friday atY:y];
    y = [self addTitle:@"Saturday:" withRange:self.location.hours.saturday atY:y];
  }
}

// @param title @"Sunday:";
// @return the Y plus the padding of where the stuff should change.
- (CGFloat)addTitle:(NSString *)title withRange:(IJRange *)range atY:(CGFloat)y {
  const int padding_x = 20;
  const int labelWidth = self.view.frame.size.width - (2 * padding_x);
  const int titleHeight = 20;
  CGRect frame = CGRectMake(2 * padding_x, y + 5, labelWidth - padding_x, titleHeight);
  UILabel *hoursTitle = [[UILabel alloc] initWithFrame:frame];
  hoursTitle.text = title;
  hoursTitle.font = titleFont;
  UILabel *dayLabel = [[UILabel alloc] initWithFrame:frame];
  dayLabel.text = [IJLocationViewController hoursForRange:range];
  dayLabel.textAlignment = NSTextAlignmentRight;
  dayLabel.font = labelFont;
  [self.view addSubviews:@[hoursTitle, dayLabel]];
  return dayLabel.maxY;
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
  return [NSString stringWithFormat:@"%02lu:%02lu%@", (unsigned long)hours, (unsigned long)minutes, apm];
}

@end
