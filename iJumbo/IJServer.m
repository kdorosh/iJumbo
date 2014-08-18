//
//  IJServer.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJServer.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBaseURL = @"http://ijumbo.herokuapp.com/api/";

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
    failureBlock(error);
  }];
}

@end
