//
//  CCityMainMessageVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainMessageVC.h"
#import "CCityNavBar.h"
#import "CCityMainMessageCell.h"
#import "CCityOfficalDocDetailVC.h"
#import "CCityMeetingDeitalVC.h"
#import <GTSDK/GeTuiSdk.h>

#define CCITY_MESSAGE_ROW_HEIGHT 70.f

@interface CCityMainMessageVC ()<CCityMainMessageCellDelegate>

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityMainMessageVC {
    
    NSInteger _pageIndex;
    NSMutableArray* _noIncludeIds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"消息提示";
    self.navigationItem.rightBarButtonItem = [self rightBarBtnItem];
    _noIncludeIds = [NSMutableArray array];
    _pageIndex = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutMySubViews];
    [self configData];
   
    if ([CCitySingleton sharedInstance].isLogIn == NO) {
        [self presentViewController:[CCityLogInVC new] animated:YES completion:nil];
    }
    
}

#pragma mark- --- layout subviews

-(void)layoutMySubViews {
    
    [self.tableView registerClass:[CCityMainMessageCell class] forCellReuseIdentifier:cellReuseId];
}

-(UIBarButtonItem*)rightBarBtnItem {
    
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"全部已读"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(allReadBtnClick)];
    [rightBarBtnItem setTintColor:MAIN_BLUE_COLOR];

    rightBarBtnItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    return rightBarBtnItem;
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

-(CGFloat)rowHeightWithModel:(CCityMessageModel*)model {
    
    YYLabel* label = [YYLabel new];
    label.numberOfLines = 0.f;
    label.font = [UIFont systemFontOfSize:15.f];
    label.text = model.content;
    label.truncationToken = [NSAttributedString attachmentStringWithContent:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(20, 20) alignToFont:label.font alignment:YYTextVerticalAlignmentCenter];
    label.frame = CGRectMake(0, 0, self.view.bounds.size.width - 60.f, MAXFLOAT);
    [label sizeToFit];
    return label.bounds.size.height + 20.f + 20.f;
}

-(void)removeWithIndex:(NSIndexPath*)indexPath {
    
    [self.tableView beginUpdates];
    
    [self.datasMuArr removeObjectAtIndex:indexPath.row];
    
    if (self.datasMuArr.count >= 1) {
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
        [self.tableView reloadData];
    }
    
    [self.tableView endUpdates];
}

#pragma mark- --- methods
-(NSMutableArray*)sortArrayWithArr:(NSArray*)array {
    
    NSArray* sortArrar = [array mutableCopy];
    
    array = [sortArrar sortedArrayUsingComparator:^NSComparisonResult( CCityMessageModel* model1,  CCityMessageModel* model) {
       
        return [model.date compare:model1.date];
    }];
    
    return [array mutableCopy];
}

#pragma mark- --- network

-(void)configData {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSString* noInclodesStr = @"";
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        
        if (_noIncludeIds.count) {
            [_noIncludeIds removeAllObjects];
        }
    }
    
    for (int i = 0; i < _noIncludeIds.count; i++) {
        
        if (i == _noIncludeIds.count -1) {
            
           noInclodesStr = [noInclodesStr stringByAppendingString:_noIncludeIds[i]];
        } else {
            
           noInclodesStr = [noInclodesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", _noIncludeIds[i]]];
        }
    }
    
    NSDictionary* parameters = @{
                                 @"pageSize" :@20,
                                 @"pageIndex":@(_pageIndex),
                                 @"token"    :[CCitySingleton sharedInstance].token,
                                 @"notIncludes":noInclodesStr
                                 };
    
    [SVProgressHUD show];
    
    [manager GET:@"service/message/GetPageUnreadMessages.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        [self endRefresh];

        if (![errorNoManager requestSuccess:responseObject]) {
    
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self configData];
            }];
            return;
        }
      
        NSArray* result = responseObject[@"rows"];
        NSMutableArray* datasArr = [NSMutableArray arrayWithCapacity:result.count];
        
        for (int i = 0 ; i < result.count; i++) {
            
            CCityMessageModel* model = [[CCityMessageModel alloc]initWithDic:result[i]];
            [datasArr addObject:model];
        }
        
        datasArr = [self sortArrayWithArr:datasArr];
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            if (!datasArr.count) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            NSMutableArray* indexPathArr = [NSMutableArray arrayWithCapacity:result.count];
            
            for (int i = 0; i < datasArr.count; i++) {
                
                [indexPathArr addObject:[NSIndexPath indexPathForRow:self.datasMuArr.count inSection:0]];
                [self.datasMuArr addObject:datasArr[i]];
            }
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
//            if (result.count * CCITY_MESSAGE_ROW_HEIGHT > self.tableView.bounds.size.height) {
//                
////                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datasMuArr.count - datasArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            } else {
//                
//            }
            
        } else {
            
            if (!result.count) {
                [self endRefresh];
                return;
            }
            
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                
                [self.tableView.mj_footer resetNoMoreData];
                
                if (self.datasMuArr.count) {
                    [self.datasMuArr removeAllObjects];
                }
            }

            [self.datasMuArr addObjectsFromArray:datasArr];
            [self.tableView reloadData];
        }
        
        for (CCityMessageModel* model in datasArr) {
            
            if ([model.messageType isEqualToString:@"收文时限提醒"]) {
                [_noIncludeIds addObject:model.messageId];
            }
        }
        
        [self endRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            _pageIndex--;
        }
        
        [self endRefresh];
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];

        NSLog(@"%@",error.description);
    }];
}

-(void)allReadBtnClick
{
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [SVProgressHUD show];
    [manager GET:@"service/message/MarkAllMessagesHasRead.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        CCErrorNoManager* errorNoMananger = [CCErrorNoManager new];
        if (![errorNoMananger requestSuccess:responseObject]) {
            [errorNoMananger getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:nil];
        }else{
            [self.datasMuArr removeAllObjects];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.description);
    }];
}

-(void)readMesssageWithId:(NSString*)idStr {
    
    NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    if (badgeNum > 0) {
        badgeNum--;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
        [GeTuiSdk setBadge:badgeNum];
    }
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager GET:@"service/message/MarkMessageHasRead.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token, @"messageId":idStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCErrorNoManager* errorNoMananger = [CCErrorNoManager new];
        if (![errorNoMananger requestSuccess:responseObject]) {
            [errorNoMananger getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:nil];
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
    
    CCityMainMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        cell.model = self.datasMuArr[indexPath.row];
    });

    cell.delegate = self;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {
        
        return 44.f;
    }
    
    CCityMessageModel* model = self.datasMuArr[indexPath.row];
    
    if (model.isOpen) {
        
        CGFloat rowHeight =  [self rowHeightWithModel:model];
        
        return rowHeight > 60.f?rowHeight:60.f;
    }
    
    return 70.f;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityMessageModel* model = self.datasMuArr[indexPath.row];
    
    [self readMesssageWithId:model.messageId];
    
    if ((NSInteger)model.mainStyle == -1) {
        
        if ([model.messageType isEqualToString:@"会议消息"]) {
            
            CCityMeetingDeitalVC* meetingVC = [[CCityMeetingDeitalVC alloc]initWithUrl:@"service/message/GetMeetingFromMessage.ashx" parameters:[@{@"token":[CCitySingleton sharedInstance].token, @"messageId":model.messageId} mutableCopy]];
            [self.navigationController pushViewController:meetingVC animated:YES];
        }
        
    } else {
        
        CCityOfficalDocDetailVC* detailVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:@[@"表单信息", @"公文材料"] Id:@{@"messageId":model.messageId} contentModel:CCityOfficalDocHaveDoneMode];
        
        detailVC.mainStyle = model.mainStyle;
        
        if ([model.messageType isEqualToString:@"收文时限提醒"]) {
            
            detailVC.url = @"service/message/GetFormFromSWMessage.ashx";
        } else {
            
            detailVC.url = @"service/message/GetFormFromMessage.ashx";
        }
        
        detailVC.conentMode = model.docStyle;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    [self removeWithIndex:indexPath];
}

- (void)openBtnSelectedAction:(CCityMainMessageCell*)cell {
    
   NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


@end
