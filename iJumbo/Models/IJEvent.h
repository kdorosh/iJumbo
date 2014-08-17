//
//  IJEvent.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

@class IJLocation;

#import "IJRecord.h"

@interface IJEvent : IJRecord

@property(nonatomic) NSString *date;
@property(nonatomic) NSString *desc;
@property(nonatomic) NSDate *end;
@property(nonatomic) NSDate *start;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *website;

@property(nonatomic) IJLocation *location;

// Functions.
+ (void)getEventsWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                     failureBlock:(void (^)(NSError *error))errorBlock;


@end
