//
//  CCityCommonWordsVC.m
//  LFOA
//
//  Created by Stenson on 2018/7/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "CCityCommonWordsVC.h"
#import "CCityCommonWordsModel.h"
#import "CustomIOSAlertView.h"
@interface CCityCommonWordsVC ()<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate>
{
    UITableView * _contentTableView;
    UITextView * _inputTV;
    
    CCityCommonWordsModel * _currentEditModel;
}

@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation CCityCommonWordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"常用语";
    self.view.backgroundColor = MAIN_LINE_COLOR;

    UIBarButtonItem * rightBarBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    [rightBarBtnItem setTintColor:MAIN_BLUE_COLOR];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    _dataArr = [NSMutableArray array];

    [self configData];
    [self initView];
}

-(void)rightBtnClick:(UIBarButtonItem *)barButton{
    if ([barButton.title isEqualToString:@"排序"]) {
        [_contentTableView setEditing:NO animated:YES];
    }
    
    BOOL flag = !_contentTableView.editing;
    [_contentTableView setEditing:flag animated:YES];
    [_contentTableView reloadData];
    if (flag) {
        [barButton setTitle:@"完成"];
    }else{
        [self configData];
        [barButton setTitle:@"排序"];
    }
}

-(void)configData
{
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token};
    [SVProgressHUD show];
    [manger GET:@"service/user/PhraseList.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        _dataArr = [NSMutableArray array];
        NSArray * arr  = responseObject[@"results"];
        for (int i = 0; i <arr.count ; i ++) {
            CCityCommonWordsModel * Model = [[CCityCommonWordsModel alloc]initWithDic:arr[i]];
            [_dataArr addObject:Model];
        }
        
      
        [_contentTableView reloadData];
        NSLog(@" responseObject ====  %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}


-(void)initView{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
    _contentTableView.backgroundColor = MAIN_LINE_COLOR;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [self.view addSubview:_contentTableView];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCityCommonWordsModel * model = _dataArr[indexPath.row];
    float labWidth = SCREEN_WIDTH - 55;
    if (tableView.isEditing) {
        labWidth = SCREEN_WIDTH - 80;
    }
    float height = [CCUtil heightForString:model.context font:[UIFont systemFontOfSize:16] andWidth:labWidth];
    if (height > 44.0f && model.isShowFullText) {
        return height + 10;
    }
    return 44.0f;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    CCityCommonWordsModel * model = _dataArr[indexPath.row];
    
    UILabel * _label = [UILabel new];
    _label.userInteractionEnabled =YES;
    _label.numberOfLines = 2;
    _label.font = [UIFont systemFontOfSize:16];
    _label.frame = CGRectMake(20,0, SCREEN_WIDTH - 55,44.0f);
    _label.text = model.context;
    _label.tag = 100;
    [cell.contentView addSubview:_label];
    if (tableView.isEditing) {
        _label.width = SCREEN_WIDTH - 90;
    }

    UIButton * button;
    float height = [CCUtil heightForString:_label.text font:_label.font andWidth:_label.width];
    if (height > _label.height) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10000 + indexPath.row;
        button.frame = CGRectMake(_label.right, 0, 30, _label.height);
        [cell.contentView addSubview:button];
        button.imageEdgeInsets = UIEdgeInsetsMake( (_label.height - 15) / 2, 7.5, (_label.height - 15) / 2, 7.5);
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(showAllWords:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"ccity_arrow_toBottom_30x30_"] forState:UIControlStateNormal];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, .5f);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
    
    if (model.isShowFullText) {
        _label.numberOfLines = 0;
        _label.top = 5;
        [_label sizeToFit];
        lineView.top =  _label.bottom + 5;
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        lineView.top =  43.5;
    }
    

    return cell;
}

-(void)showAllWords:(UIButton *)btn{
    NSInteger index = btn.tag - 10000;
    
    UITableViewCell * cell = (UITableViewCell *)btn.superview.superview;
    NSIndexPath * indexpath = [_contentTableView indexPathForCell:cell];
    CCityCommonWordsModel * model = _dataArr[index];
    model.isShowFullText = !model.isShowFullText;
    [_contentTableView reloadRowAtIndexPath:indexpath withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_enterType == ENTER_COMMONWORDS_TYPE_USERCENTER){
        return 0.0f;
    }
    return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    
    UILabel * textLab  =[UILabel new];
    textLab.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 44.0f);
    textLab.text = @"请点击选择以下常用语。";
    textLab.textColor = [UIColor lightGrayColor];
    textLab.font = [UIFont systemFontOfSize:14];
    [view addSubview:textLab];
    
    view.backgroundColor = MAIN_LINE_COLOR;

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArr.count == 0) {
        return 84.0f;
    }
    return 104.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * backgroundView = [[UIView alloc]init];
    backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104.0f);
    backgroundView.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * addCommonTextView  =[UIView new];
    addCommonTextView.frame = CGRectMake(0, 30, SCREEN_WIDTH , 44.0f);
    addCommonTextView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:addCommonTextView];
    if (_dataArr.count == 0) {
        addCommonTextView.top = 0;
    }
    
    UIButton * _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40.0f, addCommonTextView.height);
    [_addBtn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [_addBtn setTitle:@" 添加常用语" forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"cc_single_add_24x24" color:MAIN_BLUE_COLOR] forState:UIControlStateNormal];
    _addBtn.imageView.contentMode = UIViewContentModeLeft;
    _addBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [addCommonTextView addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(insertWordsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    UILabel * textLab  =[UILabel new];
    textLab.frame = CGRectMake(20, addCommonTextView.bottom, SCREEN_WIDTH - 40, 30.0f);
    textLab.text = @"对常用语进行更改、删除，请左划。";
    textLab.textColor = [UIColor lightGrayColor];
    textLab.font = [UIFont systemFontOfSize:14];
    [backgroundView addSubview:textLab];
    
    return backgroundView;
}


#pragma mark - 删除 修改
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
    CCityCommonWordsModel *models = _dataArr[sourceIndexPath.row];
//    //删除之前行的数据
    [_dataArr removeObject:models];
//    // 插入数据到新的位置
    [_dataArr insertObject:models atIndex:destinationIndexPath.row];
    
    [self sortCommonWords];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //刷新cell布局,解决有时候图片无法显示出来的问题
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.isEdit =self.isEdit;
//    [cell setNeedsLayout];
    
    _currentEditModel = _dataArr[indexPath.row];
    
    UITableViewRowAction *delegateAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteCommonWords];
    }];
    
    UITableViewRowAction *changeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"更改");
        
        CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc]init];
        alertView.tag = 123;
        alertView.buttonTitles = @[@"取消", @"更改"];
        UIView *customView = [self createAlertInputView:@"更改常用语"];
        customView.frame = CGRectMake(0, 0, 300, 160);
        [alertView setContainerView:(UITableView *)customView];
        alertView.delegate = self;
        [alertView show];
        _inputTV.text = _currentEditModel.context;
    }];
    changeAction.backgroundColor = CCITY_RGB_COLOR(250,155,10,1);
    return @[delegateAction,changeAction];
}

-(void)insertWordsBtnClick{
    CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc]init];
    alertView.tag = 456;
    alertView.buttonTitles = @[@"取消", @"添加"];
    UIView *customView = [self createAlertInputView:@"添加常用语"];
    customView.frame = CGRectMake(0, 0, 300, 160);
    [alertView setContainerView:(UITableView *)customView];
    alertView.delegate = self;
    [alertView show];
}

-(UIView *)createAlertInputView:(NSString *)titleStr{
    
    UIView* titleView   = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];

    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, 0, 300, 40.0f);
    
    _inputTV = [[UITextView alloc]init];
    _inputTV.layer.cornerRadius = 5.f;
    [titleView addSubview:_inputTV];
    _inputTV.layer.borderWidth = 1.f;
    _inputTV.layer.borderColor = CC_LINT_COLOR.CGColor;
    _inputTV.frame = CGRectMake(10.0f, 45.0f, 280.0f, 110.0f);
    
    return titleView;
}


#pragma mark - CustomIOSAlertViewDelegate
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    CustomIOSAlertView * alertV = (CustomIOSAlertView *)alertView;
    if (alertV.tag == 123) {
        if (buttonIndex == 1) {
            [self changCommonWords];
        }
    }else if (alertV.tag == 456) {
        if (buttonIndex == 1) {
            [self insertCommonWords];
        }
    }
    [alertView removeAllSubviews];
    [alertView close];
}

#pragma mark - 删除常用语

-(void)deleteCommonWords
{
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token,
                           @"idx":_currentEditModel.idx};
    [manger GET:@"service/user/PhraseDelete.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        [self configData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}


#pragma mark - 更改常用语

-(void)changCommonWords
{
    if (_inputTV.text.length ==0) {
        [SVProgressHUD showWithStatus:@"常用语内容不能为空"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token,
                           @"text":_inputTV.text,
                           @"idx":_currentEditModel.idx};
    [manger GET:@"service/user/PhraseEdit.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        [self configData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

#pragma mark - 添加常用语

-(void)insertCommonWords
{
    if (_inputTV.text.length ==0) {
        [SVProgressHUD showWithStatus:@"常用语内容不能为空"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token,
                           @"text":_inputTV.text};
    [manger GET:@"service/user/PhraseAdd.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
            }];
            return;
        }
        [self configData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}
#pragma mark - 常用语排序

-(void)sortCommonWords
{
    NSString * ids = @"";
    for (int i = 0; i < _dataArr.count; i ++ ) {
        CCityCommonWordsModel * model = _dataArr[i];
        if (i == 0) {
            ids = model.id;
        }else{
            ids = [NSString stringWithFormat:@"%@,%@",ids,model.id];
        }
    }
    
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token,
                           @"ids":ids};
    [manger GET:@"service/user/PhraseSort.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
            }];
            return;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_enterType == ENTER_COMMONWORDS_TYPE_DOC){
        CCityCommonWordsModel * model = _dataArr[indexPath.row];
        self.successSelectBlock(model.context);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
