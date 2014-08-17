//
//  IJEvent.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEvent.h"
#import "IJHelper.h"

@implementation IJEvent

@dynamic date;
@dynamic desc;
@dynamic end;
@dynamic start;
@dynamic title;
@dynamic website;
@dynamic location;

+ (void)getEventsWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                     failureBlock:(void (^)(NSError *error))errorBlock {
  [IJEvent startRequestWithURN:@"/events"
                          data:nil
                       context:[IJHelper mainContext]
                        domain:nil
                   resultBlock:successBlock
                  failureBlock:errorBlock];
}

@end
