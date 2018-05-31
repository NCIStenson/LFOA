//
//  CCityDocSearchVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityDocSearchVC.h"
#import "CCityMainDocSearchCell.h"
#import "CCityAccessoryManager.h"

@interface CCityDocSearchVC ()

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityDocSearchVC {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datasMuArr = [NSMutableArray array];
    
    self.title = @"资料查询";
    [self.tableView registerClass:[CCityMainDocSearchCell class] forCellReuseIdentifier:cellReuseId];
    
    self.parameters = [NSMutableDictionary dictionary];
    
    [self.parameters setObject:@20 forKey:@"pageSize"];
    
    [self refreshWithIndex:1];
}

#pragma mark- --- refresh 

-(void)refreshWithIndex:(NSInteger)index {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    if (index) {
        
        [self.parameters setObject:@(index) forKey:@"pageIndex"];
    }
    
    [manager POST:@"service/search/QueryLaw.ashx" parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",task.currentRequest.URL.absoluteString);
        
        [SVProgressHUD dismiss];
        
        NSArray* result = responseObject[@"results"];
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];

            [self.datasMuArr removeAllObjects];
            
            [self addDatasWithArr:result];
            
            [self.tableView reloadData];
            
        } else if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];
            
            NSInteger addCount = [self addDatasWithArr:result];
            
            if (!result.count) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self addPageIndex:NO];
                return;
            }
            
            [self.tableView beginUpdates];
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.datasMuArr.count - addCount, addCount)] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
        } else {
            
            [self addDatasWithArr:result];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];
            [self addPageIndex:NO];
        }
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

-(NSInteger)addDatasWithArr:(NSArray*)result {
    
    NSInteger addCounts = 0;
    
    for (int i = 0; i < result.count; i++) {
        
        CCityMainDocSearchModel* model = [[CCityMainDocSearchModel alloc]initWithDic:result[i]];
        
        if (self.datasMuArr.count) {
            
            BOOL isHave = NO;
            
            for (CCityMainDocSearchModel* inModel in self.datasMuArr) {
                
                if ([inModel.type isEqualToString:model.type]) {
                    
                    isHave = YES;
                    CCityMainDocsearchDetailModel* detailModel = [[CCityMainDocsearchDetailModel alloc]initWithDic:result[i]];
                    [inModel.children addObject:detailModel];
                }
            }
            
            if (isHave == NO) {
                
                addCounts++;
                CCityMainDocsearchDetailModel* detailModel = [[CCityMainDocsearchDetailModel alloc]initWithDic:result[i]];
                
                [model.children addObject:detailModel];
                [self.datasMuArr addObject:model];
            }
        } else {
            
            CCityMainDocsearchDetailModel* detailModel = [[CCityMainDocsearchDetailModel alloc]initWithDic:result[i]];
            [model.children addObject:detailModel];
            [self.datasMuArr addObject:model];
            
            addCounts++;
        }
    }

    return addCounts;
}

-(void)footerRefresh {
    
    [self addPageIndex:YES];
    [self refreshWithIndex:0];
}

-(void)headerRefresh {
    
    [self refreshWithIndex:1];
}

-(void)addPageIndex:(BOOL)isAdd {
    
    NSInteger pangeIndex = [self.parameters[@"pageIndex"] integerValue];
    
    if (isAdd) {    pangeIndex++;   }
    else       {    pangeIndex--;   }
    
    self.parameters[@"pageIndex"] = @(pangeIndex);
}

#pragma mark- --- methods

-(void)sectionHeaderClicked:(UIControl*)section {
    
    CCityMainDocSearchModel* model = self.datasMuArr[section.tag - 2000];
    model.isOpen = !model.isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section.tag - 2000] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)accessorySelected:(CCityAppendixView*)accessonary {
    
    NSDictionary* parameters = @{
                                 @"path":accessonary.url,
                                 @"name":accessonary.titleLabel.text,
                                 };
    
    CCityAccessoryManager* accessoryManager = [[CCityAccessoryManager alloc]init];
    
    NSArray* fileNames = [accessonary.titleLabel.text componentsSeparatedByString:@"."];
    [accessoryManager OpenFileWithUrl:@"service/search/PreviewFile.ashx" parameters:parameters fileType:[fileNames lastObject] fileName:[fileNames firstObject]];
    
    accessoryManager.requestSucess = ^(UIViewController *vc) {
        
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.datasMuArr.count?self.datasMuArr.count:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityMainDocSearchModel* model = self.datasMuArr[indexPath.section];
    CCityMainDocsearchDetailModel* cellModel = model.children[indexPath.row];
    
    CCityMainDocSearchCell* cell = [CCityMainDocSearchCell new];
    
    return [cell getCellHeightWithModel:cellModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!self.datasMuArr.count) {   return 0;   }
    
    CCityMainDocSearchModel* model = self.datasMuArr[section];
    
    if (model.isOpen) { return model.children.count;    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityMainDocSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    
    CCityMainDocSearchModel* model = self.datasMuArr[indexPath.section];
    CCityMainDocsearchDetailModel* cellModel = model.children[indexPath.row];
    
    while ([cell.contentView.subviews lastObject]) {

        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.model  = cellModel;
    cell.isOpen = cellModel.isOpen;
    
    if (cell.accessoryConArr) {
        
        for (int i = 0; i < cell.accessoryConArr.count; i++) {
            
            CCityAppendixView* accessoryCon = cell.accessoryConArr[i];
            [accessoryCon addTarget:self action:@selector(accessorySelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.datasMuArr.count) {
        
        CCityNoDataSection* noDataView = [CCityNoDataSection new];
        return noDataView;
    }
    
    UIControl* sectionHeader = [[UIControl alloc]init];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.tag = 2000+section;
    
    CCityMainDocSearchModel* model = self.datasMuArr[section];
    
    UIImageView* imageView;
    
    if (model.isOpen) {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_folder_40x40"]];
    } else {
         imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_folder_40x40"]];
    }
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = model.type;
    
    CALayer* bottomLine = [CALayer new];
    bottomLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3f].CGColor;
    bottomLine.frame = CGRectMake(0, 59.5, self.view.bounds.size.width, .5f);
    
    [sectionHeader.layer addSublayer:bottomLine];
    [sectionHeader addSubview:imageView];
    [sectionHeader addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(sectionHeader).with.offset(10.f);
        make.left.equalTo(sectionHeader).with.offset(10.f);
        make.bottom.equalTo(sectionHeader).with.offset(-10.f);
        make.width.equalTo(imageView.mas_height);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(imageView);
        make.right.equalTo(sectionHeader).with.offset(-10.f);
    }];
    
    [sectionHeader addTarget:self action:@selector(sectionHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return sectionHeader;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityMainDocSearchModel* model = self.datasMuArr[indexPath.section];
    CCityMainDocsearchDetailModel* cellModel = model.children[indexPath.row];
    
    cellModel.isOpen = !cellModel.isOpen;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
