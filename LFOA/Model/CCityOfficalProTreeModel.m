//
//  CCityOfficalProTreeModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalProTreeModel.h"

@implementation CCityOfficalProTreeModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self configDataWithDic:dic];
    }
    return self;
}

-(void)configDataWithDic:(NSDictionary*)dic {
    
    _title    = dic[@"text"];
    
    if (!self.level) {  self.level = 1; }
    
    if (dic[@"formid"]) {
        
        _ids = @{
                 @"formid" :dic[@"formid"],
                 @"workid" :dic[@"workid"],
                 @"fk_node":dic[@"fk_node"]
                 };
    }
    
    if (dic[@"children"]) {
        
        NSArray* children = dic[@"children"];

        NSMutableArray* muArr = [NSMutableArray arrayWithCapacity:children.count];
        
        for (int i = 0; i < children.count; i++) {
            
            CCityOfficalProTreeModel* model = [[CCityOfficalProTreeModel alloc]initWithDic:children[i]];

            [muArr addObject:model];
            
        }
        
        _children = [muArr mutableCopy];
    }
    
    _isOpen   = NO;
}

@end
