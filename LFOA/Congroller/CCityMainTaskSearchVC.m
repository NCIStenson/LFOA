//
//  CCityMainTaskSearchVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME @"mainTaskSearchHistory"

#import "CCityMainTaskSearchVC.h"
#import "CCityNoDataCell.h"
#import "CCityMainTaskDetailSearchVC.h"
#import "CCityFileManager.h"
#import "CCityMainTaskSearchCell.h"
#import "CCityMainTaskSearchResultVC.h"
#import "CCityMainSearchTaskModel.h"

@interface CCityMainTaskSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@end

static NSString* ccityMainTaskSerachCellReuseId = @"ccityMainTaskSerachCellReuseId";

@implementation CCityMainTaskSearchVC {
    
    UISearchBar*    _searchBar;
    NSMutableArray* _historyArr;
    NSMutableArray* _datasArr;
    BOOL            _isShowHistory;
    UITableView*    _tableView;
    NSString*       _searchStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _isShowHistory = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar.layer addSublayer:[self line]];

    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configData];
    self.title = @"综合查询";
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self writeData];
}

#pragma mark- --- layout

-(void)layoutMySubViews {
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [self rightBarBtn];
    
    _tableView = [self tableView];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

-(CAShapeLayer*)line {
    
    CAShapeLayer* line = [CAShapeLayer layer];
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    line.frame = CGRectMake(0, 44, self.view.bounds.size.width, .5f);
    return line;
}

// rightBarBtn
-(UIBarButtonItem*)rightBarBtn {
    
    UIBarButtonItem* rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"高级搜索" style:UIBarButtonItemStylePlain target:self action:@selector(detailSearch)];
    [rightBarBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
    return rightBarBtn;
}

//  tableView
-(UITableView*)tableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.tableHeaderView =  [self searchBar];
    _tableView.tableFooterView = [self footerBtn];
    _tableView.sectionFooterHeight = .1f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CCityMainTaskSearchCell class] forCellReuseIdentifier:ccityMainTaskSerachCellReuseId];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 44.f;
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [_tableView addGestureRecognizer:tableViewGesture];
    return _tableView;
}

-(UIButton*)footerBtn {
    
    UIButton* footerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footerBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.f);
    [footerBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [footerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    return footerBtn;
}

-(UISearchBar*)searchBar {
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.f);
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.backgroundImage = [[UIImage alloc]init];
    
    CAShapeLayer* layer = [self line];
    layer.backgroundColor = CCITY_RGB_COLOR(0, 0, 0, .2f).CGColor;
    layer.frame = CGRectMake(0, 43.5, self.view.bounds.size.width, .5f);

    [_searchBar.layer addSublayer:layer];
    
    return _searchBar;
}

#pragma mark- --- config datas

- (void)configData {
    
    CCityFileManager* fileManager = [[CCityFileManager alloc]init];
    
    _historyArr = [NSMutableArray arrayWithContentsOfFile:[fileManager getCacheDirFileWithFileName:CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME]];
    
    [_tableView reloadData];
}

-(void)searchActionWithStr:(NSString*)searchStr {
    
    [SVProgressHUD show];
    
    NSDictionary* paramters = @{
                  @"token"    :[CCitySingleton sharedInstance].token,
                  @"value"    :searchStr,
                  @"deptname" :[CCitySingleton sharedInstance].deptname,
                  @"pageSize" :@20,
                  @"pageIndex":@1
                  };
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:@"service/form/ColligateSearch.ashx" parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self searchActionWithStr:_searchStr];
            }];
            return;
        }
        
        NSArray* datas = responseObject[@"results"];
        NSMutableArray* resultArr = [NSMutableArray array];
        if (!datas.count) {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"结果为空" detail:nil];
        } else {
            
            for (int i = 0; i < datas.count; i++) {
                
                CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:datas[i]];
                [resultArr addObject:model];
            }
        }
        
        CCityMainTaskSearchResultVC* resultVC = [[CCityMainTaskSearchResultVC alloc]initDatas:resultArr url:@"service/form/ColligateSearch.ashx" parameters:paramters];
        [self.navigationController pushViewController:resultVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- methods

- (void)tableViewTouchInSide {
    
    [self hiddenKeyboard];
}

-(BOOL)writeData {
    
    CCityFileManager* fileManager = [[CCityFileManager alloc]init];
    NSString* cachePath = [fileManager getCacheDirFileWithFileName:CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME];
    NSMutableArray* arr = [NSMutableArray arrayWithContentsOfFile:cachePath];
    
    if ([arr isEqualToArray:_historyArr]) {
        
        return YES;
    } else {
        
        return [_historyArr writeToFile:cachePath atomically:YES];
    }
}

-(void)hiddenKeyboard {
    
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

//    clearHistory
-(void)clearHistory {
    
    if (_historyArr) {
        [_historyArr removeAllObjects];
        [_tableView reloadData];
    }
    [self hiddenKeyboard];
}

- (void)detailSearch {
    
    CCityMainTaskDetailSearchVC* detailVC = [[CCityMainTaskDetailSearchVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:NO];
}

-(NSString*)deleteSpaceWithStr:(NSString*)str {
    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isShowHistory) {
        
        return _historyArr.count?_historyArr.count:1;
    } else {
        
        return _datasArr.count?_datasArr.count:1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_isShowHistory) {
        return 30.f;
    } else {
       return 0.f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_isShowHistory) {
        
        UILabel* label = [UILabel new];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.firstLineHeadIndent = 15.f;
        label.attributedText = [[NSAttributedString alloc]initWithString:@"历史记录" attributes:@{ NSParagraphStyleAttributeName  : paragraphStyle,
            NSForegroundColorAttributeName : [UIColor blackColor],
//          NSFontAttributeName            : font,
            }];
        
        label.backgroundColor = CCITY_RGB_COLOR(247, 247, 247, 1.f);
        return label;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isShowHistory) {
        
        if (!_historyArr.count) {
            
            CCityNoDataCell* cell = [[CCityNoDataCell alloc]init];
            
            return cell;
        } else {
            
            CCityMainTaskSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityMainTaskSerachCellReuseId];
            
            cell.deleteSelf = ^(CCityMainTaskSearchCell *cell) {
              
                [_historyArr removeObjectAtIndex:indexPath.row];

                if (_historyArr.count >=1) {
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                } else {
                    
                    [_tableView reloadData];
                }
               
            };
            cell.textLabel.text = _historyArr[indexPath.row];
            return cell;
        }
        
    } else {
        
        if (!_datasArr.count) {
            
            CCityNoDataCell* cell = [[CCityNoDataCell alloc]init];
            return cell;
        } else {
           
            UITableViewCell* cell = [UITableViewCell new];
            return cell;
        }
    }
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_historyArr.count) {   return; }
    
    [self hiddenKeyboard];
    
    if (_isShowHistory) {
        
        if ([_searchBar.text isEqualToString:_historyArr[indexPath.row]]) {
            
            _searchBar.text = _historyArr[indexPath.row];
        }
        
        _searchStr = _historyArr[indexPath.row];
        [self searchActionWithStr:_searchStr];
    } else {
        
    }
}

#pragma mark- --- searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString* searchStr = [self deleteSpaceWithStr:searchBar.text];
    
    if (searchStr.length > 0) {
        
        if (!_historyArr.count) {
            _historyArr = [NSMutableArray array];
        }
        
        if (![_historyArr containsObject:searchStr]) {
            [_historyArr insertObject:searchStr atIndex:0];
            
            [_tableView reloadData];
        }
        
        _searchStr = searchStr;
        [self searchActionWithStr:_searchStr];
        
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self hiddenKeyboard];
}

@end
