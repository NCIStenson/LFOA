//
//  CCityMainTaskSearchResultVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainTaskSearchResultVC.h"
#import "CCityMainTasekSearchResultCell.h"
#import "CCityOfficalDocDetailVC.h"
#import "CCLeftBarBtnItem.h"

@interface CCityMainTaskSearchResultVC ()<UITableViewDelegate, UITableViewDataSource>

@end

static NSString* mianSearchResutlCellReuseId = @"mianSearchResutlCellReuseId";

@implementation CCityMainTaskSearchResultVC {
    
//    UITableView*         _tableView;
}

- (instancetype)initDatas:(NSMutableArray*)datas url:(NSString*)url parameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        
        self.datasMuArr = [datas mutableCopy];
        self.url        = [url mutableCopy];
        self.parameters  = [parameters mutableCopy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"查询结果";
    
    CCLeftBarBtnItem* backCon = [CCLeftBarBtnItem new];
    backCon.label.backgroundColor = [UIColor whiteColor];
    backCon.action = ^{
      
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
    
    [self layoutMySubViews];
}

#pragma mark- --- layoutSubViews

- (void)layoutMySubViews {
    
    [self myLocalTableView];
}

-(UITableView*)myLocalTableView {
    
    [self.tableView registerClass:[CCityMainTasekSearchResultCell class] forCellReuseIdentifier:mianSearchResutlCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self.tableView;
}

-(void)refreshDataWithPage:(NSInteger)index {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    if (!index) {
        self.parameters[@"pageIndex"] = @1;
    }
    
    [manager POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* results = responseObject[@"results"];
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            [self.datasMuArr removeAllObjects];
            
            for (int i = 0 ; i < results.count; i++) {
                
                CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:results[i]];
                [self.datasMuArr addObject:model];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];

            if (!results.count) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                
                NSInteger oldCount = self.datasMuArr.count;
                
                [self.tableView beginUpdates];
                NSMutableArray* indexPathArr = [NSMutableArray arrayWithCapacity:results.count];
                
                for (int i = 0 ; i < results.count; i++) {
                    
                    CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:results[i]];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.datasMuArr.count inSection:0];
                    [indexPathArr addObject:indexPath];
                    [self.datasMuArr addObject:model];
                }
                
                [self.tableView insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                
                if (results.count*75 > self.tableView.bounds.size.height) {
                    
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:oldCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else {
                    
                    [self.tableView setScrollEnabled:YES];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

#pragma mark- --- mehtods

-(void)headerRefresh {
    
    [self refreshDataWithPage:0];
    [self.tableView.mj_footer resetNoMoreData];
}

-(void)footerRefresh {
    
    NSInteger pageIndex = [self.parameters[@"pageIndex"] integerValue];
    pageIndex += 1;
    self.parameters[@"pageIndex"] = @(pageIndex);
    [self refreshDataWithPage:pageIndex];
}

#pragma mark- --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasMuArr.count?self.datasMuArr.count:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {
        
        CCityNoDataCell* noDataCell = [CCityNoDataCell new];
        return noDataCell;
    }
    
    CCityMainTasekSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:mianSearchResutlCellReuseId];
    
    cell.model = self.datasMuArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 75.f;
    
//    CCityMainTasekSearchResultCell* cell = [CCityMainTasekSearchResultCell new];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    CGFloat rowHeight = [cell getHeightWithModel:_datasMuArr[indexPath.row]];
//    
//    return rowHeight > 60?rowHeight:60.f;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityMainSearchTaskModel* model = self.datasMuArr[indexPath.row];
    
    NSDictionary* ids = @{
                          @"workId" :model.workId,
                          @"fkNode" :model.fkNode,
                          @"formId" :model.formId,
                          @"fk_flow":model.fkFlow,
                          };

    CCityOfficalDocDetailVC* docDetailVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:@[@"表单信息", @"材料清单"] Id:ids contentModel:CCityOfficalDocHaveDoneMode];
    
    if (model.mainStyle == 1) {
        
        docDetailVC.mainStyle = 0;
    } else if (model.mainStyle == 0) {
        
        docDetailVC.mainStyle = 1;
    } else {
        
        docDetailVC.mainStyle = _mainStyle;
    }
    [self.navigationController pushViewController:docDetailVC animated:YES];
}

@end
