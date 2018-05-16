//
//  CCitySecurity.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/31.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCitySecurity.h"
#import <CommonCrypto/CommonDigest.h>

#define CCITY_SALT        @"setCC@213445.%&-20[sdf]{+/*-21z345"
#define CCITY_SESSION_KEY @"user_seccion"

@implementation CCitySecurity

+(NSString*)md5WithStr:(NSString*)str {
    
    str = [str stringByAppendingString:CCITY_SALT];
    str = [CCitySecurity base64Str:str];
    const char* cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [result appendFormat:@"%02x",digest[i]];
    }
    
    return result;
}

+(NSString*)base64Str:(NSString*)str {
    
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}


+(BOOL)saveSessionWith:(NSString*)session {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:session forKey:CCITY_SESSION_KEY];
    
    return [userDefaults synchronize];
}

+(NSString*)getSession {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:CCITY_SESSION_KEY];
}

+(BOOL)setAutoLogIn:(BOOL)isAuto {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isAuto forKey:@"is_auto_Login"];
    return [userDefaults synchronize];
}

+(BOOL)isAutoLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"is_auto_Login"];
}

+(BOOL)isRememberPassWord:(BOOL)isRemember {
    
    NSUserDefaults* userDefaulds = [NSUserDefaults standardUserDefaults];
    [userDefaulds setBool:isRemember forKey:@"is_remember_password"];
    return [userDefaulds synchronize];
}

+(BOOL)isRememberPassWord {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"is_remember_password"];
}

+(NSString*)deptName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deptName"];
}

+ (BOOL)setDeptName:(NSString*)deptName {
    
    NSUserDefaults* userDefaulds = [NSUserDefaults standardUserDefaults];
    [userDefaulds setObject:deptName forKey:@"deptName"];
    return [userDefaulds synchronize];
}

+(NSString*)userName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ccity_userName"];
}

+(BOOL)setUserName:(NSString*)userName {
    
    NSUserDefaults* userDefaulds = [NSUserDefaults standardUserDefaults];
    [userDefaulds setObject:userName forKey:@"ccity_userName"];
    return [userDefaulds synchronize];
}


+(NSString*)passWord {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ccity_passWord"];
}

+(BOOL)setPassWord:(NSString*)passWord {
    
    NSUserDefaults* defaulds = [NSUserDefaults standardUserDefaults];
    if (passWord.length > 0) {
        
        [defaulds setObject:passWord forKey:@"ccity_passWord"];
    } else {
        
        [defaulds removeObjectForKey:@"ccity_passWord"];
    }
    
    return [defaulds synchronize];
}

+(void)setIsShowNotific:(NSString *)isShowNotific {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:isShowNotific forKey:@"ccity_is_show_notific"];
    [defaults synchronize];
}

+(NSString *)IsShowNotific {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ccity_is_show_notific"];
}

@end
