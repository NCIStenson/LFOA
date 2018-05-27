//
//  CCityOfficalDocModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityOfficalDocModel : NSObject

@property(nonatomic, strong) NSString* docTitle;
@property(nonatomic, strong) NSString* docNumber;
@property(nonatomic, strong) NSString* docDate;
@property(nonatomic, assign) BOOL      isRead;
@property(nonatomic, strong) NSString* messagetype; // 业务类型
@property(nonatomic, strong) NSString* surplusDays;
@property(nonatomic, strong) NSString* passPerson;
@property(nonatomic, strong) NSString* passOpinio;

@property(nonatomic, assign) CCityOfficalDocContentMode contentMode;
@property(nonatomic, assign) CCityOfficalMainStyle  mainStyle;
@property(nonatomic, strong)NSDictionary* docId;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end

 // 新建公文项目流程模型类
@interface CCityOfficalNewProjectModel : NSObject

@property(nonatomic, copy) NSString* projectName;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, strong) NSArray * detailDataArr;

@property(nonatomic, copy) NSString * proName;
@property(nonatomic, copy) NSString * proNum;
@property(nonatomic, assign) BOOL proChecked;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
