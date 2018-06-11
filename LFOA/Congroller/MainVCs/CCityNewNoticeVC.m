//
//  CCityNewNoticeVC.m
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#define kMAXNUMPHOTO 9

#define kDateBtnTag 1000
#define kAlertBoxBtnTag 1001

#define kNotiTitle @"通知标题"
#define kNotiEndDate @"有效期限"

#define kNotiPublishSection @"发布科室"
#define kNotiReceiver @"接收人员"
#define kNotiContent @"公告内容"

#import "CCityNewNoticeVC.h"
#import "CCityNewNotiCell.h"
#import "CCityDatePickerVC.h"
#import "CCityOptionDetailView.h"
#import <ZLPhotoActionSheet.h>

@interface CCityNewNoticeVC ()<CCityNewNotiCellDelegate,CCityOptionDetailViewDelegate>
{
    NSMutableDictionary * _uploadParameters;
    CCityOptionDetailView * _optionDetailView;
    
    CCityNewNotficModel * _newNotimodel;
}

@property (nonatomic,strong) NSMutableArray * imagesArr;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end

static NSString * CCITYNEWCELLID = @"CCITYNEWCELLID";

@implementation CCityNewNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新建通告";
    _uploadParameters = [NSMutableDictionary dictionary];
    [self configData];
    [self initView];
}

-(void)configData {
    
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token};
    [manger GET:@"service/notice/PrePublishNotice.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        
        _newNotimodel = [[CCityNewNotficModel alloc]initWithDic:responseObject];
//        NSArray* results = responseObject[@"results"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

-(void)initView{
    UIView * _footerView =[self footerView];
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
    

    [self.tableView registerClass:[CCityNewNotiCell class] forCellReuseIdentifier:CCITYNEWCELLID];
//[self.tableView registerClass:[CCityOfficalDocDetailCell class] forCellReuseIdentifier:ccityOfficlaMuLineReuseId];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* writeOpinioBtn =  [self getBottomBtnWithTitle:@"提交" sel:@selector(writeOpinioAction)];
    
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
    
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return  28.0f;
    }else if (indexPath.row == 5){
        return 110.0f;
    }else if (indexPath.row == 6){
        
        if ((self.imagesArr.count + 1 ) % 4 == 0) {
            return 20 + ((SCREEN_WIDTH - 50) / 4 + 10) * ((self.imagesArr.count + 1) / 4 );
        }
        return 20 + ((SCREEN_WIDTH - 50) / 4 + 10) * ((self.imagesArr.count + 1) / 4 + 1);
    }
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CCityNewNotiMeetingCell* model = self.dataArr[indexPath.section];
    
    CCityNewNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:CCITYNEWCELLID forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            NSString * str = [_uploadParameters objectForKey:@"noticeName"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kNotiTitle;
            }
        }
            break;
        case 1:
        {
            cell.newStyle = CCityNewNotiMeetingStyleDate;
            NSString * str = [_uploadParameters objectForKey:@"endDate"];
            UIButton * btn = [cell.contentView viewWithTag:kDateBtnTag];
            if (str.length > 0) {
                [btn setTitle:str forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }            
        }
            break;
            
        case 2:{
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            NSString * str = [_uploadParameters objectForKey:@"orgName"];
            UIButton * btn = [cell.contentView viewWithTag:kAlertBoxBtnTag];
            if (str.length > 0) {
                [btn setTitle:str forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

        }
            break;

        case 3:
            cell.newStyle = CCityNewNotiMeetingStyleNextPage;
            break;

        case 4:{
            cell.newStyle = CCityNewNotiMeetingStyleOther;
            BOOL isEmergency = [[_uploadParameters objectForKey:@"isEmergency"] boolValue];
            BOOL isSendSms = [[_uploadParameters objectForKey:@"isSendSms"] boolValue];

            cell.isHeightLevel = isEmergency;
            cell.isSendMessage = isSendSms;
        }
            break;

        case 5:{
            cell.newStyle = CCityNewNotiMeetingStyleTextView;
            NSString * str = [_uploadParameters objectForKey:@"noticeContent"];
            if (str.length > 0) {
                cell.notiContentTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kNotiContent;
            }
        }
            break;

        case 6:{
            cell.newStyle = CCityNewNotiMeetingStyleUpload;
            cell.choosedFileArr = self.imagesArr;
        }
            break;

        default:
            break;
    }
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark- --- CCityNewNotiMeetingCellDelegate

- (void)showDatePickerVCWithIndex:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
    CCityDatePickerVC* dataPicker = [[CCityDatePickerVC alloc]initWithDate:nil withIsShowTime:CCityOfficalDetailDateStyle];
    
    dataPicker.slelectAction = ^(NSString *date) {
        
        NSArray * arr = [date componentsSeparatedByString:@" "];
        if (arr.count > 0) {
            [_uploadParameters setObject:arr[0] forKey:@"endDate"];
        }
        [self.tableView reloadData];
    };
    
    [self presentViewController:dataPicker animated:YES completion:nil];
}

-(void)showDepartmentOption:(NSIndexPath *)indexpath withButton:(UIButton *)btn
{
    [self.view endEditing:YES];
    CGRect tmp = [btn convertRect:btn.bounds toView:self.view];
    
    if (!_optionDetailView) {
        float viewHeight;
        float marginTop = tmp.origin.y + tmp.size.height;
        if (_newNotimodel.departments.count * 44 > SCREEN_HEIGHT - NAV_HEIGHT - marginTop) {
            viewHeight = SCREEN_HEIGHT - NAV_HEIGHT - marginTop;
        }else{
            viewHeight = _newNotimodel.departments.count * 44;
        }
        _optionDetailView = [[CCityOptionDetailView alloc]initWithData:_newNotimodel.departments withType:CCityDropdownBoxDepartment withFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, viewHeight)];
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

-(void)textViewWillEditingWithCell:(CCityNewNotiCell *)cell
{
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
}

-(void)textViewTextDidChange:(CCityNewNotiCell *)cell
{

}

-(void)isHeightLever:(BOOL)isHeightLever withIndexpath:(NSIndexPath *)indexpath
{
    [self.view endEditing:YES];
    if (isHeightLever) {
        [_uploadParameters setObject:@"true" forKey:@"isEmergency"];
    }else{
        [_uploadParameters setObject:@"false" forKey:@"isEmergency"];
    }
}

-(void)isSendMessage:(BOOL)isSend withIndexpath:(NSIndexPath *)indexpath
{
    [self.view endEditing:YES];
    
    if (isSend) {
        [_uploadParameters setObject:@"true" forKey:@"isSendSms"];
    }else{
        [_uploadParameters setObject:@"false" forKey:@"isSendSms"];
    }
}

-(void)textViewDidEndEditingWithCell:(CCityNewNotiCell *)cell
{
    NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
    if (indexpath.row == 0) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"noticeName"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"noticeName"];
        }
    }else  if (indexpath.row == 5) {
        if (cell.notiContentTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiContentTextView.text forKey:@"noticeContent"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"noticeContent"];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
}

-(void)showChooseFileVC
{
    [self showImagePickController:NO];
}

#pragma mark - _optionDetailViewDelegate

-(void)didSelectOption:(NSObject *)obj
{
    CCityNewNotficDepartmentModel * model = (CCityNewNotficDepartmentModel *) obj;
    [_uploadParameters setObject:model.ID forKey:@"orgId"];
    [_uploadParameters setObject:model.ORGANIZATIONNAME forKey:@"orgName"];
    [self.tableView reloadData];
    
    [self removeBoxOptionView];
}


/**
 *  @author Stenson, 16-08-01 16:08:07
 *
 *  选取照片
 *
 *  @param isTaking 是否拍照
 */
-(void)showImagePickController:(BOOL)isTaking;
{
    if (self.imagesArr.count == kMAXNUMPHOTO) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多上传%d张照片",kMAXNUMPHOTO]];
        [SVProgressHUD dismissWithDelay:1.5f];
        return;
    }
    [[self getPas] showPhotoLibrary];
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kMAXNUMPHOTO;
    //设置照片最大选择数
    actionSheet.maxSelectCount = kMAXNUMPHOTO;
    //设置允许选择的视频最大时长
    actionSheet.allowSelectVideo = NO;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 5;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = NO;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = NO;
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.imagesArr = [NSMutableArray array];
        [strongSelf.imagesArr addObjectsFromArray:images];
        strongSelf.lastSelectAssets = assets.mutableCopy;
        [self.tableView reloadData];
    }];
    
    return actionSheet;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)didDeleteBtnWithIndex:(NSInteger)index
{
    [self.imagesArr removeObjectAtIndex:index];
    [self.lastSelectAssets removeObjectAtIndex:index];
    
    [self.tableView reloadRow:6 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
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
