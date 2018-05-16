//
//  CCityMessageModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMessageModel.h"

@implementation CCityMessageModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _messageId   = dic[@"ID"];
        _time        = dic[@"SENDTIME"];
        _messageType = dic[@"MESSAGE_TYPE"];
        _userName    = dic[@"CY_NAME"];
        _content     = dic[@"CONTENT"];
        _date        = [self formtTimeWithStr:_time];
        
        _mainStyle = -1;
        _isOpen    = NO;
        
        _secondLevelType = dic[@"AJLX"];
        
        if ([_secondLevelType isEqualToString:@"行政办公"]) {
            
            _mainStyle = CCityOfficalMainDocStyle;
        } else if ([_secondLevelType isEqualToString:@"规划业务"]) {
            
            _mainStyle = CCityOfficalMainSPStyle;
        }
        
        _docStyle = CCityOfficalDocBackLogMode;
        
        if ([_messageType isEqualToString:@"传阅消息"]) {
            
            _docStyle = CCityOfficalDocReciveReadMode;
        } else if ([_messageType isEqualToString:@"督办消息"]) {
            
            _docStyle = CCityOfficalDocHaveDoneMode;
        } else if ([_messageType isEqualToString:@"收文时限提醒"]) {
            
            _docStyle = CCityOfficalDocBackLogMode;
            _mainStyle = CCityOfficalMainDocStyle;
        }
        
    }
    
    return self;
}

-(NSDate*)formtTimeWithStr:(NSString*)str {
    
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//    [dateformatter setLocale:[NSLocale currentLocale]];
    
//    NSLog(@"%@--%@",str , [dateformatter dateFromString:str]);
    return [dateformatter dateFromString:str];
}

@end
