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
