//
//  ZEMarcoConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef CCMarcoConstant_h
#define CCMarcoConstant_h

#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#define ZE_weakify(var)   __weak typeof(var) weakSelf = var
#define ZE_strongify(var) __strong typeof(var) strongSelf = var


#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define IS_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define IS_IOS11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define kCURRENTASPECT SCREEN_WIDTH / 375.0f

#define FRAME_WIDTH     [[UIScreen mainScreen] applicationFrame].size.width
#define FRAME_HEIGHT    [[UIScreen mainScreen] applicationFrame].size.height
#define IPHONE5_MORE     ([[UIScreen mainScreen] bounds].size.height > 480)
#define IPHONE4S_LESS    ([[UIScreen mainScreen] bounds].size.height <= 480)
#define IPHONE5     ([[UIScreen mainScreen] bounds].size.height == 568)
#define IPHONE6_MORE     ([[UIScreen mainScreen] bounds].size.height > 568)
#define IPHONE6     ([[UIScreen mainScreen] bounds].size.height == 667)
#define IPHONE6P     ([[UIScreen mainScreen] bounds].size.height == 736)
#define IPHONEX     ([[UIScreen mainScreen] bounds].size.height == 812)

#define IPHONETabbarHeight (IPHONEX ? 83.0f : 49.0f)

#endif /* ZEMarcoConstant_h */
