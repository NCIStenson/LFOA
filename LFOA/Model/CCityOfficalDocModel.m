
//
//  CCityOfficalDocModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocModel.h"

@implementation CCityOfficalDocModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self configDataWithDic:dic];
    }
    return self;
}

- (void)configDataWithDic:(NSDictionary*)dic {
    
    NSMutableDictionary* docId = [@{@"workId" :dic[@"workid"],
               @"formId" :dic[@"formid"],
               @"fId"    :dic[@"fid"],
               @"fkNode" :dic[@"fk_node"],
               @"fk_flow":dic[@"fk_flow"],
               @"fkFlow" :dic[@"fk_flow"],
               } mutableCopy];
    
    if (dic[@"messageId"] != NULL) {   [docId setObject:dic[@"messageId"] forKey:@"messageId"];   }
    if (dic[@"fileid"] != NULL) {   [docId setObject:dic[@"fileid"] forKey:@"fileid"];   }
    
    _docId = [docId mutableCopy];
    
//    if (_contentMode != CCityOfficalDocHaveDoneMode) {
    
        if (dic[@"isread"] != NULL) {   _isRead = [dic[@"isread"] boolValue];   }
        
        if (dic[@"readstate"] != NULL) {    _isRead = [dic[@"readstate"] boolValue];    }
//    }

//    if (_contentMode == CCityOfficalDocReciveReadMode) {
    
        if (dic[@"cyr"] != NULL) {  _passPerson = dic[@"cyr"];  }
        else {  _passPerson = @"";  }
        
        if (dic[@"cyOpinion"] != NULL) {    _passOpinio = dic[@"cyOpinion"];    }
        else {  _passOpinio = @"";  }
//    }
    
    _docTitle = dic[@"projectname"];
    _docDate = [self conerDateStrWithStr:dic[@"rdt"]];
    
    if (dic[@"datet"]) {
        _surplusDays = dic[@"datet"];
    }
    
    if (dic[@"flowname"]) {
        
        _messagetype = dic[@"flowname"];
    }
    
    if (dic[@"projectno"]) {
        
        _docNumber = dic[@"projectno"];
    } else {
        
        if (dic[@"cyr"]) {
            
            _docNumber = [NSString stringWithFormat:@"传阅人：%@",dic[@"cyr"]];
        }
    }
}

-(NSString*)conerDateStrWithStr:(NSString*)dateStr {
        
    NSArray* dateArr = [dateStr componentsSeparatedByString:@" "];
    NSString* years = [dateArr firstObject];
    NSArray* yearsArr = [years componentsSeparatedByString:@"-"];
    
    dateStr = @"";
    
    for (int i = 0; i < yearsArr.count; i++) {
        
        NSString* date;
        if (i == yearsArr.count - 1) {
            
            date = yearsArr[i];
        } else {
            
            date = [NSString stringWithFormat:@"%@/",yearsArr[i]];
        }
        
        dateStr = [dateStr stringByAppendingString:date];
    }
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@" %@", [dateArr lastObject]]];
    
    return dateStr;
}

@end


@implementation CCityOfficalNewProjectModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self configDataWithDic:dic];
    }
    return self;
}

-(void)configDataWithDic:(NSDictionary *)dic
{
    _proNum = [dic objectForKey:@"no"];
    _proName = [dic objectForKey:@"proname"];
    _proChecked = [[dic objectForKey:@"checked"] boolValue];
//    _isSelected = NO;
    
    _isOpen = NO;
    _projectName = [dic objectForKey:@"name"];
    _detailDataArr = [dic objectForKey:@"yw"];
}

@end
