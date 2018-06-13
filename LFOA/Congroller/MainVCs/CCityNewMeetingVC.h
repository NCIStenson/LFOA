//
//  CCityNewMeetingVC.h
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewVC.h"

typedef void(^successPublishMeetingBlock)(void);

@interface CCityNewMeetingVC : CCityBaseTableViewVC

@property (nonatomic,copy) successPublishMeetingBlock successPublishNoti;

@end
