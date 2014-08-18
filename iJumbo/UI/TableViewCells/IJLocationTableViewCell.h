//
//  IJLocationTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IJLocation.h"

static const int kLocationTableViewCellHeight = 40;

@interface IJLocationTableViewCell : UITableViewCell

- (void)addDataFromLocation:(IJLocation *)location;

@end
