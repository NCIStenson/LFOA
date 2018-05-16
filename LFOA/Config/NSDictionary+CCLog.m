//
//  NSDictionary+CCLog.m
//  LFOA
//
//  Created by Stenson on 2018/5/15.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "NSDictionary+CCLog.h"

@implementation NSDictionary (CCLog)

#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale{
    
    NSString *logString;
    
    @try {
        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil]encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
}
#endif

@end
