//
//  CCityOfficalProLogVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalProLogVC.h"
#import "CCityOfficalProLogCell.h"
#import "CCityProLogModel.h"
#import "CCityProLogDetailModel.h"

static NSString* ccityOfficalProLogCellReuseId = @"CCityOfficalProLogCell";

@interface CCityOfficalProLogVC ()

@end

@implementation CCityOfficalProLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mainStyle == CCityOfficalMainSPStyle) {
        
        self.titleLabel.text = @"项目日志";
    } else if (self.mainStyle == CCityOfficalMainDocStyle) {
        
        self.titleLabel.text = @"公文日志";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self layoutSubViews];
    [self configData];
}

#pragma mark- --- layout subviews

- (void)layoutSubViews {
    
    [self.tableView registerClass:[CCityOfficalProLogCell class] forCellReuseIdentifier:ccityOfficalProLogCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark- --- methods

// analyse and sort

- (void)configDataWithDic:(NSDictionary*)dic {
  
    self.dataMuArr = [NSMutableArray array];
    
    NSArray* results = dic[@"results"];
    
    NSMutableArray* datasArr = [NSMutableArray arrayWithCapacity:results.count];

    for (int i = 0; i < results.count; i++) {
        
        CCityProLogModel* model = [[CCityProLogModel alloc]initWithDic:results[i]];
        [datasArr addObject:model];
    }
    
    NSSortDescriptor* sorter = [[NSSortDescriptor alloc]initWithKey:@"rdt" ascending:YES];
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc]initWithObjects:&sorter count:1];
    
    NSArray* sortArr = [results sortedArrayUsingDescriptors:sortDescriptors];
    
    CCityProLogModel* model;
    
    for (int i = 0; i < sortArr.count; i++) {
        
        if (i == 0) {
            
            model = [[CCityProLogModel alloc]initWithDic:sortArr[i]];
        }
        
        NSArray* dateArr = [self getModelTitleWithStr:sortArr[i][@"rdt"]];
        NSString* sectionTitle = dateArr[0];
        
        if (![sectionTitle isEqualToString:model.title]) {
            
            model = [[CCityProLogModel alloc]initWithDic:sortArr[i]];
            model.title = sectionTitle;
            [self.dataMuArr addObject:model];
        }
    
        NSDictionary* detailTimeDic = @{
                                        @"day"  :dateArr[1],
                                        @"time" :dateArr[2],
                                        @"title":sortArr[i][@"ndtot"],
                                        @"name" :sortArr[i][@"emptot"],
                                        };
        
        CCityProLogDetailModel* detailModel = [[CCityProLogDetailModel alloc]initWithDic:detailTimeDic];
        
        if (!model.children) {  model.children = [NSMutableArray array];  }
        
        [model.children addObject:detailModel];
    }
}

-(NSArray*)getModelTitleWithStr:(NSString*)date {
    
    NSArray* datesArr = [date componentsSeparatedByString:@" "];
    NSString* yearAndMonth = datesArr[0];
    NSArray* YMDArr = [yearAndMonth componentsSeparatedByString:@"-"];
    NSString* title = [NSString stringWithFormat:@"%@年%@月", YMDArr[0], YMDArr[1]];
    NSString* day = YMDArr[2];
    
    return @[title, day, datesArr[1]];
}

#pragma mark- --- network

- (void)configData {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:@"service/form/GetProjectLog.ashx" parameters:self.ids progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSArray* results = responseObject[@"results"];
        
        if (!results.count) {   return; }
        
        if (results.count == 1 && [results[0][@"rdt"] isEqualToString:@""]) {
            
            return;
        }
        
        [self configDataWithDic:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- uitableview delegate datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataMuArr.count?self.dataMuArr.count:1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataMuArr.count) {
        
        CCityProLogModel* model = self.dataMuArr[section];
        return model.children.count;
    } else {
        
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityProLogModel* model = self.dataMuArr[indexPath.section];
    
    if (indexPath.row == model.children.count -1 && indexPath.section != self.dataMuArr.count -1) {
        
        return 74.f;
    }
    
    return 54.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [UIView new];
    
    headerView.backgroundColor = CCITY_DAY_LINE_COLOR;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_calendar_50x50_"]];
    
    UILabel* titleLabel = [UILabel new];
//    titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    [headerView addSubview:imageView];
    [headerView addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(10.f);
        make.left.equalTo(headerView).with.offset(20.f);
        make.bottom.equalTo(headerView).with.offset(-10.f);
        make.width.equalTo(imageView.mas_height);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(imageView);
        make.right.equalTo(headerView).with.offset(-5.f);
    }];
    
    CCityProLogModel* model = self.dataMuArr[section];
    
    if (!self.dataMuArr) {  titleLabel.text = @"无数据";   }
    
    else {  titleLabel.text = model.title;  }
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalProLogCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficalProLogCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    CCityProLogModel* model = self.dataMuArr[indexPath.section];
    CCityProLogDetailModel* detialModel = model.children[indexPath.row];
    
    if (indexPath.row == model.children.count -1 && indexPath.section != self.dataMuArr.count -1) {
    
        cell.isBottom = YES;
    }
    cell.model = detialModel;
    return cell;
}

@end
