//
//  CCityMainSearchTaskModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainSearchTaskModel.h"

@implementation CCityMainSearchTaskModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        if (dic[@"metatype"] == NULL) {
            
            _mainStyle = -1;
        } else {
            
            _mainStyle = [dic[@"metatype"] integerValue];
        }
        
        _workId = dic[@"workid"];
        _fkNode = dic[@"fknode"];
        _formId = dic[@"formid"];
        _fkFlow = dic[@"fkflow"];
        
        _registeTime = dic[@"djsj"];
        _proNum      = dic[@"ajbh"];
       
        _proName     = dic[@"xmmc"];
        
        if (_proName.length <=0) {
            _proName = @"空";
        }
        
        _proType     = dic[@"ywlx"];
    }
    
    return self;
}

@end
