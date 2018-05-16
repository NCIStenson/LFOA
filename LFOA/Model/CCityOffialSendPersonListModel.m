//
//  CCityOffialSendPersonListModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOffialSendPersonListModel.h"

@implementation CCityOfficalSendPersonDetailModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _childrenDic = dic[@"children"];
        _personId = dic[@"id"];
        _name     = dic[@"text"];
        _pinyin = [self chineseTranslateEnglish:_name];
        _firstLetter = [self getLetter:_name];
    }
    return self;
}

-(NSString *)getLetter:(NSString *) strInput{
    if ([strInput length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:strInput];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        ms = [ms substringToIndex:1];
        return [ms uppercaseString];
    }
    return nil;
}

-(NSString *)chineseTranslateEnglish:(NSString *)str
{
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    mutableString =(NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];

    return mutableString;
}
@end


@implementation CCityOffialSendPersonListModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _firstLetterArr = [NSMutableArray array];
        _formatDataDic = [NSMutableDictionary dictionary];
        [self configDataWithDic:dic];
    }
    return self;
}

- (void) configDataWithDic:(NSDictionary*)dic {
    
    _isOpen = NO;
    _groupTitle = dic[@"name"];
    _fkNode = [NSString stringWithFormat:@"%@",dic[@"toNode"]];
    
    NSArray* organization = dic[@"organization"];
    NSDictionary* organizDic = organization[0];
    
    NSArray* persons = organizDic[@"children"];
    
    _groupItmes = [NSMutableArray arrayWithCapacity:persons.count];
    
    for (int i = 0; i < persons.count; i++) {
        CCityOfficalSendPersonDetailModel* detailModel = [[CCityOfficalSendPersonDetailModel alloc]initWithDic:persons[i]];
        if(detailModel.childrenDic.count > 0){
            for (int j = 0 ; j < detailModel.childrenDic.count ; j ++) {
                CCityOfficalSendPersonDetailModel * detailModel1 = [[CCityOfficalSendPersonDetailModel alloc]initWithDic:detailModel.childrenDic[j]];
                [_groupItmes addObject:detailModel1];
            }
        }else{
            [_groupItmes addObject:detailModel];
        }
    }
        
    for (char c = 'A'; c <= 'Z'; ++c) {
        NSString * charStr =  [NSString stringWithFormat:@"%c",c];
        NSMutableArray * arr = [NSMutableArray array];
        for (int j = 0 ; j < _groupItmes.count; j++) {
            CCityOfficalSendPersonDetailModel * detailModel = _groupItmes[j];
            if ([charStr isEqualToString:detailModel.firstLetter]) {
                [arr addObject:detailModel];
            }
        }
        if(arr.count > 0){
            NSSortDescriptor * sdFirstName = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
            NSArray * sortedArray = [arr sortedArrayUsingDescriptors:@[sdFirstName]];
            
            [_firstLetterArr addObject:charStr];
            [_formatDataDic setObject:sortedArray forKey:charStr];
        }
    }    
}

@end

