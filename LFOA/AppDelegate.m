//
//  AppDelegate.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define kGtAppId      @"dXlYzv8lhW55G5d9Adj2k8"
#define kGtAppKey     @"KZaxaMfA8r7Yuc9etEiZh9"
#define kGtAppSecret  @"8JElq1ypBk80B456vF93A3"

// mine test
// #define kGtAppId      @"HMk2Okd8eWAMFWlCtCabn9"
// #define kGtAppKey     @"byGlSbVrt96oUC38im7WJ6"
// #define kGtAppSecret  @"Ju9VsDXDAT7YEgEUX9vR41"

#import "AppDelegate.h"
#import "CCityRootViewController.h"
#import "CCityBaseNavController.h"
#import "CCityTabBarController.h"

#import "CCitySecurity.h"
#import "CCitySingleton.h"
#import "CCityJSONNetWorkManager.h"

#import "CCityMainMessageVC.h"
#import "CCityNoficManager.h"

#import <TSMessage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    
    NSMutableArray* _geTuiMessages;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [self setNavBar];
    
    if ([CCitySecurity isAutoLogin]) {
        
        if ([CCitySecurity getSession]) {   [self autoLogInWithNotfic:nil];   } else {
            CCityLogInVC* logInVC = [[CCityLogInVC alloc] init];
            self.window.rootViewController = logInVC;
        }
    } else {
        
        CCityLogInVC* logInVC = [[CCityLogInVC alloc] init];
        self.window.rootViewController = logInVC;
    }
    
    /*
     *
    //若由远程通知启动
    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
        if ([CCitySecurity isAutoLogin]) {

            if ([CCitySecurity getSession]) {   [self autoLogInWithNotfic:remoteNotification];   }
        } else {
            
            CCityLogInVC* logInVC = [[CCityLogInVC alloc] init];
            logInVC.notificDic = remoteNotification;
            self.window.rootViewController = logInVC;
        }

    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    [self registerRemoteNotfication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterGeTuiClientId) name:CCITY_SET_TOKEN_KEY object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if (![CCitySecurity IsShowNotific]) {
            [CCitySecurity setIsShowNotific:@"YES"];
        }
    });
    
    sleep(1.f);
    */
    
    return YES;
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    
    // check token
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    [manger POST:@"service/Login.ashx" parameters:@{@"token":[CCitySecurity getSession], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            [CCitySingleton sharedInstance].token = responseObject[@"tokenstr"];
            [CCitySecurity saveSessionWith:responseObject[@"tokenstr"]];
            
        } else {
            
            [CCitySingleton sharedInstance].isLogIn = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark- --- notfics

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    
    NSLog(@"register notfic failed : %@",error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (CCITY_DEBUG) {
        
        NSLog(@"\n>>>[DeviceToken Success]:%@\n\n",token);
    }
    
    [GeTuiSdk registerDeviceToken:token];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (CCITY_DEBUG) {
        
        NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    }
    
    if (application.applicationState == UIApplicationStateInactive) {
        
        [CCityNoficManager reciveNotific:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark- --- GeTui delegate

/** SDK收到透传消息回调 */
/*
-(void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    //收到个推消息
    NSString* payloadMsg = nil;
    
    if (payloadData) {
        
        payloadMsg = [[NSString alloc]initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    if (CCITY_DEBUG) {
        
        payloadMsg = [NSString stringWithFormat:@"个推透传：%@", payloadMsg];
        [TSMessage showNotificationWithTitle:payloadMsg type:(TSMessageNotificationTypeSuccess)];
        
        NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg :%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
        
        NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    }
}
*/

-(void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    //个推SDK已注册，返回clientId
    if (CCITY_DEBUG) {
        
        NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    }
    
    if ([CCitySingleton sharedInstance].isLogIn) {
        
        [self RegisterGeTuiClientId];
    }
}

#pragma mark- --- methods

//  RegisterGeTuiClientId

-(void)RegisterGeTuiClientId {
    
    if (![GeTuiSdk clientId]) { return; }

    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [manager GET:@"service/message/push/BindUserDevice.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token, @"clientId":[GeTuiSdk clientId], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (CCITY_DEBUG) {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

//  registerRemoteNotfication

-(void)registerRemoteNotfication {
    
    if(CCITY_SYSTEM_VERSION >= 10.0) {
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (!error) {
                NSLog(@"reuqest authorization succeeded");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings* seetings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:seetings];
    }
}

#pragma mark- ---   autoLogIn

- (void)autoLogInWithNotfic:(NSDictionary*)notificDic {
    
    [SVProgressHUD showWithStatus:@"登陆验证中..."];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
       
        dispatch_group_enter(group);
        
        [manager POST:@"service/Login.ashx" parameters:@{@"token":[CCitySecurity getSession], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
                [CCitySecurity saveSessionWith:responseObject[@"tokenstr"]];
                [CCitySingleton sharedInstance].token = responseObject[@"tokenstr"];
                [CCitySingleton sharedInstance].userName = [CCitySecurity userName];
                [CCitySingleton sharedInstance].deptname = responseObject[@"deptname"];
                [CCitySingleton sharedInstance].occupation = responseObject[@"occupation"];
                [CCitySingleton sharedInstance].organization = responseObject[@"organization"];
                
                if (![[CCitySecurity deptName] isEqualToString:responseObject[@"deptName"]]) {
                    
                    [CCitySecurity setDeptName:@"deptName"];
                }
                
                 [CCitySingleton sharedInstance].isLogIn = YES;
            }
            
            if (CCITY_DEBUG) {  NSLog(@"%@--%@", [CCitySecurity getSession],responseObject);    }
            
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            NSLog(@"%@",error.description);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if ([CCitySingleton sharedInstance].isLogIn) {
            
            CCityTabBarController* tabBarVC = [[CCityTabBarController alloc] init];
            tabBarVC.notificDic = notificDic;
            self.window.rootViewController = tabBarVC;
        } else {
            
            CCityLogInVC* logInVC = [CCityLogInVC new];
            logInVC.notificDic = notificDic;
            self.window.rootViewController = [CCityLogInVC new];
        }
    });
}

- (void)setNavBar {

    [UINavigationBar appearance].tintColor = CCITY_MAIN_COLOR;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
}

@end
