//
//  CCityImageTypeManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityImageTypeManager.h"

@implementation CCityImageTypeManager

+(NSString*)getImageNameWithType:(NSString*)fileType {
    
    NSString* imageName;
    
    if ([fileType containsString:@"doc"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_doc_50x50";
    } else if ([fileType containsString:@"txt"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_text_50x50";
    } else if ([fileType containsString:@"dwg"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_dwg_50x50";
    } else if ([fileType containsString:@"ppt"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_ppt_50x50";
    } else if ([fileType containsString:@"xls"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_xls_50x50";
    } else if ([fileType containsString:@"rar"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_rar_50x50";
    } else if ([fileType containsString:@"pdf"]) {
        
        imageName = @"ccity_Offical_detailList_fileType_pdf_50x50";
    }  else if ([fileType containsString:@"jpg"] || [fileType containsString:@"jpeg"] || [fileType containsString:@"png"]) {
        
        imageName = @"cc_pic_50x50";
    } else {
        
        imageName = @"ccity_Offical_detailList_fileType_general_50x50";
    }
    
    return imageName;
}

+(NSArray *)getMeetingImageNameWithType:(NSString *)type {
    
    NSString* imageName = @"";
    UIColor*  bgColor = CCITY_MAIN_COLOR;
    
    if ([type isEqualToString:@"规划业务"]) {
        
        bgColor = CCITY_RGB_COLOR(0, 217, 44, 1.f);
        imageName = @"ccity_sp_50x50_";
    } else if ([type isEqualToString:@"行政办公"]) {
        
         imageName = @"ccity_doc_package_50x50_";
    } else if ([type isEqualToString:@"传阅消息"]) {
        
        bgColor = CCITY_RGB_COLOR(255, 213, 0, 1.f);
        imageName = @"ccity_long_arrow_to_right_50x50_";
    } else if ([type isEqualToString:@"回退消息"]) {
        
        bgColor = CCITY_RGB_COLOR(255, 79, 71, 1.f);
        imageName = @"ccity_return_back_50x50_";
    } else if ([type isEqualToString:@"督办消息"]) {
        
        bgColor = CCITY_RGB_COLOR(0, 214, 179, 1.f);
        imageName = @"ccity_du_50x50_";
    } else if ([type isEqualToString:@"市县文消息"]) {
        
        bgColor = CCITY_RGB_COLOR(215, 57, 238, 1.f);
        imageName = @"ccity_double_arrow_50x50_";
    } else if ([type isEqualToString:@"会议消息"]) {
        
        bgColor = CCITY_RGB_COLOR(18, 138, 255, 1.f);
        imageName = @"ccity_meeting_50x50_";
    } else if ([type isEqualToString:@"收文时限提醒"]) {
        
        bgColor = CCITY_RGB_COLOR(255, 140, 118, 1.f);
        imageName = @"ccity_height_level_doc_50x50_";
    } else if ([type isEqualToString:@"系统消息"]) {
        
        bgColor = CCITY_RGB_COLOR(0, 217, 44, 1.f);
        imageName = @"ccity_Offical_detailList_fileType_system_40x40";
    }

    return @[bgColor, imageName];
}

@end
