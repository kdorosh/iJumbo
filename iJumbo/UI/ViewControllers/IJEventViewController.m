//
//  IJEventViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventViewController.h"
#import "IJLocation.h"
#import "IJRecord.h"

static const int padding = 20;

@interface IJEventViewController ()
@property(nonatomic) IJEvent *event;
@property(nonatomic) UIScrollView *scrollView;
@end

@implementation IJEventViewController

- (id)initWithEvent:(IJEvent *)event {
  self = [super init];
  if (self) {
    self.event = event;
  }
  return self;
}

- (void)viewDidLoad {
  NSAssert(self.event, @"Must provide an event.");
  [super viewDidLoad];
  self.title = self.event.date;
  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
  [self.view addSubview:self.scrollView];
  NSString *time;
  // TODO(amadou): Make the dateformatter static.
  // and delete it when there is a memory warning.
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  // TODO(amadou): Add am/pm.
  [dateFormatter setDateFormat:@"HH:mm"];
  if (self.event.end) {
    time = [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:self.event.start], [dateFormatter stringFromDate:self.event.end]];
  } else {
    time = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.event.start]];
  }
  CGFloat y = [self insertLabelAtY:20  withTitle:@"Title" andDetails:self.event.title];
  y = [self insertLabelAtY:y + padding withTitle:@"Time" andDetails:time];
  y = [self insertLabelAtY:y + padding withTitle:@"Location" andDetails:self.event.location.name];
  // TODO(amadou): Make the url clickable.
  y = [self insertLabelAtY:y + padding withTitle:@"Website" andDetails:self.event.website];
  y = [self insertLabelAtY:y + padding withTitle:@"Description" andDetails:self.event.desc];
  self.scrollView.contentSize = CGSizeMake(self.view.width, y + padding);
}

// @return the maxY of the label holding details.
- (CGFloat)insertLabelAtY:(CGFloat)y withTitle:(NSString *)title andDetails:(NSString *)details {
  NSAssert(title, @"Must provide a title.");
  const int titleHeight = 20;
  const int labelWidth = self.view.width - (2 * padding);
  UIFont * const font = [UIFont fontWithName:@"Roboto-Light" size:16];
  UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, labelWidth, titleHeight)];
  titleLabel.text = title;
  titleLabel.font = font;
  [self.scrollView addSubview:titleLabel];
  
  UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, titleLabel.maxX + padding, labelWidth, titleHeight)];
  detailsLabel.text = (details) ? details : @"N/A";
  detailsLabel.font = font;
  detailsLabel.numberOfLines = 0;
  [detailsLabel sizeToFit];
  detailsLabel.frame = CGRectMake(padding, titleLabel.maxY + padding/2.0f , labelWidth, detailsLabel.height);
  [self.scrollView addSubview:detailsLabel];
  
  return detailsLabel.maxY;
}

@end
