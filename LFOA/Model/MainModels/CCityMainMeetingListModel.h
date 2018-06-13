//
//  CCityMainMeetingListModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityMainMeetingListModel : CCityBaseModel

@property(nonatomic, strong)NSString* annexitemId;
@property(nonatomic, strong)NSString* meetingTitle;
@property(nonatomic, strong)NSString* meetingNum;
@property(nonatomic, strong)NSString* meetingTime;
@property(nonatomic, strong)NSString* meetingPlace;
@property(nonatomic, strong)NSString* meetingType;
@property(nonatomic, strong)NSString* meetingMembers;
@property(nonatomic, strong)NSString* meetingSponsor;
@property(nonatomic, strong)NSString* sponsoredUnit;
@property(nonatomic, strong)NSString* meetingRecorder;
@property(nonatomic, strong)NSString* meetingCJYR;
@property(nonatomic, strong)NSString* meetingChecker;
@property(nonatomic, strong)NSString* compere;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, assign)BOOL isRead;


@property(nonatomic, strong)NSArray*  accessoryFiles;
@property(nonatomic, assign)BOOL      hasFile;
@end

@interface CCityNewMeetingPersonModel : CCityBaseModel

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


@interface CCityNewMeetingDepartmentModel : CCityBaseModel

@property(nonatomic, strong)NSString* ID;
@property(nonatomic, strong)NSString* ORGANIZATIONNAME;

@end


@interface CCityNewMeetingTypeModel : CCityBaseModel

@property(nonatomic, strong)NSString* ID;
@property(nonatomic, strong)NSString* HYNAME;

@end

@interface CCityNewMeetingModel : CCityBaseModel

@property(nonatomic, strong)NSString* annexitemId;
@property(nonatomic, strong)NSArray* departments;
@property(nonatomic, strong)NSArray* meetingTypes;
@property(nonatomic, strong)NSArray* organizationTree;

@end

