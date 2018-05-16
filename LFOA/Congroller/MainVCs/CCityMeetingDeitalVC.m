//
//  CCityMeetingDeitalVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMeetingDeitalVC.h"
#import "CCityNavBar.h"
#import "CCityBaseTableViewCell.h"
#import <CoreText/CoreText.h>
#import "CCityNotficModel.h"
#import "CCityAccessoryManager.h"
#import "CCityAppendixView.h"
#import "CCitySystemVersionManager.h"

@interface CCityMeetingDeitalVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CCityMeetingDeitalVC {
    
    CCityMainMeetingListModel* _model;
    UITableView*               _tableView;
    NSString*                  _url;
    NSMutableDictionary*       _paramters;
}

- (instancetype)initWithUrl:(NSString*)url parameters:(NSMutableDictionary*)parameters
{
    self = [super init];
    if (self) {
        
        _url = url;
        _paramters = parameters;
        [self configDataWithUrl:url parameters:parameters];
    }
    return self;
}

- (instancetype)initWithModel:(CCityMainMeetingListModel*)model
{
    self = [super init];
    if (self) {
      
        _model = model;
    }
    return self;
}

-(void)configDataWithUrl:(NSString*)url parameters:(NSMutableDictionary*)parameters {
    
    [self layoutMySubViews];
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
               
                _paramters[@"token"] = [CCitySingleton sharedInstance].token;
                [self configDataWithUrl:_url parameters:_paramters];
            }];
        } else {
            _model = [[CCityMainMeetingListModel alloc]initWithDic:responseObject];
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error.description);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tableView) {
        
        [self layoutMySubViews];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layoutSubViews

- (void)layoutMySubViews {
    
    CCityNavBar* navBar = [self navBar];
    _tableView = [self tableView];
    
    [self.view addSubview:navBar];
    [self.view addSubview:_tableView];
    
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.height.mas_equalTo(84.f);
        } else {
            
            make.height.mas_equalTo(64.f);
        }
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(CCityNavBar*)navBar {
    
    CCityNavBar* navBar = [CCityNavBar new];
    navBar.barTintColor = CCITY_MAIN_COLOR;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleLabel.text = @"会议详情";
    [navBar.backControl addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    return navBar;
}

-(UITableView*)tableView {
    
    UITableView* talbeView = [UITableView new];
    
    talbeView.delegate = self;
    talbeView.dataSource = self;
    talbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView* contentView = [UIView new];
    
    UILabel* headerLabel = [self headerLabel];
    
    headerLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width - 20.f, MAXFLOAT);
    [headerLabel sizeToFit];
    
    contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, headerLabel.frame.size.height + 15.f);
    headerLabel.frame = CGRectMake(10, 10, self.view.bounds.size.width - 20.f, headerLabel.bounds.size.height);
    
    [contentView addSubview:headerLabel];
    
    talbeView.tableHeaderView = contentView;
    talbeView.tableFooterView = [self tableFooterView];
    
    return talbeView;
}

-(UIView*)tableFooterView {
    
    UIView* tableFooterView = [UIView new];
    
    for (int i = 0; i < _model.accessoryFiles.count; i++) {
        
        CCityFileModel* accessoryModel = [[CCityFileModel alloc]initWithDic:_model.accessoryFiles[i]];
        CCityAppendixView* accessoryView = [[CCityAppendixView alloc]init];
        accessoryView.titleLabel.text = accessoryModel.fileName;
        accessoryView.sizeLabel.text = accessoryModel.fileSize;
        accessoryView.url = accessoryModel.fileUrl;
        accessoryView.type = accessoryModel.type;
        [accessoryView addTarget:self action:@selector(accessoryAction:) forControlEvents:UIControlEventTouchUpInside];
        accessoryView.frame = CGRectMake(10, 70*i + 10, self.view.bounds.size.width - 20.f, 60.f);
        [tableFooterView addSubview:accessoryView];
    }
    
    tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, _model.accessoryFiles.count * 70.f + 10);
    return tableFooterView;
}

- (UILabel*)contentLabel {
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    return contentLabel;
}

-(UILabel*)headerLabel {
    
    UILabel* headerLabel = [UILabel new];
    headerLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    headerLabel.text = _model.meetingTitle;
    headerLabel.font = [UIFont boldSystemFontOfSize:17.f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}

#pragma mark- ---  methods

- (void)accessoryAction:(CCityAppendixView*)accessory {
    
    CCityAccessoryManager* accessoryManager = [[CCityAccessoryManager alloc]init];
    
    accessoryManager.requestSucess = ^(UIViewController *vc) {
      
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [accessoryManager OpenFileWithUrl:@"service/search/PreviewFile.ashx" parameters:@{@"path":accessory.url, @"name":accessory.titleLabel.text} fileType:accessory.type fileName:[[accessory.titleLabel.text componentsSeparatedByString:@"."] firstObject]];
}

//    pop
-(void)pop {
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSAttributedString*)titleAttributeTextWithText:(NSString*)text {
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f]} context:nil].size;
    
    CGFloat margin = (100 - textSize.width)/text.length - 1;
    
    NSNumber* number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc]initWithString:text];

    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, text.length - 1)];
    return attributeString;
}

-(CGFloat)rowHeightWithText:(NSString*)text {
    
    UILabel* label = [self contentLabel];
    label.font = [UIFont systemFontOfSize:16.f];
    label.numberOfLines = 0;
    label.text = text;
    
    label.frame = CGRectMake(0, 0, self.view.bounds.size.width - 93 - 15, MAXFLOAT);
    [label sizeToFit];
    
    return label.bounds.size.height;
}

#pragma mark- --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityBaseTableViewCell* cell = [CCityBaseTableViewCell new];
    
    UILabel* titleLabel =[self contentLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    UILabel* contentLabel = [self contentLabel];
    contentLabel.font = [UIFont systemFontOfSize:16.f];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:contentLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).with.offset(10.f);
        make.bottom.equalTo(cell.contentView);
        make.width.mas_equalTo(93.f);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right);
        make.bottom.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).with.offset(-5.f);
    }];
    
    switch (indexPath.row) {
            
        case 0:
            
            titleLabel.attributedText = [self titleAttributeTextWithText:@"会议编号："];
            contentLabel.text = _model.meetingNum;
            break;
        case 1:
            
           titleLabel.attributedText = [self titleAttributeTextWithText:@"会议类型："];
            contentLabel.text = _model.meetingType;
            break;
        case 2:
            
           titleLabel.attributedText = [self titleAttributeTextWithText:@"会议时间："];
            contentLabel.text = _model.meetingTime;
            break;
        case 3:
            
           titleLabel.attributedText = [self titleAttributeTextWithText:@"参会人："];
            contentLabel.numberOfLines = 0;
            contentLabel.text = _model.meetingMembers;
            break;
        case 4:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"会议室："];
            contentLabel.text = _model.meetingPlace;
            break;
        case 5:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"组织部门："];
            contentLabel.text = _model.meetingSponsor;
            break;
        case 6:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"组织单位："];
            contentLabel.text = _model.sponsoredUnit;
            break;
        case 7:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"记录人："];
            contentLabel.text = _model.meetingRecorder;
            break;
        case 8:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"传记要人："];
            contentLabel.text = _model.meetingCJYR;
            break;
        case 9:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"考勤人："];
            contentLabel.text = _model.meetingChecker;
            break;
        case 10:
            
        titleLabel.attributedText = [self titleAttributeTextWithText:@"主持人："];
        contentLabel.text = _model.compere;
            break;
        case 11:
            
          titleLabel.attributedText = [self titleAttributeTextWithText:@"会议内容："];
          contentLabel.numberOfLines = 0;
          contentLabel.text = _model.content;
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = 34.f;
    
    if (indexPath.row == 3) {
        
        rowHeight = [self rowHeightWithText:_model.meetingMembers] + 10;
    }
    
    if (indexPath.row == 11) {
        
          rowHeight = [self rowHeightWithText:_model.content] + 10;
    }
    
    return rowHeight > 34?rowHeight:34;
}

#pragma mark- --- UITableViewDelegate

@end
