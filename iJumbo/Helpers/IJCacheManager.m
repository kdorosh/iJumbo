//
//  IJCacheManager.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJCacheManager.h"

@interface IJCacheManager ()
@property(nonatomic) NSCache *imageCache;
@property(nonatomic) NSMutableSet *urlSet;
@end

@implementation IJCacheManager

- (instancetype)init {
  self = [super init];
  if (self) {
    self.imageCache = [[NSCache alloc] init];
    self.urlSet = [NSMutableSet set];
  }
  return self;
}

+ (IJCacheManager *)sharedManager {
  static IJCacheManager* manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[IJCacheManager alloc] init];
  });
  return manager;
}

+ (UIImage *)getImageForURL:(NSString *)url {
  IJCacheManager *manager = [IJCacheManager sharedManager];
  return [manager.imageCache objectForKey:url];
}

+ (void)cacheImage:(UIImage *)image forURL:(NSString *)url {
  IJCacheManager *manager = [IJCacheManager sharedManager];
  [manager.imageCache setObject:image forKey:url];
}

+ (void)isLoadingImageAtURL:(NSString *)url {
  IJCacheManager *manager = [IJCacheManager sharedManager];
  [manager.urlSet addObject:url];
}

+ (void)isNotLoadingImageAtURL:(NSString *)url {
  IJCacheManager *manager = [IJCacheManager sharedManager];
  [manager.urlSet removeObject:url];
}

+ (BOOL)isLoadingURL:(NSString *)url {
  IJCacheManager *manager = [IJCacheManager sharedManager];
  return [manager.urlSet containsObject:url];
}

@end
