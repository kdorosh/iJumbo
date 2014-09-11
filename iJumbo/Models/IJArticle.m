//
//  IJArticle.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJArticle.h"
#import "IJHelper.h"

@implementation IJArticle

@dynamic articleID;
@dynamic author;
@dynamic link;
@dynamic posted;
@dynamic source;
@dynamic title;
@dynamic section;

+ (void)getArticlesWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                       failureBlock:(void (^)(NSError *error))errorBlock {
  [IJArticle startRequestWithURN:@"/articles"
                            data:nil
                         context:[IJHelper mainContext]
                          domain:nil
                     resultBlock:successBlock
                    failureBlock:errorBlock];
}

+ (void)getObserverArticlesWithSuccessBlock:(void (^)(NSArray *articles))successBlock
                               failureBlock:(void (^)(NSError *error))errorBlock {
  [IJArticle startRequestWithURN:@"/articles/observer"
                            data:nil
                         context:[IJHelper mainContext]
                          domain:nil
                     resultBlock:successBlock
                    failureBlock:errorBlock];
}

+ (void)getDailyArticlesWithSuccessBlock:(void (^)(NSArray *articles))successBlock
                            failureBlock:(void (^)(NSError *error))errorBlock {
  [IJArticle startRequestWithURN:@"/articles/daily"
                            data:nil
                         context:[IJHelper mainContext]
                          domain:nil
                     resultBlock:successBlock
                    failureBlock:errorBlock];
}

@end
