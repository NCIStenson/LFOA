//
//  CCityOfficalDetialMenuBaseVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetialMenuBaseVC.h"
#import "CCLeftBarBtnItem.h"

@interface CCityOfficalDetialMenuBaseVC ()

@end

@implementation CCityOfficalDetialMenuBaseVC {
    
    CALayer* _bottomLine;
}

- (instancetype)initWithIds:(NSDictionary*)ids
{
    self = [super init];
    if (self) {
        
        _ids = ids;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomLine = [CALayer layer];
    _bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
    _bottomLine.frame = CGRectMake(0, 43, self.view.bounds.size.width, 1.f);
    [self.navigationController.navigationBar.layer addSublayer:_bottomLine];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CCLeftBarBtnItem* backCon = [CCLeftBarBtnItem new];
    backCon.label.text = @"";
    
    backCon.action = ^{
        [self backAction];
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bottomLine removeFromSuperlayer];
}

#pragma mark- --- layoutSubviews

- (void)layoutMySubViews {
    
   _tableView = [self myTableView];
    
    [self.view addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

-(UITableView*)myTableView {

    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self tableViewHeaderView];
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    tableView.sectionFooterHeight = .1f;
    tableView.sectionFooterHeight = .1f;
    
    return tableView;
}

-(UIView*)tableViewHeaderView {
    
    UIView* tableViewHeaderView = [UIView new];
    
    tableViewHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40.f);
    tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    _titleLabel = [UILabel new];
    _titleLabel.textColor = CCITY_MAIN_COLOR;
    _titleLabel.frame = CGRectMake(20, 0, tableViewHeaderView.bounds.size.width - 5.f, tableViewHeaderView.bounds.size.height);
    
    [tableViewHeaderView addSubview:_titleLabel];
    
    return tableViewHeaderView;
}

#pragma mark- --- methods

- (void) backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataMuArr.count?self.dataMuArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [UITableViewCell new];

    if (!self.dataMuArr.count) {
        
        cell.textLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
        cell.textLabel.textColor = CCITY_MAIN_FONT_COLOR;
        cell.textLabel.text = @"无数据";
    }
    
    return cell;
}


@end
