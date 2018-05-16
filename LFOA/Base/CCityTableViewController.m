//
//  CCityTableViewController.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityTableViewController.h"

@interface CCityTableViewController ()

@end

@implementation CCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar.layer addSublayer:[self lineLayer]];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    
    MJRefreshNormalHeader* mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRefresh];
    }];
    
    mjHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mjHeader;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self footerRefresh];
    }];
    
    _datasMuArr = [NSMutableArray array];

    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

-(CALayer*)lineLayer {
    
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = CCITY_RGB_COLOR(0, 0, 0, .3f).CGColor;
    layer.frame = CGRectMake(0, 44, self.view.bounds.size.width, .5f);
    return layer;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark- --- setters

-(void)setShowFooterRefresh:(BOOL)showFooterRefresh {
    _showFooterRefresh = showFooterRefresh;
    
    if (!showFooterRefresh) {
        
        self.tableView.mj_footer = nil;
    }
}

-(void)setShowHeaderRefresh:(BOOL)showHeaderRefresh {
    _showHeaderRefresh = showHeaderRefresh;
    
    if (showHeaderRefresh) {
        
        self.tableView.mj_header = nil;
    }
}

#pragma mark- ---  methods

-(void)headerRefresh {  }

-(void)footerRefresh {  }

-(void)endRefresh {
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return .1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datasMuArr.count?_datasMuArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityNoDataCell *cell = [CCityNoDataCell new];
    
    return cell;
}



@end
