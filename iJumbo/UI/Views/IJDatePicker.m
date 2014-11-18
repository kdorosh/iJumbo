//
//  IJDatePicker.m
//  iJumbo
//
//  Created by Amadou Crookes on 11/4/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJDatePicker.h"

static const int kIJDatePickerButtonHeight = 25;

@interface IJDatePicker ()
@end

@implementation IJDatePicker

- (instancetype)initWithWidth:(CGFloat)width {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.frame = CGRectMake(0, kIJDatePickerButtonHeight, width, self.datePicker.height);
    self.frame = CGRectMake(0, 0, width, self.datePicker.height + kIJDatePickerButtonHeight);
    [self addSubview:self.datePicker];
    const CGFloat buttonTitlePadding = 10;
    _leftButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width/2.0f, kIJDatePickerButtonHeight)];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2.0f, 0, width/2.0f, kIJDatePickerButtonHeight)];
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _leftButton.contentEdgeInsets  = UIEdgeInsetsMake(0, buttonTitlePadding, 0, 0);
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, buttonTitlePadding);
    UIFont *buttonFont = [UIFont regularFontWithSize:14];
    UIColor *buttonTitleColor = [UIColor blackColor];

    self.leftButton.backgroundColor  = [UIColor clearColor];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.leftButton.titleLabel  setFont:buttonFont];
    [self.rightButton.titleLabel setFont:buttonFont];
    [self.leftButton  setTitleColor:[UIColor iJumboBlue]      forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor iJumboBlue]      forState:UIControlStateSelected];
    [self.leftButton  setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];

    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
  }
  return self;
}

- (void)setRightButtonTitle:(NSString *)title {
  [self setTitle:title forButton:self.rightButton];
}

- (void)setLeftButtonTitle:(NSString *)title {
  [self setTitle:title forButton:self.leftButton];
}

- (void)setTitle:(NSString *)title forButton:(UIButton *)button {
  [button setTitle:title forState:UIControlStateNormal];
}

- (void)updatesForDateChangeForTarget:(id)target withAction:(SEL)action {
  [self.datePicker addTarget:target
                      action:action
            forControlEvents:UIControlEventValueChanged];
}

- (void)setDate:(NSDate *)date {
  _date = date;
  self.datePicker.date = date;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
  _datePickerMode = datePickerMode;
  self.datePicker.datePickerMode = datePickerMode;
}

@end
