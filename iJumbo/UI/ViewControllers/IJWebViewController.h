//
//  IJWebViewController.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/19/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJWebViewController : UIViewController
- (instancetype)initWithURL:(NSString *)url;
+ (IJWebViewController *)defaultInstanceWithURL:(NSString *)url;
@end
