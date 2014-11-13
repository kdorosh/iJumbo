//
//  IJVariables.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#ifndef iJumbo_Variables
#define iJumbo_Variables

#define kIJumboBlue [UIColor colorWithRed:68/255.0f green:138/255.0f blue:255/255.0 alpha:1]
#define kIJumboGrey [UIColor colorWithRed:240/255.0f green:240/255.0f blue:238/255.0f alpha:1]
#define iJumboBlueWithAlpha(a) [UIColor colorWithRed:68/255.0f green:138/255.0f blue:255/255.0 alpha:a];

#define IJ_runOnMainThread if (![NSThread isMainThread]) { dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return; };

#define kFirstRunUserDefaultsKey @"FirstRunVersion_1_UserDefaultsKey"
#define kDeviceIdUserDefaultsKey @"DeviceIdUserDefaultsKey"
#define kDeviceNotificationIdDataUserDefaultsKey @"DeviceNotificationIdNSDataDefaultsKey"  // The key that stores the actualy NSData given by the delegate function.
#define kDeviceHasRegisteredForNotificationsKey @"kDeviceHasRegisteredForNotificationsKey"  // The server has the apns device id.

#endif
