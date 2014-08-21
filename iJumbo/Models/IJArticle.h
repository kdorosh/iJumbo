//
//  IJArticle.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

@interface IJArticle : IJRecord

@property(nonatomic) NSString *articleID;
@property(nonatomic) NSString *author;
@property(nonatomic) NSString *link;
@property(nonatomic) NSDate *posted;
@property(nonatomic) NSString *source;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *imageURL;

+ (void)getArticlesWithSuccessBlock:(void (^)(NSArray *articles))successBlock
                       failureBlock:(void (^)(NSError *error))errorBlock;
+ (void)getObserverArticlesWithSuccessBlock:(void (^)(NSArray *articles))successBlock
                               failureBlock:(void (^)(NSError *error))errorBlock;
+ (void)getDailyArticlesWithSuccessBlock:(void (^)(NSArray *articles))successBlock
                            failureBlock:(void (^)(NSError *error))errorBlock;

@end
