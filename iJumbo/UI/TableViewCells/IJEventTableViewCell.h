//
//  IJEventTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IJEvent.h"

static const int kEventTableViewCellHeight = 65;

@interface IJEventTableViewCell : UITableViewCell

- (void)addDataFromEvent:(IJEvent *)event;

@end
