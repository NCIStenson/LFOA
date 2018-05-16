//
//  CCityBaseTableViewVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewVC.h"
#import "CCitySegmentedControl.h"
#import "CCityBaseTableViewCell.h"

@interface CCityBaseTableViewVC ()

@end

static NSString* cellReuseId = CELL_REUSE_ID;

@implementation CCityBaseTableViewVC {
    
    NSArray* _items;
}

- (instancetype)init
{
    self = [self initWithItmes:nil];
    if (self) {
        
        
    }
    return self;
}

- (instancetype)initWithItmes:(NSArray*)items
{
    self = [super init];
    if (self) {
        
        _items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutMySubViwsWithItems:_items];
}

#pragma mark- ---  setters

// show footer
-(void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    
    if (!showRefreshFooter) {   return; }

        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

// show header
-(void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    
    if (!showRefreshHeader) {   return;     }

    MJRefreshNormalHeader* header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _tableView.mj_header = header;
}

#pragma mark- --- layout subviews

// layout
- (void)layoutMySubViwsWithItems:(NSArray*)items {
    
    if (items) {
        
        _segCon = [self segmetedConWithArr:items];
        _segCon.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_segCon];
    }
    
    _tableView = [self myTableView];

//    float topPadding = 0;
//    if (_segCon) {
//        topPadding = _segCon.bounds.size.height;
//    }
    
    float bottomPadding = 0;
    if (self.tabBarItem) {
        bottomPadding = 50.f;
    }
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        if (_segCon) {   make.top.equalTo(_segCon.mas_bottom);    }
        
        else {  make.top.equalTo(self.view);    }
        
        make.bottom.equalTo(self.view).with.offset(-bottomPadding);
        
        make.left.equalTo(self.view);

        make.right.equalTo(self.view);
    }];
}

- (CCitySegmentedControl*)segmetedConWithArr:(NSArray*)items {
    
    CCitySegmentedControl* segCon = [[CCitySegmentedControl alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44) andItems:items];
    [segCon addTarget:self action:@selector(segmentedConValueChanged:) forControlEvents:UIControlEventValueChanged];
    return segCon;
}

// tableview
-(UITableView*)myTableView {
    
   UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView registerClass:[CCityBaseTableViewCell class] forCellReuseIdentifier:cellReuseId];
    tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    tableView.sectionFooterHeight = .1f;
    tableView.sectionHeaderHeight = .1f;
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}

#pragma mark- --- methods 

- (void)segmentedConValueChanged:(CCitySegmentedControl*)segCon {   }

- (void) footerRefresh {    }

- (void) headerRefresh {    }

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count?_dataArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityBaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
    if (!_dataArr.count) {  cell.textLabel.text = @"无数据";   }    
    return cell;
}

@end
