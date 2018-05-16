//
//  CCityOfficalFileViewerVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalFileViewerVC.h"
#import "CCLeftBarBtnItem.h"

@interface CCityOfficalFileViewerVC ()

@end

@implementation CCityOfficalFileViewerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCLeftBarBtnItem* backCon = [CCLeftBarBtnItem new];
    backCon.action = ^{
        [self backAction];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
}

#pragma mark- --- methods
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
