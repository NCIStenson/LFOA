//
//  CCityBaseTableViewVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CELL_REUSE_ID @"baseTableVCCellReuseId"

#import "CCityBaseViewController.h"
#import "CCitySegmentedControl.h"

#import <MJRefresh.h>

@interface CCityBaseTableViewVC : CCityBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView*    tableView;
@property(nonatomic, strong)NSMutableArray* dataArr;

@property(nonatomic, assign)BOOL showRefreshHeader;
@property(nonatomic, assign)BOOL showRefreshFooter;
@property(nonatomic, strong)CCitySegmentedControl* segCon;

- (instancetype)initWithItmes:(NSArray*)items;

- (void)segmentedConValueChanged:(CCitySegmentedControl*)segCon;

//refresh
- (void) footerRefresh;
- (void) headerRefresh;

@end
