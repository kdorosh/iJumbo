//
//  IJCacheManager.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IJCacheManager : NSObject

+ (void)cacheImage:(UIImage *)image forURL:(NSString *)url;
+ (UIImage *)getImageForURL:(NSString *)url;

/// Image Loadings.
+ (void)isLoadingImageAtURL:(NSString *)url;
+ (void)isNotLoadingImageAtURL:(NSString *)url;
+ (BOOL)isLoadingURL:(NSString *)url;

@end
