//
//  CCityAboutAppVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/11/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_PHONE_NUM @"18932604044"

#import "CCityAboutAppVC.h"
#import "CCLeftBarBtnItem.h"
#import "CCityAppInfo.h"
#import <TTTAttributedLabel.h>

@interface CCityAboutAppVC ()<TTTAttributedLabelDelegate>

@end

@implementation CCityAboutAppVC {
    
    BOOL  _isBackTouch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isBackTouch = YES;
    CCLeftBarBtnItem* leftBarBtn = [CCLeftBarBtnItem new];
    leftBarBtn.arrow.backgroundColor = CCITY_MAIN_COLOR;
    leftBarBtn.label.text = @"我的";
    leftBarBtn.label.textColor = [UIColor whiteColor];
    leftBarBtn.action = ^{
       
        [self backAction];
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    self.title = @"关于";
    
    [self layoutSubView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = CCITY_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self changeNarBar];
}

#pragma mark- --- layout subviews

-(void)layoutSubView {
    
    UIImageView* logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.jpg"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel* appVersionLabel = [UILabel new];
    appVersionLabel.text = [NSString stringWithFormat:@"版本号：%@", [[CCityAppInfo alloc]init].appVersion];
    appVersionLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString* fontName = appVersionLabel.font.fontName;
    CGFloat fontSize = 16.f;
    
    appVersionLabel.font = [UIFont fontWithName:fontName size:fontSize];
    
    TTTAttributedLabel* contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20.f, MAXFLOAT)];
    contentLabel.numberOfLines = 0.f;
    contentLabel.font = [UIFont fontWithName:fontName size:fontSize];
    contentLabel.text = [NSString stringWithFormat:@"查询更多信息，可以登陆《廊坊市县一体化管理服务平台》，请登陆\n 6.66.46.27/lfcxgh \n廊坊市空间资源数字化信息管理中心提供技术支持 电话：%@",CCITY_PHONE_NUM];
    NSRange phoneNumRange = [contentLabel.text rangeOfString:CCITY_PHONE_NUM];
    [contentLabel addLinkToPhoneNumber:CCITY_PHONE_NUM withRange:phoneNumRange];
    [contentLabel sizeToFit];
    contentLabel.delegate = self;

    [self.view addSubview:logoImageView];
    [self.view addSubview:appVersionLabel];
    [self.view addSubview:contentLabel];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).with.offset(20.f);
        make.size.mas_equalTo(CGSizeMake(100.f, 100.f));
        make.centerX.equalTo(self.view);
    }];
    
    [appVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(logoImageView.mas_bottom).with.offset(20.f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(20.f);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(appVersionLabel.mas_bottom).with.offset(40.f);
        make.left.equalTo(self.view).with.offset(10.f);
        make.right.equalTo(self.view).with.offset(-10.f);
        make.height.mas_equalTo(contentLabel.bounds.size.height);
    }];
}

#pragma mark- --- methods

-(void)backAction {
    
    [self changeNarBar];
    _isBackTouch = NO;
}

- (void)changeNarBar {
    
    if (_isBackTouch) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = CCITY_MAIN_COLOR;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    }
}

#pragma mark- --- ttlabel delegate

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    
    NSString* urlStr = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    NSURL* phoneUrl = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    
//    UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:phoneNumber message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction* OkAction = [UIAlertAction actionWithTitle:@"拨打" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//        NSString* urlStr = [NSString stringWithFormat:@"tel://%@",phoneNumber];
//        NSURL* phoneUrl = [NSURL URLWithString:urlStr];
//        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//            [[UIApplication sharedApplication] openURL:phoneUrl];
//        }
//
//    }];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//
//    [alertCon addAction:OkAction];
//    [alertCon addAction:cancelAction];
//
//    [self presentViewController:alertCon animated:YES completion:nil];
}

@end
