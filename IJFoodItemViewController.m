//
//  IJFoodItemViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 10/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJFoodItemViewController.h"

#import "IJFoodItem.h"
#import "IJBottomNotificationView.h"

static const int kFoodItemPadding = 16;

@interface IJFoodItemViewController ()
@property(nonatomic) IJFoodItem *foodItem;
@property(nonatomic) UIScrollView *scrollView;
@end

@implementation IJFoodItemViewController

- (instancetype)initWithFoodItem:(IJFoodItem *)foodItem {
  IJAssertNotNil(foodItem);
  self = [super init];
  if (self) {
    self.foodItem = foodItem;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.foodItem.name;
  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
  [self.view addSubview:self.scrollView];
  [self addLabelsForFoodItem];
  NSString *alertString;
  NSSet *subscribedFoods = [NSSet setWithArray:[IJFoodItem subscribedFood]];
  if ([subscribedFoods member:self.foodItem]) {
    alertString = @"Unsubscribe";
  } else {
    alertString = @"Subscribe";
  }
  UIBarButtonItem *alertButton =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bell.png"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(toggleAlert)];
  self.navigationItem.rightBarButtonItem = alertButton;
}

- (void)toggleAlert {
  NSSet *subscribedFoods = [NSSet setWithArray:[IJFoodItem subscribedFood]];
  if ([subscribedFoods member:self.foodItem]) {
    [IJFoodItem unsubscribeFromFoodItem:self.foodItem];
  } else {
    [IJFoodItem subscribeToFoodItem:self.foodItem];
  }
}

- (void)addLabelsForFoodItem {
  CGFloat y = [self insertLabelAtY:20           withTitle:@"Serving Size" andDetails:self.foodItem.servingSize];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Calories" andDetails:IJNSNumberToString(self.foodItem.calories)];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Fat Calories" andDetails:IJNSNumberToString(self.foodItem.fatCalories)];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Sat Fat" andDetails:self.foodItem.saturatedFat];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Cholestoral" andDetails:self.foodItem.cholestoral];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Sodium" andDetails:self.foodItem.sodium];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Total Carbs" andDetails:self.foodItem.carbs];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Dietary Fiber" andDetails:self.foodItem.fiber];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Sugars" andDetails:self.foodItem.sugar];
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Protein" andDetails:self.foodItem.protein];
  
  // Ingredients.
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Ingredients" andDetails:@""];
  y = [self addBoxedText:self.foodItem.ingredients atY:y + kFoodItemPadding/2.0f];
  
  // Allergens.
  y = [self insertLabelAtY:y + kFoodItemPadding withTitle:@"Allergens" andDetails:@""];
  y = [self addBoxedText:self.foodItem.allergens atY:y + kFoodItemPadding/2.0f];
  
  self.scrollView.contentSize = CGSizeMake(self.view.width, y + kFoodItemPadding + self.navigationController.navigationBar.maxY);
}

- (CGFloat)insertLabelAtY:(CGFloat)y withTitle:(NSString *)title andDetails:(NSString *)details {
  IJAssertNotNil(title);
  const int labelHeight = 20;
  const int labelWidth = self.view.width - (2.0f * kFoodItemPadding);
  UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFoodItemPadding, y, labelWidth, labelHeight)];
  titleLabel.text = [title stringByAppendingString:@":"];
  titleLabel.font = [UIFont regularFontWithSize:17];;
  [self.scrollView addSubview:titleLabel];
  
  UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFoodItemPadding, y, labelWidth, labelHeight)];
  detailsLabel.text = (details) ? details : @"N/A";
  detailsLabel.font = [UIFont lightFontWithSize:17];
  detailsLabel.textAlignment = NSTextAlignmentRight;
  detailsLabel.numberOfLines = 0;
  [self.scrollView addSubview:detailsLabel];
  
  return detailsLabel.maxY;
}

// Adds the ingredients to the view in a bordered box.
- (CGFloat)addBoxedText:(NSString *)text atY:(CGFloat)y {
  if (!text) {
    return y;
  }
  UILabel *label = [[UILabel alloc] init];
  label.text = text;
  label.numberOfLines = 0;
  label.font = [UIFont lightFontWithSize:15];
  const CGFloat textWidth = self.view.width - (3 * kFoodItemPadding);
  const CGFloat boxWidth = self.view.width - (2 * kFoodItemPadding);
  const CGFloat padding = boxWidth/2.0f - textWidth/2.0f;
  CGSize maxSize = CGSizeMake(textWidth, 10000);
  CGSize textActualSize = [label sizeThatFits:maxSize];
  UIView *boundingBox = [[UIView alloc] initWithFrame:CGRectMake(kFoodItemPadding, y, boxWidth, textActualSize.height + (2 * padding))];
  label.frame = CGRectMake(padding, padding, textWidth, textActualSize.height);
  [boundingBox addSubview:label];
  boundingBox.layer.borderWidth = 1.5f;
  boundingBox.layer.borderColor = [[UIColor lightGrayColor] CGColor];

  [self.scrollView addSubview:boundingBox];
  return boundingBox.maxY;
}
@end
