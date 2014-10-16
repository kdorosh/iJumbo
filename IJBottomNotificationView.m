//
//  IJBottomNotificationView.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

static const CGFloat kNotificationViewHeight = 60;

#import "IJBottomNotificationView.h"

@interface IJBottomNotificationView ()
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) UILabel *detailTextLabel;
@property(nonatomic) NSTimer *hideTimer;
@property(nonatomic) NSDate *lastNotificationDate;
@end

@implementation IJBottomNotificationView

+ (IJBottomNotificationView *)sharedInstance {
  static IJBottomNotificationView *sharedNotification = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedNotification = [[self alloc] init];
  });
  return sharedNotification;

}

- (instancetype)init {
  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, window.maxY, window.width, kNotificationViewHeight);
    self.backgroundColor = iJumboBlueWithAlpha(0.95);
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height/2.0f)];
    self.textLabel.font = [UIFont regularFontWithSize:20];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2.0f - 7, self.width, self.height/2.0f)];
    self.detailTextLabel.font = [UIFont regularFontWithSize:14];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [window addSubview:self];
  }
  return self;
}

+ (void)presentNotificationWithText:(NSString *)text
                       detailedText:(NSString *)detailText
                        forDuration:(NSTimeInterval)duration {
  IJBottomNotificationView *notificationView = [self sharedInstance];
  if (notificationView.lastNotificationDate != nil &&
      [notificationView.lastNotificationDate timeIntervalSinceNow] > -30) {
    return;
  }
  notificationView.lastNotificationDate = [NSDate date];
  [notificationView.hideTimer invalidate];
  notificationView.textLabel.text = text;
  notificationView.detailTextLabel.text = detailText;
  UIWindow *window = (UIWindow*)[notificationView superview];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationDelay:0];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  notificationView.frame = CGRectMake(0, window.maxY - notificationView.height, notificationView.width, notificationView.height);
  [UIView commitAnimations];
  
  notificationView.hideTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                                target:notificationView
                                                              selector:@selector(dismissNotificationView)
                                                              userInfo:nil
                                                               repeats:NO];
}

- (void)dismissNotificationView {
  NSLog(@"Dismiss notification view");
  UIWindow *window = (UIWindow *)[self superview];
  [UIView animateWithDuration:0.3 animations:^{
    self.frame = CGRectMake(0, window.maxY, self.width, self.height);
  }];
}



@end
