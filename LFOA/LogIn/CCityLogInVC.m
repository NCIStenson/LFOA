//
//  CCityLogInVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define OUTSIDE_PADDING  40.f
#define INSIDE_PADDING   10.f


#import "CCityLogInVC.h"

#import "CCityLogInTF.h"
#import "CCityLogInCheckBoxBtn.h"
#import "CCitySingleton.h"

#import "CCitySecurity.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityAlterManager.h"
#import "CCityTabBarController.h"

#import <TSMessage.h>

@interface CCityLogInVC ()<UITextFieldDelegate>

@end

@implementation CCityLogInVC {
    
    CCityLogInTF* _userNameTF;
    CCityLogInTF* _passWord;
    NSString*     _isAutoLogIn;
    UIView* _mainContainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addKeyboardNontfication];
    
    UIView*   logo     = [self logo];
    UIButton* logInBtn = [self logInBtn];

    UIImageView* bgView = [self bgImageView];
    _mainContainView = [self mainContentView];
    
    UIView* contetnView = [UIView new];

    [self.view addSubview:bgView];
    [self.view addSubview:contetnView];
    
    [contetnView addSubview:logo];
    [contetnView addSubview:logInBtn];
    [contetnView addSubview:_mainContainView];
    
    [contetnView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(500.f);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(contetnView);
        make.top.equalTo(contetnView).with.offset(50.f);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               
        if ([UIScreen mainScreen].bounds.size.height >= 736) {
            
            make.top.equalTo(_mainContainView.mas_bottom).with.offset(40.f);
        } else {
            
            make.top.equalTo(_mainContainView.mas_bottom).with.offset(20.f);
        }
        make.left.equalTo(_mainContainView);
        make.right.equalTo(_mainContainView);
        make.height.equalTo(@40.f);
    }];
    
    [_mainContainView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(logo.mas_bottom).with.offset(20.f);
        make.left.equalTo(contetnView).with.offset(40.f);
        make.right.equalTo(contetnView).with.offset(-40.f);
        make.height.mas_equalTo(150.f);
    }];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

#pragma mark- ---  layout subviews
// bgView
-(UIImageView*)bgImageView {
    
    UIImageView * bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_login.jpg"]];
    bgView.backgroundColor = CCITY_MAIN_BGCOLOR;
    return bgView;
}

// content view
-(UIView*)mainContentView {
    
    UIView* contentView = [UIView new];
    contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.8f];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 5.f;
    _userNameTF = [self uerNameTF];
    _passWord   = [self passWordTF];
    
    CCityLogInCheckBoxBtn* remreberPwdBtn = [self rememberPassWordBtn];
    CCityLogInCheckBoxBtn* autoLogInBtn   = [self autoLogInBtn];
    
    [contentView addSubview:_userNameTF];
    [contentView addSubview:_passWord];
    [contentView addSubview:remreberPwdBtn];
    [contentView addSubview:autoLogInBtn];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(contentView).with.offset(10.f);
        make.left.equalTo(contentView).with.offset(INSIDE_PADDING);
        make.right.equalTo(contentView).with.offset(-INSIDE_PADDING);
        make.height.mas_equalTo(40.f);
    }];
    
    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTF.mas_bottom).with.offset(5.f);
        make.left.equalTo(_userNameTF);
        make.right.equalTo(_userNameTF);
        make.height.equalTo(_userNameTF);
    }];
    
    [remreberPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_passWord).with.offset(20.f);
        make.bottom.equalTo(contentView).with.offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 30.f));
    }];
    
    [autoLogInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_passWord).with.offset(-20.f);
        make.bottom.equalTo(remreberPwdBtn);
        make.size.mas_equalTo(CGSizeMake(80.f, 30.f));
    }];
    
    return contentView;
}

// logo
- (UIView*)logo {
    
    UIView* logo = [UIView new];
    
    UIImageView* logImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_login_logo_347x347"]];
    
    [logo addSubview:logImage];
    
    [logImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(logo);
        make.left.equalTo(logo);
        make.bottom.equalTo(logo);
        make.right.equalTo(logo);
    }];
    
    return logo;
}

// uerName TF
-(CCityLogInTF*)uerNameTF {
    
    CCityLogInTF* userNameTF = [[CCityLogInTF alloc]init];
    userNameTF.placeholder = @"用户名";
    
    if ([CCitySecurity userName]) {
            
        userNameTF.text =[CCitySecurity userName];
    }
    
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_login_userName_50x50_"]];

    [leftView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(leftView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    userNameTF.leftView =leftView;
    userNameTF.tag = 201;
    userNameTF.delegate = self;
    userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    return userNameTF;
}

// passWord TF
- (CCityLogInTF*)passWordTF {
    
    CCityLogInTF* passWord = [[CCityLogInTF alloc]init];
    
    passWord.placeholder = @"密码";
    
    if ([CCitySecurity isRememberPassWord]) {
        
        if ([CCitySecurity passWord]) { passWord.text = [CCitySecurity passWord];   }
    }
    
    passWord.secureTextEntry = YES;
    passWord.tag = 202;
    passWord.delegate = self;
    
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_login_passsWord_50x50_"]];
    
    [leftView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(leftView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    passWord.leftView = leftView;
    passWord.tag = 201;
    passWord.leftViewMode = UITextFieldViewModeAlways;
    
    return passWord;
}

// remember PassWord Btn
-(CCityLogInCheckBoxBtn*)rememberPassWordBtn {
    
    CCityLogInCheckBoxBtn* remberPwdBtn = [CCityLogInCheckBoxBtn buttonWithType:UIButtonTypeCustom];

    [remberPwdBtn addTarget:self action:@selector(rememberPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    
    remberPwdBtn.selectedValue = [CCitySecurity isRememberPassWord];
    [self setCheckBoxBtnStateWith:remberPwdBtn];
    
    [remberPwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    return remberPwdBtn;
}

// auto LogIn Btn
-(CCityLogInCheckBoxBtn*)autoLogInBtn {
    
    CCityLogInCheckBoxBtn* autoLogInBtn = [CCityLogInCheckBoxBtn buttonWithType:UIButtonTypeCustom];
    [autoLogInBtn addTarget:self action:@selector(autoLogInAction:) forControlEvents:UIControlEventTouchUpInside];
    autoLogInBtn.selectedValue = [CCitySecurity isAutoLogin];
    
    if (autoLogInBtn.selectedValue) {    _isAutoLogIn = @"true";  }
    else                            {    _isAutoLogIn = @"false"; }
    
    [self setCheckBoxBtnStateWith:autoLogInBtn];
    
    [autoLogInBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    return autoLogInBtn;
}

// logIn Btn
- (UIButton*)logInBtn {
    
    UIButton* logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logInBtn addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    [logInBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.7f]forState:UIControlStateNormal];
    logInBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f].CGColor;
    logInBtn.layer.borderWidth = 1.f;
    [logInBtn setTitle:@"登   录" forState:UIControlStateNormal];
    
    logInBtn.layer.cornerRadius = 5.f;
    logInBtn.clipsToBounds = YES;
    return logInBtn;
}

#pragma mark- --- methods

// keyboard notfication
- (void) addKeyboardNontfication {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardFrameChage:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// keyboard frame change
- (void)keyBoardFrameChage:(NSNotification*)notfic {
    
    NSDictionary* userInfo = [notfic userInfo];
    
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat bottom;
    
    if (_userNameTF.isFirstResponder) {
        bottom = _userNameTF.frame.origin.y + _userNameTF.frame.size.height;
    } else {
        bottom = _passWord.frame.origin.y + _passWord.frame.size.height;
    }
    
    bottom += _mainContainView.frame.origin.y;
    
    if (bottom <= keyboardFrame.origin.y) {
        
        return;
    }
    
    BOOL isHidden = keyboardFrame.origin.y == self.view.bounds.size.height;
    CGRect showFrame = self.view.frame;
    
    if (isHidden) {
        
        showFrame.origin.y = 0;
    } else {
        
        showFrame.origin.y = -(bottom - keyboardFrame.origin.y);
    }
    
    [UIView animateWithDuration:.3f animations:^{
       
        self.view.frame = showFrame;
    }];
    
}

// key board did hidden
- (void) keyboardWillHidden:(NSNotification*)notfic {
    
    if (self.view.frame.origin.y != 0) {
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.view.frame = viewFrame;
        }];
    }
}

//remember pwd
- (void)rememberPwdAction:(CCityLogInCheckBoxBtn*)btn {
    
    btn.selectedValue = !btn.selectedValue;
    
    [CCitySecurity isRememberPassWord:btn.selectedValue];
    [self setCheckBoxBtnStateWith:btn];
}

// auto login
- (void)autoLogInAction:(CCityLogInCheckBoxBtn*)btn {
    
    btn.selectedValue = !btn.selectedValue;
    
    if (btn.selectedValue) {    _isAutoLogIn = @"true";  }
    else                   {    _isAutoLogIn = @"false"; }
    
    [self setCheckBoxBtnStateWith:btn];

    [CCitySecurity setAutoLogIn:btn.selectedValue];
}

// change checkbox ui
- (void)setCheckBoxBtnStateWith:(CCityLogInCheckBoxBtn*)btn {
    
    if (btn.selectedValue) {
        
        [btn setImage:[UIImage imageNamed:@"ccity_login_selected_15x15"] forState:UIControlStateNormal];
    } else {
        
        [btn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    }
}

// log in
- (void)logInAction {
    
    [SVProgressHUD show];
    
    if (![self checkValues]) {
        
        [SVProgressHUD dismiss];
//         或 密码
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"用户名 不能为空！" detail:nil];
        return;
    }
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parameters = @{@"username"  : _userNameTF.text,
                                 @"password"  : _passWord.text,
                                 @"rememberMe": _isAutoLogIn,
                                 @"iOS"       : @"true",
                                 };
        
    [manager POST:@"service/Login.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObject);
  
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            if (responseObject[@"tokenstr"] == [NSNull null]) {

                [TSMessage showNotificationInViewController:self title:@"凭据获取失败，请联系管理员" subtitle:nil type:TSMessageNotificationTypeError];
                return;
            }
            
            [self logInSuccessWith:responseObject];
            
        } else {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"用户名或者密码错误" detail:nil];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error.description);
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"请求失败" detail:error.localizedDescription];
    }];
}

// checkValues
- (BOOL)checkValues {
    
//    ||!_passWord.text.length
    if (!_userNameTF.text.length) {   return NO;  }
    
    return YES;
}

- (void) hidenKeyboard {
    
    if (_userNameTF.isFirstResponder) { [_userNameTF resignFirstResponder]; }
    
    if (_passWord.isFirstResponder)   {   [_passWord resignFirstResponder];   }
}

-(void)logInSuccessWith:(NSDictionary*)response {
   
    if (![[CCitySecurity passWord] isEqual:_passWord.text]) {
        
        [CCitySecurity setPassWord:_passWord.text];
    }
    
    if (![[CCitySecurity userName] isEqual:_userNameTF.text]) {
        
        [CCitySecurity setUserName:_userNameTF.text];
    }
    
    if (![[CCitySecurity deptName] isEqualToString:response[@"deptname"]]) {
        
        [CCitySecurity setDeptName:response[@"deptname"]];
    }
    
    [CCitySingleton sharedInstance].token    = response[@"tokenstr"];
    [CCitySingleton sharedInstance].deptname = response[@"deptname"];
    [CCitySingleton sharedInstance].userName = _userNameTF.text;
    [CCitySingleton sharedInstance].occupation = response[@"occupation"];
    [CCitySingleton sharedInstance].organization = response[@"organization"];
    
    if (_isAutoLogIn) { [CCitySecurity saveSessionWith:response[@"tokenstr"]];  }
    
    [CCitySingleton sharedInstance].isLogIn  = YES;

    // login success
    if (self.logInSuccess) { self.logInSuccess(); }
    
    if ([[UIApplication sharedApplication] keyWindow].rootViewController == self) {
        
        CCityTabBarController* tabBarViewController = [[CCityTabBarController alloc]init];
        tabBarViewController.notificDic = _notificDic;
        [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarViewController;
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark- --- touches
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hidenKeyboard];
}

#pragma mark- --- UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_userNameTF.isFirstResponder) { [_passWord becomeFirstResponder];   }
    
    else {  [_passWord resignFirstResponder];   }
    
    return YES;
}

@end
