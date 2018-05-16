//
//  AppDelegate.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTSDK/GeTuiSdk.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

