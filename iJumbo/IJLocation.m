//
//  IJLocation.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocation.h"

#import "IJHelper.h"

@implementation IJLocation

@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic phone;
@dynamic website;
@dynamic address;
@dynamic hours;
@dynamic section;

+ (void)getLocationsWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                        failureBlock:(void (^)(NSError *error))errorBlock {
  [IJLocation startRequestWithURN:@"/locations"
                             data:nil
                          context:[IJHelper mainContext]
                           domain:nil
                      resultBlock:successBlock
                     failureBlock:errorBlock];
}

@end
