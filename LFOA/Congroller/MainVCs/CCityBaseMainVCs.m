//
//  CCityBaseMainVCs.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseMainVCs.h"

@interface CCityBaseMainVCs ()

@end

@implementation CCityBaseMainVCs {
    
    CALayer* _lineLayer;
}

- (instancetype)initDatas:(NSMutableArray*)datas url:(NSString*)url parameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        
        _datasMuArr = [datas mutableCopy];
        _url        = [url mutableCopy];
        _parameters  = [parameters mutableCopy];
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _lineLayer = [self lineLayer];
    [self.navigationController.navigationBar.layer addSublayer:_lineLayer];
    
    _tableView = [self myTableView];
    
    self.showHeaderRefresh = YES;
    self.showFooterRefresh = YES;
    
    [self.view addSubview:_tableView];
    
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

-(void)setShowHeaderRefresh:(BOOL)showHeaderRefresh {
    _showHeaderRefresh = showHeaderRefresh;
    
    if (showHeaderRefresh) {
        
        MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = refreshHeader;
    }
}

-(void)setShowFooterRefresh:(BOOL)showFooterRefresh {
    _showFooterRefresh = showFooterRefresh;
    
    if (showFooterRefresh) {
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [self footerRefresh];
        }];
    }
}

-(UITableView*)myTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    self.tableView.sectionFooterHeight = 0.f;
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    return _tableView;
}

#pragma mark- ---  setters

-(void)setAddNavBarLine:(BOOL)addNavBarLine {
    _addNavBarLine = addNavBarLine;
    
    if (!addNavBarLine) {
        
        [_lineLayer removeFromSuperlayer];
    }
}

#pragma mark- --- methods

-(void)headerRefresh {
    
}

-(void)footerRefresh {
    
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datasMuArr.count?_datasMuArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [UITableViewCell new];
    return cell;
}


@end
