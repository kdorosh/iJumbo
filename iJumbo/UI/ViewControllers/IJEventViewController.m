//
//  IJEventViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventViewController.h"
#import "IJLocation.h"
#import "IJLocationViewController.h"
#import "IJRecord.h"
#import "IJWebViewController.h"

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
  IJAssertNotNil(self.event);
  [super viewDidLoad];
  self.title = self.event.date;
  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
  [self.view addSubview:self.scrollView];
  NSString *time;
  // TODO(amadou): Make the dateformatter static.
  // and delete it when there is a memory warning.
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  // TODO(amadou): Add am/pm.
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
  [dateFormatter setDateFormat:@"hh:mma"];
  if (self.event.end) {
    time = [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:self.event.start], [dateFormatter stringFromDate:self.event.end]];
  } else {
    time = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.event.start]];
  }
  CGFloat y = [self insertLabelAtY:20  withTitle:@"Title" andDetails:self.event.title];
  y = [self insertLabelAtY:y + padding withTitle:@"Time" andDetails:time];
  y = [self insertLabelAtY:y + padding withTitle:@"Location" andDetails:self.event.location.name];
  y = [self insertLabelAtY:y + padding withTitle:@"Website" andDetails:self.event.website withAction:@selector(pushWebView)];
  y = [self insertLabelAtY:y + padding withTitle:@"Description" andDetails:self.event.desc];
  self.scrollView.contentSize = CGSizeMake(self.view.width, y + padding);
}

- (CGFloat)insertLabelAtY:(CGFloat)y withTitle:(NSString *)title andDetails:(NSString *)details {
  return [self insertLabelAtY:y withTitle:title andDetails:details withAction:nil];
}

// @return the maxY of the label holding details.
- (CGFloat)insertLabelAtY:(CGFloat)y withTitle:(NSString *)title andDetails:(NSString *)details withAction:(SEL)action {
  IJAssertNotNil(title);
  const int titleHeight = 20;
  const int labelWidth = self.view.width - (2 * padding);
  UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, labelWidth, titleHeight)];
  titleLabel.text = title;
  titleLabel.font = [UIFont regularFontWithSize:17];;
  [self.scrollView addSubview:titleLabel];
  
  UIButton *detailsButton =
      [[UIButton alloc] initWithFrame:CGRectMake(padding, titleLabel.maxX + padding, labelWidth, titleHeight * 3)];
  [detailsButton setTitle:(details) ? details : @"N/A" forState:UIControlStateNormal];
  detailsButton.titleLabel.font = [UIFont lightFontWithSize:17];
  detailsButton.titleLabel.numberOfLines = 0;
  [detailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [detailsButton setTitleColor:kIJumboBlue forState:UIControlStateHighlighted];
  detailsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  detailsButton.contentEdgeInsets = UIEdgeInsetsZero;
  [detailsButton sizeToFit];
  detailsButton.frame = CGRectMake(padding, titleLabel.maxY + padding/2.0f , labelWidth, detailsButton.height);
  [self.scrollView addSubview:detailsButton];
  
  // Setup if this data should be able interactive.
  if (action) {
    [detailsButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
  } else {
    detailsButton.userInteractionEnabled = NO;
  }
  
  return detailsButton.maxY;
}

- (BOOL)shouldAutorotate
{
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

- (void)pushWebView {
  IJWebViewController *webVC = [IJWebViewController defaultInstanceWithURL:self.event.website];
  [self.navigationController pushViewController:webVC animated:YES];
} 

@end
