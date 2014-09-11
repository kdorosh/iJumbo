//
//  IJNewsTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IJArticle.h"

static NSString * const kNewsTableViewCellID = @"IJNewsTableViewCellID";

static const int kNewsTableViewCellHeight = 95;

@interface IJNewsTableViewCell : UITableViewCell

- (void)addDataFromArticle:(IJArticle *)article;

@end
