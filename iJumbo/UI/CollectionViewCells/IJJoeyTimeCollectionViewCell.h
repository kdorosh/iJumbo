//
//  IJJoeyTimeCollectionViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 10/7/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJJoeyTimeCollectionViewCell : UICollectionViewCell

// Changes the time shown in the cell to @a timeSince.
// @param timeSince The time since midnight that this time represents.
- (void)setTimeSinceMidnight:(NSNumber *)minutesSince;

@end
