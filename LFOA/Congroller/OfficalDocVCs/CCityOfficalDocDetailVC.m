//
//  CCityOfficalDocDetailVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define LOCAL_CELL_FONT_SIZE 13.f

#import "CCityOfficalDocDetailVC.h"
#import "CCityOfficalDetailSectionView.h"
#import "CCityOfficalDocDetailCell.h"
#import "CCityOfficalDetailDocListView.h"
#import "CCityAlterManager.h"
#import "CCityOfficalDetailPsrsonListVC.h"
#import "CCityDatePickerVC.h"
#import "CCitySystemVersionManager.h"
#import "CCLeftBarBtnItem.h"
#import "CustomIOSAlertView.h"
#import <TSMessage.h>
#import "CCHuiqianDetailVC.h"
#import "CCErrorNoManager.h"

#import "CCityUploadFileVC.h"
#import "CCityOfficalDocVC.h"

@interface CCityOfficalDocDetailVC ()<CCityOfficalDocDetailDelegate,CCityOfficalDetailDocListViewDelegate,CCityOffialPersonListDelegate,CustomIOSAlertViewDelegate>

@end

static NSString* ccityOfficlaDataExcleReuseId  = @"CCityOfficalDetailDataExcleStyle";
static NSString* ccityOfficlaMuLineReuseId  = @"CCityOfficalDetailMutableLineTextStyle";

@implementation CCityOfficalDocDetailVC {
    
    CGRect        _editCellFrame;
    UIView*       _footerView;
    UIButton*     _sendBtn;
    
    NSString*                   _huiQianStr;
    NSIndexPath*                _huiQianIndexPath;
    
    CCityOfficalDetailDocListView* _fileListView;
    
    NSMutableDictionary* _valuesDic;
    NSMutableDictionary* _docId;
}

-(instancetype)initWithItmes:(NSArray *)items Id:(NSDictionary*)docId contentModel:(CCityOfficalDocContentMode)contentMode {
    
    self = [super initWithItmes:items];
    
    if (self) {
        
        _conentMode = contentMode;
        _docId      = [docId mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _valuesDic = [NSMutableDictionary dictionary];
    
    if(_isNewProject){
        if ([CCUtil isNotNull:_resultDic]) {
            [self showDocDetail:_resultDic];
        }
    }else{
        [self configDataWithId:_docId];
    }
    
    self.navigationItem.leftBarButtonItem  = [self leftBarBtnItem];
    self.navigationItem.rightBarButtonItem = [self rightBarBtnItem];
    
    if (_conentMode != CCityOfficalDocHaveDoneMode) {
     
        _footerView = [self footerView];
        [self.view addSubview:_footerView];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {

                if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
                    make.bottom.equalTo(self.view).with.offset(-74.f);
                } else {

                    make.bottom.equalTo(self.view).with.offset(-50.f);
                }
        }];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.tableView.mas_bottom);
            make.left.equalTo  (self.view);
            make.bottom.equalTo(self.view);
            make.right.equalTo (self.view);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view);
        }];
    }
    
    [self.tableView registerClass:[CCityOfficalDocDetailCell class] forCellReuseIdentifier:ccityOfficlaDataExcleReuseId];
    [self.tableView registerClass:[CCityOfficalDocDetailCell class] forCellReuseIdentifier:ccityOfficlaMuLineReuseId];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kShowUploadSuccess) name:kUPLOADIMAGE_SUCCESS object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenKeyboard];
}

-(void)kShowUploadSuccess
{
    [SVProgressHUD showInfoWithStatus:@"上传成功"];
    [SVProgressHUD dismissWithDelay:1.5];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_mainStyle == CCityOfficalMainSPStyle) {
        self.title = @"项目详情";
    } else if (_mainStyle == CCityOfficalMainDocStyle) {
        
        self.title = @"公文详情";
    }
}

-(void)setIsEnd:(BOOL)isEnd {
    _isEnd = isEnd;
    
    if (_isEnd) {
        
        [_sendBtn setTitle:@"结案" forState:UIControlStateNormal];
    }
}

#pragma mark- --- layout Subviews

- (UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (_conentMode == CCityOfficalDocBackLogMode) {
        
        UIButton* saveBtn = [self getBottomBtnWithTitle:@"保 存" sel:@selector(saveAction:)];
        
        _sendBtn =[self getBottomBtnWithTitle:@"发 送" sel:@selector(sendAction)];
        
        [footerView addSubview:saveBtn];
        [footerView addSubview:_sendBtn];
        
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(footerView).with.offset(5.f);
            make.left.equalTo(footerView).with.offset(10.f);
            make.right.equalTo(_sendBtn.mas_left).with.offset(-10.f);
            make.width.equalTo(_sendBtn);
            
            if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
                
                make.bottom.equalTo(footerView).with.offset(-30.f);
            } else {
                
                make.bottom.equalTo(footerView).with.offset(-10.f);
            }
        }];
        
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(saveBtn);
            make.left.equalTo(saveBtn.mas_right).with.offset(10.f);
            make.bottom.equalTo(saveBtn);
            make.right.equalTo(footerView).with.offset(-10.f);
            make.width.equalTo(saveBtn);
        }];
    } else if (_conentMode == CCityOfficalDocReciveReadMode) {
        
        UIButton* writeOpinioBtn =  [self getBottomBtnWithTitle:@"填写阅读意见" sel:@selector(writeOpinioAction)];
        
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
    }
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

// left nav btn
-(UIBarButtonItem*)leftBarBtnItem {
    
    CCLeftBarBtnItem* backBtn = [CCLeftBarBtnItem new];
    backBtn.label.text = @"";
    backBtn.label.backgroundColor = [UIColor whiteColor];
    backBtn.action = ^{
        [self backAction];
    };
  
    UIBarButtonItem* leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    return leftBarBtnItem;
}

// right nav btn
-(UIBarButtonItem*)rightBarBtnItem {
    
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ccity_nav_menu_30x30_"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    
    rightBarBtnItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    return rightBarBtnItem;
}

-(CCityOfficalDetailDocListView*) fileListView {
    
    CCityOfficalDetailDocListView* listView = [[CCityOfficalDetailDocListView alloc]initWithUrl:@"service/form/GetMaterialList.ashx" andIds:_docId];
    listView.delegate = self;
    listView.backgroundColor = [UIColor whiteColor];
    
    return listView;
}

#pragma mark- --- methods

// content mode changed
-(void)segmentedConValueChanged:(CCitySegmentedControl *)segCon {
    
    _footerView.hidden = (segCon.selectedIndex == 1);
    
    if (segCon.selectedIndex != 1) {
        
        [self.view bringSubviewToFront:self.tableView];
        
        if (_footerView) {
            [self.view bringSubviewToFront:_footerView];
        }
        
    } else {
        
        if (!_fileListView) {
            
            _fileListView = [self fileListView];
            
            __block CCityOfficalDocDetailVC* blockSelf = self;
            
            _fileListView.pushToFileViewerVC = ^(UIViewController *fileViewerVC) {
              
                [blockSelf pushTo:fileViewerVC];
            };
            [self.view addSubview:_fileListView];
            
            [_fileListView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(self.tableView);
                make.left.equalTo(self.tableView);
                make.right.equalTo(self.tableView);
                make.bottom.equalTo(self.view);
            }];
            [self.view bringSubviewToFront:_fileListView];

        } else {
            
            [self.view bringSubviewToFront:_fileListView];
        }
    }
}

// keyboard will show
- (void)keyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardFrame.size.height, 0);
    
   CGRect visibleFrame = _editCellFrame;
    visibleFrame.origin.y = visibleFrame.origin.y-25;
     [self.tableView scrollRectToVisible:visibleFrame animated:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0);
}

// back action
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// menu action
- (void) menuAction {
    
    CCityOfficalDetailMenuVC* menuVC = [[CCityOfficalDetailMenuVC alloc]initWithStyle:_mainStyle];
    menuVC.contentMode = _conentMode;
    menuVC.ids = _docId;
    menuVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    
    menuVC.pushToNextVC = ^(UIViewController *viewController) {
        
        [self.navigationController pushViewController:viewController animated:YES];
    };
    
    menuVC.pushToRoot = ^{
      
        if (self.sendActionSuccessed) { self.sendActionSuccessed(_indexPath); }
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationController.definesPresentationContext = YES;
    
    menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self.navigationController presentViewController:menuVC animated:NO completion:nil];
}

// push to vc 
-(void)pushTo:(UIViewController*)vc {
    
    [self.navigationController pushViewController:vc animated:YES];
}

// sectionview clicked
- (void) sectionViewClicked:(CCityOfficalDetailSectionView*)sectionView {
    
    CCityOfficalDocDetailModel* model = self.dataArr[sectionView.sectionNum];
   
    [self.view endEditing:YES];
    
    if (model.style == CCityOfficalDetailMutableLineTextStyle || model.style == CCityOfficalDetailOpinionStyle) {
        
        model.isOpen = !model.isOpen;
        model.cellNum = model.isOpen?1:0;
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionView.sectionNum] withRowAnimation:UITableViewRowAnimationFade];

        [self.tableView endUpdates];
        
    } else {
        
        if (model.canEdit == NO) {  return; }
        
        if (model.style == CCityOfficalDetailDateStyle || model.style == CCityOfficalDetailDateTimeStyle) {
            
            [self showDatePickerVCWithIndex:sectionView.sectionNum withSectionStyle:model.style];
        } else if (model.style == CCityOfficalDetailSimpleLineTextStyle) {
            
            [self showInputVCWithModel:model andIndex:sectionView.sectionNum];
        } else if (model.style == CCityOfficalDetailContentSwitchStyle) {
            
            [self showSwitchVCWithModel:model index:sectionView.sectionNum];
        }
    }
}

// show input vc
- (void)showInputVCWithModel:(CCityOfficalDocDetailModel*)model andIndex:(NSInteger)index {
    
    NSString* title = [NSString stringWithFormat:@"修改%@",model.title];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.text = model.value;
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField* inputTF = alertController.textFields[0];
        [self saveMethodWithIndex:index andText:inputTF.text];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// show datePickerVC
- (void) showDatePickerVCWithIndex:(NSInteger)index withSectionStyle:(CCityOfficalDetailSectionStyle)style {
    
    CCityDatePickerVC* dataPicker = [[CCityDatePickerVC alloc]initWithDate:nil withIsShowTime:style];
    
    dataPicker.slelectAction = ^(NSString *date) {
      
        [self saveMethodWithIndex:index andText:date];
           [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self presentViewController:dataPicker animated:YES completion:nil];
}

// show switch vc
-(void)showSwitchVCWithModel:(CCityOfficalDocDetailModel*)model index:(NSInteger)index {
    
    UIAlertController* switchVC = [UIAlertController alertControllerWithTitle:model.title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < model.switchContentArr.count; i++) {
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:model.switchContentArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self saveMethodWithIndex:index andText:action.title];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [switchVC addAction:action];
        
        if (i == model.switchContentArr.count -1) {
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [switchVC addAction:cancelAction];
        }
    }
    
    [self presentViewController:switchVC animated:YES completion:nil];
}

// send
- (void) sendAction {
    
    [self saveAction:nil];
    for (int i = 0 ; i < self.dataArr.count; i ++) {
        CCityOfficalDocDetailModel* model = self.dataArr[i];
        NSLog(@"  123 = ,%@,",model.value);
        if ( model.canEdit && model.isRequired && model.value.length == 0 ) {

            [SVProgressHUD showInfoWithStatus:model.RequiredMessage];
            [SVProgressHUD dismissWithDelay:1.5f];
            return;
        }
    }
    
    if (_isEnd) {

        [CCityAlterManager showAlertWithVC:self Str:@"结案提醒" detail:@"您确定要结案吗？" okHandle:^(UIAlertAction *action) {
            if ([action.title isEqualToString:@"确定"]) {
                [SVProgressHUD show];

                AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];

                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:_docId];

                [dic setObject:[CCitySingleton sharedInstance].token forKey:@"token"];

                [manager POST:@"service/form/End.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                    [SVProgressHUD dismiss];

                    CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
                    if ([errorNoManager requestSuccess:responseObject]) {

                        if (self.sendActionSuccessed) {

                            self.sendActionSuccessed(_indexPath);
                        }

                        [self.navigationController popViewControllerAnimated:YES];
                    } else {

                        [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                            [self sendAction];
                        }];
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                    [SVProgressHUD dismiss];

                    [self showIsEndFailedAlertVCWithTip:error.localizedDescription];
                }];
            }
        }];
        return;

    } else {
        CCityOfficalDetailPsrsonListVC* listVC = [[CCityOfficalDetailPsrsonListVC alloc]initWithIds:_docId];
        listVC.delegate = self;
        [self pushTo:listVC];
    }
}

-(void)showIsEndFailedAlertVCWithTip:(NSString*)tip {
    
    UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:tip preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction* reTryAction = [UIAlertAction actionWithTitle:@"重试" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self sendAction];
    }];
    
    [alertCon addAction:cancelAction];
    [alertCon addAction:reTryAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (void) saveMethodWithIndex:(NSInteger)index andText:(NSString*)text {
    
    CCityOfficalDocDetailModel* model = self.dataArr[index];
    
    if (model.style == CCityOfficalDetailDateStyle) {
        NSArray* timesArr = [text componentsSeparatedByString:@"-"];
        if(timesArr.count > 0){
            if (timesArr.count > 2) {
                model.value = [NSString stringWithFormat:@"%@/%@/%@",timesArr[0],timesArr[1],timesArr[2]];
            }
        }
        
    } else {
        
        if (!text||text.length == 0) { return; }
        model.value = text;
    }
    
    // 根据 model 的table 值 去 _valuesDic 查找 对应table
    NSMutableDictionary* talbeDic = _valuesDic[model.table];
    
    // 如果table 不存在，创建table，并把tale 保存到 _valuesDic 中
    if (!talbeDic) {
        
        talbeDic = [NSMutableDictionary dictionary];
        [_valuesDic setObject:talbeDic forKey:model.table];
    }
    
    NSDictionary* valusDic = @{
                               @"@dataType"     :model.dataType,
                               @"#cdata-section":text
                               };
    
    //  通过更新 value 更新 modle 中存储的 section 高度 和 valueText 高度
    [model updataValue];

    // 保存到table中，因为table 是指针，所以同步会保存到 _valuesDic 中
    [talbeDic setObject:valusDic forKey:model.field];
    
}

- (void)checkVisibleWithView:(CCityOfficalDetailSectionView*)view {
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = viewFrame.size.height + 100.f;
    
    if (!CGRectIntersectsRect(self.view.frame, view.frame)) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:view.sectionNum] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)hiddenKeyboard {
    
    [self.view endEditing:YES];
}

-(void)writeOpinioAction {
    
    CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc]init];
    alertView.buttonTitles = @[@"取消", @"回复"];
    alertView.passOpinio = _passOponio;
    alertView.passPerson = _passPerson;
    alertView.delegate = self;
    [alertView show];
}

- (void) addHuiQianOpinioAction:(UIButton*)btn {
    
    NSInteger section = btn.tag - 5000;
    CCityOfficalDocDetailModel* model = self.dataArr[section];
    
    CCHuiqianDetailVC* huiqianDetailVC = [[CCHuiqianDetailVC alloc]initWithModel:model title:model.title style:CCHuiQianEditAddStyle];
    huiqianDetailVC.docId       = _docId;
    huiqianDetailVC.outerRowNum = section;
    
    huiqianDetailVC.addSuccess = ^() {
       
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.huiQianMuArr.count - 1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self pushTo:huiqianDetailVC];
}

- (void)updataHuiQianUIWithState:(BOOL)isAdd {
    
    CCityOfficalDocDetailModel* model = self.dataArr[_huiQianIndexPath.section];
    
    if (isAdd) {

        CCHuiQianModel* huiqianModel = [[CCHuiQianModel alloc]init];
        huiqianModel.contentsMuArr = [NSMutableArray arrayWithCapacity:4];
        
        for (int i = 0; i < 4; i++) {
            
            CCHuiQianModel* lastModel = [CCHuiQianModel new];
            
            switch (i) {
                case 0:
                    lastModel.title = @"签字意见: ";
                    lastModel.content = _huiQianStr;
                    break;
                case 1:
                    
                    lastModel.title   = @"签字人: ";
                    lastModel.content = [CCitySingleton sharedInstance].userName;
                    break;
                case 2:
                    
                    lastModel.title   = @"签字日期: ";
                    lastModel.content = lastModel.currentFormatTime;
                    break;
                case 3:
                    
                    lastModel.title   = @"所在科室: ";
                    lastModel.content = [CCitySingleton sharedInstance].deptname;
                    break;
                default:
                    break;
            }
            
            [huiqianModel.contentsMuArr addObject:lastModel];
        }
        if (!model.huiQianMuArr) {
            model.huiQianMuArr = [NSMutableArray array];
        }
        [model.huiQianMuArr addObject:huiqianModel];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_huiQianIndexPath.row + 1) inSection:_huiQianIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else {
        CCHuiQianModel* huiqianModel = [model.huiQianMuArr lastObject];
        for (int i = 0 ; i < huiqianModel.contentsMuArr.count; i++) {
            CCHuiQianModel* model = huiqianModel.contentsMuArr[i];
            if ([model.title containsString:@"签字意见"]) {
                model.content = _huiQianStr;
            }
        }
        if ([CCUtil isNotNull:_huiQianIndexPath]) {
            [self.tableView reloadRowsAtIndexPaths:@[_huiQianIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(NSAttributedString*)huiqianCellAttributedStr:(CCHuiQianModel*)model {
    
    NSInteger innerCellNum = model.contentsMuArr.count<=4?model.contentsMuArr.count:4;
    NSString* contentStr = @"";
    
    for (int i = 0; i < innerCellNum; i++) {
        
        CCHuiQianModel* detailModel = model.contentsMuArr[i];
        if (i == innerCellNum - 1) {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@：%@", detailModel.title, detailModel.content]];
        } else {
            contentStr = [contentStr stringByAppendingString: [NSString stringWithFormat:@"%@：%@\n", detailModel.title, detailModel.content]];
        }
    }
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5.f;
    NSAttributedString* resultStr = [[NSAttributedString alloc]initWithString:contentStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    return resultStr;
}

#pragma mark- --- network

// save
- (void) saveAction:(UIButton*)btn {

    [self.view endEditing:YES];
    
    if (_isNewProject) {
        if([CCUtil isNotNull:self.dataArr]){
            for (int i = 0 ; i < self.dataArr.count; i++) {
                CCityOfficalDocDetailModel* model = self.dataArr[i];
                if (model.value.length > 0) {
                    [self saveMethodWithIndex:i andText:model.value];
                }
            }
        }
    }
    
    if (!_valuesDic.count && !_huiQianStr) {
        if (btn) {
            [SVProgressHUD showInfoWithStatus:@"数据未改变，无需保存"];
        }
        return;
    }
    
    if (btn) {  [SVProgressHUD show];   }
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSDictionary* datasDic = [NSDictionary dictionaryWithObject:_valuesDic forKey:@"root"];
    NSData* valuseData = [NSJSONSerialization dataWithJSONObject:datasDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString* valuesStr = [[NSString alloc]initWithData:valuseData encoding:NSUTF8StringEncoding];
    [parameters addEntriesFromDictionary:_docId];
    [parameters setObject:valuesStr forKey:@"formSaveStr"];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_group_t groupQueue = dispatch_group_create();
    
    __block BOOL isFileListSaveSuccess = NO;
    __block BOOL isHuiQianSaveSuccess = NO;
    __block BOOL isHuiQianAdd = NO;  // 会签 插入/更新
    
    // 表单保存
    if (_valuesDic.count) {
        dispatch_group_enter(groupQueue);

        [manager POST:@"service/form/Save.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            CCErrorNoManager* errorManager = [CCErrorNoManager new];
            
            if (![errorManager requestSuccess:responseObject]) {
                
                [errorManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                    [self saveAction:btn];
                }];
                return;
            } else {
                
                if (btn) {
                    isFileListSaveSuccess = YES;
                    dispatch_group_leave(groupQueue);
                    NSLog(@"=======================================");
                }
            }
            
            if (CCITY_DEBUG) { NSLog(@"fileList:%@",responseObject); }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_group_leave(groupQueue);
            
            //            if (btn) {
            //
            //                [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
            //            }
            if (CCITY_DEBUG) {
                NSLog(@"fileListError:%@",error);
            }
        }];
    } else {
        isFileListSaveSuccess = YES;
    }
   
    
    // 会签意见
    if (_huiQianStr) {
        
        dispatch_group_enter(groupQueue);
        NSLog(@"%@",_huiQianStr);
        NSDictionary* parame = @{
                                 @"token"   :[CCitySingleton sharedInstance].token,
                                 @"content" :_huiQianStr,
                                 @"workId"  :_docId[@"workId"],
                                 @"fkNode":_docId[@"fkNode"],
                                 };
        
        [manager GET:@"service/form/SignOpinion.ashx" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",task.currentRequest.URL.absoluteString);
            
            CCErrorNoManager* errorManager = [CCErrorNoManager new];
            
            if([errorManager requestSuccess:responseObject]) {
                isHuiQianSaveSuccess = YES;
                
                // insert/update
                if ([responseObject[@"operation"] isEqual:@"insert"]) {
                    isHuiQianAdd = YES;
                }
            }
            dispatch_group_leave(groupQueue);
            
            if (CCITY_DEBUG) { NSLog(@"huiqian:%@",responseObject); }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_group_leave(groupQueue);
            
            if (CCITY_DEBUG) { NSLog(@"huiqianError:%@",error); }
        }];
    } else {
        isHuiQianSaveSuccess = YES;
    }
    
    dispatch_group_notify(groupQueue, dispatch_get_main_queue(), ^{
        NSLog(@"全部执行结束。。。。。。");
        [SVProgressHUD dismiss];
        
        NSString* tripStr = @"保存失败";
        if (isHuiQianSaveSuccess && isFileListSaveSuccess) {
            tripStr = @"保存成功";
            [self updataHuiQianUIWithState:isHuiQianAdd];
        }
        if (_isNewProject) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[CCityOfficalDocVC class]]) {
                    CCityOfficalDocVC *revise =(CCityOfficalDocVC *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_SAVEINFO_SUCCESS object:nil];
        }
        [CCityAlterManager showSimpleTripsWithVC:self Str:tripStr detail:nil];
    });

}

- (void)configDataWithId:(NSDictionary*)docId {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSMutableDictionary* parameters = [docId mutableCopy];
    [parameters addEntriesFromDictionary:_docId];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    if (!_url) {    _url =@"service/form/FormDetail.ashx";  }
    
    [SVProgressHUD show];
    
    [manager GET:_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" ====  %@",responseObject);
        [self showDocDetail:responseObject];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@",error);
    }];
}


-(void)showDocDetail:(NSDictionary *)responseObject{
    if (responseObject[@"isEnd"] != NULL) {
        self.isEnd = [responseObject[@"isEnd"] boolValue];
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        CCErrorNoManager* errorManager = [CCErrorNoManager new];
        if (![errorManager requestSuccess:responseObject]) {
            
            [errorManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self configDataWithId:_docId];
            }];
            return;
        }
        
        if (!_docId[@"fk_flow"]) {  _docId[@"fk_flow"] = responseObject[@"fkFlow"]; }
        
        if (!_docId[@"workId"]) {   _docId[@"workId"] = responseObject[@"workId"];  }
        
        if (!_docId[@"fId"]) {  _docId[@"fId"] = responseObject[@"fid"];    }
        
        if (!_docId[@"fkNode"]) {   _docId[@"fkNode"] = responseObject[@"fkNode"];  }
    }
    
    NSArray* resultArr = responseObject[@"form"];
    
    if (!self.dataArr) {
        
        self.dataArr = [NSMutableArray arrayWithCapacity:resultArr.count];
    }
    
    NSString* groupId = @"xxx";
    NSDictionary* result;
    
    for (int i = 0 ; i < resultArr.count; i++) {
        
        result = resultArr[i];
        
        CCityOfficalDocDetailModel* model = [[CCityOfficalDocDetailModel alloc]initWithDic:result];
        if (_conentMode != CCityOfficalDocBackLogMode) {
            
            if (model.canEdit) {    model.canEdit = NO; }
        } else {
            
            // input opinio for self have no date & singature
            if ((model.canEdit == YES) && [groupId isEqual:result[@"GroupId"]]) { continue; }
            
            if ([result[@"ControlType"] isEqual:@"分组框"]) {
                
                groupId = result[@"GroupId"];
            }
        }
        
        [self.dataArr addObject:model];
    }
    
    [self.tableView reloadData];
}

-(void)sendOpinio:(CustomIOSAlertView*)alertView {
    
    [SVProgressHUD show];

    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
 
    NSDictionary* parametersDic = @{
                                    @"messageId":_docId[@"messageId"],
                                    @"fileId"   :_docId[@"formId"],
                                    @"content"  :alertView.inputTV.text,
                                    };
    
    [manager POST:@"service/form/ReplyOpinion.ashx" parameters:parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"status"] isEqual:@"success"]) {
            
            [alertView close];
            [TSMessage showNotificationWithTitle:@"发送成功" type:TSMessageNotificationTypeSuccess];
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
            [SVProgressHUD dismissWithDelay:2];
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:2];
    }];
}

-(CGFloat)rowHeightWithIndexPath:(NSIndexPath*)indexPath {
    
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:LOCAL_CELL_FONT_SIZE];
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    CCHuiQianModel* huiqianModel = model.huiQianMuArr[indexPath.row];
    label.attributedText = [self huiqianCellAttributedStr:huiqianModel];
    label.numberOfLines = 0;
    CGFloat rightPadding = 35;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30 - 20 -rightPadding, MAXFLOAT);
    [label sizeToFit];
    return label.bounds.size.height+10;
}

#pragma mark- --- custom alerview delegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        CustomIOSAlertView* cusAlertView = (CustomIOSAlertView*)alertView;
        if (cusAlertView.inputTV.text.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"发送内容为空"];
            [SVProgressHUD dismissWithDelay:2.f];
            return;
        } else {
            
            [self sendOpinio:cusAlertView];
        }
    } else {
        
         [alertView close];
    }
}

#pragma mark- --- personListVC delegate
-(void)viewControllerDismissActoin {
    
    if (self.sendActionSuccessed) {
        
        self.sendActionSuccessed(_indexPath);
    }
}

#pragma mark- --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    CCityOfficalDocDetailModel* model = self.dataArr[section];
    return model.sectionHeight > 44.f ? model.sectionHeight : 44.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CCityOfficalDocDetailModel* model = self.dataArr[section];

    CCityOfficalDetailSectionView* sectionView = [[CCityOfficalDetailSectionView alloc]initWithStyle:model.style];
    sectionView.sectionNum      = section;
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.model           = model;
    sectionView.addBtn.tag = 5000+section;
    [sectionView.addBtn addTarget:self action:@selector(addHuiQianOpinioAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addTarget:self action:@selector(sectionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return sectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CCityOfficalDocDetailModel* model = self.dataArr[section];
    
    if (model.style == CCityOfficalDetailDataExcleStyle) {
        return model.huiQianMuArr.count;
    }  else if (model.style == CCityOfficalDetailHuiQianStyle) {
        return model.huiQianMuArr.count + 1;
    }
    return model.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    
    CCityOfficalDocDetailCell*  cell = nil;
    
    if (model.style == CCityOfficalDetailDataExcleStyle) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficlaDataExcleReuseId];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        CCHuiQianModel* huiqaianModel = model.huiQianMuArr[indexPath.row];
        cell.textLabel.attributedText = [self huiqianCellAttributedStr:huiqaianModel];
    } else if (model.style == CCityOfficalDetailHuiQianStyle) {
       
        if (!_huiQianIndexPath) {
            NSInteger rowNum = 0;
            
            if (model.huiQianMuArr && model.huiQianMuArr.count) {
                rowNum = model.huiQianMuArr.count -1;
            }
            
             _huiQianIndexPath = [NSIndexPath indexPathForRow:rowNum inSection:indexPath.section];
        }
       
        if (indexPath.row == model.huiQianMuArr.count) {
            
            model.canEdit = YES;
            cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficlaMuLineReuseId];
            cell.delegate = self;
            cell.tag = 100100;
        } else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficlaDataExcleReuseId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            CCHuiQianModel* huiqaianModel = model.huiQianMuArr[indexPath.row];
            cell.textLabel.attributedText = [self huiqianCellAttributedStr:huiqaianModel];
        }
        if (indexPath.row == model.huiQianMuArr.count - 1) {
            cell.removeBottomLine = YES;
        } else {
            cell.removeBottomLine = NO;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficlaMuLineReuseId];
    }
    
    cell.model    = model;
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_conentMode != CCityOfficalDocBackLogMode) {
        
        if (cell.textView.editable) {   cell.textView.editable = NO;    }
    }
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
        
        // delete
        CCHuiQianModel* hqModel = model.huiQianMuArr[indexPath.row];
        NSMutableDictionary* row = [NSMutableDictionary dictionaryWithDictionary:@{@"@id":hqModel.rowId, @"@deleteFlag":@"true"}];
        for (CCHuiQianModel* huiqianModel in hqModel.contentsMuArr) {
            
            [row setObject:@{@"#cdata-sectoin":huiqianModel.content} forKey:huiqianModel.field];
        }
        
        if ([_valuesDic.allKeys containsObject:model.table]) {
            
            NSMutableArray* rowArr = _valuesDic[model.table][@"Rows"][@"Row"];
            [rowArr addObject:row];
        } else {
            
            NSMutableArray* rowArr = [NSMutableArray arrayWithObject:row];
            NSDictionary* rows = @{@"Rows":@{@"Row":rowArr}};
            NSDictionary* table = @{model.table:rows};
            [_valuesDic addEntriesFromDictionary:table];
        }
        
        [model.huiQianMuArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    return model.style == CCityOfficalDetailDataExcleStyle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];

    float height = [CCUtil heightForString:model.value font:[UIFont systemFontOfSize:[UIFont systemFontSize] - 1] andWidth:SCREEN_WIDTH - 20] + 10;

    if (model.style == CCityOfficalDetailDataExcleStyle) {
        return [self rowHeightWithIndexPath:indexPath];
    } else if (model.style == CCityOfficalDetailHuiQianStyle) {
        if (indexPath.row == model.huiQianMuArr.count) {
            
            return height > 90 ? height + 10 : 100;
        } else {
            return [self rowHeightWithIndexPath:indexPath];
        }
    } else {
        return height > 90 ? height + 10 : 100;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArr.count) {  return; }
    
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    
    if (model.style == CCityOfficalDetailDataExcleStyle) {
        
        CCHuiQianEditStyle style = model.canEdit?CCHuiQianEditEditStyle:CCHuiQianEditCheckStyle;
        
        CCHuiqianDetailVC* huiqianDetailVC = [[CCHuiqianDetailVC alloc]initWithModel:model title:model.title style:style];
        
        huiqianDetailVC.innerRowNum = indexPath.row;
        huiqianDetailVC.docId       = _docId;
        
        huiqianDetailVC.addSuccess = ^() {
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [self pushTo:huiqianDetailVC];
    } else {
        [self hiddenKeyboard];
    }
}

#pragma mark- --- tableViewCell delegate

-(void)textViewWillEditingWithCell:(CCityOfficalDocDetailCell*)cell {
 
    _editCellFrame = cell.frame;
}

-(void)textViewTextDidChange:(CCityOfficalDocDetailCell *)cell {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    model.value = cell.textView.text;
}

// 文本编辑结束时 调用
-(void)textViewDidEndEditingWithCell:(CCityOfficalDocDetailCell*)cell {

    if (cell.tag == 100100 ) {
        
        _huiQianStr = [cell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        //    得到编辑的 cell
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];

        [self saveMethodWithIndex:indexPath.section andText:cell.textView.text];
    }
}

#pragma mark - CCityOfficalDetailDocListViewDelegate

-(void)goUploadFileVC:(CCityOfficalDetailFileListModel *)model
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:_docId];
    [dic setObject:model.dirName forKey:@"materialFolder"];
    CCityUploadFileVC * uploadFileVC = [[CCityUploadFileVC alloc]init];
    uploadFileVC.resultDic = dic;
    [self.navigationController pushViewController:uploadFileVC animated:YES];
}
@end
