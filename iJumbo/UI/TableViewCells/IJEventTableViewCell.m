//
//  IJEventTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventTableViewCell.h"

@interface IJEventTableViewCell ()
@property(nonatomic) UILabel *timeLabel;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) NSDateFormatter *timeFormatter;
@end

@implementation IJEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView = backView;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.frame.size.width;
    CGFloat contentInset = 5;
    UIView *contentView =
        [[UIView alloc] initWithFrame:
            CGRectMake(contentInset, contentInset, width - (2 * contentInset), kEventTableViewCellHeight - (2 * contentInset))];
    contentView.backgroundColor = [UIColor iJumboGrey];
    CGSize contentSize = contentView.frame.size;
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInset, 0, contentSize.width/3.0 - (2 * contentInset), contentSize.height)];
    self.timeLabel.font = [UIFont lightFontWithSize:12];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor iJumboBlackText];
    [self addSubview:self.timeLabel];
    CGSize timeSize = self.timeLabel.frame.size;
    CGFloat fullTimeWidth = timeSize.width + (2 * contentInset);
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(fullTimeWidth, 0, contentSize.width - fullTimeWidth, contentSize.height)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont regularFontWithSize:14];
    self.titleLabel.textColor = [UIColor iJumboBlackText];
    
    [contentView addSubview:self.timeLabel];
    [contentView addSubview:self.titleLabel];
    [self addSubview:contentView];
  }
  return self;
}

- (void)addDataFromEvent:(IJEvent *)event {
  self.titleLabel.text = event.title;
  if (event.start && event.end) {
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.timeFormatter stringFromDate:event.start], [self.timeFormatter stringFromDate:event.end]];
  } else if (event.start) {
    self.timeLabel.text = [self.timeFormatter stringFromDate:event.start];
  } else {
    NSLog(@"Start was not provided...");
    NSLog(@"Event: %@", event);
  }
}

- (NSDateFormatter *)timeFormatter {
  if (!_timeFormatter) {
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"h:mm aaa"];
  }
  return _timeFormatter;
}

@end
