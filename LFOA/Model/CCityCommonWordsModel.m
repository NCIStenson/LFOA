//
//  CCityCommonWordsModel.m
//  LFOA
//
//  Created by Stenson on 2018/7/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "CCityCommonWordsModel.h"

@implementation CCityCommonWordsModel
-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    [self setValuesForKeysWithDictionary:dic];
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"isShowFullText"]) {
        _isShowFullText = NO;
    }
}

@end
