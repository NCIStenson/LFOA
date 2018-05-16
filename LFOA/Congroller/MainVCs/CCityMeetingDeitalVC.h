//
//  CCityMeetingDeitalVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"
#import "CCityMainMeetingListModel.h"

@interface CCityMeetingDeitalVC : CCityBaseViewController

- (instancetype)initWithModel:(CCityMainMeetingListModel*)model;

- (instancetype)initWithUrl:(NSString*)url parameters:(NSMutableDictionary*)parameters;
@end
