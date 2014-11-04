//
//  IJDatePicker.m
//  iJumbo
//
//  Created by Amadou Crookes on 11/4/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJDatePicker.h"

static const int kIJDatePickerButtonHeight = 30;

@interface IJDatePicker ()
@property(nonatomic) UIButton *leftButton;
@property(nonatomic) UIButton *rightButton;
@end

@implementation IJDatePicker

- (instancetype)initWithWidth:(CGFloat)width {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc] init];
    self.frame = CGRectMake(0, 0, width, self.datePicker.height + kIJDatePickerButtonHeight);
    [self addSubview:self.datePicker];
    self.leftButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width/2.0f, self.datePicker.height)];
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2.0f, 0, width/2.0f, kIJDatePickerButtonHeight)];
    [self.leftButton.titleLabel  setTextAlignment:NSTextAlignmentLeft];
    [self.rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];

    UIFont *buttonFont = [UIFont regularFontWithSize:12];
    UIColor *buttonTitleColor = [UIColor blackColor];

    self.leftButton.backgroundColor  = [UIColor clearColor];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.leftButton.titleLabel  setFont:buttonFont];
    [self.rightButton.titleLabel setFont:buttonFont];
    [self.leftButton  setTitleColor:kIJumboBlue      forState:UIControlStateSelected];
    [self.rightButton setTitleColor:kIJumboBlue      forState:UIControlStateSelected];
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

@end
