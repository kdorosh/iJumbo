//
//  IJFoodItemTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

static const int kFoodItemTableViewCellHeight = 40;

#import <UIKit/UIKit.h>

@class IJFoodItem;

@interface IJFoodItemTableViewCell : UITableViewCell

@property(nonatomic) UILabel *nameLabel;

- (void)addDataFromFoodItem:(IJFoodItem *)foodItem;

@end
