//
//  CCityNoficManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/10/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNoficManager.h"
#import "CCityMainMessageVC.h"
#import "CCityNotficVC.h"
#import "CCityBaseNavController.h"
#import <TSMessage.h>

@implementation CCityNoficManager

+(void)reciveNotific:(NSDictionary*)dataDic {
    
    if (!dataDic) {  return; }
    
    if (CCITY_DEBUG) {
        
       NSData* data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [TSMessage showNotificationWithTitle:str type:TSMessageNotificationTypeWarning];
    }
    
    UIViewController* targetVC;

    NSDictionary* apns  = dataDic[@"aps"];
    NSDictionary* alert = apns[@"alert"];
    NSString* title     = alert[@"title"];
    
    UIViewController* currentVC = [[CCitySingleton sharedInstance] getCurrentVisibleVC];
    
    if ([currentVC isKindOfClass:[CCityLogInVC class]]) {
        
        CCityLogInVC* logInVC = (CCityLogInVC*)currentVC;
        logInVC.notificDic = dataDic;
        return;
    }
    
    if ([title containsString:@"通知公告"]) {
        
        if ([currentVC isKindOfClass:[CCityNotficVC class]]) {  return; }
        
        targetVC = [[CCityNotficVC alloc]init];
    } else {
        
        if ([currentVC isKindOfClass:[CCityMainMessageVC class]]) { return; }
        targetVC = [[CCityMainMessageVC alloc]init];
    }
    
    targetVC.hidesBottomBarWhenPushed = YES;
    
    if ([currentVC isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabbarVC = (UITabBarController*)currentVC;
        currentVC = tabbarVC.selectedViewController;
    }
    
    if (![currentVC isKindOfClass:[CCityBaseNavController class]]) {
        
        while (!currentVC.navigationController) {
            
            [currentVC dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([currentVC isKindOfClass:[CCityBaseNavController class]]) {
            
            CCityBaseNavController* baseNav = (CCityBaseNavController*)currentVC;
            [baseNav pushViewController:targetVC animated:NO];
        } else {
            
            [currentVC.navigationController pushViewController:targetVC animated:YES];
        }
    });
}

+ (BOOL) checkNotficService {
    
    if ([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone) {
        
        return NO;
    }
    
    return YES;
}

@end
