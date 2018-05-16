//
//  CCityOfficalDetailPsrsonListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define kFirstLetterHeight 40.0f

#import "CCityOfficalDetailPsrsonListVC.h"
#import "CCityOfficalDetailPersonListCell.h"
#import "CCityOffialSendPersonListModel.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityAlterManager.h"
#import "CCitySystemVersionManager.h"

@interface CCityOfficalDetailPsrsonListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

static NSString* ccityOfficalDeitalPersonListCellReuseId = @"ccityOfficalDeitalPersonListCellReuseId";

@implementation CCityOfficalDetailPsrsonListVC {
    
    NSMutableDictionary* _ids;
    NSArray*            _dataArr;
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
    self.title = @"发送给";
    
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
    
    [sendBtn setTitle:@"提 交" forState:UIControlStateNormal];
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
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSString* userIdsStr = @"";
    
    for (int i = 0; i < _selectedArr.count; i++) {
        userIdsStr = [userIdsStr stringByAppendingString:_selectedArr[i]];
        if (i != _selectedArr.count -1) {
            userIdsStr = [userIdsStr stringByAppendingString:@","];
        }
    }
    
    NSMutableDictionary* parameters = [@{@"toNode"   :_fkNode,
                                         @"token"    :[CCitySingleton sharedInstance].token,
                                         @"usernames":userIdsStr,
                                         } mutableCopy];
    
    [parameters addEntriesFromDictionary:_ids];
    
    [manager POST:@"service/form/Send.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if ([errorNoManager requestSuccess:responseObject]) {
            
            [self sendSuccess];
        } else {
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self sendAction];
            }];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
    }];
    
}

- (void)configData {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    for (NSString* key in _ids.allKeys) {
        
        if ([key isEqualToString:@"fk_flow"]) {
            
            [_ids setObject:_ids[@"fk_flow"] forKey:@"fkFlow"];
            [_ids removeObjectForKey:@"fk_flow"];
        }
    }
    [_ids setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    [SVProgressHUD show];
    
    [manager GET:@"service/form/GetAccepter.ashx" parameters:_ids progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"status"] isEqualToString:@"failed"]){
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据错误" detail:nil];
        }else{
            if([CCUtil isNotNull:[responseObject objectForKey:@"result"]]){
                NSArray* datasArr = [responseObject objectForKey:@"result"];
                
                NSMutableArray* muDataArr = [NSMutableArray arrayWithCapacity:datasArr.count];
                
                for (int i = 0 ; i < datasArr.count; i++) {
                    CCityOffialSendPersonListModel* model = [[CCityOffialSendPersonListModel alloc]initWithDic:datasArr[i]];
                    if (datasArr.count == 1) {
                        model.isOpen = YES;
                    }
                    [muDataArr addObject:model];
                }
                
                _dataArr = [muDataArr mutableCopy];
                [_tableView reloadData];
                
                [SVProgressHUD dismiss];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",task.currentRequest.URL.absoluteString);
        NSLog(@"%@",error);
    }];
}
#pragma mark- --- metods

- (void) dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendSuccess {
    
    if ([self.delegate respondsToSelector:@selector(viewControllerDismissActoin)]) {
        
        [self.delegate viewControllerDismissActoin];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)headerSectionAction:(UIControl*)headerSction {
    NSInteger section = headerSction.tag - 4000;
    CCityOffialSendPersonListModel* model = _dataArr[section];
    model.isOpen = !model.isOpen;
    
    for (int i = 0 ; i < _dataArr.count; i++) {
        CCityOffialSendPersonListModel* model = _dataArr[i];
        if (section != i) {
            model.isOpen = NO;
        }
    }
    
    for (int i = 0 ; i < _dataArr.count; i ++ ) {
        CCityOffialSendPersonListModel* model = _dataArr[i];
        for (int j = 0; j < model.firstLetterArr.count; j ++) {
             NSArray * arr = [model.formatDataDic objectForKey:model.firstLetterArr[j]];
            for (int k = 0; k < arr.count; k ++ ) {
                CCityOfficalSendPersonDetailModel * detailModel = arr[k];
                detailModel.isSelected = NO;
            }
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
    CCityOffialSendPersonListModel* model = _dataArr[indexPath.section];
    
    NSString * keyValue = model.firstLetterArr[indexPath.row];
    
    NSArray * contentArr = [model.formatDataDic objectForKey:keyValue];
    
    return kFirstLetterHeight + contentArr.count * 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIControl* sectionHeader = [UIControl new];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.tag = 4000 + section;
    [sectionHeader addTarget:self action:@selector(headerSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CCityOffialSendPersonListModel* model = _dataArr[section];
    
    UIImageView* headerImageView = [[UIImageView alloc]init];
    headerImageView.image = [UIImage imageNamed:@"ccity_offical_sendDoc_node_50x50_"];
    
    UILabel* sectionNodeLabel = [UILabel new];
    sectionNodeLabel.textColor = CCITY_MAIN_FONT_COLOR;
    sectionNodeLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    sectionNodeLabel.text = model.groupTitle;
    
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
    
    CCityOffialSendPersonListModel* model = _dataArr[section];
    
    if (model.isOpen == NO) {   return 0;   }
    
    return model.firstLetterArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOffialSendPersonListModel* model = _dataArr[indexPath.section];
    
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
    
    NSString * keyValue = model.firstLetterArr[indexPath.row];
    cell.firstLetter = keyValue;
    NSArray * arra = [model.formatDataDic objectForKey:keyValue];
    cell.modelArr = arra;
    for (int i = 0; i < arra.count; i ++) {
        UIButton * clickContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickContentBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:clickContentBtn];
        clickContentBtn.frame = CGRectMake(0, 44 * i + kFirstLetterHeight, SCREEN_WIDTH, 44.0f);
        clickContentBtn.tag = 500 + i;
        [clickContentBtn addTarget:self action:@selector(didselectContent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)didselectContent:(UIButton *)btn{
    UIView *v = [btn superview];//获取button所在的父类视图UITableViewCellContentView
    UITableViewCell *cell = (UITableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];//获取cell对应的section
    NSInteger btnIndex =btn.tag - 500;
    
    BEMCheckBox * checkBox = [cell viewWithTag:10000 + btnIndex];
    
    CCityOffialSendPersonListModel* model = _dataArr[indexPathAll.section];
    
    CCityOfficalSendPersonDetailModel* cellModel = [model.formatDataDic objectForKey:model.firstLetterArr[indexPathAll.row]] [btnIndex];
    
    cellModel.isSelected = !cellModel.isSelected;
    
    [checkBox setOn:cellModel.isSelected animated:NO];
    [checkBox reload];
    NSLog(@"  %@  ===  %@",cellModel.pinyin,cellModel.firstLetter);
    NSLog(@" _fkNode == %@",_fkNode );
    
    if (!_fkNode) {
        if (cellModel.isSelected) {
            [_selectedArr addObject:cellModel.personId];
        }
        _fkNode = model.fkNode;
    }else{
        if (cellModel.isSelected) {
            [_selectedArr addObject:cellModel.personId];
        } else {
            [_selectedArr removeObject:cellModel.personId];
        }
    }
    //    else {
    //
    //        if ([_fkNode isEqualToString:model.fkNode]) {
    //            if (cellModel.isSelected) {
    //                [_selectedArr addObject:cellModel.personId];
    //            } else {
    //                [_selectedArr removeObject:cellModel.personId];
    //            }
    //        } else {
    //
    //            NSMutableArray* indextPathArr = [NSMutableArray new];
    //
    //            CCityOffialSendPersonListModel* selectedModel = _dataArr[_selectedSection];
    //            for (int i = 0; i < selectedModel.groupItmes.count; i++) {
    //
    //                CCityOfficalSendPersonDetailModel* oldDetailModel = selectedModel.groupItmes[i];
    //                if (oldDetailModel.isSelected) {
    //
    //                    [indextPathArr addObject:[NSIndexPath indexPathForRow:i inSection:_selectedSection]];
    //                    oldDetailModel.isSelected = NO;
    //                }
    //            }
    //
    //            [_tableView reloadRowsAtIndexPaths:indextPathArr withRowAnimation:UITableViewRowAnimationNone];
    //
    //            [_selectedArr removeAllObjects];
    //            [_selectedArr addObject:cellModel.personId];
    //            _fkNode = model.fkNode;
    //        }
    //    }
    //    _selectedSection = indexPathAll.section;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    CCityOfficalDetailPersonListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    CCityOffialSendPersonListModel* model = _dataArr[indexPath.section];
//    CCityOfficalSendPersonDetailModel* cellModel = model.groupItmes[indexPath.row];
//
//    cellModel.isSelected = !cellModel.isSelected;
//
//    [cell.checkBox setOn:cellModel.isSelected animated:NO];
//    [cell.checkBox reload];
//
//    NSLog(@"  %@  ===  %@",cellModel.pinyin,cellModel.firstLetter);
//
//    if (!_fkNode) {
//        if (cellModel.isSelected) {
//            [_selectedArr addObject:cellModel.personId];
//        }
//        _fkNode = model.fkNode;
//    } else {
//
//        if ([_fkNode isEqualToString:model.fkNode]) {
//
//            if (cellModel.isSelected) {
//                [_selectedArr addObject:cellModel.personId];
//            } else {
//                [_selectedArr removeObject:cellModel.personId];
//            }
//        } else {
//
//            NSMutableArray* indextPathArr = [NSMutableArray new];
//
//            CCityOffialSendPersonListModel* selectedModel = _dataArr[_selectedSection];
//            for (int i = 0; i < selectedModel.groupItmes.count; i++) {
//
//                CCityOfficalSendPersonDetailModel* oldDetailModel = selectedModel.groupItmes[i];
//                if (oldDetailModel.isSelected) {
//
//                    [indextPathArr addObject:[NSIndexPath indexPathForRow:i inSection:_selectedSection]];
//                    oldDetailModel.isSelected = NO;
//                }
//            }
//
//            [_tableView reloadRowsAtIndexPaths:indextPathArr withRowAnimation:UITableViewRowAnimationNone];
//
//            [_selectedArr removeAllObjects];
//            [_selectedArr addObject:cellModel.personId];
//            _fkNode = model.fkNode;
//        }
//    }
//    _selectedSection = indexPath.section;
//}

@end

