//
//  IJVariables.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#ifndef iJumbo_Variables
#define iJumbo_Variables

// Call this at the beginning of a function if it must be on the main thread.
// If it is not, it calls this function again on the main thread.
#define IJ_runOnMainThread if (![NSThread isMainThread]) { dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return; };

#define kFirstRunUserDefaultsKey @"FirstRunVersion_1_UserDefaultsKey"
#define kDeviceIdUserDefaultsKey @"DeviceIdUserDefaultsKey"
#define kDeviceNotificationIdDataUserDefaultsKey @"DeviceNotificationIdNSDataDefaultsKey"  // The key that stores the actualy NSData given by the delegate function.
#define kDeviceHasRegisteredForNotificationsKey @"kDeviceHasRegisteredForNotificationsKey"  // The server has the apns device id.

#endif
