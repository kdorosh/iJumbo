//
//  IJLink.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLink.h"
#import "IJHelper.h"

@implementation IJLink

@dynamic name;
@dynamic url;
@dynamic id;

+ (void)getLinksWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                   failureBlock:(void (^)(NSError *error))errorBlock {
  [IJLink startRequestWithURN:@"/links"
                         data:nil
                      context:[IJHelper mainContext]
                       domain:nil
                  resultBlock:successBlock
                 failureBlock:errorBlock];
}

@end
