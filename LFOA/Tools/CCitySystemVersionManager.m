//
//  CCitySystemVersionManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/10/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCitySystemVersionManager.h"
#import <sys/utsname.h>

@implementation CCitySystemVersionManager

+(NSString*)deviceStr {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if([platform isEqualToString:@"iPhone5,1"]) return@"5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return@"5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return@"5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return@"5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return@"5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return@"5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return@"6P";
    
    if([platform isEqualToString:@"iPhone7,2"]) return@"6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return@"6S";
    
    if([platform isEqualToString:@"iPhone8,2"]) return@"6SP";
    
    if([platform isEqualToString:@"iPhone8,4"]) return@"SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return@"7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return@"7P";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"8P";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"X";
    
    return platform;
  
}

+(NSString*)OSVersion {
    
    return nil;
}

@end
