//
//  CCHuiqianDetailVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCHuiqianDetailVC.h"
#import "CCHuiqianDetailCell.h"
#import "CCitySystemVersionManager.h"
#import "CCityBackToLeftView.h"
#import <TSMessage.h>

#define CC_LOCAL_TEXT_COLOR CCITY_RGB_COLOR(100, 100, 100, 1)
#define CC_LOCAL_BG_COLOR   CCITY_RGB_COLOR(241, 241, 241, 1)

@interface CCHuiqianDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCHuiqianDetailVC {
    
    UITableView*                _tableView;
    CCityOfficalDocDetailModel* _model;
    NSMutableDictionary*        _newValues;
    BOOL                        _isHaveData;
    CGRect                      _currentTextViewRect;
}

- (instancetype)initWithModel:(CCityOfficalDocDetailModel*)model title:(NSString*)title style:(CCHuiQianEditStyle)style
{
    self = [super init];
    if (self) {
       
        _model       = model;
        _editStyle   = style;
        _headerTitle = title;
        _isHaveData  = NO;
        if (style == CCHuiQianEditCheckStyle) { _editable = NO; }
        else {  _editable = YES;    }
      
        _newValues = [NSMutableDictionary new];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_editStyle == CCHuiQianEditAddStyle) {
        _huiQianModel = [_model.emptyHuiQianModel copy];
    } else {
        _huiQianModel = _model.huiQianMuArr[_innerRowNum];
    }
    
    UINavigationBar* navBar = [self navBar];
    navBar.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44.f);
    
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.f)];
    topView.backgroundColor = CCITY_MAIN_COLOR;
    
    _tableView = [self tableView];
    UIView* footerView = [self footerView];
    
    [self.view addSubview:navBar];
    [self.view addSubview: footerView];
    [self.view addSubview:_tableView];
    [self.view addSubview:topView];
    
    CGRect tableViewFrame = CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 80.f - 64.f);
    
    if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
        tableViewFrame.size.height = self.view.bounds.size.height - 100.f - 64.f;
    }
    _tableView.frame       = tableViewFrame;
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(UITableView*)tableView {
    
    UITableView* tableView = [UITableView new];
    tableView.tableHeaderView = [self tableHeaderView];
    tableView.separatorColor = CCITY_RGB_COLOR(237, 237, 237, 1);
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    [tableView registerNib:[UINib nibWithNibName:@"CCHuiqianDetailCell" bundle:nil] forCellReuseIdentifier:cellReuseId];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 44.f;
    tableView.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    return tableView;
}

-(UIView*)tableHeaderView {
    
    UIView* tableHeaderView = [UIView new];
    tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.f);
    tableHeaderView.backgroundColor = CC_LOCAL_BG_COLOR;
    UILabel* headerLabel = [UILabel new];
    headerLabel.textColor = CC_LOCAL_TEXT_COLOR;
    headerLabel.font = [UIFont systemFontOfSize:13.f];
    NSString* styleStr;
    
    switch (_editStyle) {
        case CCHuiQianEditCheckStyle:
            styleStr = @"查看";
            break;
        case CCHuiQianEditEditStyle:
            styleStr = @"编辑";
            break;
        case CCHuiQianEditAddStyle:
            styleStr = @"添加";
            break;
        default:
            styleStr = @"";
            break;
    }
    headerLabel.text = [NSString stringWithFormat:@"%@-%@", self.headerTitle, styleStr];
    headerLabel.frame = CGRectMake(30.f, 0, tableHeaderView.bounds.size.width - 30.f, tableHeaderView.bounds.size.height);
    [tableHeaderView addSubview:headerLabel];
    return tableHeaderView;
}

- (UINavigationBar*)navBar {
    
    UINavigationBar* navBar = [[UINavigationBar alloc]init];
    UINavigationItem* topItem = [[UINavigationItem alloc]initWithTitle:@"列表控件编辑器"];
    
    CCityBackToLeftView* backView = [CCityBackToLeftView new];
    backView.backgroundColor = CCITY_MAIN_COLOR;
    backView.userInteractionEnabled = YES;
    
    UIControl* backCon = [UIControl new];
    backCon.backgroundColor = CCITY_MAIN_COLOR;
    backCon.frame           = CGRectMake(0, 0, 60.f, 44.f);
    [backCon addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [backCon addSubview:backView];
    
    topItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
    
    navBar.items = @[topItem];
    navBar.translucent = NO;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = CCITY_MAIN_COLOR;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    return navBar;
}

-(UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = CC_LOCAL_BG_COLOR;
    
    NSMutableArray* btnsArr = [NSMutableArray arrayWithCapacity:2];
    
    if (_editable) {
        
        UIButton* saveBtn = [self btn];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:saveBtn];
        [btnsArr addObject:saveBtn];
    }
    
    UIButton* closeBtn = [self btn];
    [closeBtn setTitleColor:CC_LOCAL_TEXT_COLOR forState:UIControlStateNormal];
    closeBtn.backgroundColor = CCITY_RGB_COLOR(231, 231, 231, 1);
    closeBtn.layer.borderColor = CCITY_RGB_COLOR(218, 218, 218, 1).CGColor;
    closeBtn.layer.borderWidth = .5f;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:closeBtn];
    
    [btnsArr addObject:closeBtn];

    if (btnsArr.count > 1) {
        
    CGFloat padding = (self.view.bounds.size.width - 80 * btnsArr.count)-(btnsArr.count - 1);
    [btnsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:padding / 2.f tailSpacing:padding / 2.f];
    
    [btnsArr mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(20.f);
        make.height.mas_equalTo(40.f);
    }];
    } else {
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(footerView).with.offset(20.f);
            make.centerX.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width - 30.f, 40.f));
        }];
    }
    return footerView;
}

-(UIButton*)btn {
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = CCITY_MAIN_COLOR;
    btn.layer.cornerRadius = 5.f;
    btn.clipsToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --- keyboard

- (void)keyboardFrameChange:(NSNotification*)notfic {
    
    NSDictionary* userInfo = notfic.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float animateTime = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat bottom = _currentTextViewRect.origin.y + _currentTextViewRect.size.height + 64;
    
    if (bottom > keyboardFrame.origin.y) {

        [UIView animateWithDuration:animateTime animations:^{

            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y -= (bottom - keyboardFrame.origin.y);
            self.view.frame = viewFrame;
        }];
    } else {
        
        if (keyboardFrame.origin.y == self.view.bounds.size.height) {
            CGRect viewFrame = self.view.frame;
            if (viewFrame.origin.y != 0) {
                viewFrame.origin.y = 0;
                self.view.frame = viewFrame;
            }
        }
    }
}

#pragma mark --- methods

- (void) closeAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction {
    
    if (_isHaveData == NO) {
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据未改变无需保存" detail:nil];
        return;
    }
    
    for (CCHuiQianModel* model in _huiQianModel.contentsMuArr) {
        
        if (model.content.length > 0) {
             [_newValues setObject:@{@"#cdata-section":model.content} forKey: model.field];
        }
    }
    
    [_newValues addEntriesFromDictionary:@{
                                           @"@id" :_huiQianModel.rowId,
                                           @"@deleteFlag":@"false"
                                           }];
        
    NSDictionary* rows = @{@"Row":@[_newValues]};
    _parameters = @{_model.table:@{@"Rows":rows}};
        
    [self sendToServerWithModel:_huiQianModel];
}

#pragma mark- --- network

-(void)sendToServerWithModel:(CCHuiQianModel*)model {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSDictionary* datasDic = [NSDictionary dictionaryWithObject:_parameters forKey:@"root"];
    NSData* valuseData = [NSJSONSerialization dataWithJSONObject:datasDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString* valuesStr = [[NSString alloc]initWithData:valuseData encoding:NSUTF8StringEncoding];
    [parameters addEntriesFromDictionary:_docId];
    [parameters setObject:valuesStr forKey:@"formSaveStr"];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"service/form/Save.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (_editStyle == CCHuiQianEditAddStyle) {
         
            [self getNewIdWithModel:model];
        } else {
            
            [SVProgressHUD dismiss];

            CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
            
            if ([errorNoManager requestSuccess:responseObject]) {
                [self addSuccessWithModel:model];
                
                [CCityAlterManager showSimpleTripsWithVC:self Str:@"保存成功" detail:nil];
                
            } else {
                [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                    
                    [self sendToServerWithModel:_huiQianModel];
                }];
            }
        }
        
        if (CCITY_DEBUG) { NSLog(@"%@",responseObject); }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
            
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        if (CCITY_DEBUG) {  NSLog(@"%@",error); }
    }];
}

-(void) getNewIdWithModel:(CCHuiQianModel*)model {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSMutableDictionary* parameters = [_docId mutableCopy];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    [manager POST:@"service/form/FormDetail.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self getNewIdWithModel:_huiQianModel];
            }];
            return;
        }

            NSArray* form        = responseObject[@"form"];
            NSDictionary* rowDic = form[_outerRowNum];
            NSArray* columns     = rowDic[@"Columns"];
            NSDictionary* column = [columns firstObject];
            NSDictionary* values = column[@"Values"];
            NSMutableArray* keys = [values.allKeys mutableCopy];
            if (!_model.huiQianMuArr) {
                
                _model.huiQianMuArr = [NSMutableArray new];
                model.rowId = [keys firstObject];
            } else {
                
                for (CCHuiQianModel* huiqianModel in _model.huiQianMuArr) {
                    
                    [keys removeObject:huiqianModel.rowId];
                }
                
                model.rowId = [keys firstObject];
            }
            
            [self addSuccessWithModel:model];
        
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"保存成功" detail:nil];
//     else {
//
//            [TSMessage showNotificationWithTitle:@"保存成功，但未能成功刷新数据ID，将会影响到“详情”页面此条数据删除" type:TSMessageNotificationTypeWarning];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
      if (CCITY_DEBUG) {  NSLog(@"%@",error); }
        
    }];
}

-(void)addSuccessWithModel:(CCHuiQianModel*)model {
    
    if (_editStyle == CCHuiQianEditAddStyle) {
        
        [_model.huiQianMuArr addObject:model];
    }
    
    if (self.addSuccess) {    self.addSuccess();    }
}

#pragma mark- --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _huiQianModel.contentsMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCHuiqianDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if (cell.inputTextView.editable != _editable) {
        cell.inputTextView.editable = _editable;
    }

    CCHuiQianModel* model = _huiQianModel.contentsMuArr[indexPath.row];

    cell.titleLabel.text = [NSString stringWithFormat:@"%@：", model.title];

    if (_editable) {
        cell.inputTextView.delegate = self;
    } else {
        cell.inputTextView.editable = _editable;
    }

    cell.inputTextView.tag = 1000 + indexPath.row;

    if (_editStyle != CCHuiQianEditAddStyle) {
        cell.inputTextView.text = model.content;
    }
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
}

#pragma mark --- textview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    _currentTextViewRect = [_tableView rectForRowAtIndexPath: [NSIndexPath indexPathForRow:textView.tag - 1000 inSection:0]];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length <= 0) {    return; }
    
    if (!_isHaveData) { _isHaveData = YES;  }

    CCHuiQianModel* model = _huiQianModel.contentsMuArr[textView.tag - 1000];
    model.content = textView.text;
}

@end
