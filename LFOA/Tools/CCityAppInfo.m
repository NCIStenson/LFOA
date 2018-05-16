//
//  CCityAppInfo.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/11/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAppInfo.h"

@implementation CCityAppInfo

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
    
        // app版本
        _appVersion  = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        // app build版本
       _buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    }
    return self;
}

@end
