//
//  CCityNoficDetailVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNoficDetailVC.h"
#import "CCityBaseTableViewCell.h"
#import "CCityNavBar.h"
#import "CCityAppendixView.h"
#import "CCityAccessoryManager.h"
#import "CCitySystemVersionManager.h"

@interface CCityNoficDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CCityNoficDetailVC {
    
    UITableView* _tableView;
    CCityNotficModel* _model;
}

- (instancetype)initWithModel:(CCityNotficModel*)model
{
    self = [super init];
    if (self) {
        
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self myHeaderView];
    _tableView.tableFooterView = [self myFooterView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    CCityNavBar* navBar = [self navBar];
    
    [self.view addSubview:navBar];
    [self.view addSubview:_tableView];

    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.height.mas_equalTo(84.f);
        } else {
            
            make.height.mas_equalTo(64.f);
        }
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

-(CCityNavBar*)navBar {
    
    CCityNavBar* navBar = [CCityNavBar new];
    
    [navBar.backControl addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    navBar.titleLabel.text = @"通知通告详情";
    navBar.backLabel.hidden = YES;
    
    navBar.barTintColor = CCITY_MAIN_COLOR;
    
    navBar.tintColor = [UIColor whiteColor];
    return navBar;
}

-(UIView*)myHeaderView {
    
    UIView* contentView = [[UIView alloc]init];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-40, MAXFLOAT)];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = _model.notficTitle;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(20, 20, self.view.bounds.size.width-40, titleLabel.bounds.size.height);
    
    [contentView addSubview:titleLabel];
    
    CGRect contViewFrame = titleLabel.bounds;
    contViewFrame.size.height += 30;
    contentView.frame = contViewFrame;
    
    return contentView;
}

-(UIView*)myFooterView {
    
    UIView* footerContentView = [[UIView alloc]init];
    
    if (!_model.files.count) {
        
        return footerContentView;
    }
    
    footerContentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60*_model.files.count + 10*(_model.files.count-1) + 10*2);
    
    for (int i = 0; i < _model.files.count; i++) {
        
        CCityFileModel* model = _model.files[i];
        CCityAppendixView* accessoryView = [[CCityAppendixView alloc]init];
        accessoryView.frame = CGRectMake(20,   (70 * i), self.view.bounds.size.width - 40, 60);
        [accessoryView addTarget:self action:@selector(accessoryAction:) forControlEvents:UIControlEventTouchUpInside];
        accessoryView.titleLabel.text = model.fileName;
        accessoryView.url = model.fileUrl;
        accessoryView.sizeLabel.text = model.fileSize;
        accessoryView.type = [[model.fileName componentsSeparatedByString:@"."] lastObject];
        
        [footerContentView addSubview:accessoryView];
    }
    
    return footerContentView;
}

-(UILabel*)contentLabel {
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0.f;
    contentLabel.text = _model.notficContent;
    contentLabel.font = [UIFont systemFontOfSize:16.f];
    contentLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width - 40.f, MAXFLOAT);
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(20, 10, contentLabel.bounds.size.width, contentLabel.bounds.size.height);
    return contentLabel;
}

- (NSAttributedString*)formatStrWithTitle:(NSString*)title content:(NSString*)content {
  
    NSMutableAttributedString* titleStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f]}];
    
     NSAttributedString* contentStr = [[NSAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
    
     [titleStr appendAttributedString:contentStr];
    
    return titleStr;
}

#pragma mark- --- methods

- (void)accessoryAction:(CCityAppendixView*)accessory {
    
    CCityAccessoryManager* accessoryManager = [[CCityAccessoryManager alloc]init];
    
    NSDictionary* parameters = @{
                                 @"path":accessory.url,
                                 @"name":accessory.titleLabel.text,
                                 };
    
    NSArray* fileNames = [accessory.titleLabel.text componentsSeparatedByString:@"."];
    
    [accessoryManager OpenFileWithUrl:@"service/search/PreviewFile.ashx" parameters:parameters fileType:[fileNames lastObject] fileName:[fileNames firstObject]];
    
    accessoryManager.requestSucess = ^(UIViewController *vc) {
        
        [self.navigationController pushViewController:vc animated:YES];
    };
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        
        return [self contentLabel].bounds.size.height + 30.f;
    }
    return 35.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   CCityBaseTableViewCell* cell = [CCityBaseTableViewCell new];
    cell.linePadding = 20.f;
    
    UITableViewCell* normalCell;
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.textColor = CCITY_GRAY_TEXTCOLOR;

    [cell.contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    switch (indexPath.row) {
        case 0:
            
            if (_model.isHeightLevel) {
                
                contentLabel.attributedText = [self formatStrWithTitle:@"是否紧急：" content:@"是"];
            } else {
                
                contentLabel.attributedText = [self formatStrWithTitle:@"是否紧急：" content:@"否"];
            }
            break;
        case 1:
            
             contentLabel.attributedText = [self formatStrWithTitle:@"发布科室：" content:_model.notficFromName];
            break;
        case 2:
            
            contentLabel.attributedText = [self formatStrWithTitle:@"发布时间：" content:_model.notficPostTime];
            break;
        case 3:
            
            normalCell = [UITableViewCell new];
            normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [normalCell.contentView addSubview:[self contentLabel]];
            return normalCell;
            break;
        default:
            break;
    }
    
    return cell;
}

@end
