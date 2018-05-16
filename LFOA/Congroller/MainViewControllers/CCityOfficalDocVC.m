//
//  CCityOfficalDocVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_OFFICAL_DOC_SEARCH_COLOR  CCITY_RGB_COLOR(230, 230, 230, 1)
#define PAGEINDEX_KEY @"pageIndex"

#define BACKLOG_URL        @"service/gw/gwdblist.ashx"
#define HAVE_DONE_URL      @"service/gw/gwyblist.ashx"
#define REACIVE_READ_URL   @"service/gw/gwsylist.ashx"

#define SP_BACKLOG_URL        @"service/xm/xmdblist.ashx"
#define SP_HAVE_DONE_URL      @"service/xm/xmyblist.ashx"
#define SP_REACIVE_READ_URL   @"service/xm/xmsylist.ashx"

#define CCITY_SEARCH_KEY [NSString stringWithFormat:@"searchParm%d", contentMode]

#import "CCityOfficalDocVC.h"
#import "CCityOfficalDocModel.h"
#import "CCityOfficalBackLogCell.h"
#import "CCityJSONNetWorkManager.h"
#import "CCitySecurity.h"

@interface CCityOfficalDocVC ()<UISearchBarDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@end

static NSString* officalBackLogCellReuseId = @"officalBackLogCellReuseId";

@implementation CCityOfficalDocVC {
    
    UISearchBar*               _searchBar;
    
    CCityOfficalDocContentMode contentMode;
    NSMutableDictionary*       _subDataDic;
    
    NSMutableDictionary*       parameters;
    NSString*                  currentUrl;
    NSMutableDictionary*       _contentParameters;
    
    UIButton* clearBtn;
    NSInteger pageContentNum;
    
    NSURLSessionDataTask* currentTask;
    
    UIScrollView* _scrollView;   // main content scrollview
    NSMutableArray* tableViewArr;
    BOOL    _userChanged;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageContentNum      = 20;
    
    [self layoutOfficalDocsubViews];
    
    _contentParameters = [@{
                           @"backLog"   :@1,
                           @"haveDone"  :@1,
                           @"reciveRead":@1,
                           } mutableCopy];
    
    _subDataDic = [NSMutableDictionary dictionaryWithCapacity:3];
    
//    if (self.tableView) {   self.tableView = nil;   }
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    rightBarButtonItem.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    if (self.tableView) {   self.tableView = nil;   }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!parameters) {

        if (![CCitySingleton sharedInstance].token) {
            
            [CCitySingleton sharedInstance].userName = [CCitySecurity getSession];
        }
        
        parameters = [@{@"token": [CCitySingleton sharedInstance].token, @"pageSize":@(pageContentNum)} mutableCopy];
    }
    
    if (![parameters[@"token"] isEqual:[CCitySingleton sharedInstance].token]) {
        
        [self initDatas];
    }
    
    [self changeDataWithMode:contentMode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    if (currentTask.state == NSURLSessionTaskStateRunning) {
        [currentTask cancel];
    }
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark- --- layoutMusubViews

- (void)layoutOfficalDocsubViews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44.f, self.view.bounds.size.width, self.view.bounds.size.height - 108-49.f)];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = CCITY_MAIN_BGCOLOR;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, 0);
    
    _scrollView.tag = 1000000;
    
    tableViewArr = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i++) {
            
        UITableView* tableView = [[UITableView alloc]init];
//        [tableView registerClass:[CCityOfficalBackLogCell class] forCellReuseIdentifier:officalBackLogCellReuseId];
//        tableView.rowHeight = 60.f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
        tableView.frame = CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        
        MJRefreshNormalHeader* header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        
        tableView.mj_header = header;
        [tableViewArr addObject:tableView];
        
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        
        [_scrollView addSubview:tableView];
    }
    
    [self.view addSubview:_scrollView];
}

#pragma mark- --- methods 

-(void)initDatas {
    
    parameters[@"token"] = [CCitySingleton sharedInstance].token;
    [_subDataDic removeAllObjects];
    
    _contentParameters = [@{
                            @"backLog"   :@1,
                            @"haveDone"  :@1,
                            @"reciveRead":@1,
                            } mutableCopy];
}

-(void)changePageIndexWithIndex:(NSInteger)index {
    
    switch (contentMode) {
        case CCityOfficalDocBackLogMode:
            
            _contentParameters[@"backLog"] =@(index);
            break;
            
        case CCityOfficalDocReciveReadMode:
            
            _contentParameters[@"reciveRead"] = @(index);
            break;
            
        case CCityOfficalDocHaveDoneMode:
            
             _contentParameters[@"haveDone"] =@(index);
            break;
            
        default:
            break;
    }
}

- (NSInteger)getMyPageIndex {
    
    NSInteger pageIndex;
    
    switch (contentMode) {
        case CCityOfficalDocBackLogMode:
            
          pageIndex = [_contentParameters[@"backLog"] integerValue];
            break;
            
        case CCityOfficalDocReciveReadMode:
            
          pageIndex =  [_contentParameters[@"reciveRead"] integerValue];
            break;
            
        case CCityOfficalDocHaveDoneMode:
            
          pageIndex =  [_contentParameters[@"haveDone"] integerValue];
            break;
            
        default:
            break;
    }
    
    return pageIndex;
}

// search bar
-(void) searchAction {
    
    if (!_searchBar) {
       
        _searchBar              = [[UISearchBar alloc]init];
        _searchBar.delegate     = self;
        _searchBar.tintColor    = [UIColor blackColor];
        _searchBar.barTintColor = CCITY_OFFICAL_DOC_SEARCH_COLOR;
        _searchBar.hidden = YES;
        [self.view addSubview:_searchBar];
    }

    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.segCon.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44.f);
    }];
    
    CGRect scrollViewFrame = _scrollView.frame;

    if (_searchBar.hidden) {
        
        _searchBar.hidden = NO;
        scrollViewFrame.origin.y = 88;
    } else {
        
        [self cancelSearch];
        _searchBar.hidden = YES;
        scrollViewFrame.origin.y = 44;
    }
    
    _scrollView.frame = scrollViewFrame;
}

// cancel search
- (void)cancelSearch {
    
    for (int i = 0; i < 3; i++) {
        
        NSString* searchKey = [NSString stringWithFormat:@"searchParm%d",i];
        
        if (_contentParameters[searchKey]) {
            
            [_contentParameters removeObjectForKey:searchKey];
//            [_subDataDic removeObjectForKey:@(i)];
        }
    }
    [_subDataDic removeAllObjects];
    [self changeDataWithMode:contentMode];
}

// hidden keyboard
-(void) hiddenKeyboary {
    
    if ([_searchBar isFirstResponder]) {    [_searchBar resignFirstResponder];  }
}

// header mode btn changed
-(void)segmentedConValueChanged:(CCitySegmentedControl *)segCon {
    
    [super segmentedConValueChanged:segCon];
    contentMode = segCon.selectedIndex;
    
    if (_searchBar) {
        
        _searchBar.text =_contentParameters[CCITY_SEARCH_KEY];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
          [_scrollView setContentOffset:CGPointMake(self.view.bounds.size.width*segCon.selectedIndex, 0) animated:NO];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self changeDataWithMode:segCon.selectedIndex];
    });
}

- (void) changeDataWithMode:(CCityOfficalDocContentMode)mode {
    
    if (contentMode != mode) {
        
        contentMode = mode;
    }
    
    switch (contentMode) {
            
        case CCityOfficalDocBackLogMode:
            
            if (self.mainStyle == CCityOfficalMainDocStyle) {
                currentUrl = BACKLOG_URL;
            } else {
                currentUrl = SP_BACKLOG_URL;
            }
            break;
        case CCityOfficalDocHaveDoneMode:
            
            if (self.mainStyle == CCityOfficalMainDocStyle) {
                currentUrl = HAVE_DONE_URL;
            }   else {
                currentUrl = SP_HAVE_DONE_URL;
            }
            break;
        case CCityOfficalDocReciveReadMode:
            
            if (self.mainStyle == CCityOfficalMainDocStyle)  {
                
                currentUrl = REACIVE_READ_URL;
            } else {
                
                currentUrl = SP_REACIVE_READ_URL;
            }
            
            break;
        default:
            break;
    }
    
    [self reoadDataWithIndex:contentMode url:currentUrl];
}

//*************************************** mode change method ****************************

- (void)reoadDataWithIndex:(NSInteger)index url:(NSString*)url{
    
    if (_subDataDic[@(contentMode)]) {
            
        UITableView* tableView = tableViewArr[contentMode];
        [tableView reloadData];
     
    } else {
        
        [self configDataWithURL:url];
    }
}

#pragma mark- --- refresh

-(void)headerRefresh {
    
    [self changePageIndexWithIndex:1];
    [self configDataWithURL:currentUrl];
    UITableView* tableView = tableViewArr[contentMode];
    
    [tableView.mj_footer resetNoMoreData];
}

-(void)footerRefresh {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSInteger pageIndex = [self getMyPageIndex];
    
    pageIndex += 1;
    
    [self changePageIndexWithIndex:pageIndex];
    
    parameters[PAGEINDEX_KEY] = @(pageIndex);
    
    UITableView* tableView = tableViewArr[contentMode];
    NSMutableArray* dataArr = _subDataDic[@(contentMode)];
    
    currentTask = [manager POST:currentUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* results = responseObject[@"results"];
        
        if (results.count) {
            
            NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:results.count];
            
            [tableView beginUpdates];
            
            NSInteger curretnCellNumber = dataArr.count;
            
            for (int i = 0; i < results.count; i++) {
                
                CCityOfficalDocModel* model = [[CCityOfficalDocModel alloc]initWithDic:results[i]];
                [indexPaths addObject:[NSIndexPath indexPathForRow:dataArr.count inSection:0]];
                [dataArr addObject:model];
            }
            
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView endUpdates];
            
            if (results.count*60.f >= tableView.bounds.size.height) {
                
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:curretnCellNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            } else {
                
            }
            
            [tableView.mj_footer endRefreshing];
        } else {
            
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
        UITableView* tableView = tableViewArr[contentMode];

        NSInteger pageIndex = [self getMyPageIndex];
        pageIndex -= 1;
        [self changePageIndexWithIndex:pageIndex];
        [tableView.mj_footer endRefreshing];
    }];
}

#pragma mark- --- netWork

- (void)configDataWithURL:(NSString*)url {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    parameters[PAGEINDEX_KEY] = @([self getMyPageIndex]);
    
    if (_contentParameters[CCITY_SEARCH_KEY]) {
        
        [parameters setObject:_contentParameters[CCITY_SEARCH_KEY] forKey:@"search"];
    } else {
        
        if (parameters[@"search"]) {
            
            [parameters removeObjectForKey:@"search"];
        }
    }
    
    CCityOfficalDocContentMode mode = contentMode;
    
   currentTask = [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       [SVProgressHUD dismiss];
       
       CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
       if (![errorNoManager requestSuccess:responseObject]) {
           
           [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
               [self initDatas];
               [self configDataWithURL:currentUrl];
           }];
           return;
       }
       
        NSArray* datasArr = responseObject[@"results"];
       
        NSMutableArray* dataMuArr = [NSMutableArray arrayWithCapacity:datasArr.count];
       
        for (int i = 0; i < datasArr.count; i++) {
            
            CCityOfficalDocModel* model = [[CCityOfficalDocModel alloc]initWithDic:datasArr[i]];
            [dataMuArr addObject:model];
        }
       
        [_subDataDic setObject:dataMuArr forKey:@(mode)];
       dispatch_async(dispatch_get_main_queue(), ^{
           
           [SVProgressHUD dismiss];
           
           UITableView* tableView = tableViewArr[mode];
           
           [tableView reloadData];
           
           if (tableView.mj_header.state == MJRefreshStateRefreshing) {
               
               [tableView.mj_header endRefreshing];
           }
       });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            UITableView* tableView = tableViewArr[mode];
            
            [tableView.mj_header endRefreshing];
        });
        
        NSLog(@"%@",error);

    }];
}

//*************************************** mode change method end ****************************

#pragma mark- --- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray* dataArr = _subDataDic[@(contentMode)];
    
    return dataArr.count?dataArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray* dataArr = _subDataDic[@(contentMode)];
    
    if (!dataArr.count) {
        
        UITableViewCell* cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"无数据";
        return cell;
    }
    
    CCityOfficalBackLogCell* cell = [tableView dequeueReusableCellWithIdentifier:officalBackLogCellReuseId];
    
    if (!cell) {

        cell = [[CCityOfficalBackLogCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:officalBackLogCellReuseId mainStyle:_mainStyle conentMode:contentMode];
    }
    
    CCityOfficalDocModel* model = dataArr[indexPath.row];
    
    if (model.mainStyle != _mainStyle) {
        model.mainStyle = _mainStyle;
    }
    
    if (model.contentMode != contentMode) {
        model.contentMode = contentMode;
    }
    
    cell.model = model;
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray* dataArr = _subDataDic[@(contentMode)];
    
    if (!dataArr.count) {  return; }
    
    CCityOfficalDocModel* model = dataArr[indexPath.row];
    
    switch (contentMode) {
            
        case CCityOfficalDocBackLogMode:
           
            if (model.isRead == NO) { model.isRead = YES;  }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case CCityOfficalDocHaveDoneMode:
            
            break;
        case CCityOfficalDocReciveReadMode:
            
            if (model.isRead == NO) { model.isRead = YES;  }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
    
     [self pushToDocDetailVCWithId:model indexPath:indexPath];
}

- (void)pushToDocDetailVCWithId:(CCityOfficalDocModel*)model indexPath:(NSIndexPath*)indexPath {
    
    NSArray* itemsArr;
    
    if (_mainStyle == CCityOfficalMainDocStyle) {
        
        itemsArr = @[@"表单信息",@"公文材料"];
    } else if (_mainStyle == CCityOfficalMainSPStyle) {
        
        itemsArr = @[@"表单信息",@"材料清单"];
    }
    
    CCityOfficalDocDetailVC* docDetialVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:itemsArr Id:model.docId contentModel:contentMode];
    docDetialVC.hidesBottomBarWhenPushed = YES;
    docDetialVC.indexPath  = indexPath;
    docDetialVC.mainStyle  = _mainStyle;
    docDetialVC.passPerson = model.passPerson;
    docDetialVC.passOponio = model.passOpinio;
    
    docDetialVC.sendActionSuccessed = ^(NSIndexPath *indexPath) {
      
        NSMutableArray* dataArr = _subDataDic[@(contentMode)];
        UITableView* tableView = tableViewArr[contentMode];
        
        [tableView beginUpdates];
        
        [dataArr removeObjectAtIndex:indexPath.row];
        
        if (dataArr.count) {    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];   }
        
        else {    [tableView reloadData]; }
        
        [tableView endUpdates];
    };
    
    [self.navigationController pushViewController:docDetialVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (contentMode == CCityOfficalDocBackLogMode) {
        
        return 70.f;
    }
    
    return 55.f;
}

#pragma mark- --- searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!clearBtn) {
        
        UITextField* tf = [searchBar valueForKey:@"_searchField"];
        for (UIView* view in tf.subviews) {
            
            if ([view isKindOfClass:[UIButton class]]) {
                
                clearBtn = (UIButton*)view;
                [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

// clear action

- (void) clearAction {
    
    [self hiddenKeyboary];
    [self searchAction];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self hiddenKeyboary];
    if (searchBar.text) {
        
        [_contentParameters setObject:searchBar.text forKey:CCITY_SEARCH_KEY];
        [_subDataDic removeObjectForKey:@(contentMode)];
        [self changeDataWithMode:contentMode];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self hiddenKeyboary];
    [self searchAction];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = NO;
}

#pragma mark- --- uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = _scrollView.contentOffset.x / self.view.bounds.size.width;
    
    if (self.segCon.selectedIndex!= index) {
        
         self.segCon.selectedIndex = index;
    }
}

@end
