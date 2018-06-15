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

#define kMeetingType @"会议类型"
#define kMeetingNum @"会议编号"
#define kMeetingTitle @"会议名称"
#define kMeetingPerson @"参会人"
#define kMeetingTime @"会议时间"
#define kMeetingRoom @"会议室"
#define kMeetingDepartment @"组织部门"
#define kMeetingZZDW @"组织单位"
#define kMeetingRecorder @"记录人"
#define kMeetingCJYR @"传纪要人"
#define kMeetingKQR @"考勤人"
#define kMeetingZCR @"主持人"
#define kMeetingContent @"会议内容"

#define kNewNotiFontSize 14

#import "CCityNewMeetingVC.h"
#import "CCityNewMeetingCell.h"
#import "CCityDatePickerVC.h"
#import "CCityOptionDetailView.h"
#import <ZLPhotoActionSheet.h>
#import "CCityMultilevelPersonVC.h"

@interface CCityNewMeetingVC ()<CCityNewMeetingCellDelegate,CCityOptionDetailViewDelegate>
{
    NSMutableDictionary * _uploadParameters;
    CCityOptionDetailView * _optionDetailView;
    
    CCityNewMeetingModel * _newMettingModel;
}

@property (nonatomic,strong) NSMutableArray * imagesArr;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end

static NSString * CCITYNEWCELLID = @"CCITYNEWCELLID";

@implementation CCityNewMeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布会议";
    _uploadParameters = [NSMutableDictionary dictionary];
    [self setUploadParametersData];

    [self configData];
    [self initView];
}

-(void)configData {
    
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    NSDictionary * dic = @{@"token":[CCitySingleton sharedInstance].token};
    [manger GET:@"service/meeting/PreRegisterMeeting.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        _newMettingModel = [[CCityNewMeetingModel alloc]initWithDic:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

-(void)writeOpinioAction
{
    [self.view endEditing:YES];
    if ([self judgeUploadData]) {
        dispatch_group_t group =dispatch_group_create();
        dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
        
        dispatch_group_enter(group);
        
        //模拟多线程耗时操作
        dispatch_group_async(group, globalQueue, ^{
            [self uploadData:group];
        });
        
        dispatch_group_enter(group);
        //模拟多线程耗时操作
        dispatch_group_async(group, globalQueue, ^{
            [self uploadFile:group];
        });
        
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.navigationController popViewControllerAnimated:YES];
            });
            self.successPublishMeeting();
        });
    }
}

-(void)setUploadParametersData
{
    [_uploadParameters setObject:@"" forKey:@"hymc"];
    [_uploadParameters setObject:@"" forKey:@"hynum"];
    [_uploadParameters setObject:@"" forKey:@"hysj"];
    [_uploadParameters setObject:@"" forKey:@"zcr"];
    [_uploadParameters setObject:@"" forKey:@"hys"];
    [_uploadParameters setObject:@"" forKey:@"hylx"];
    [_uploadParameters setObject:@"" forKey:@"hyry"];
    [_uploadParameters setObject:@"" forKey:@"zzbm"];
    [_uploadParameters setObject:@"" forKey:@"zzdw"];
    [_uploadParameters setObject:@"" forKey:@"cjyr"];
    [_uploadParameters setObject:@"" forKey:@"jlr"];
    [_uploadParameters setObject:@"" forKey:@"kqr"];
    [_uploadParameters setObject:@"" forKey:@"hynr"];
}


-(BOOL)judgeUploadData
{
    NSString * hylx = [_uploadParameters objectForKey:@"hylx"];
    NSString * hymc = [_uploadParameters objectForKey:@"hymc"];
    NSString * hyry = [_uploadParameters objectForKey:@"hyry"];
    NSString * hysj = [_uploadParameters objectForKey:@"hysj"];
    NSString * zzbm = [_uploadParameters objectForKey:@"zzbm"];

    if (hylx.length == 0) {
        [self showStatusViewWithStr:@"请选择会议类型"];
        return NO;
    }else if (hymc.length == 0){
        [self showStatusViewWithStr:@"请填好会议名称"];
        return NO;
    }else if (hyry.length == 0){
        [self showStatusViewWithStr:@"请选择参会人"];
        return NO;
    }else if (hysj.length == 0){
        [self showStatusViewWithStr:@"请选择会议时间"];
        return NO;
    }else if (zzbm.length == 0){
        [self showStatusViewWithStr:@"请先选择组织部门"];
        return NO;
    }
    return YES;
}

-(void)showStatusViewWithStr:(NSString *)str
{
    [SVProgressHUD showWithStatus:str];
    [SVProgressHUD dismissWithDelay:1.5];
}

-(void)uploadData:(dispatch_group_t)group
{
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    [_uploadParameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    [_uploadParameters setObject:_newMettingModel.fileNo forKey:@"itemid"];
    [manger POST:@"service/meeting/RegisterMeeting.ashx" parameters:_uploadParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_group_leave(group);
        CCErrorNoManager* errorNOManager = [CCErrorNoManager new];
        if(![errorNOManager requestSuccess:responseObject]) {
            [errorNOManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                [self configData];
            }];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(group);
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

-(void)uploadFile:(dispatch_group_t)group
{
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSMutableDictionary * parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[CCitySingleton sharedInstance].token,
                                                                 @"type":@"会议管理",
                                                                 @"fileNo":_newMettingModel.fileNo}];
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    [manager                        POST:@"service/file/Upload.ashx"
                              parameters:parameters
               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   for (int i = 0 ; i < self.imagesArr.count; i ++) {
                       UIImage *image = self.imagesArr[i];
                       NSData *imageData = UIImagePNGRepresentation([CCUtil fixOrientation:image]);
                       
                       [formData appendPartWithFileData:imageData name:@"myFile" fileName:[NSString stringWithFormat:@"%@%d.png",[CCUtil getNowTimeTimestamp3],i] mimeType:@"image/png"];
                   }
                   
               }
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     [SVProgressHUD dismiss];
                                     if([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"status"] isEqualToString:@"failed"]){
                                         [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据错误" detail:nil];
                                     }
                                     dispatch_group_leave(group);
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     [SVProgressHUD dismiss];
                                     dispatch_group_leave(group);
                                     [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
                                     NSLog(@"%@",error);
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
    
    
    [self.tableView registerClass:[CCityNewMeetingCell class] forCellReuseIdentifier:CCITYNEWCELLID];
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
    
    return 14;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 12){
        return 110.0f;
    }else if (indexPath.row == 13){
        
        if ((self.imagesArr.count + 1 ) % 4 == 0) {
            return 20 + ((SCREEN_WIDTH - 50) / 4 + 10) * ((self.imagesArr.count + 1) / 4 );
        }
        return 20 + ((SCREEN_WIDTH - 50) / 4 + 10) * ((self.imagesArr.count + 1) / 4 + 1);
    }else if (indexPath.row == 3){
        NSString * str = [_uploadParameters objectForKey:@"hyry"];
        if( str.length > 0 )  {
            float btnHeight = [CCUtil heightForString:str font:[UIFont systemFontOfSize:kNewNotiFontSize] andWidth:SCREEN_WIDTH - 44];
            if (btnHeight > 34) {
                return btnHeight + 10;
            }
        }
        return 44.0f;
    }
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityNewMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:CCITYNEWCELLID forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            [cell.commonBtn setTitle:kMeetingType forState:UIControlStateNormal];
            NSString * str = [_uploadParameters objectForKey:@"hylx"];
            if (str.length > 0) {
                [cell.commonBtn setTitle:str forState:UIControlStateNormal];
                [cell.commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
            break;
        case 1:
        {
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            [cell.commonBtn setTitle:kMeetingNum forState:UIControlStateNormal];
            cell.commonBtn.enabled = NO;
            NSString * str = [_uploadParameters objectForKey:@"hynum"];
            if (str.length > 0) {
                [cell.commonBtn setTitle:str forState:UIControlStateNormal];
                [cell.commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
            break;
            
        case 2:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            NSString * str = [_uploadParameters objectForKey:@"hymc"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingTitle;
            }
        }
            break;
            
        case 3:{
            cell.newStyle = CCityNewNotiMeetingStyleNextPage;

            NSString * str = [_uploadParameters objectForKey:@"hyry"];
            float btnHeight = [CCUtil heightForString:str font:cell.commonLab.font andWidth:SCREEN_WIDTH - 44];
            if (str.length > 0) {
                if (btnHeight > 34) {
                    cell.commonLab.height = btnHeight;
                }
                cell.commonLab.text = str;
                cell.commonLab.textColor = [UIColor blackColor];
            }else{
                cell.commonLab.text = kMeetingPerson;
                cell.commonLab.textColor = CCITY_GRAY_TEXTCOLOR;
            }

        }
            break;
            
        case 4:{
            cell.newStyle = CCityNewNotiMeetingStyleDate;
            [cell.commonBtn setTitle:kMeetingTime forState:UIControlStateNormal];
            NSString * str = [_uploadParameters objectForKey:@"hysj"];
            if (str.length > 0) {
                [cell.commonBtn setTitle:str forState:UIControlStateNormal];
                [cell.commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
            break;
            
        case 5:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingRoom;
            NSString * str = [_uploadParameters objectForKey:@"hys"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingRoom;
            }
        }
            break;
            
        case 6:{
            cell.newStyle = CCityNewNotiMeetingStyleAlert;
            [cell.commonBtn setTitle:kMeetingDepartment forState:UIControlStateNormal];
            NSString * str = [_uploadParameters objectForKey:@"zzbmName"];
            if (str.length > 0) {
                [cell.commonBtn setTitle:str forState:UIControlStateNormal];
                [cell.commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
            break;

        case 7:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingZZDW;
            NSString * str = [_uploadParameters objectForKey:@"zzdw"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingZZDW;
            }
        }
            break;

        case 8:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingRecorder;
            NSString * str = [_uploadParameters objectForKey:@"jlr"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingRecorder;
            }
        }
            break;

        case 9:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingCJYR;
            NSString * str = [_uploadParameters objectForKey:@"cjyr"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingCJYR;
            }
        }
            break;

        case 10:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingKQR;
            NSString * str = [_uploadParameters objectForKey:@"kqr"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingKQR;
            }
        }
            break;

        case 11:{
            cell.newStyle = CCityNewNotiMeetingStyleInput;
            cell.notiTitleTextView.placeholder = kMeetingZCR;
            NSString * str = [_uploadParameters objectForKey:@"zcr"];
            if (str.length > 0) {
                cell.notiTitleTextView.text = str;
            }else{
                cell.notiTitleTextView.placeholder = kMeetingZCR;
            }
        }
            break;

        case 12:{
            cell.newStyle = CCityNewNotiMeetingStyleTextView;
            cell.notiContentTextView.placeholder = kMeetingContent;
            NSString * str = [_uploadParameters objectForKey:@"hynr"];
            if (str.length > 0) {
                cell.notiContentTextView.text = str;
            }else{
                cell.notiContentTextView.placeholder = kMeetingContent;
            }
        }
            break;
        case 13:{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3){
        [self goReceiverView];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark- --- CCityNewNotiMeetingCellDelegate

- (void)showDatePickerVCWithIndex:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
    CCityDatePickerVC* dataPicker = [[CCityDatePickerVC alloc]initWithDate:nil withIsShowTime:CCityOfficalDetailDateTimeStyle];
    dataPicker.dateFormatStr = @"yyyy/MM/dd HH:mm";
    dataPicker.slelectAction = ^(NSString *date) {
        [_uploadParameters setObject:date forKey:@"hysj"];
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
        if (_newMettingModel.departments.count * 44 > SCREEN_HEIGHT - NAV_HEIGHT - marginTop) {
            viewHeight = SCREEN_HEIGHT - NAV_HEIGHT - marginTop;
        }else{
            viewHeight = _newMettingModel.departments.count * 44;
        }
        
        if (indexpath.row == 0) {
            float marginTop = tmp.origin.y + tmp.size.height;
            if (_newMettingModel.meetingTypes.count * 44 > SCREEN_HEIGHT - NAV_HEIGHT - marginTop) {
                viewHeight = SCREEN_HEIGHT - NAV_HEIGHT - marginTop;
            }else{
                viewHeight = _newMettingModel.meetingTypes.count * 44;
            }
            _optionDetailView = [[CCityOptionDetailView alloc]initWithData:_newMettingModel.meetingTypes withType:CCityDropdownBoxMeeting withFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, viewHeight)];
        }else{
            float marginTop = tmp.origin.y + tmp.size.height;
            if (_newMettingModel.departments.count * 44 > SCREEN_HEIGHT - NAV_HEIGHT - marginTop) {
                viewHeight = SCREEN_HEIGHT - NAV_HEIGHT - marginTop;
            }else{
                viewHeight = _newMettingModel.departments.count * 44;
            }
            _optionDetailView = [[CCityOptionDetailView alloc]initWithData:_newMettingModel.departments withType:CCityDropdownBoxDepartment withFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, viewHeight)];
        }
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

-(void)textViewWillEditingWithCell:(CCityNewMeetingCell *)cell
{
    if (_optionDetailView) {
        [self removeBoxOptionView];
    }
}

-(void)textViewTextDidChange:(CCityNewMeetingCell *)cell
{
    
}

-(void)textViewDidEndEditingWithCell:(CCityNewMeetingCell *)cell
{
    NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
    if (indexpath.row == 2) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"hymc"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"hymc"];
        }
    }else  if (indexpath.row == 5) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"hys"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"hys"];
        }
    }else  if (indexpath.row == 7) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"zzdw"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"zzdw"];
        }
    }else  if (indexpath.row == 8) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"jlr"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"jlr"];
        }
    }else  if (indexpath.row == 9) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"cjyr"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"cjyr"];
        }
    }else  if (indexpath.row == 10) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"kqr"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"kqr"];
        }
    }else  if (indexpath.row == 11) {
        if (cell.notiTitleTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiTitleTextView.text forKey:@"zcr"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"zcr"];
        }
    }else  if (indexpath.row == 12) {
        if (cell.notiContentTextView.text.length > 0) {
            [_uploadParameters setObject:cell.notiContentTextView.text forKey:@"hynr"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"hynr"];
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

-(void)goReceiverView
{
    CCityMultilevelPersonVC * personVC=  [[CCityMultilevelPersonVC alloc]init];
    personVC.dataArr = [NSMutableArray arrayWithArray:_newMettingModel.organizationTree];
    personVC.strBlock = ^(NSString *str) {
        if (str.length > 0) {
            [_uploadParameters setObject:str forKey:@"hyry"];
        }else{
            [_uploadParameters setObject:@"" forKey:@"hyry"];
        }
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - _optionDetailViewDelegate

-(void)didSelectOption:(NSObject *)obj
{
    if([obj isKindOfClass:[CCityNewMeetingDepartmentModel class]]){
        CCityNewMeetingDepartmentModel * model = (CCityNewMeetingDepartmentModel *) obj;
        [_uploadParameters setObject:model.ID forKey:@"zzbm"];
        [_uploadParameters setObject:model.ORGANIZATIONNAME forKey:@"zzbmName"];
        [self.tableView reloadData];
    }else if([obj isKindOfClass:[CCityNewMeetingTypeModel class]]){
        CCityNewMeetingTypeModel * model = (CCityNewMeetingTypeModel *) obj;
        [_uploadParameters setObject:model.HYNAME forKey:@"hylx"];
        if ([model.HYNAME isEqualToString:@"局内会议"]) {
            [_uploadParameters setObject:[NSString stringWithFormat:@"jnhy%@",[CCUtil getCurrentDate:@"yyyyMMdd"]] forKey:@"hynum"];
        }else if ([model.HYNAME isEqualToString:@"临时会议"]){
            [_uploadParameters setObject:[NSString stringWithFormat:@"lshy%@",[CCUtil getCurrentDate:@"yyyyMMdd"]] forKey:@"hynum"];
        }else if ([model.HYNAME isEqualToString:@"外出会议"]){
            [_uploadParameters setObject:[NSString stringWithFormat:@"wchy%@",[CCUtil getCurrentDate:@"yyyyMMdd"]] forKey:@"hynum"];
        }
        [self.tableView reloadData];
    }
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
    
    [self.tableView reloadRow:13 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
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

