//
//  CCityUserInfoVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/23.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityUserInfoVC.h"
#import "CCityBaseTableViewCell.h"
#import "CCLeftBarBtnItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CCityUserInfoVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CCityUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.shadowImage = [self createImageWithColor:[UIColor lightGrayColor]];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:[self backCon]];
    
    UITableView* tableView = [self tableView];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark- --- layout

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UITableView*)tableView {
    
    UITableView* tableView = [UITableView new];
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}

-(UIControl*)backCon {
    
    CCLeftBarBtnItem* leftBtn = [CCLeftBarBtnItem new];
    
    leftBtn.action = ^{
        [self backAction];
    };
    leftBtn.label.text = @"更多";
    
    return leftBtn;
}

#pragma mark- --- methods
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addHeaderImageWithCell:(UITableViewCell*)cell {
    
    UIImageView* headerImageView = [UIImageView new];
    headerImageView.layer.cornerRadius = 20.f;
    headerImageView.clipsToBounds = YES;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"ccity_uesrcenter_userHeader"]];
    
    [cell.contentView addSubview:headerImageView];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cell.contentView).with.offset(15.f);
        make.right.equalTo(cell.contentView).with.offset(-10.f);
        make.bottom.equalTo(cell.contentView).with.offset(-15.f);
        make.width.equalTo(headerImageView.mas_height);
    }];
}

#pragma mark- --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            
            return 80.f;
            break;
        case 1:
            
            return 20.f;
            break;
        default:
            break;
    }
    
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityBaseTableViewCell* cell = [[CCityBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    switch (indexPath.row) {
            
        case 0:
            
            cell.textLabel.text = @"头像";
            [self addHeaderImageWithCell:cell];
            break;
        case 1:
            
            cell.backgroundColor = CCITY_MAIN_BGCOLOR;
            cell.lineColor = CCITY_MAIN_BGCOLOR;
            break;
        case 2:
            
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = [CCitySingleton sharedInstance].userName;
            break;
        case 3:
            
            cell.textLabel.text = @"单位";
            cell.detailTextLabel.text = [CCitySingleton sharedInstance].organization;
            break;
        case 4:
            
            cell.textLabel.text = @"岗位";
            cell.detailTextLabel.text = [CCitySingleton sharedInstance].occupation;
            break;
        case 5:
            
            cell.textLabel.text = @"科室";
            cell.detailTextLabel.text = [CCitySingleton sharedInstance].deptname;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark- --- UITableViewDelegate
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

@end
