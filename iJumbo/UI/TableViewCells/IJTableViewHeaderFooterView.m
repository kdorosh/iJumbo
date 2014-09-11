//
//  IJTableViewHeaderFooterView.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJTableViewHeaderFooterView.h"

@implementation IJTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor colorWithRed:26/255.0f green:191/255.0f blue:237/255.0 alpha:0.75];
    self.tintColor = self.contentView.backgroundColor;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView = backView;
    const int width = 320;
    const int height = 40;
    self.alpha = 0.1;
    const int padding = 20;
    self.sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, width - (2 * padding), height)];
    [self.sectionTitleLabel setTextColor:[UIColor whiteColor]];
    [self.sectionTitleLabel setTag:1];
    [self.sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.sectionTitleLabel.font = [UIFont regularFontWithSize:18];
    [self addSubview:self.sectionTitleLabel];
  }
  return self;
}

@end
