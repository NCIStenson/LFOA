
//
//  CCityMainTaskDetailSearchVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define BG_COLOR CCITY_RGB_COLOR(240, 240, 240, 1.f)

#define CCITY_BEGIN_TIME @""
#define CCITY_END_TIME   @""

typedef NS_ENUM(NSUInteger, CCithMainDetailTaskSearchContentStyle) {
    
    CCithMainDetailTaskSearchContentGHYWStyle,
    CCithMainDetailTaskSearchContentDocStyle,
};

#import "CCityMainTaskDetailSearchVC.h"
#import "CCityMainDetailTaskSearchCell.h"
#import "CCityDatePickerVC.h"
#import "CCityDataPickerVC.h"
#import "CCityMainTaskSearchResultVC.h"
#import "CCityMainSearchTaskModel.h"
#import "CCLeftBarBtnItem.h"

@interface CCityMainTaskDetailSearchVC ()<CCityMainDetailTaskSearchCellDelegate>

@end

@implementation CCityMainTaskDetailSearchVC {
    
    NSMutableArray* _datasArr;
    CCithMainDetailTaskSearchContentStyle _contentStyle;
    UIView* _footerContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self backCon]];
//    高级搜索
    self.title = @"综合查询";
    self.view.backgroundColor = BG_COLOR;
    _contentStyle = CCithMainDetailTaskSearchContentGHYWStyle;

    self.tableView.sectionFooterHeight = 54.f;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self segconControl];
    self.tableView.rowHeight = 44.f;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark- --- layout

-(UIControl*)backCon {
    
    CCLeftBarBtnItem* backBtn = [CCLeftBarBtnItem new];
    backBtn.action = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    return backBtn;
}

-(UIView*)segconControl {
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 54.f)];
    UISegmentedControl* segControl = [[UISegmentedControl alloc]initWithItems:@[@"规划业务", @"公文"]];
    segControl.selectedSegmentIndex = _contentStyle;
    [segControl addTarget:self action:@selector(segconControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segControl.tintColor = CCITY_MAIN_COLOR;
    [headerView addSubview:segControl];
    
    [segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(headerView).with.insets(UIEdgeInsetsMake(20, 10, 5, 10));
    }];
    
    return headerView;
}

#pragma mark- --- configData

//    search action
-(void) searchAction {
    
    [SVProgressHUD show];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(_contentStyle) forKey:@"metatype"];
    [parameters setObject:@1  forKey:@"pageIndex"];
    [parameters setObject:@20 forKey:@"pageSize"];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    for (CCityMainDetailSearchModel* model in _datasArr) {
        
        if (model.value.length > 0) {
            
            [parameters setObject: model.value forKey:model.key];
        }
        
        if (model.timeBegin) {
            
            [parameters setObject:model.timeBegin forKey:@"t1"];
        }
        
        if (model.timeEnd) {
            
            [parameters setObject:model.timeEnd forKey:@"t2"];
        }
    }
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSString* url = @"service/form/AdvancedSearch.ashx";
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        [SVProgressHUD dismiss];
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self searchAction];
            }];
            return;
        }
        
        NSArray* results = responseObject[@"results"];
        if (!results.count) {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"结果为空" detail:nil];
        } else {
            
            NSMutableArray* datas = [NSMutableArray arrayWithCapacity:results.count];
            
            for (int i = 0; i < results.count; i++) {
                
                CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:results[i]];
                [datas addObject:model];
            }
            
            CCityMainTaskSearchResultVC* resultVC = [[CCityMainTaskSearchResultVC alloc]initDatas:datas url:url parameters:parameters];
            
            if (_contentStyle) {
                
                resultVC.mainStyle = 0;
            } else {
                
                resultVC.mainStyle = 1;
            }
          
            [self.navigationController pushViewController:resultVC animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

- (void)configData {
    
    if (_contentStyle == CCithMainDetailTaskSearchContentDocStyle) {
        
        _datasArr = [NSMutableArray arrayWithCapacity:5];
        
        for (int i = 0; i < 5; i++) {
            
            CCityMainDetailSearchModel* model = [CCityMainDetailSearchModel new];
            
            switch (i) {
                case 0:
                    
                    model.placeHolder = @"公文标题";
                    model.key = @"xmmc";
                    break;
                case 1:
                    
                    model.placeHolder = @"案卷编号";
                    model.key = @"ajbh";
                    break;
                    
                case 2:
                    
                    model.placeHolder = @"办理情况";
                    model.key = @"blzt";
                    break;
                    
                case 3:
                    
                    model.placeHolder = @"业务类型";
                    model.key = @"ywlx";
                    break;
                    
                case 4:
                    
                    if (!model.timeBegin) {
                        model.timeBegin = CCITY_BEGIN_TIME;
                    }
                    
                    if (!model.timeEnd) {
                        model.timeEnd   = CCITY_END_TIME;
                    }
                    
                    break;
                    
                default:
                    break;
            }
            
            [_datasArr addObject:model];
        }
        
    } else {
        
        _datasArr = [NSMutableArray arrayWithCapacity:9];
        
        for (int i = 0; i < 9; i++) {
            
            CCityMainDetailSearchModel* model = [CCityMainDetailSearchModel new];

            switch (i) {
                    
                case 0:
                    
                    model.placeHolder = @"项目名称";
                    model.key = @"xmmc";
                    break;
                case 1:
                    model.placeHolder = @"项目编号";
                    model.key = @"xmbh";
                    break;
                case 2:
                    
                    model.placeHolder = @"案卷编号";
                    model.key = @"ajbh";
                    break;
                case 3:
                    
                    model.placeHolder = @"建设单位";
                    model.key = @"jsdw";
                    break;
                case 4:
                    
                    model.placeHolder = @"办理情况";
                    model.key = @"blzt";
                    break;
                case 5:
                    
                    model.placeHolder = @"建设位置";
                    model.key = @"jswz";
                    break;
                    
                case 6:
                    
                    model.placeHolder = @"证号";
                    model.key = @"zh";
                    break;
                case 7:
                    
                    model.placeHolder = @"业务类型";
                    model.key = @"ywlx";
                    break;
                    
                case 8:
                    
                    if (!model.timeBegin) {
                        model.timeBegin = CCITY_BEGIN_TIME;
                    }
                    
                    if (!model.timeEnd) {
                        model.timeEnd   = CCITY_END_TIME;
                    }
                    
                    break;
                default:
                    break;
            }
            
            [_datasArr addObject:model];
        }
    }
}

#pragma mark- --- methods

- (void)keyboardWillShow {
    
    if (!_footerContentView.hidden) {
        _footerContentView.hidden = YES;
    }
}

- (void)keyboardWillHidden {
    
    if (_footerContentView.hidden) {
        _footerContentView.hidden = NO;
    }
}

- (void)segconControlValueChanged:(UISegmentedControl*)segControl {
    
    if (segControl.selectedSegmentIndex == 1) {
        
        _contentStyle = CCithMainDetailTaskSearchContentDocStyle;
    } else {
        
        _contentStyle = CCithMainDetailTaskSearchContentGHYWStyle;
    }
    
    [self configData];

    [self.tableView reloadData];
}

- (void) resetDataAction {
    
    for (CCityMainDetailSearchModel* model in _datasArr) {
        
        if (model.value) {
            model.value = nil;
        }
        
        if (![model.timeBegin isEqualToString:CCITY_BEGIN_TIME]) {
            
            model.timeBegin = CCITY_BEGIN_TIME;
        }
        
        if (![model.timeEnd isEqualToString:CCITY_END_TIME]) {
            
            model.timeEnd =CCITY_END_TIME;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark- --- uitableview delegate & datasource

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    _footerContentView = [UIView new];
    
    UIButton* resetDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetDataBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetDataBtn setBackgroundColor:CCITY_MAIN_COLOR];
    [resetDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetDataBtn addTarget:self action:@selector(resetDataAction) forControlEvents:UIControlEventTouchUpInside];
    resetDataBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:CCITY_MAIN_COLOR];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    [_footerContentView addSubview:resetDataBtn];
    [_footerContentView addSubview:searchBtn];
    
    [resetDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_footerContentView).with.offset(10.f);
        make.left.equalTo(_footerContentView).with.offset(10.f);
        make.bottom.equalTo(_footerContentView).with.offset(-10.f);
        make.right.equalTo(searchBtn.mas_left).with.offset(-40.f);
        make.width.equalTo(searchBtn);
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(resetDataBtn);
        make.left.equalTo(resetDataBtn.mas_right).with.offset(40.f);
        make.bottom.equalTo(resetDataBtn);
        make.right.equalTo(_footerContentView).with.offset(-10.f);
        make.width.equalTo(resetDataBtn);
    }];
    
    _footerContentView.backgroundColor = BG_COLOR;
    return _footerContentView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_datasArr.count*44>=self.view.bounds.size.height) {
        
        return _datasArr.count;
    } else {
        
        return self.view.bounds.size.height /44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > _datasArr.count-1) {
        
        UITableViewCell* cell = [UITableViewCell new];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        CCityMainDetailTaskSearchCell* cell = [[CCityMainDetailTaskSearchCell alloc]init];
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_contentStyle == CCithMainDetailTaskSearchContentDocStyle) {
            
            switch (indexPath.row) {
                    
                case 2:
                case 3:
                    
                    cell.searchStyle = CCityMainDetailTaskSearchCellTriangleTFStyle;
                    break;
                    
                case 4:
                    
                    cell.searchStyle = CCityMainDetailTaskSearchCellDateStyle;
                    break;
                    
                default:
                    
                    cell.searchStyle = CCityMainDetailTaskSearchCellNormalTFStyle;
                    break;
            }
        } else {
            
            switch (indexPath.row) {
                    
                case 4:
                case 7:
                    cell.searchStyle = CCityMainDetailTaskSearchCellTriangleTFStyle;
                    break;
                    
                case 8:
                    cell.searchStyle = CCityMainDetailTaskSearchCellDateStyle;
                    break;
                    
                default:
                    
                    cell.searchStyle = CCityMainDetailTaskSearchCellNormalTFStyle;
                    break;
            }
        }
        
        cell.backgroundColor = BG_COLOR;
        cell.model = _datasArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];

    if (indexPath.row > _datasArr.count-1) {
        return;
    }
    
    CCityMainDetailTaskSearchCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.searchStyle == CCityMainDetailTaskSearchCellTriangleTFStyle) {
        
        if ([cell.model.placeHolder isEqualToString:@"办理情况"]) {
            
             CCityDataPickerVC* dataPickerVC = [[CCityDataPickerVC alloc]initWtihDatas:@[@"在办" ,@"暂停" ,@"结案" ,@"归档" ,@"会议"]];
            dataPickerVC.didSelectData = ^(NSString *selectedData) {
                NSLog(@"%@",selectedData);
                cell.model.value = selectedData;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            dataPickerVC.title = cell.model.placeHolder;
        
            [self presentViewController:dataPickerVC animated:YES completion:nil];
            
        } else if ([cell.model.placeHolder isEqualToString:@"业务类型"]) {
            
            AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
            
            [SVProgressHUD show];
            
            [manager POST:@"service/form/GetFlowName.ashx" parameters:@{@"metatype":@(_contentStyle)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [SVProgressHUD dismiss];
                NSArray* results = responseObject[@"results"];
                
                CCityDataPickerVC* dataPickerVC = [[CCityDataPickerVC alloc]initWtihDatas:results];
                
                dataPickerVC.title = cell.model.placeHolder;
                
                dataPickerVC.didSelectData = ^(NSString *selectedData) {
                    
                    cell.model.value = selectedData;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                [self presentViewController:dataPickerVC animated:YES completion:nil];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [SVProgressHUD dismiss];
                [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
                NSLog(@"%@",error.description);
            }];
        }
    }
}

#pragma mark- --- cell delegate

-(void)valueSelected:(CCityMainDetailTaskSearchCell*)cell {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    CCityMainDetailSearchModel* model = _datasArr[indexPath.row];
    
    model.value = cell.myTextField.text;
}

-(void)timeDidselected:(CCityMainDetailTaskSearchCell*)cell tag:(NSInteger)tag {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    CCityMainDetailSearchModel* model = _datasArr[indexPath.row];
    
    CCityDatePickerVC* datePickerVC = [[CCityDatePickerVC alloc]init];
    [self presentViewController:datePickerVC animated:YES completion:nil];
        
    datePickerVC.slelectAction = ^(NSString *date) {
        
        if (cell.timeDidSelectAction) {
            
            cell.timeDidSelectAction(date, tag);
        }
        
        if (tag == 30001) {
            
            model.timeBegin = date;
        } else {
            
            model.timeEnd = date;
        }
        
        NSLog(@"%@------%@",model.timeBegin, model.timeEnd);
    };
    
}

@end
