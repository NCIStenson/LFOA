//
//  CCityOfficalDocDetailModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocDetailModel.h"

@implementation CCHuiQianModel

- (id)copyWithZone:(nullable NSZone *)zone {
    
    CCHuiQianModel* model = [CCHuiQianModel new];
    model.title   = self.title;
    model.content = self.content;
    model.rowId   = self.rowId;
    model.field   = self.field;
    model.contentsMuArr = [self.contentsMuArr mutableCopy];
    return model;
}

-(NSString *)currentFormatTime {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* formatTime = [dateFormat stringFromDate:date];
    return formatTime;
}

@end

@implementation CCityOfficalDocDetailModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    
    if (self) {
        
        [self configDataWithDic:dic];
    }
    
    return self;
}

-(void)configDataWithDic:(NSDictionary*)dic {
    
    _dataType = dic[@"DataType"];
    _canEdit  = ![dic[@"ReadOnly"] boolValue];
    _isRequired  = [dic[@"Required"] boolValue];
    _RequiredMessage  = dic[@"RequiredMessage"] ;
    _table    = dic[@"Table"];
    _groupId  = dic[@"GroupId"];
    _cellNum  = 0;
    
    if (dic[@"Label"] == [NSNull null]) {   _title = @"空";  }
    else                        {  _title  = dic[@"Label"]; }
    
    if (dic[@"Value"] == [NSNull null]) {   _value = @"";   }
    else {  _value = dic[@"Value"]; }
    
    NSString* contentType = dic[@"ControlType"];
    NSString* dateFormat = dic[@"DateFormat"];

    if ([contentType isEqual:@"文本框"]) {
        
        if ([dic[@"MultiLine"] boolValue]) {
            
            _style = CCityOfficalDetailMutableLineTextStyle;
            if ([dic[@"TextType"] isEqual:@"意见"]) {
                
                _style = CCityOfficalDetailOpinionStyle;
            }
            _isOpen  = YES;
            _cellNum = 1;
        } else if (_canEdit) {
            
            _style = CCityOfficalDetailSimpleLineTextStyle;
        } else {
            
            _style = CCityOfficalDetailNormalStyle;
        }
        
    } else if ([contentType isEqual:@"日期框"]) {
        if ([CCUtil isNotNull:dateFormat]) {
            if ([dateFormat isEqualToString:@"yyyy-MM-dd HH:mm:ss"]) {
                _style            = CCityOfficalDetailDateTimeStyle;
            }else{
                _style            = CCityOfficalDetailDateStyle;
            }
        }else{
            _style            = CCityOfficalDetailDateStyle;
        }
        
        NSString* dataStr = dic[@"Value"];
        
        if (dataStr.length > 0 && _style == CCityOfficalDetailDateStyle) {
            _value = [[dataStr componentsSeparatedByString:@" "] firstObject];
        }
    } else if ([contentType isEqual:@"下拉框"]) {
        
        _style = CCityOfficalDetailContentSwitchStyle;
        if (dic[@"ControlDataSource"] != [NSNull null]) {
            
            NSDictionary* values = dic[@"ControlDataSource"];
            _switchContentArr = values.allValues;
        }
    } else if ([contentType isEqual:@"数据网格"]) {
        
        if ([dic[@"TextType"] isEqual:@"会签意见"]) {
            
            _style = CCityOfficalDetailHuiQianStyle;
        } else {
            
            _style   = CCityOfficalDetailDataExcleStyle;
        }
        
        NSArray* columns = dic[@"Columns"];
        NSArray* keys;
        
        if (columns.count > 0) {
            
            _emptyHuiQianModel = [CCHuiQianModel new];
            _emptyHuiQianModel.rowId = @"-1";
            _emptyHuiQianModel.contentsMuArr = [NSMutableArray arrayWithCapacity:columns.count];
            for (NSDictionary* colsDic in columns) {
                
                CCHuiQianModel* model = [CCHuiQianModel new];
                model.title   = colsDic[@"Label"];
                model.field   = colsDic[@"Field"];
                model.content = @"";
                [_emptyHuiQianModel.contentsMuArr addObject:model];
            }
            
            NSDictionary* column = columns[0];
            NSDictionary* values = column[@"Values"];
            keys = values.allKeys;
            _cellNum = keys.count;
            if (keys.count > 0) {
                
                _huiQianMuArr = [NSMutableArray arrayWithCapacity:keys.count];
                
                for (NSString* key in keys) {
                    
                    CCHuiQianModel* detailModel = [CCHuiQianModel new];
                    detailModel.contentsMuArr = [NSMutableArray arrayWithCapacity:columns.count];
                    detailModel.rowId = key;
                    for (NSDictionary* colsDic in columns) {
                        
                        CCHuiQianModel* model = [CCHuiQianModel new];
                        model.title = colsDic[@"Label"];
                        model.field = colsDic[@"Field"];
                        model.content = colsDic[@"Values"][key];
                        [detailModel.contentsMuArr addObject:model];
                    }
                    
                    [_huiQianMuArr addObject:detailModel];
                }
            }
        }
        
    }
    
    if (!(dic[@"Field"] == [NSNull null])) {    _field = dic[@"Field"]; }
    
    _titleLabelSize = [self getTitleSizeWithStr:_title];
    _sectionHeight   = [self getSectionHeightWithStr:_value];
}

-(void)updataValue {
    
    _sectionHeight   = [self getSectionHeightWithStr:_value];
}

- (CGSize)getTitleSizeWithStr:(NSString*)str {
    
    UILabel* label = [UILabel new];
    label.numberOfLines =0;
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.text = str;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
    
    [label sizeToFit];
    
    if (label.frame.size.height < 34) {
        
        return CGSizeMake(label.frame.size.width, 34.f);
    }
    
    return label.frame.size;
}

-(CGFloat)getSectionHeightWithStr:(NSString*)str {
    
    if (self.style == CCityOfficalDetailOpinionStyle || self.style == CCityOfficalDetailMutableLineTextStyle) { return 44.f;    }
    
    UILabel* label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]-1];
    label.text = str;
    
    if (_titleLabelSize.width < ([UIScreen mainScreen].bounds.size.width - 20)*2 / 3) {
        
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - _titleLabelSize.width - 20 - 20, MAXFLOAT);
        [label sizeToFit];
    } else {
        
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
        [label sizeToFit];
        
        return 25 + _titleLabelSize.height + label.frame.size.height;
    }
    
    if (label.frame.size.height > 34) {
        
        return label.frame.size.height + 10;
    }
    
    return 44;
}

@end

