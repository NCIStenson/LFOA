//
//  CCityBaseViewController.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"
#import "CCitySingleton.h"

@interface CCityBaseViewController ()

@end

@implementation CCityBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = CCITY_MAIN_BGCOLOR;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([CCitySingleton sharedInstance].isLogIn == NO) {
        
        [[CCitySingleton sharedInstance]showLogInVCWithPresentedVC:self];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([SVProgressHUD isVisible]) {    [SVProgressHUD dismiss];    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
