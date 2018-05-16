//
//  CCityTabBarController.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityTabBarController.h"
#import "CCitySingleton.h"
#import "CCityBaseNavController.h"

#import "CCityHomeVC.h"
#import "CCityApproveVC.h"
#import "CCityMoreVC.h"
#import "CCityUserCenterVC.h"
#import "CCityOfficalDocVC.h"

#import "CCitySecurity.h"

#import "CCityHomeVC.h"
#import "CCityMainMessageVC.h"

#import "CCityNoficManager.h"

@interface CCityTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CCityTabBarController {
    
    CCityHomeVC* _home;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = CCITY_MAIN_COLOR;
    self.viewControllers = [self tabBarViewControlls];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_notificDic) {
        
        [CCityNoficManager reciveNotific:_notificDic];
        _notificDic = nil;
    }
}

- (NSArray*)tabBarViewControlls {
    
    _home = [[CCityHomeVC alloc]init];
    _home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"ccity_root_home_30x30_"] tag:100];
    
    CCityOfficalDocVC* approvc = [[CCityOfficalDocVC alloc]initWithItmes:@[@"待办箱",@"已办箱",@"收阅箱"]];
    approvc.mainStyle = CCityOfficalMainSPStyle;
    approvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"审批" image:[UIImage imageNamed:@"ccity_root_approal_30x30_"] tag:101];
    approvc.title = @"审批";
    
//    CCityMoreVC* more = [[CCityMoreVC alloc]init];
//    more.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"ccity_root_more_40x40_"] tag:102];
    
    CCityUserCenterVC* userCenter = [[CCityUserCenterVC alloc]init];
    userCenter.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"ccity_root_userCenter_30x30_"] tag:103];
    userCenter.title = @"我的";
    
    CCityOfficalDocVC* officalDoc = [[CCityOfficalDocVC alloc]initWithItmes:@[@"待办箱",@"已办箱",@"收阅箱"]];
    officalDoc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"公文" image:[UIImage imageNamed:@"ccity_root_officalDoc_30x30_"] tag:104];
    officalDoc.title = @"公文";
    officalDoc.mainStyle = CCityOfficalMainDocStyle;
    self.delegate = self;
    NSArray* vcArr = @[_home, officalDoc, approvc ,userCenter];
    
    NSMutableArray* navArr = [NSMutableArray arrayWithCapacity:vcArr.count];
    
    for (int i = 0; i < vcArr.count; i++) {
        
            CCityBaseNavController* baseNav = [[CCityBaseNavController alloc]initWithRootViewController:vcArr[i]];
            [navArr addObject:baseNav];
    }
    
    return navArr;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.tabBarItem.tag != 100) {
        
        if (_home.hiddenNavBarAnimate) {
            _home.hiddenNavBarAnimate = NO;
        }
    }
    return YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations  {
    
   return UIInterfaceOrientationMaskPortrait;
}

@end
