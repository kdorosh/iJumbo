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
  if ([domain isEqual:IJServerDomainCodeLocalJSONRequest]) {
    id object = [self getLocalDataFromJSONResource:URN];
    if (object) {
      responseBlock(object);
    } else {
      failureBlock([NSError errorWithDomain:@"File not found" code:1 userInfo:nil]);
    }
    return;
  }
  NSString* url = [kBaseURL stringByAppendingPathComponent:URN];
  NSMutableDictionary *params_auth = [NSMutableDictionary dictionaryWithDictionary:params];
  AFHTTPRequestOperationManager *manager = [self defaultManager];
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

// @param resource The name of the json resource that should be returned. For a file called
// locations.json, the resource would be @"locations".
// @return The object(s) stored to disk as either a NSDictionary or NSArray.
+ (id)getLocalDataFromJSONResource:(NSString *)resource {
  NSError* err = nil;
  NSString* dataPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
  NSArray* objects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                   options:kNilOptions
                                                     error:&err];
  return objects;
}

+ (void)getJSONAtURL:(NSString *)url
             success:(void (^)(id object))success
             failure:(void (^)(NSError *error))failure {
  IJAssertNotNil(url);
  AFHTTPRequestOperationManager *manager = [self defaultManager];
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (void)postData:(NSDictionary *)data
           toURL:(NSString *)url
         success:(void (^)(id object))success
         failure:(void (^)(NSError *error))failure {
  IJAssertNotNil(url);
  AFHTTPRequestOperationManager *manager = [self defaultManager];
  [manager POST:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (void)deleteData:(NSDictionary *)data
             toURL:(NSString *)url
           success:(void (^)(id object))success
           failure:(void (^)(NSError *error))failure {
  IJAssertNotNil(url);
  AFHTTPRequestOperationManager *manager = [self defaultManager];
  [manager DELETE:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (void)putData:(NSDictionary *)data
          toURL:(NSString *)url
        success:(void (^)(id object))success
        failure:(void (^)(NSError *error))failure {
  IJAssertNotNil(url);
  AFHTTPRequestOperationManager *manager = [self defaultManager];
  [manager PUT:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (AFHTTPRequestOperationManager *)defaultManager {
  NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceIdUserDefaultsKey];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
  [requestSerializer setValue:deviceID forHTTPHeaderField:@"device_id"];
  manager.requestSerializer = requestSerializer;
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  return manager;
}

@end
