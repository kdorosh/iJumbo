//
//  IJFoodItemTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJFoodItemTableViewCell.h"

#import "IJFoodItem.h"

static NSSet *subscribedFood;
static const CGFloat fontSize = 17;

@interface IJFoodItemTableViewCell ()
@end

@implementation IJFoodItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    const CGFloat padding = 20;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, self.width - padding, self.height)];
    _nameLabel.font = [UIFont lightFontWithSize:fontSize];
    _nameLabel.textColor = [UIColor iJumboBlackText];
    [self addSubview:_nameLabel];
  }
  return self;
}

- (void)addDataFromFoodItem:(IJFoodItem *)foodItem {
  if (!subscribedFood) {
    subscribedFood = [NSSet setWithArray:[IJFoodItem subscribedFood]];
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(updateSubscribedFood)
                                                 name:kSubscribedToFoodItemNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(updateSubscribedFood)
                                                 name:kUnsubscribedToFoodItemNotification
                                               object:nil];
  }
  self.nameLabel.text = foodItem.name;
  self.nameLabel.font = ([subscribedFood member:foodItem]) ? [UIFont regularFontWithSize:fontSize] : [UIFont lightFontWithSize:fontSize];
}

+ (void)updateSubscribedFood {
  subscribedFood = [NSSet setWithArray:[IJFoodItem subscribedFood]];
}

@end
