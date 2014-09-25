//
//  IJMinutesTillCollectionViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJMinutesTillCollectionViewCell : UICollectionViewCell

- (void)updateWithMinutes:(NSNumber *)minutes detailText:(NSString *)detailText;

@end
