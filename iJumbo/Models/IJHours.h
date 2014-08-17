//
//  IJHours.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

@class IJRange;

@interface IJHours : IJRecord

// Relationships.
@property(nonatomic) IJRange *sunday;
@property(nonatomic) IJRange *monday;
@property(nonatomic) IJRange *tuesday;
@property(nonatomic) IJRange *wednesday;
@property(nonatomic) IJRange *thursday;
@property(nonatomic) IJRange *friday;
@property(nonatomic) IJRange *saturday;

@end
