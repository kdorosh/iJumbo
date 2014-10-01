//
//  IJMinutesTillCollectionViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMinutesTillCollectionViewCell.h"

@interface IJMinutesTillCollectionViewCell ()
@property(nonatomic) UILabel *minutesTillLabel;
@property(nonatomic) UILabel *detailLabel;
@end

@implementation IJMinutesTillCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.minutesTillLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/5.0f,
                                                                      self.height/5.0f,
                                                                      3 * self.width/4.0f,
                                                                      self.height/3.0f)];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.minutesTillLabel.frame.origin.x,
                                                                 self.minutesTillLabel.maxY - 10,
                                                                 3 * self.width/4.0f,
                                                                 self.height - self.minutesTillLabel.maxY)];
    self.detailLabel.font = [UIFont regularFontWithSize:14];
    self.detailLabel.textColor = [UIColor colorWithWhite:0 alpha:0.65];
    self.minutesTillLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:self.minutesTillLabel];
    [self addSubview:self.detailLabel];
  }
  return self;
}

- (void)updateWithMinutes:(NSNumber *)minutes detailText:(NSString *)detailText {
  UIFont *numberFont = [UIFont regularFontWithSize:28];
  UIFont *minuteFont = [UIFont lightFontWithSize:13];  // Used for the @"min(s)" after the number.
  NSString *minutesString = (minutes) ? [NSString stringWithFormat:@"%i", minutes.intValue] : @"n/a";
  NSMutableAttributedString *numberString =
      [[NSMutableAttributedString alloc] initWithString:minutesString
                                             attributes:@{NSFontAttributeName: numberFont}];
  NSMutableAttributedString *minsString =
      [[NSMutableAttributedString alloc] initWithString:(minutes.intValue >= 2) ? @" mins" : @" min"
                                             attributes:@{NSFontAttributeName: minuteFont}];
  if (minutes)
    [numberString appendAttributedString:minsString];
  self.minutesTillLabel.attributedText = numberString;
  self.detailLabel.text = detailText;
}

@end
