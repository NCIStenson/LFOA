//
//  CCityNotficModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityFileModel : CCityBaseModel

@property(nonatomic, strong)NSString* fileName;
@property(nonatomic, strong)NSString* fileSize;
@property(nonatomic, strong)NSString* fileUrl;
@property(nonatomic, strong)NSString* type;

@end

@interface CCityNewNotficPersonModel : CCityBaseModel

@property(nonatomic, strong)NSString* iconCls;
@property(nonatomic, strong)NSString* personId;
@property(nonatomic, strong)NSString* rowid;
@property(nonatomic, strong)NSString* type;
@property(nonatomic, strong)NSString* text;

@property(nonatomic, strong)NSString* pinyin;
@property(nonatomic, strong)NSString* firstLetter;

@property(nonatomic, strong)NSMutableArray* orgModelArr;  //  存放部门
@property(nonatomic, strong)NSMutableArray* personModelArr;  //  存放人员个人信息

@property(nonatomic, strong)NSMutableArray* personalModelFirstLetterArr; //  存放人员首字母
@property(nonatomic, strong)NSMutableArray* personalModelFormatArr;  // 存放格式化的人员数组


@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) BOOL isSelected;

@end


@interface CCityNewNotficDepartmentModel : CCityBaseModel

@property(nonatomic, strong)NSString* ID;
@property(nonatomic, strong)NSString* ORGANIZATIONNAME;

@end

@interface CCityNewNotficModel : CCityBaseModel

@property(nonatomic, strong)NSString* annexitemId;
@property(nonatomic, strong)NSArray* departments;
@property(nonatomic, strong)NSArray* organizationTree;

@end

@interface CCityNotficModel : CCityBaseModel<NSMutableCopying>

@property(nonatomic, assign)BOOL      isHaveFile;
@property(nonatomic, assign)BOOL      isHeightLevel;
@property(nonatomic, assign)BOOL      isRead;

@property(nonatomic, strong)NSString* messageId;
@property(nonatomic, strong)NSString* notficFromName;
@property(nonatomic, strong)NSString* notficPostTime;
@property(nonatomic, strong)NSString* notficTitle;
@property(nonatomic, strong)NSString* notficContent;

@property(nonatomic, strong)NSArray* files;

@end



