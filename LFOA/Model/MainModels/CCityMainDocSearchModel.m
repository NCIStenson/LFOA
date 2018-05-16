//
//  CCityMainDocSearchModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainDocSearchModel.h"

@implementation CCityAccessoryModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super initWithDic:dic];
    if (self) {
        
        _accessoryName = dic[@"name"];
        _accessoryUrl  = dic[@"path"];
        _accessorySize = dic[@"size"];
    }
    return self;
}

@end

@implementation CCityMainDocsearchDetailModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _isOpen = NO;
        
        _name   = dic[@"fgmc"];
        _time   = [self fromatTimeWithTime:dic[@"fxsj"]];
        _from   = dic[@"fxjg"];
        _info   = dic[@"info"];
        _number = dic[@"fgbh"];
        
        NSArray* children = dic[@"children"];
        
        NSMutableArray* accessoryMuArr = [NSMutableArray arrayWithCapacity:children.count];
        
        for(int i = 0; i < children.count; i++) {
            
            CCityAccessoryModel* model = [[CCityAccessoryModel alloc]initWithDic: children[i]];
            [accessoryMuArr addObject:model];
        }
        
        _accessoryArr = [accessoryMuArr mutableCopy];
    }
    
    return self;
}

-(NSString*)fromatTimeWithTime:(NSString*)time {
    
    NSArray* times = [time componentsSeparatedByString:@" "];
    return times[0];
}


@end

@implementation CCityMainDocSearchModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _type = dic[@"fglb"];
        _children = [NSMutableArray array];
    }
    
    return self;
}


@end
