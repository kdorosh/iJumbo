//
//  IJBottomNotificationView.h
//  iJumbo
//
//  Created by Amadou Crookes on 10/9/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJBottomNotificationView : UIView

+ (void)presentNotificationWithText:(NSString *)text
                       detailedText:(NSString *)detailText
                        forDuration:(NSTimeInterval)duration;

@end
