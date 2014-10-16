//
//  IJServer.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJServer.h"

#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>

#import "IJCacheManager.h"
#import "IJBottomNotificationView.h"

static NSDate *lastAlertTime;

@implementation IJServer

+ (void)startRequestWithURN:(NSString *)URN
                       data:(NSDictionary *)params
                      paged:(BOOL)paged
                     domain:(id)domain
                    batched:(BOOL)batched
              dispatchGroup:(dispatch_group_t)dispatchGroup
              responseBlock:(void (^)(id))responseBlock
               failureBlock:(void (^)(NSError *))failureBlock {
  NSString* url = [kBaseURL stringByAppendingPathComponent:URN];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
  //[requestSerializer setValue:[RCSession accessToken] forHTTPHeaderField:@"auth_key"];
  manager.requestSerializer = requestSerializer;
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  NSMutableDictionary *params_auth = [NSMutableDictionary dictionaryWithDictionary:params];
  // TODO(amadou): pass something that can help id this device/user for daily active users etc...
  //params_auth[@"auth_key"] = [RCSession accessToken];
  [manager GET:url parameters:params_auth
  success:^(AFHTTPRequestOperation *operation, id responseObject) {
    responseBlock(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Failure!!!!");
    NSLog(@"Response: %@", operation.responseString);
    if (error.code == NSURLErrorNotConnectedToInternet) {
      [IJBottomNotificationView presentNotificationWithText:@"No Internet Connection"
                                               detailedText:@"Try again later"
                                                forDuration:6.5f];
    }
    failureBlock(error);
  }];
}

+ (void)getImageAtURL:(NSString*)url
              success:(void (^)(UIImage *image))success
              failure:(void (^)(NSError *error))failure {
  UIImage* cachedImage = [IJCacheManager getImageForURL:url];
  if (cachedImage) {
    success(cachedImage);
    return;
  }
  AFHTTPRequestOperationManager* httpManager = [[AFHTTPRequestOperationManager alloc] init];
  httpManager.responseSerializer = [AFImageResponseSerializer serializer];
  [httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, UIImage* image) {
    [IJCacheManager cacheImage:image forURL:url];
    success(image);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (void)getJSONAtURL:(NSString *)url
             success:(void (^)(id object))success
             failure:(void (^)(NSError *error))failure {
  NSAssert(url && success && failure, @"Must pass all parameters.");
  AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

@end
