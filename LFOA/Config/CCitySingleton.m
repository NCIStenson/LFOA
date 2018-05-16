//
//  CCitySingleton.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCitySingleton.h"
#import "CCityNoficManager.h"
#import "CCitySecurity.h"
#import <GTSDK/GeTuiSdk.h>

@implementation CCitySingleton

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isLogIn = NO;
    }
    return self;
}

-(void)setIsLogIn:(BOOL)isLogIn {
    _isLogIn = isLogIn;

    if (_isLogIn) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CCITY_LOG_SUCCESS_NOTIFIC_KEY object:nil];
        });
        
        [GeTuiSdk setPushModeForOff:NO];
    }
}

-(void)setToken:(NSString *)token {
    _token = token;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CCITY_SET_TOKEN_KEY object:nil];
    });
}

- (void)showLogInVCWithPresentedVC:(UIViewController*)currentVC {
    
    CCityLogInVC* logInVC = [[CCityLogInVC alloc]init];
    
    if (!currentVC) {
        
        currentVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    
    if ([currentVC isKindOfClass:[CCityLogInVC class]]) {
        return;
    }
    
    [[self getVisibleViewControllerFrom:currentVC] presentViewController:logInVC animated:YES completion:nil];
}

-(UIViewController*)getCurrentVisibleVC {
    
    UIViewController* currentVisibleVC = [[[UIApplication sharedApplication]keyWindow] rootViewController];
    
    while (currentVisibleVC.presentedViewController) {
        currentVisibleVC = [self getVisibleViewControllerFrom:currentVisibleVC];
    }
    return currentVisibleVC;
}

- (UIViewController*)getVisibleViewControllerFrom:(UIViewController*)vc {
    
    if (!vc) {
        
        vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        
        if (vc.presentedViewController) {
            
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            
            return vc;
        }
    }
    
    return vc;
}

@end
