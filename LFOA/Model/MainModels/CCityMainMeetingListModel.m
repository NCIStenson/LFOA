//
//  CCityMainMeetingListModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainMeetingListModel.h"

@implementation CCityMainMeetingListModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        _annexitemId     = dic[@"annexitemId"];
        _meetingTitle    = dic[@"hymc"];
        _meetingNum      = dic[@"hybh"];
        _meetingPlace    = dic[@"hydd"];
        _meetingType     = dic[@"hylx"];
        _meetingMembers  = dic[@"hyry"];
        _meetingSponsor  = dic[@"zzbm"];
        _sponsoredUnit   = dic[@"zzdw"];
        _meetingRecorder = dic[@"jlr"];
        _meetingCJYR     = dic[@"cjyr"];
        _meetingChecker  = dic[@"kqr"];
        _compere         = dic[@"hyzcr"];
        _content         = dic[@"hynr"];
        _accessoryFiles  = dic[@"children"];
        _isRead          = [dic[@"isRead"] boolValue];
        _meetingTime     = [self formateTimeWithStr:dic[@"hysj"]];
        
        _hasFile         = _accessoryFiles.count;
    }
    
    return self;
}

- (NSString*)formateTimeWithStr:(NSString*)time {
    
    if (time.length <= 0) {
        return @"空";
    }
    
    NSArray* times = [time componentsSeparatedByString:@" "];
    
    NSString* hm = @"00:00";
    
    if (times.count==2) {
        
        NSArray* hms = [times[1] componentsSeparatedByString:@":"];
        
        for (int i = 0; i < hms.count; i++) {
            
            if (i == 0) {
                hm = hms[0];
            } else if (i == 1) {
                
                hm  = [NSString stringWithFormat:@"%@:%@", hm ,hms[1]];
            }
        }
        
        NSString* ym = times[0];
        ym = [NSString stringWithFormat:@" %@ %@", ym, hm];
        return ym;
    }
    
    return time;
}

@end

@implementation CCityNewMeetingTypeModel
-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        _ID = dic[@"ID"];
        _HYNAME = dic[@"HYNAME"];
    }
    
    return self;
}

@end

@implementation CCityNewMeetingDepartmentModel
-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        _ID = dic[@"ID"];
        _ORGANIZATIONNAME = dic[@"ORGANIZATIONNAME"];
    }
    
    return self;
}

@end

@implementation CCityNewMeetingPersonModel

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
                CCityNewMeetingPersonModel * orgModel = [[CCityNewMeetingPersonModel alloc]initWithDic:_children[i]];
                [_orgModelArr addObject:orgModel];
                
                NSArray * personArr = _children[i][@"children"];
                
                NSMutableArray * firstLetterArr = [NSMutableArray array];
                NSMutableDictionary * formatDataDic = [NSMutableDictionary dictionary];
                NSMutableArray * personModelArr = [NSMutableArray arrayWithCapacity:personArr.count];
                
                for (int k = 0 ; k < personArr.count; k++) {
                    CCityNewMeetingPersonModel * personalModel = [[CCityNewMeetingPersonModel alloc]initWithDic:personArr[k]];
                    [personModelArr addObject:personalModel];
                }
                
                NSSortDescriptor * sdFirstName = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
                NSArray * sortedArray = [personModelArr sortedArrayUsingDescriptors:@[sdFirstName]];
                
                NSMutableArray * cacheArr = [NSMutableArray array];
                for (int i = 0; i <sortedArray.count; i ++) {
                    CCityNewMeetingPersonModel * personalModel = sortedArray[i];
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

@implementation CCityNewMeetingModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithDic:dic];
    
    if (self) {
        
        _fileNo = dic[@"fileNo"];
        _departments  = dic[@"departments"];
        
        NSArray * meetingTypeArr = dic[@"meetingTypes"][@"rows"];
        if (meetingTypeArr.count) {
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:meetingTypeArr.count];
            for (int i = 0; i < meetingTypeArr.count; i++) {
                CCityNewMeetingTypeModel* fileModel = [[CCityNewMeetingTypeModel alloc]initWithDic:meetingTypeArr[i]];
                [filesMuArr addObject:fileModel];
            }
            _meetingTypes = [filesMuArr mutableCopy];
        }

        NSArray* files = dic[@"departments"];
        if (files.count) {
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:files.count];
            for (int i = 0; i < files.count; i++) {
                CCityNewMeetingDepartmentModel* fileModel = [[CCityNewMeetingDepartmentModel alloc]initWithDic:files[i]];
                [filesMuArr addObject:fileModel];
            }
            _departments = [filesMuArr mutableCopy];
        }
        
        NSArray* organizationTreeArr = dic[@"organizationTree"];
        if (organizationTreeArr.count) {
            NSMutableArray* filesMuArr = [NSMutableArray arrayWithCapacity:organizationTreeArr.count];
            for (int i = 0; i < organizationTreeArr.count; i++) {
                CCityNewMeetingPersonModel* fileModel = [[CCityNewMeetingPersonModel alloc]initWithDic:organizationTreeArr[i]];
                [filesMuArr addObject:fileModel];
            }
            _organizationTree = [filesMuArr mutableCopy];
        }
    }
    
    return self;
}
@end
