//
//  IJLocationTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IJLocation.h"

static const int kLocationTableViewCellHeight = 50;

@class IJLocationTableViewCell;

@protocol IJLocationTableViewCellDelegate <NSObject>
- (void)didClickInfoButton:(IJLocationTableViewCell*)cell;
- (void)didClickMapButton:(IJLocationTableViewCell*)cell;
@end

@interface IJLocationTableViewCell : UITableViewCell

@property(nonatomic) id<IJLocationTableViewCellDelegate> delegate;

- (void)addDataFromLocation:(IJLocation *)location;

@end
