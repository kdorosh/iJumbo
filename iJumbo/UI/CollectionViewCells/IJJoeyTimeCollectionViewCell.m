//
//  IJJoeyTimeCollectionViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/7/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJJoeyTimeCollectionViewCell.h"

@interface IJJoeyTimeCollectionViewCell ()
@property(nonatomic) UILabel *timeLabel;
@end

@implementation IJJoeyTimeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.timeLabel.font = [UIFont lightFontWithSize:13];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
  }
  return self;
}

- (void)setTimeSinceMidnight:(NSNumber *)minutesSince {
  unsigned int totalMinutes = minutesSince.intValue;
  unsigned int hours = totalMinutes/60;
  unsigned int minutes = totalMinutes%60;
  NSString *apm = (hours >= 12) ? @"pm" : @"am";
  hours = hours % 12;
  if (hours == 0)
    hours = 12;
  self.timeLabel.text = [NSString stringWithFormat:@"%i:%02i%@", hours, minutes, apm];
}

@end
