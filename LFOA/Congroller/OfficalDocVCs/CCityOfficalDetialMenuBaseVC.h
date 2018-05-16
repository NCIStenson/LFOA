//
//  CCityOfficalDetialMenuBaseVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"

@interface CCityOfficalDetialMenuBaseVC : CCityBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView*    tableView;
@property(nonatomic, strong)NSMutableArray* dataMuArr;
@property(nonatomic, strong)UILabel*        titleLabel;
@property(nonatomic, strong)NSDictionary*   ids;

@property(nonatomic, assign) NSInteger     contentMode;
@property(nonatomic, assign)CCityOfficalMainStyle mainStyle;

- (instancetype)initWithIds:(NSDictionary*)ids;

@end
