//
//  IJServer.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "MMServer.h"

static NSString * const kBaseURL = @"http://ijumbo.herokuapp.com/api/";

@interface IJServer : MMServer

+ (void)getImageAtURL:(NSString*)url
              success:(void (^)(UIImage *image))success
              failure:(void (^)(NSError *error))failure;

+ (void)getJSONAtURL:(NSString *)url
             success:(void (^)(id object))success
             failure:(void (^)(NSError *error))failure;

@end
