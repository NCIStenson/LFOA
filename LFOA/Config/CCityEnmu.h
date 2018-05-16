//
//  CCityEnmu.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#ifndef CCityEnmu_h
#define CCityEnmu_h

#define CCITY_SYSTEM_TYPE    [CCitySystemVersionManager deviceStr]
#define CCITY_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]

typedef NS_ENUM(NSUInteger, CCityOfficalDetailSectionStyle) {
    
    CCityOfficalDetailNormalStyle,
    CCityOfficalDetailContentSwitchStyle,      // 选择
    CCityOfficalDetailDateStyle,               // 日期
    CCityOfficalDetailDateTimeStyle,               // 选择日期和时间
    CCityOfficalDetailSimpleLineTextStyle,     // 单行文本框
    CCityOfficalDetailMutableLineTextStyle,   // 多行文本框
    CCityOfficalDetailOpinionStyle,           // 意见框
    CCityOfficalDetailDataExcleStyle,         // 数据网格
    CCityOfficalDetailHuiQianStyle,           // 会签
};

typedef NS_ENUM(NSUInteger, CCityOfficalDocContentMode) {
    
    CCityOfficalDocBackLogMode,
    CCityOfficalDocHaveDoneMode,
    CCityOfficalDocReciveReadMode
};

typedef NS_ENUM(NSUInteger, CCityOfficalMainStyle) {
    
    CCityOfficalMainDocStyle,
    CCityOfficalMainSPStyle,
};

typedef NS_ENUM(NSUInteger, CCHuiQianEditStyle) {
    CCHuiQianEditAddStyle,
    CCHuiQianEditEditStyle,
    CCHuiQianEditCheckStyle,
};

/*
 * 服务器返回代码
 */
typedef NS_ENUM(NSUInteger, CCNetWorkStateErrorCode) {
    
    CCNetWorkStateTokenOutOfData     = 1,     // 用户不存在或TOKEN过期
    CCNetWorkStateListNotConfig      = 100,   // 表单配置文件不存在
    CCNetWorkStateListNotExist       = 101,   // 表单不存在
    CCNetWorkStateLowJurisdiction    = 200,   // 没有权限
    CCNetWorkStateInvalidParameter   = 500,   // 参数无效
    CCNetWorkStateServerExecuteError = 501,   // 执行错误
};

#endif /* CCityEnmu_h */
