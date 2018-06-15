//
//  CCityNewNewsVC.m
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#define kBottomBtnHeight (IPHONEX ? 74 : 50)

#import "CCityNewNewsVC.h"
#import "ZSSRichTextEditor.h"
#import "ZSSDemoViewController.h"
#import "CCityNewMeetingCell.h"

#import "ZSSDemoViewController.h"
#import "CCityOptionDetailView.h"

#import "CCityMainMeetingListModel.h"

@interface CCityNewNewsVC ()<CCityNewMeetingCellDelegate,CCityOptionDetailViewDelegate>
{
    NSString * _htmlStr;
    
    ZSSDemoViewController * _demoViewController;
    
    NSMutableDictionary * _uploadParameters;
    CCityOptionDetailView * _optionDetailView;
}
@end

static NSString * CCITYNEWCELLID = @"CCITYNEWCELLID";

@implementation CCityNewNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布新闻";
    _uploadParameters = [NSMutableDictionary dictionary];
    [self initView];
}

#pragma mark - View Will Appear Section
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //Add observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - View Will Disappear Section
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //Remove observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)initView{
    UIView * _footerView =[self footerView];
    [self.view addSubview:_footerView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.bottom.equalTo(self.view).with.offset(-kBottomBtnHeight);
        } else {
            
            make.bottom.equalTo(self.view).with.offset(-kBottomBtnHeight);
        }
    }];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.equalTo  (self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo (self.view);
    }];
    
    
    [self.tableView registerClass:[CCityNewMeetingCell class] forCellReuseIdentifier:CCITYNEWCELLID];
    //[self.tableView registerClass:[CCityOfficalDocDetailCell class] forCellReuseIdentifier:ccityOfficlaMuLineReuseId];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* writeOpinioBtn =  [self getBottomBtnWithTitle:@"发布新闻" sel:@selector(writeOpinioAction)];
    
    [footerView addSubview:writeOpinioBtn];
    
    [writeOpinioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView).with.offset(5.f);
        make.left.equalTo(footerView).with.offset(10.f);
        make.right.equalTo(footerView).offset(-10.f);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.bottom.equalTo(footerView).with.offset(-30.f);
        } else {
            
            make.bottom.equalTo(footerView).with.offset(-10.f);
        }
    }];
    return footerView;
}

-(UIButton*)getBottomBtnWithTitle:(NSString*)title sel:(SEL)sel {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.clipsToBounds = YES;
    bottomBtn.layer.cornerRadius = 5.f;
    [bottomBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return bottomBtn;
}

#pragma mark- --- UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return SCREEN_HEIGHT - NAV_HEIGHT - 44 * 3 - kBottomBtnHeight ;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCityNewMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:CCITYNEWCELLID forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = @"新闻标题";
            NSString * str = [_uploadParameters objectForKey:@"title"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = @"新闻标题";
            }
        }
            break;
        case 1:
        {
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = @"新闻简介";
            NSString * str = [_uploadParameters objectForKey:@"introduce"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder =@"新闻简介";
            }
        }
            break;
        case 2:
        {
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            [cell.commonBtn setTitle:@"所属分类" forState:UIControlStateNormal];
            NSString * str = [_uploadParameters objectForKey:@"typeName"];
            if (str.length > 0) {
                [cell.commonBtn setTitle:str forState:UIControlStateNormal];
                [cell.commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
            break;
        case 3:
        {
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            cell.contentView.backgroundColor = MAIN_ARM_COLOR;
            if (!_demoViewController) {
                _demoViewController = [[ZSSDemoViewController alloc]init];
                [self addChildViewController:_demoViewController];
                _demoViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 44 * 3  - kBottomBtnHeight);
                _demoViewController.editorView.height = _demoViewController.view.height - 40 ;
                _demoViewController.toolbarHolder.frame = CGRectMake(0, _demoViewController.view.bottom  - 40, SCREEN_WIDTH, 40);
                [cell.contentView addSubview:_demoViewController.view];
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                    if (_optionDetailView) {
                        [self removeBoxOptionView];
                    }
                }];
                [_demoViewController.view addGestureRecognizer:tap];

            }
        }
            break;
            
        default:
            break;
    }
    return cell;
    
}


#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Toolbar Sizes
    CGFloat sizeOfToolbar = _demoViewController.toolbarHolder.frame.size.height;
    
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    const int extraHeight = 10;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            // Toolbar
            CGRect frame = _demoViewController.toolbarHolder.frame;
            frame.origin.y = _demoViewController.view.frame.size.height - (keyboardHeight + sizeOfToolbar) + kBottomBtnHeight;
            _demoViewController.toolbarHolder.frame = frame;
            
            // Editor View
            CGRect editorFrame = _demoViewController.editorView.frame;
            editorFrame.size.height = (_demoViewController.view.frame.size.height - keyboardHeight) - sizeOfToolbar - extraHeight + kBottomBtnHeight;
            _demoViewController.editorView.frame = editorFrame;
            _demoViewController.editorViewFrame = _demoViewController.editorView.frame;
            _demoViewController.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            _demoViewController.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = _demoViewController.sourceView.frame;
            sourceFrame.size.height = (_demoViewController.view.frame.size.height - keyboardHeight) - sizeOfToolbar - extraHeight;
            _demoViewController.sourceView.frame = sourceFrame;
            
            // Provide editor with keyboard height and editor view height
            [_demoViewController setFooterHeight:(keyboardHeight - 8)];
            [_demoViewController setContentHeight: _demoViewController.editorViewFrame.size.height];
            
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            CGRect frame = _demoViewController.toolbarHolder.frame;
            
            if (_demoViewController.alwaysShowToolbar) {
                frame.origin.y = _demoViewController.view.frame.size.height - sizeOfToolbar;
            } else {
                frame.origin.y = _demoViewController.view.frame.size.height + keyboardHeight;
            }

            _demoViewController.toolbarHolder.frame = frame;
            
            // Editor View
            CGRect editorFrame = _demoViewController.editorView.frame;
            
            if (_demoViewController.alwaysShowToolbar) {
                editorFrame.size.height = ((_demoViewController.view.frame.size.height - sizeOfToolbar) - extraHeight);
            } else {
                editorFrame.size.height = _demoViewController.view.frame.size.height;
            }
            
            _demoViewController.editorView.frame = editorFrame;
            _demoViewController.editorViewFrame = _demoViewController.editorView.frame;
            _demoViewController.editorView.scrollView.contentInset = UIEdgeInsetsZero;
            _demoViewController.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
            
            // Source View
            CGRect sourceFrame = _demoViewController.sourceView.frame;
            
            if (_demoViewController.alwaysShowToolbar) {
                sourceFrame.size.height = ((self.view.frame.size.height - sizeOfToolbar) - extraHeight);
            } else {
                sourceFrame.size.height = self.view.frame.size.height;
            }
            
            _demoViewController.sourceView.frame = sourceFrame;
            
            [_demoViewController setFooterHeight:0];
            [_demoViewController setContentHeight:_demoViewController.editorViewFrame.size.height];
            
        } completion:nil];
        
    }
    
}


#pragma mark - CCityNewMeetingCellDelegate

-(void)textViewWillEditingWithCell:(CCityNewMeetingCell *)cell
{
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
}
-(void)textViewDidEndEditingWithCell:(CCityNewMeetingCell *)cell
{
    NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
    if (indexpath.row == 0) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"title"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"title"];
        }
    }else if (indexpath.row == 1){
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"introduce"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"introduce"];
        }
    }
}

-(void)showDepartmentOption:(NSIndexPath *)indexpath withButton:(UIButton *)btn
{
    [self.view endEditing:YES];
    CGRect tmp = [btn convertRect:btn.bounds toView:self.view];
    
    if (!_optionDetailView) {
        float viewHeight;
        float marginTop = tmp.origin.y + tmp.size.height;

        NSArray * arr =@[ @{@"HYNAME":@"局内新闻",
                                   @"ID":@"1"},
                          @{@"HYNAME":@"行业动态",
                            @"ID":@"2"}];
        NSMutableArray * newsTypeArr = [NSMutableArray array];
        for ( int i = 0; i < arr.count; i ++) {
            CCityNewMeetingTypeModel * model = [[CCityNewMeetingTypeModel alloc]initWithDic:arr[i]];
            [newsTypeArr addObject:model];
        }
        
        if (newsTypeArr.count * 44 > SCREEN_HEIGHT - NAV_HEIGHT - marginTop) {
            viewHeight = SCREEN_HEIGHT - NAV_HEIGHT - marginTop;
        }else{
            viewHeight = newsTypeArr.count * 44;
        }
        
        _optionDetailView = [[CCityOptionDetailView alloc]initWithData:newsTypeArr withType:CCityDropdownBoxMeeting withFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, viewHeight)];
        
        _optionDetailView.delegate = self;
        _optionDetailView.backgroundColor = MAIN_ARM_COLOR;
        [self.view addSubview:_optionDetailView];
        
    }else{
        [self removeBoxOptionView];
    }
}

-(void)removeBoxOptionView{
    [_optionDetailView removeAllSubviews];
    [_optionDetailView removeFromSuperview];
    _optionDetailView = nil;
}

#pragma mark - _optionDetailViewDelegate

-(void)didSelectOption:(NSObject *)obj
{
    if([obj isKindOfClass:[CCityNewMeetingTypeModel class]]){
        CCityNewMeetingTypeModel * model = (CCityNewMeetingTypeModel *) obj;
        [_uploadParameters setObject:model.ID forKey:@"type"];
        [_uploadParameters setObject:model.HYNAME forKey:@"typeName"];
        [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self removeBoxOptionView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
}

#pragma mark - 发布新闻

-(void)writeOpinioAction
{
    [self.view endEditing:YES];
    if ([self judgeUploadData]) {
        [self uploadData];
    }
}

-(BOOL)judgeUploadData
{
    NSString * title = [_uploadParameters objectForKey:@"title"];
    NSString * introduce = [_uploadParameters objectForKey:@"introduce"];
    NSString * type = [_uploadParameters objectForKey:@"type"];
    NSString * content = [_demoViewController getHTML];
    
    if (title.length == 0) {
        [self showStatusViewWithStr:@"标题为空，请先填写"];
        return NO;
    }else if (introduce.length == 0){
        [self showStatusViewWithStr:@"简介为空，请先填写"];
        return NO;
    }else if (type.length == 0){
        [self showStatusViewWithStr:@"新闻类型为空，请先选择"];
        return NO;
    }else if (content.length == 0){
        [self showStatusViewWithStr:@"请编辑新闻内容"];
        return NO;
    }
    return YES;
}

-(void)showStatusViewWithStr:(NSString *)str
{
    [SVProgressHUD showWithStatus:str];
    [SVProgressHUD dismissWithDelay:1.5];
}

-(void)uploadData
{
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    [_uploadParameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    [_uploadParameters setObject:[_demoViewController getHTML] forKey:@"content"];
    [_uploadParameters setObject:[CCUtil getCurrentDate:@"yyyy-MM-dd"] forKey:@"starttime"];
    [_uploadParameters setObject:@"2099-12-31" forKey:@"endtime"];
    [manger POST:@"service/news/CreateNews.ashx" parameters:_uploadParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{

            }];
            return;
        }
        self.successBlock();
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
