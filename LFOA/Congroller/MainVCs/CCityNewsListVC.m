//
//  CCityNewsListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsListVC.h"
#import "CCityNewsListCell.h"
#import "CCityNewsDetailVC.h"
#import "CCityNewNewsVC.h"
#import "ZSSRichTextEditor.h"
@interface CCityNewsListVC ()

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityNewsListVC {
    
    NSInteger _pageIndex;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新闻列表";
    UIBarButtonItem* rightBarButtonItem ;
    rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发新闻" style:UIBarButtonItemStylePlain target:self action:@selector(goNewNewsVC)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _pageIndex = 1;
    self.tableView.rowHeight = 70.f;
    
    [self.tableView registerClass:[CCityNewsListCell class] forCellReuseIdentifier: cellReuseId];
    
    [self configData];
}

#pragma mark- --- network
-(void)configData {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parameters = @{
                                 @"pageIndex":@(_pageIndex),
                                 @"pageSize":@20
                                 };
    
    [manager POST:@"service/search/GetNewsList.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSArray* results = responseObject[@"results"];
        NSMutableArray* resultsDataArr = [NSMutableArray arrayWithCapacity:results.count];
        
        for (int i = 0; i < results.count; i++) {
            
            CCityNewsModel* model = [[CCityNewsModel alloc]initWithDic:results[i]];
            [resultsDataArr addObject:model];
        }
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            if (!resultsDataArr.count) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                _pageIndex--;
                return ;
            }
            
            NSMutableArray* indexPathArr = [NSMutableArray arrayWithCapacity:resultsDataArr.count];
            
            for (int i = 0; i <resultsDataArr.count; i++) {
                
                [indexPathArr addObject:[NSIndexPath indexPathForRow:self.datasMuArr.count inSection:0]];
                [self.datasMuArr addObject:resultsDataArr[i]];
            }
            
            [self.tableView beginUpdates];
            
            [self.tableView insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
            if (results.count*70 > self.tableView.bounds.size.height) {
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datasMuArr.count - results.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            } else {
                
            }
            
        } else {
            
            if (!resultsDataArr.count) {
                return ;
            }
            
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            self.datasMuArr = [resultsDataArr mutableCopy];
            [self.tableView reloadData];
        }
        
        [self endRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self endRefresh];
        
        [SVProgressHUD dismiss];
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            _pageIndex--;
        }
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        
        NSLog(@"%@",error.description);
    }];
}

#pragma mark- --- methods

-(void)headerRefresh {
    
    _pageIndex = 1;
    [self configData];
}

-(void)footerRefresh {
    
    _pageIndex++;
    [self configData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {
        
        CCityNoDataCell* cell = [CCityNoDataCell new];
        return cell;
    }
    
    CCityNewsListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
//    while ([cell.contentView.subviews lastObject]) {
//        [[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
    
    cell.model = self.datasMuArr[indexPath.row];
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (!self.datasMuArr.count) {
        return;
    }
    CCityNewsDetailVC* detialVC = [[CCityNewsDetailVC alloc]initWithModel:self.datasMuArr[indexPath.row]];
    [self.navigationController pushViewController:detialVC animated:YES];
}

-(void)goNewNewsVC{
//    ZSSRichTextEditor * newnewsVC = [[ZSSRichTextEditor alloc]init];
    
    CCityNewNewsVC * newnewsVC = [[CCityNewNewsVC alloc]init];
    newnewsVC.successBlock = ^{
        [self configData];
    };
    [self.navigationController pushViewController:newnewsVC animated:YES];
}

@end
