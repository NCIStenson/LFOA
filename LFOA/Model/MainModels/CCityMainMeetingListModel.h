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
