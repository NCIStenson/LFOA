//
//  CCityUserCenterVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_USERCRNTER_BGCOLOR CCITY_RGB_COLOR(244, 245, 250, 1)
#define CCITY_USERCRNTER_PADDING 3.f;

#import "CCityUserCenterVC.h"
#import "CCityUserCenterCell.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityUserInfoVC.h"
#import "CCityAboutAppVC.h"

#import "CCitySecurity.h"
#import "CCitySingleton.h"
#import "CCityChangePassWorldVC.h"
#import "CCityCommonWordsVC.h"
#import "CCityUserReportVC.h"
#import <GTSDK/GeTuiSdk.h>

@interface CCityUserCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CCityUserCenterVC {
    
    UITableView* _tableView;
    UILabel*     _nameLabel;
    UILabel* _positionlabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self upDatas];
}

#pragma mark- --- layoutSubViews 

-(void)layoutMySubViews {
    
    _tableView = [[UITableView alloc]init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [[UIView alloc]init];
    _tableView.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame = CGRectMake(0, 3.f, tableViewFrame.size.width, tableViewFrame.size.height - 3.f - 50.f - 64 - 50.f);
    _tableView.frame = tableViewFrame;
    
    UIControl* tableHeaderView = [self tableHeaderView];
    [tableHeaderView addTarget:self action:@selector(headViewAction) forControlEvents:UIControlEventTouchUpInside];
    tableHeaderView.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 80.f);
    
    _tableView.tableHeaderView =tableHeaderView;
    
    UIView* logoutView = [self logoutView];
    
    [self.view addSubview:logoutView];
    [self.view addSubview:_tableView];
    
    [logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_tableView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50.f);
    }];
}

- (UIView*)logoutView {
    
    UIView* logoutView = [UIView new];
    
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutBtn setTitle:@"退   出" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    logoutBtn.layer.cornerRadius = 5.f;
    logoutBtn.clipsToBounds = YES;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setBackgroundColor:CCITY_MAIN_COLOR];
    
    [logoutView addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(logoutView).with.offset(5.f);
        make.left.equalTo(logoutView).with.offset(10.f);
        make.bottom.equalTo(logoutView).with.offset(-5.f);
        make.right.equalTo(logoutView).with.offset(-10.f);
    }];
    
    return logoutView;
}

// header View
-(UIControl*)tableHeaderView {
    
    UIControl* headerView = [UIControl new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"ccity_uesrcenter_userHeader"] forState:UIControlStateNormal];
    headerBtn.layer.cornerRadius = 25.f;
    
    headerBtn.clipsToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
//    _nameLabel.font = [UIFont systemFontOfSize:15.f];
    _nameLabel.textColor = CCITY_MAIN_FONT_COLOR;
    
    if ([CCitySingleton sharedInstance].userName) {
        
        _nameLabel.text = [CCitySingleton sharedInstance].userName;
    } else {
        
        _nameLabel.text = @"姓名";
    }
    
    _positionlabel = [UILabel new];
    _positionlabel.textColor = [UIColor grayColor];
    _positionlabel.font = [UIFont systemFontOfSize:15.f];
    _positionlabel.text = @"职位";
    
    UIImageView* cerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_userCenter_cer_44x44_"]];
    [headerView addSubview:headerBtn];
    [headerView addSubview:_nameLabel];
    [headerView addSubview:_positionlabel];
    [headerView addSubview:cerImageView];
    
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(15.f);
        make.left.equalTo(headerView).with.offset(20.f);
        make.bottom.equalTo(headerView).with.offset(-15.f);
        make.width.equalTo(headerBtn.mas_height);
    }];
    
    [cerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(20.f);
        make.right.equalTo(headerView).with.offset(-31.f);
        make.height.mas_equalTo(25.f);
        make.width.mas_equalTo(25.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(20.f);
        make.left.equalTo(headerBtn.mas_right).with.offset(5.f);
        make.right.equalTo(cerImageView).with.offset(-5.f);
        make.height.equalTo(_positionlabel);
    }];
    
    [_positionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(headerView).with.offset(-20.f);
        make.left.equalTo(_nameLabel);
        make.right.equalTo(_nameLabel);
        make.height.equalTo(_nameLabel);
    }];
    
    return headerView;
}

#pragma mark- --- methods

-(void)headViewAction {
    
    CCityUserInfoVC* userInfo = [[CCityUserInfoVC alloc]init];
    userInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void)upDatas {
    
    if (![_nameLabel.text isEqualToString:[CCitySingleton sharedInstance].userName]) {
        
        _nameLabel.text = [CCitySingleton sharedInstance].userName;
    }
    
    if (![_positionlabel.text isEqualToString: [CCitySingleton sharedInstance].deptname]) {
        
        _positionlabel.text = [CCitySingleton sharedInstance].deptname;
    }
}

- (void)logOut {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [GeTuiSdk clearAllNotificationForNotificationBar];
    
    
    [GeTuiSdk setPushModeForOff:YES];
    
    [manager POST:@"service/Logout.ashx" parameters:@{@"token":[CCitySecurity getSession]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--登出-成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"--登出-请求失败：%@", error.description);
    }];
    
    [CCitySecurity saveSessionWith:@"logout"];
    [CCitySingleton sharedInstance].isLogIn = NO;
    [[CCitySingleton sharedInstance] showLogInVCWithPresentedVC:self];
}

-(void)changePassWord {
    
    CCityChangePassWorldVC* changePassWorldVC = [[CCityChangePassWorldVC alloc]init];
    changePassWorldVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePassWorldVC animated:YES];
}

-(void)commonWord {
    
    CCityCommonWordsVC* commonWordsVC = [[CCityCommonWordsVC alloc]init];
    commonWordsVC.enterType = ENTER_COMMONWORDS_TYPE_USERCENTER;
    commonWordsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commonWordsVC animated:YES];
}

-(void)userReport {
    
    CCityUserReportVC* userReportVC = [CCityUserReportVC new];
    userReportVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userReportVC animated:YES];
}

// 关于
-(void)aboutApp {
    
    CCityAboutAppVC* aboutVC = [CCityAboutAppVC new];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

-(UITableViewCell*)getPlaceHolderCell:(UITableViewCell*)cell {
    
    cell.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0.f, 0, 0);
    return cell;
}

-(UITableViewCell*)setCellWithTitle:(NSString*)title imageName:(NSString*)imageName cell:(UITableViewCell*)cell isLast:(BOOL)isLast{
    
    if (isLast) {
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        
        cell.separatorInset = UIEdgeInsetsMake(0, 18.f, 0, 0);
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = title;
    return cell;
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 5.f;
            break;
        case 4:
            return 40.f;
            break;
        default:
            return 44.f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

        switch (indexPath.row) {
                
            case 0:
            case 4:
                [self getPlaceHolderCell:cell];
                break;
                
            case 1:
                
                [self setCellWithTitle: @"修改密码" imageName:@"ccity_userCenter_lock" cell:cell isLast:NO];
                break;
            case 2:
                
                [self setCellWithTitle: @"常用语" imageName:@"icon_user_commonText" cell:cell isLast:NO];
                break;
            case 3:
                
                [self setCellWithTitle:@"用户反馈" imageName:@"ccity_userCenter_setting_50x50_" cell:cell isLast:YES];
                break;
            case 5:
                
                [self setCellWithTitle:@"关于" imageName:@"ccity_user_icon_25x25" cell:cell isLast:YES];
                break;
            default:
                break;
        }

    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 1:         // 修改密码
            
            [self changePassWord];
            break;
        case 2:         // 常用语
            
            [self commonWord];
            break;
            
        case 3:         // 用户反馈
            
            [self userReport];
            break;

       
        case 5:
            
            [self aboutApp];
            break;
        default:
            break;
    }
}

@end
