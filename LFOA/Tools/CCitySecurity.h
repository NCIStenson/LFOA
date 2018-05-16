//
//  CCitySecurity.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/31.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCitySecurity : NSObject

+(void)setIsShowNotific:(NSString *)isShowNotific;
+(NSString*)IsShowNotific;

+(NSString*)md5WithStr:(NSString*)str;

+(BOOL)saveSessionWith:(NSString*)session;
+(NSString*)getSession;

+(BOOL)setAutoLogIn:(BOOL)isAuto;
+(BOOL)isAutoLogin;

+(BOOL)isRememberPassWord:(BOOL)isRemember;
+(BOOL)isRememberPassWord;

+(NSString*)userName;
+(BOOL)setUserName:(NSString*)userName;

+(NSString*)passWord;
+(BOOL)setPassWord:(NSString*)PassWord;

+(NSString*)deptName;
+ (BOOL)setDeptName:(NSString*)deptName;
@end
