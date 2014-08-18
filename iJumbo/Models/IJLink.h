//
//  IJLink.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

@interface IJLink : IJRecord
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *url;
@property(nonatomic) NSDate *firstSeen;

// Functions.
+ (void)getLinksWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                    failureBlock:(void (^)(NSError *error))errorBlock;

@end
