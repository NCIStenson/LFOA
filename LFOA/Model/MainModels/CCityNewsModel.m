//
//  CCityNewsModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsModel.h"

@implementation CCityNewsModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _title   = dic[@"title"];
        _time    = dic[@"starttime"];
        _brief   = dic[@"brief"];
        _content = dic[@"content"];
        _sender  = dic[@"sender"];
        _type    = dic[@"newstype"];        
    }
    
    return self;
}

@end
