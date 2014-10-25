//
//  IJServer.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "MMServer.h"

static NSString * const kBaseURL = @"http://ijumboapp.com/v2/api";

@interface IJServer : MMServer

/* Do not need this since the news does not have images anymore.
+ (void)getImageAtURL:(NSString*)url
              success:(void (^)(UIImage *image))success
              failure:(void (^)(NSError *error))failure;
*/

+ (void)getJSONAtURL:(NSString *)url
             success:(void (^)(id object))success
             failure:(void (^)(NSError *error))failure;

+ (void)postData:(NSDictionary *)data
           toURL:(NSString *)url
         success:(void (^)(id object))success
         failure:(void (^)(NSError *error))failure;

+ (void)deleteData:(NSDictionary *)data
             toURL:(NSString *)url
           success:(void (^)(id object))success
           failure:(void (^)(NSError *error))failure;

@end
