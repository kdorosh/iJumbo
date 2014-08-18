//
//  IJLinkTableViewCell.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IJLink.h"

static const int kLinkTableViewCellHeight = 44;

@interface IJLinkTableViewCell : UITableViewCell

- (void)addDataFromLink:(IJLink *)link;

@end
