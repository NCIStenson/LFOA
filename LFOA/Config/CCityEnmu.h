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

typedef NS_ENUM(NSUInteger, CCityNewTypeStyle) {
    CCityNewTypeNoti,   // 新建通知
    CCityNewTypeMeeting,    // 新建会议
};

typedef NS_ENUM(NSUInteger, CCityNewNotiMeetingStyle) {
    CCityNewNotiMeetingStyleInput,      // 普通输入
    CCityNewNotiMeetingStyleDate,       // 日期
    CCityNewNotiMeetingStyleAlert,      // 下拉框
    CCityNewNotiMeetingStyleNextPage,   // 进入下级页面
    CCityNewNotiMeetingStyleTextView,   // 内容输入框
    CCityNewNotiMeetingStyleUpload,     // 上传附件
    CCityNewNotiMeetingStyleOther,      // 会议选择是否紧急 是否发送短信
};

//  是会议类型 或者 发布科室
typedef NS_ENUM(NSUInteger, CCityDropdownBox) {
    CCityDropdownBoxMeeting, //  局内会议 临时会议 外出会议
    CCityDropdownBoxDepartment, // 发布科室 子类
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


/**
 进入常用语页面的方式

 - ENTER_COMMONWORDS_TYPE_DOC: 从公文列表进入
 - ENTER_COMMONWORDS_TYPE_USERCENTER: 从用户中心进入
 */
typedef NS_ENUM(NSUInteger, ENTER_COMMONWORDS_TYPE) {
    ENTER_COMMONWORDS_TYPE_DOC,
    ENTER_COMMONWORDS_TYPE_USERCENTER,
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
