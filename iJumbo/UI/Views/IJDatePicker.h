//
//  IJDatePicker.h
//  iJumbo
//
//  Created by Amadou Crookes on 11/4/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJDatePicker : UIView

@property(nonatomic) UIDatePicker *datePicker;
@property(nonatomic) NSDate *date;
@property(nonatomic, readonly) UIButton *leftButton;
@property(nonatomic, readonly) UIButton *rightButton;
@property(nonatomic) UIDatePickerMode datePickerMode;

- (instancetype)initWithWidth:(CGFloat)width;

- (void)setLeftButtonTitle:(NSString *)title;
- (void)setRightButtonTitle:(NSString *)title;

- (void)updatesForDateChangeForTarget:(id)target withAction:(SEL)action;

@end
