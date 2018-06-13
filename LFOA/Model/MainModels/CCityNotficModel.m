//
//  CCityNotficModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNotficModel.h"

@implementation CCityFileModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
       
        _fileName = dic[@"name"];
        _fileSize = dic[@"size"];
        _fileUrl  = dic[@"path"];
        _type = [[_fileName componentsSeparatedByString:@"."] lastObject];
    }
    
    return self;
}


@end

@implementation CCityNewNotficDepartmentModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        _ID = dic[@"ID"];
        _ORGANIZATIONNAME = dic[@"ORGANIZATIONNAME"];
    }
    
    return self;
}

@end

@implementation CCityNewNotficPersonModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        
        _iconCls = dic[@"iconCls"];
        _personId  = dic[@"id"];
        _rowid  = dic[@"rowid"];
        _type  = dic[@"type"];
        _text  = dic[@"text"];
        _pinyin = [self chineseTranslateEnglish:_text];
        _firstLetter = [self getLetter:_text];

        _isOpen = NO;
        _isSelected = NO;
        
        _orgModelArr = [NSMutableArray array];
        _personModelArr = [NSMutableArray array];
        
        _personalModelFirstLetterArr = [NSMutableArray array];
        _personalModelFormatArr = [NSMutableArray array];
        
        NSArray * _children = dic[@"children"];
        
        if ([_type integerValue] == 1) {
            for (int i = 0 ; i < _children.count; i ++) {
                CCityNewNotficPersonModel * orgModel = [[CCityNewNotficPersonModel alloc]initWithDic:_children[i]];
                [_orgModelArr addObject:orgModel];

                NSArray * personArr = _children[i][@"children"];
                
                NSMutableArray * firstLetterArr = [NSMutableArray array];
                NSMutableDictionary * formatDataDic = [NSMutableDictionary dictionary];
                NSMutableArray * personModelArr = [NSMutableArray arrayWithCapacity:personArr.count];
                
                for (int k = 0 ; k < personArr.count; k++) {
                    CCityNewNotficPersonModel * personalModel = [[CCityNewNotficPersonModel alloc]initWithDic:personArr[k]];
                    [personModelArr addObject:personalModel];
                }
                
                NSSortDescriptor * sdFirstName = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
                NSArray * sortedArray = [personModelArr sortedArrayUsingDescriptors:@[sdFirstName]];

                NSMutableArray * cacheArr = [NSMutableArray array];
                for (int i = 0; i <sortedArray.count; i ++) {
                    CCityNewNotficPersonModel * personalModel = sortedArray[i];
                    if (i == 0) {
                        [firstLetterArr addObject:personalModel.firstLetter];
                        [cacheArr addObject:personalModel];
                        if(i == sortedArray.count - 1){
                            [formatDataDic setObject:cacheArr forKey:firstLetterArr.lastObject];
                        }
                    }else if (i == sortedArray.count - 1){
                        if ([firstLetterArr.lastObject isEqualToString:personalModel.firstLetter]) {
                            [cacheArr addObject:personalModel];
                            [formatDataDic setObject:cacheArr forKey:firstLetterArr.lastObject];
                        }else{
                            [formatDataDic setObject:cacheArr forKey:firstLetterArr.lastObject];
                            cacheArr = [NSMutableArray array];
                            [cacheArr addObject:personalModel];
                            [firstLetterArr addObject:personalModel.firstLetter];
                            [formatDataDic setObject:cacheArr forKey:firstLetterArr.lastObject];
                        }
                    }else{
                        if ([firstLetterArr.lastObject isEqualToString:personalModel.firstLetter]) {
                            [cacheArr addObject:personalModel];
                        }else{
                            [formatDataDic setObject:cacheArr forKey:firstLetterArr.lastObject];
                            cacheArr = [NSMutableArray array];
                            [cacheArr addObject:personalModel];
                            [firstLetterArr addObject:personalModel.firstLetter];
                        }
                    }
                }
                
                [_personModelArr addObject:sortedArray];
                [_personalModelFirstLetterArr addObject:firstLetterArr];
                [_personalModelFormatArr addObject:formatDataDic];
            }
        }
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

@implementation CCityNewNotficModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        
        _annexitemId = dic[@"annexitemId"];
        _departments  = dic[@"departments"];
        NSArray* files = dic[@"departments"];
        if (files.count) {
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:files.count];
            for (int i = 0; i < files.count; i++) {
                CCityNewNotficDepartmentModel* fileModel = [[CCityNewNotficDepartmentModel alloc]initWithDic:files[i]];
                [filesMuArr addObject:fileModel];
            }
            _departments = [filesMuArr mutableCopy];
        }
        
        NSArray* organizationTreeArr = dic[@"organizationTree"];
        if (organizationTreeArr.count) {
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:organizationTreeArr.count];
            for (int i = 0; i < organizationTreeArr.count; i++) {
                CCityNewNotficPersonModel* fileModel = [[CCityNewNotficPersonModel alloc]initWithDic:organizationTreeArr[i]];
                [filesMuArr addObject:fileModel];
            }
            _organizationTree = [filesMuArr mutableCopy];
        }
    }
    
    return self;
}

@end

@implementation CCityNotficModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        
        _messageId      = dic[@"annexitemid"];
        _isHeightLevel  = [dic[@"emergency"] boolValue];
        _notficFromName = dic[@"orgname"];
        _notficPostTime = [self formatTiemWithTime:dic[@"releasedate"]];
        _notficTitle    = dic[@"noticename"];
        _notficContent  = dic[@"noticecontent"];
        _isRead         = [dic[@"isread"] boolValue];
        
        NSArray* files = dic[@"children"];
        
        if (files.count) {
            _isHaveFile = YES;
            
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:files.count];
            for (int i = 0; i < files.count; i++) {
                
                CCityFileModel* fileModel = [[CCityFileModel alloc]initWithDic:files[i]];
                [filesMuArr addObject:fileModel];
            }
            
            _files = [filesMuArr mutableCopy];
            
        } else {
            
            _isHaveFile = NO;
        }
    }
    return self;
}

-(NSString*)formatTiemWithTime:(NSString*)time {
    
    NSArray* times = [time componentsSeparatedByString:@" "];
    NSString* YMD = [times firstObject];
    NSArray* YMDS = [YMD componentsSeparatedByString:@"/"];
    
    return [NSString stringWithFormat:@"%@-%@-%@", YMDS[0], YMDS[1], YMDS[2]];
}

#pragma mark -- mucopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    
    CCityNotficModel* model = [[CCityNotficModel allocWithZone:zone]init];
    model.isHaveFile = _isHaveFile;
    model.isHeightLevel = _isHeightLevel;
    model.isRead = _isRead;
    
    model.notficFromName = _notficFromName;
    model.notficPostTime = _notficPostTime;
    model.notficTitle = _notficTitle;
    model.notficContent = _notficContent;
    model.files = _files;
    return model;
}

@end
