//
//  CCityChangePassWorldVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/26.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityChangePassWorldVC.h"
#import "CCityBaseTableViewCell.h"

@interface CCityChangePassWorldVC ()<UITextFieldDelegate>

@end

@implementation CCityChangePassWorldVC {
    
    NSString* _oldPwd;
    NSString* _newPwd;
    NSString* _checkNewPwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    self.title = @"修改密码";
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark- --- layout subviews

-(UIView*)tableHeaderView {
    
    UIView* tableHeaderView = [UIView new];
    tableHeaderView.backgroundColor = CCITY_MAIN_BGCOLOR;
    tableHeaderView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 10.f);
    return tableHeaderView;
}

-(void)configCommitCellWithCell:(CCityBaseTableViewCell*)cell {
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = CCITY_MAIN_COLOR;
    btn.layer.cornerRadius = 5.f;
    [btn setTintColor:[UIColor whiteColor]];
    [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"修 改" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]}] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changPwdAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(20, 10, 20, 10));
    }];
}

#pragma mark- --- methods

- (void)changPwdAction {
    
     [self.view endEditing:YES];
    
    if (!_newPwd) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"新密码为空" detail:nil];
        return;
    }
    
    if (![_newPwd isEqualToString:_checkNewPwd]) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"两次密码输入不一致" detail:nil];
        return;
    }
    
    if ([_oldPwd isEqualToString:_newPwd]) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"新密码与旧密码一致" detail:nil];
        return;
    }
    
    if (!_oldPwd) {
        _oldPwd = @"";
    }
    
    [SVProgressHUD show];
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSDictionary* parameters = @{
                                 @"token":[CCitySingleton sharedInstance].token,
                                 @"oldPassword":_oldPwd,
                                 @"newPassword":_newPwd,
                                 };
    [manager POST:@"service/user/ModifyPassword.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];

        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        
        if ([errorNoManager requestSuccess:responseObject]) {
              [[UIApplication sharedApplication]keyWindow].rootViewController = [[CCityLogInVC alloc]init];
            
        } else {
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self changPwdAction];
            }];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        return 84.f;
    }
    
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    CCityBaseTableViewCell* cell = [CCityBaseTableViewCell new];
    
    UILabel* titleLabel = [UILabel new];
//    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    UITextField* inputTF = [UITextField new];
    inputTF.delegate = self;
    inputTF.tag = 2000+indexPath.row;
//    inputTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:inputTF];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).with.offset(10.f);
        make.bottom.equalTo(cell.contentView);
        make.width.mas_equalTo(125.f);
    }];
    
    [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(titleLabel);
        make.right.equalTo(cell.contentView).with.offset(-5.f);
    }];
    
    switch (indexPath.row) {
        case 0:
            
            titleLabel.text = @"当前登陆密码：";
            inputTF.placeholder = @"请输入原始密码";
            break;
        case 1:
            
            titleLabel.text = @"新密码：";
            inputTF.placeholder = @"请设置新密码";
            break;
        case 2:
            
            titleLabel.text = @"再次输入密码：";
            inputTF.placeholder = @"请再次输入";
            break;
            
        case 3:
            
            cell.backgroundColor = CCITY_MAIN_BGCOLOR;
            cell.lineColor = CCITY_MAIN_BGCOLOR;
            [self configCommitCellWithCell:cell];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
}

#pragma mark- --- textfiled delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case 2000:
            
            _oldPwd = textField.text;
            break;
        case 2001:
            
            _newPwd = textField.text;
            break;
        case 2002:
            
            _checkNewPwd = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
