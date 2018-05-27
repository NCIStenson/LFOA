//
//  CCityNewProjectVC.m
//  LFOA
//
//  Created by Stenson on 2018/5/26.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//


//
//  CCityOfficalDetailPsrsonListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define kFirstLetterHeight 40.0f

#import "CCityNewProjectVC.h"
#import "CCityOfficalDetailPersonListCell.h"
#import "CCityOfficalDocModel.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityAlterManager.h"
#import "CCitySystemVersionManager.h"
#import "CCityOfficalDocDetailVC.h"
#import "CCityMainSearchTaskModel.h"

@interface CCityNewProjectVC ()<UITableViewDelegate,UITableViewDataSource>

@end

static NSString* ccityOfficalDeitalPersonListCellReuseId = @"ccityOfficalDeitalPersonListCellReuseId";

@implementation CCityNewProjectVC {
    
    NSMutableDictionary* _ids;
    NSMutableArray*            _dataArr;
    UITableView*        _tableView;
    NSMutableArray*     _selectedArr;
    NSString*           _fkNode;
    NSInteger           _selectedSection;
    CALayer*            _lineLayer;
}

- (instancetype)initWithIds:(NSDictionary*)ids
{
    self = [super init];
    
    if (self) {
        
        _ids = [ids mutableCopy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CCITY_MAIN_BGCOLOR;
    if (_mainStyle == CCityOfficalMainDocStyle) {
        self.title = @"新建公文";
    }else if (_mainStyle == CCityOfficalMainSPStyle){
        self.title = @"新建项目";
    }
    
    _lineLayer = [CALayer new];
    _lineLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f].CGColor;
    _lineLayer.frame = CGRectMake(0, 44.f, self.view.bounds.size.width, .5f);
    [self.navigationController.navigationBar.layer addSublayer:_lineLayer];
    
    _selectedArr = [NSMutableArray array];
    
    [self layoutMySubViews];
    [self configData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    self.navigationController.navigationBar.barTintColor = CCITY_MAIN_COLOR;
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_lineLayer removeFromSuperlayer];
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.tintColor = CCITY_MAIN_COLOR;
    //    [self.navigationController.navigationBar setTitleTextAttributes:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layoutMySubViews
-(void)layoutMySubViews {
    
    UIView* footView = [self footerView];
    UIButton* sendBtn = [self sendBtn];
    _tableView = [self tableView];
    _tableView.rowHeight = 44.f;
    [self.view addSubview:_tableView];
    [footView addSubview:sendBtn];
    [self.view addSubview:footView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footView).with.offset(5.f);
        make.left.equalTo(footView).with.offset(10.f);
        make.bottom.equalTo(footView).with.offset(-5.f);
        make.right.equalTo(footView).with.offset(-10.f);
    }];
    
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.bottom.equalTo(self.view).with.offset(-20.f);
        } else {
            
            make.bottom.equalTo(self.view);
        }
        
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@50.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(footView.mas_top);
    }];
    
}

-(UITableView*)tableView {
    
    UITableView* tableView = [UITableView new];
    [tableView registerClass:[CCityOfficalDetailPersonListCell class] forCellReuseIdentifier:ccityOfficalDeitalPersonListCellReuseId];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.sectionHeaderHeight = 44.f;
    tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    return tableView;
}

// footerView
-(UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

// sendBtn
-(UIButton*)sendBtn {
    
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    sendBtn.backgroundColor = CCITY_MAIN_COLOR;
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 5.f;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    return sendBtn;
}

#pragma mark- --- netWork

- (void) sendAction {
    
    if(_selectedArr.count == 0){
        [SVProgressHUD showInfoWithStatus:@"请选择要创建的业务类型"];
        [SVProgressHUD dismissWithDelay:1.5f];
    }else{
        AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
        NSDictionary * parameters;
        parameters = @{@"token":[CCitySingleton sharedInstance].token,@"fkFlow":_selectedArr[0]};
        [SVProgressHUD show];
        
        [manager POST:@"service/business/NewWork.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@" ====  %@",responseObject);

            if([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"status"] isEqualToString:@"failed"]){
                [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据错误" detail:nil];
            }else{
                
                NSDictionary* ids = @{@"workId" : responseObject[@"workId"],
                                      @"fkNode" :responseObject[@"fkNode"],
                                      @"formId" :responseObject[@"formId"],
                                      @"fk_flow":responseObject[@"fkFlow"],
                                      };

                CCityOfficalDocDetailVC* docDetailVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:@[@"表单信息", @"材料清单"] Id:ids contentModel:CCityOfficalDocBackLogMode];
                docDetailVC.isNewProject = YES;
                docDetailVC.resultDic = responseObject;
                [self.navigationController pushViewController:docDetailVC animated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
            NSLog(@"%@",error);
        }];
    }
    
}

- (void)configData {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * parameters;
    if (_mainStyle == CCityOfficalMainDocStyle) {
        parameters = @{@"token":[CCitySingleton sharedInstance].token,@"type":@"行政办公"};
    }else{
        parameters = @{@"token":[CCitySingleton sharedInstance].token,@"type":@"规划业务"};
    }
    [SVProgressHUD show];
    
    [manager GET:@"service/business/GetFlowsByType.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"status"] isEqualToString:@"failed"]){
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据错误" detail:nil];
        }else{
            if([CCUtil isNotNull:[responseObject objectForKey:@"flows"]]){
                NSArray* datasArr = [responseObject objectForKey:@"flows"];
                
                NSMutableArray* muDataArr = [NSMutableArray arrayWithCapacity:datasArr.count];
                for (int i = 0 ; i < datasArr.count; i++) {
                    CCityOfficalNewProjectModel * model = [[CCityOfficalNewProjectModel alloc]initWithDic:datasArr[i]];
                    if (datasArr.count == 1) {
                        model.isOpen = YES;
                    }
                    [muDataArr addObject:model];
                }
//
                _dataArr = [NSMutableArray arrayWithArray:muDataArr];
                [_tableView reloadData];
                
                [SVProgressHUD dismiss];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}
#pragma mark- --- metods

- (void) dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendSuccess {
    
//    if ([self.delegate respondsToSelector:@selector(viewControllerDismissActoin)]) {
//        [self.delegate viewControllerDismissActoin];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)headerSectionAction:(UIControl*)headerSction {
    
    NSInteger section = headerSction.tag - 4000;
    CCityOfficalNewProjectModel * model = _dataArr[section];
    model.isOpen = !model.isOpen;
    
    for (int i = 0 ; i < _dataArr.count; i++) {
        CCityOfficalNewProjectModel* model = _dataArr[i];
        if (section != i) {
            model.isOpen = NO;
        }
    }
    
    [_selectedArr removeAllObjects];
    [_tableView reloadData];
}

#pragma mark- --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIControl* sectionHeader = [UIControl new];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.tag = 4000 + section;
    [sectionHeader addTarget:self action:@selector(headerSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CCityOfficalNewProjectModel* model = _dataArr[section];
    
    UIImageView* headerImageView = [[UIImageView alloc]init];
    headerImageView.image = [UIImage imageNamed:@"ccity_offical_sendDoc_node_50x50_"];
    
    UILabel* sectionNodeLabel = [UILabel new];
    sectionNodeLabel.textColor = CCITY_MAIN_FONT_COLOR;
    sectionNodeLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    sectionNodeLabel.text = model.projectName;
    
    [sectionHeader addSubview:headerImageView];
    [sectionHeader addSubview:sectionNodeLabel];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(sectionHeader).with.offset(11.5f);
        make.left.equalTo(sectionHeader).with.offset(10.f);
        make.bottom.equalTo(sectionHeader).with.offset(-11.5f);
        make.width.equalTo(headerImageView.mas_height);
    }];
    
    [sectionNodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerImageView);
        make.left.equalTo(headerImageView.mas_right).with.offset(10.f);
        make.bottom.equalTo(headerImageView);
        make.right.equalTo(sectionHeader);
    }];
    
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    CCityOfficalNewProjectModel* model = _dataArr[section];
    
    if (model.isOpen == NO) {   return 0;   }
    
    return model.detailDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalNewProjectModel* model = _dataArr[indexPath.section];
    
    if (!_dataArr.count) {
        UITableViewCell* cell = [UITableViewCell new];
        cell.textLabel.text = @"无数据";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    CCityOfficalDetailPersonListCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficalDeitalPersonListCellReuseId];
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    NSDictionary * dic = model.detailDataArr[indexPath.row];
    cell.projectModel = [[CCityOfficalNewProjectModel alloc]initWithDic:dic];
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    
    CCityOfficalNewProjectModel* model = _dataArr[indexPath.section];
    NSDictionary * dic = model.detailDataArr[indexPath.row];
    CCityOfficalNewProjectModel * projectModel = [[CCityOfficalNewProjectModel alloc]initWithDic:dic];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];//获取cell
    BEMCheckBox * checkBox = [cell.contentView viewWithTag:10000];
    projectModel.proChecked = !projectModel.proChecked;
    [checkBox setOn:projectModel.proChecked animated:NO];
    [checkBox reload];
    
    if (projectModel.proChecked) {
        [_selectedArr addObject:projectModel.proNum];
    } else {
        [_selectedArr removeObject:projectModel.proNum];
    }
}

@end


