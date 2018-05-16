//
//  CCityProLogDetailModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/30.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityProLogDetailModel.h"

@implementation CCityProLogDetailModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _title = dic[@"title"];
        _time  = [self configTimeWithTime:dic[@"time"]];
        _name  = dic[@"name"];
        _day   = dic[@"day"];
    }
    
    return self;
}

-(NSString*)configTimeWithTime:(NSString*)time {
    
    NSArray* times = [time componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@:%@",times[0],times[1]];
}

@end
