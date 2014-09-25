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
    self.minutesTillLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/4.0f,
                                                                      self.height/5.0f,
                                                                      self.width/2.0f,
                                                                      self.height/3.0f)];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.minutesTillLabel.frame.origin.x,
                                                                 self.minutesTillLabel.maxY - 10,
                                                                 self.width - self.width/2.0f,
                                                                 self.height - self.minutesTillLabel.maxY)];
    self.detailLabel.font = [UIFont regularFontWithSize:16];
    self.detailLabel.textColor = [UIColor colorWithWhite:0 alpha:0.65];
    [self addSubview:self.minutesTillLabel];
    [self addSubview:self.detailLabel];
    [self updateWithMinutes:@(6) detailText:@"to Amadou's Lair ;)"];
  }
  return self;
}

- (void)updateWithMinutes:(NSNumber *)minutes detailText:(NSString *)detailText {
  UIFont *numberFont = [UIFont regularFontWithSize:40];
  UIFont *minuteFont = [UIFont lightFontWithSize:13];  // Used for the @"min(s)" after the number.
  NSMutableAttributedString *numberString =
      [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", minutes.intValue]
                                             attributes:@{NSFontAttributeName: numberFont}];
  NSMutableAttributedString *minsString =
      [[NSMutableAttributedString alloc] initWithString:(minutes.intValue >= 2) ? @" mins" : @" min"
                                             attributes:@{NSFontAttributeName: minuteFont}];
  [numberString appendAttributedString:minsString];
  self.minutesTillLabel.attributedText = numberString;
  self.detailLabel.text = detailText;
}

@end
