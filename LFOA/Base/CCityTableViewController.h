//
//  CCityTableViewController.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface CCityTableViewController : CCityBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray* datasMuArr;
@property(nonatomic, strong)UITableView*    tableView;

@property(nonatomic, assign)BOOL showHeaderRefresh;
@property(nonatomic, assign)BOOL showFooterRefresh;

-(void)headerRefresh;
-(void)footerRefresh;

-(void)endRefresh;

@end
