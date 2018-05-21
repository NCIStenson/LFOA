//
//  CCityMainMeetingListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_MAIN_MEETING_ROW_HEIGHT 75.f

#import "CCityMainMeetingListVC.h"
#import "CCityMainMeetingCell.h"
#import "CCityMeetingDeitalVC.h"

@interface CCityMainMeetingListVC ()

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityMainMeetingListVC {
    
    NSInteger _pageIndex;
    
    NSMutableDictionary* _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"会议列表";
    
    _parameters = [@{@"pageSize":@20} mutableCopy];
    
    self.datasMuArr = [NSMutableArray array];
    
    [self.tableView registerClass:[CCityMainMeetingCell class] forCellReuseIdentifier:cellReuseId];
    self.tableView.rowHeight = CCITY_MAIN_MEETING_ROW_HEIGHT;
    
    _pageIndex = 1;
    
    [self configData];
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

-(void)endRefresh {
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark- --- network
- (void)configData {
    
    [self.tableView reloadData];
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [_parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    [_parameters setObject:@(_pageIndex) forKey:@"pageIndex"];
//    [_parameters setObject:@"20" forKey:@"pageSize"];

    [manager POST:@"service/search/GetMeetList.ashx" parameters:_parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

        NSArray* resutls = responseObject[@"results"];
        NSMutableArray* resultsArr = [NSMutableArray arrayWithCapacity:resutls.count];
        
        for (int i = 0; i < resutls.count; i++) {
            
            CCityMainMeetingListModel* model = [[CCityMainMeetingListModel alloc]initWithDic:resutls[i]];
            [resultsArr addObject:model];
        }
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_footer resetNoMoreData];
            
            if (!resutls.count) {
                return;
            }
            
            self.datasMuArr = [resultsArr mutableCopy];
            [self.tableView reloadData];
        } else if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
           
            if (!resutls.count) {
               
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                _pageIndex--;
                return;
            }
            
            NSMutableArray* indexPathArr = [NSMutableArray arrayWithCapacity:resutls.count];
            
            for (int i = 0; i < resutls.count; i++) {
                
                [indexPathArr addObject:[NSIndexPath indexPathForRow:resultsArr.count+i inSection:0]];
            }
            
            [self.tableView beginUpdates];
            
            [self.datasMuArr addObjectsFromArray:resultsArr];
            
            [self.tableView insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
            if (resutls.count * CCITY_MAIN_MEETING_ROW_HEIGHT > self.tableView.bounds.size.height) {
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datasMuArr.count - resutls.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            } else {
                
                if (self.datasMuArr.count* CCITY_MAIN_MEETING_ROW_HEIGHT > self.tableView.bounds.size.height) {
                }
            }
            
        } else {
            
            if (!resutls.count) {
                return;
            }
            
            self.datasMuArr = [resultsArr mutableCopy];
            [self.tableView reloadData];
        }
        
        [self endRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self endRefresh];

        [SVProgressHUD dismiss];
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        
        NSLog(@"%@",error.description);
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            _pageIndex--;
        }
    }];
}

-(void)readMesssageWithId:(NSString*)idStr {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:@"service/meeting/MarkMeetingHasRead.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token, @"annexitemId":idStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCErrorNoManager* errorNoMananger = [CCErrorNoManager new];
        if (![errorNoMananger requestSuccess:responseObject]) {
            [errorNoMananger getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:nil];
        }else{
            NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badgeNum > 0) {
                badgeNum--;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.description);
        
    }];
}


#pragma mark- --- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {
        
        CCityNoDataCell* cell = [CCityNoDataCell new];
        return cell;
    }
    
    CCityMainMeetingCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
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
    
    CCityMainMeetingListModel * model = self.datasMuArr[indexPath.row];
    
    if (!model.isRead) {
        [self readMesssageWithId:model.annexitemId];
        model.isRead = YES;
//        [self.datasMuArr replaceObjectAtIndex:indexPath.row withObject:model];
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    CCityMeetingDeitalVC* detailVC = [[CCityMeetingDeitalVC alloc]initWithModel:self.datasMuArr[indexPath.row]];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
