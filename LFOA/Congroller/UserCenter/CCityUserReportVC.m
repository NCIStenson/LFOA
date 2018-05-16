//
//  CCityUserReportVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/27.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_REPORT_STR @"留下你的宝贵意见，我们会努力完善"

#import "CCityUserReportVC.h"
#import "CCLeftBarBtnItem.h"
#import "CCitySystemVersionManager.h"

@interface CCityUserReportVC ()

@end

@implementation CCityUserReportVC {
    
    UIButton* _senderBtn;
    CALayer*  _line;
    NSString* _reportStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户反馈";
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self backBarBtnView]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    
    _line = [self line];
    
    [self.navigationController.navigationBar.layer addSublayer:_line];
    
    UIView* footerView = [self tableViewFooterView];
    
            if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
                
                footerView.frame = CGRectMake(0, self.view.bounds.size.height - 148.f, self.view.bounds.size.width, 104.f);
            } else {
                
                footerView.frame = CGRectMake(0, self.view.bounds.size.height - 128.f, self.view.bounds.size.width, 84.f);
            }
    
    [self.view addSubview:footerView];
    
    [self.tableView addGestureRecognizer:[self tapGes]];
    
    self.tableView.rowHeight = (self.view.bounds.size.height - 50.f)/2;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_line removeFromSuperlayer];
}

#pragma mark- --- layout subviews

-(CALayer*)line {
    
    CALayer* layer = [[CALayer alloc]init];
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height -.5f, self.view.bounds.size.width, .5f);
    return layer;
}
-(UIView*)tableViewFooterView {
    
    UIView* tableViewFooterView = [UIView new];
    
    _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _senderBtn.layer.cornerRadius = 5.f;
    _senderBtn.backgroundColor = [UIColor grayColor];
    [_senderBtn setTitle:@"发送" forState:UIControlStateNormal];
    _senderBtn.userInteractionEnabled = NO;
    [_senderBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFooterView addSubview:_senderBtn];

    [_senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
        make.edges.equalTo(tableViewFooterView).with.insets(UIEdgeInsetsMake(30, 10, 30, 10));
        } else {
        make.edges.equalTo(tableViewFooterView).with.insets(UIEdgeInsetsMake(20, 10, 20, 10));
        }
    }];
    
    return tableViewFooterView;
}

/*
-(UIControl*)backBarBtnView {
    
    UIControl* backView = [UIControl new];
    backView.frame = CGRectMake(0, 0, 60.f, self.navigationController.navigationBar.bounds.size.height);
    [backView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    CCityBackToLeftView* trangle = [CCityBackToLeftView new];
    trangle.backgroundColor = [UIColor whiteColor];
    trangle.tintColor = [UIColor blackColor];
//    trangle.frame = CGRectMake(0, 0, 15.f, 24.f);

    UILabel* backLabel = [UILabel new];
    backLabel.text = @"返回";
    
    [backView addSubview:trangle];
    [backView addSubview:backLabel];
    
    [trangle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(backView);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(15.f, 24.f));
    }];
    
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(backView).with.offset(2.f);
        make.left.equalTo(trangle.mas_right).with.offset(5.f);
        make.bottom.equalTo(backView);
        make.right.equalTo(backView);
    }];
    
    return backView;
}
 
*/

-(UITapGestureRecognizer*)tapGes {
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTap)];
    return tap;
}

#pragma mark- --- methods

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)tableViewTap {
    
    [self.view endEditing:YES];
}

- (void)sendAction {
    
    [self.view endEditing:YES];
    
    if (_reportStr.length <= 0) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"请输入意见内容" detail:nil];
        return;
    }
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [manager GET:@"service/user/Feedback.ashx" parameters:@{@"":[CCitySingleton sharedInstance].token, @"content":_reportStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        [SVProgressHUD dismiss];
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if ([errorNoManager requestSuccess:responseObject]) {
            
            UIAlertController* tipCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"感谢您提出宝贵意见" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self backAction];
            }];
            
            [tipCon addAction:okAction];
            
            [self presentViewController:tipCon animated:YES completion:nil];
        } else {
         
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self sendAction];
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.description detail:nil];
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = CCITY_MAIN_BGCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITextView* textView = [UITextView new];
    textView.font = [UIFont systemFontOfSize:16.f];
    textView.delegate = self;
    textView.text = CCITY_REPORT_STR;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1.f;
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 5.f;
    textView.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(20, 10, 0, 10));
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
}

#pragma mark- --- uitextfield delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:CCITY_REPORT_STR]) {
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.textColor = [UIColor lightGrayColor];
        textView.text = CCITY_REPORT_STR;
    } else if (![textView.text isEqualToString:CCITY_REPORT_STR]) {
        
          _reportStr = textView.text;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {

    if ([textView.text isEqualToString:CCITY_REPORT_STR] || [textView.text isEqualToString:@""]) {
        
        if (_senderBtn.userInteractionEnabled) {
            _senderBtn.userInteractionEnabled = NO;
            _senderBtn.backgroundColor = [UIColor grayColor];
        }
    } else {
        
        _senderBtn.userInteractionEnabled = YES;
        _senderBtn.backgroundColor = CCITY_MAIN_COLOR;
        
    }

}

@end
