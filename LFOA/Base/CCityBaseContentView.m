//
//  CCityBaseContentView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseContentView.h"
#import <MJRefresh.h>

static NSString* baseContentViewReuseId = @"baseContentViewReuseId";

@implementation CCityBaseContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self layoutMySubViews];
    }
    return self;
}

- (void)layoutMySubViews {
    
    _tableView = [self myTableView];
    
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
    }];
}

#pragma mark- --- setters

-(void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    
    if (!showRefreshHeader) {   return; }
    
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = refreshHeader;
}

- (void) setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    
    if (!_showRefreshFooter) {   return; }

    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshAction)];
}

#pragma mark- --- layout subviews

-(UITableView*)myTableView {
    
    UITableView* tableView = [[UITableView alloc]init];
    
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:baseContentViewReuseId];
    return tableView;
}

#pragma mark- --- methods

- (void)headerRefreshAction {
    
    if ([self.delegate respondsToSelector:@selector(headerRefresh:)]) {
        
        [self.delegate headerRefresh:self];
    }
}

- (void)footRefreshAction{
    
    if ([self.delegate respondsToSelector:@selector(footerRefresh:)]) {
        
        [self.delegate footerRefresh:self];
    }
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count?_dataArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:baseContentViewReuseId];
    
    if (!_dataArr.count) {  cell.textLabel.text = @"无数据";   }
    
    return cell;
}

@end
