//
//  CCityBaseMainVCs.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"
#import <MJRefresh.h>

@interface CCityBaseMainVCs : CCityBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSString* url;
@property(nonatomic, strong)NSMutableArray* datasMuArr;
@property(nonatomic, strong)NSMutableDictionary* parameters;
@property(nonatomic, strong)UITableView* tableView;

@property(nonatomic, assign)BOOL showHeaderRefresh;
@property(nonatomic, assign)BOOL showFooterRefresh;

@property(nonatomic, assign)BOOL addNavBarLine;

- (instancetype)initDatas:(NSMutableArray*)datas url:(NSString*)url parameters:(NSDictionary*)parameters;

-(void)headerRefresh;
-(void)footerRefresh;

@end
