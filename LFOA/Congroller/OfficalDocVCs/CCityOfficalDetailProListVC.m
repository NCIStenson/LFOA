//
//  CCityOfficalDetailProListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/17.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailProListVC.h"
#import "CCityOfficalProDocListCell.h"
#import "CCityOfficalDocDetailVC.h"

@interface CCityOfficalDetailProListVC ()

@end

static NSString* ccityOfficalProDocListCellReuseId = @"CCityOfficalProDocListCell";

@implementation CCityOfficalDetailProListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mainStyle == CCityOfficalMainDocStyle) {
        
        self.titleLabel.text = @"公文表单";
    } else if (self.mainStyle == CCityOfficalMainSPStyle) {
        
        self.titleLabel.text = @"项目表单";
    }
    
    self.tableView.rowHeight = 44.f;
    
    [self layoutSubViews];
    [self configData];
}

#pragma mark- --- layoutsubviews

- (void)layoutSubViews {
    
    [self.tableView registerClass:[CCityOfficalProDocListCell class] forCellReuseIdentifier:ccityOfficalProDocListCellReuseId];
}

#pragma mark- --- netWork 

- (void)configData {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:@"service/form/GetFormList.ashx" parameters:self.ids progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        self.dataMuArr = responseObject[@"results"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
    }];
}

#pragma mark- --- uitabledelegate datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataMuArr.count) {
        return;
    }
    
    [SVProgressHUD show];
    
    NSDictionary* model = self.dataMuArr[indexPath.row];
    
    NSDictionary* ids = @{
                          @"fkNode" :model[@"fk_node"],
                          @"workId" :model[@"workid"],
                          @"formId" :model[@"formid"],
                          @"fk_flow":model[@"fk_flow"],
                          };
    
    CCityOfficalDocDetailVC* detailVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:@[@"表单信息",@"公文材料"] Id:ids contentModel:CCityOfficalDocHaveDoneMode];
    
    detailVC.mainStyle = self.mainStyle;
    detailVC.conentMode = self.contentMode;
    
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalProDocListCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficalProDocListCellReuseId];
    
    if (!self.dataMuArr.count) {
        
        cell.model = @{@"name":@"无数据"};
        return cell;
    }
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.model = self.dataMuArr[indexPath.row];
    return cell;
}

@end
