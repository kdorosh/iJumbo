//
//  IJFoodItemTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJFoodItemTableViewCell.h"

#import "IJFoodItem.h"

@interface IJFoodItemTableViewCell ()
@property(nonatomic) UILabel *nameLabel;
@end

@implementation IJFoodItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    const CGFloat padding = 20;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, self.width - padding, self.height)];
    _nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    [self addSubview:_nameLabel];
  }
  return self;
}

- (void)addDataFromFoodItem:(IJFoodItem *)foodItem {
  self.nameLabel.text = foodItem.name;
}

@end
