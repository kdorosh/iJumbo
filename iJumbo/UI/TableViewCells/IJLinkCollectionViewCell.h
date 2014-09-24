//
//  IJLinkCollectionViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/23/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IJLink;

@interface IJLinkCollectionViewCell : UICollectionViewCell

- (void)addDataFromLink:(IJLink *)link;

@end
