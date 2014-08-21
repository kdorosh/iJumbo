//
//  IJLocation.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

#import <MapKit/MapKit.h>

@class IJHours;

@interface IJLocation : IJRecord <MKAnnotation>

// Attributes.
@property(nonatomic) NSNumber *latitude;
@property(nonatomic) NSNumber *longitude;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *phone;
@property(nonatomic) NSString *website;
@property(nonatomic) NSString *address;
@property(nonatomic) NSString *section;

// Relationships.
@property(nonatomic) IJHours *hours;

// Functions.
+ (void)getLocationsWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                        failureBlock:(void (^)(NSError *error))errorBlock;

@end
