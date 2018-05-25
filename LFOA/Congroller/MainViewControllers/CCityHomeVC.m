//
//  CCityHomeVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define A_MAP_URL @"http://122.226.81.198:8889/lfjygis/"

#import "CCityHomeVC.h"
#import <SDCycleScrollView.h>
#import "CCityHomeCell.h"
#import "CCityMainTaskSearchVC.h"
#import "CCityMainDocSearchModel.h"
#import "CCityDocSearchVC.h"
#import "CCityNotficVC.h"
#import "CCityMainMessageVC.h"
#import "CCityMainMeetingListVC.h"
#import "CCityNewsListVC.h"
#import <GTSDK/GeTuiSdk.h>
#import "CCitySecurity.h"
#import "CCityAMapVC.h"
#import "CCityNewsDetailVC.h"
#import "CCityUserInfoVC.h"

#define CCITY_HOME_LINE_WIDTH .5f
#define CCITY_HOME_LINE_COLOR [UIColor lightGrayColor]

@interface CCityHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

static NSString* homeCollectionCellReuseId = @"homeCollectionCellReuseId";
static NSString* homeCollectionSectionHeaderReuseId = @"homeCollectionSectionHeaderReuseId";
static NSString* homeCollectionSectionFooterReuseId = @"homeCollectionSectionFooterReuseId";

@implementation CCityHomeVC {
    
    NSMutableArray*      _dataMuArr;
    NSMutableDictionary* _parameters;
    
    UILabel* _userName;
    UILabel* _userFrom;
    
    UICollectionView*  _collectionView;
    SDCycleScrollView* _quickScrollView;
    NSMutableArray*    _newsDateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _hiddenNavBarAnimate = NO;
    self.title = @"首页";
    [self configData];
    self.view.backgroundColor = CCITY_MAIN_BGCOLOR;
    [self layoutMySubViews];
    
//    [self checkNotific];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* userNameStr =  [CCitySingleton sharedInstance].userName;
    
    if (![_userName.text isEqualToString:userNameStr]) {
        _userName.attributedText = [self getAttributedStringWithStr:userNameStr];
    }
    
    NSString* userFromStr =  [CCitySingleton sharedInstance].deptname;
    
    if (![_userFrom.text isEqualToString:userFromStr]) {
        
           _userFrom.attributedText = [self getAttributedStringWithStr:userFromStr];
    }

    if (self.navigationController.navigationBar.hidden == NO) {

        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationController setNavigationBarHidden:YES animated:_hiddenNavBarAnimate];

        _hiddenNavBarAnimate = YES;
    }
    
    [self configBadgeNum];
    [self configNews];   // 快讯
    [self configCheckUpdate];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layout subviews

-(void)layoutMySubViews {
    
    _collectionView = [self collectionView];
    _collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:_collectionView];
}

- (UICollectionView*)collectionView {
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing      = .0f;
    flowLayout.minimumInteritemSpacing = .0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * 9/16.f + 44.f);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 44.f);
    
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width / 3.f, self.view.bounds.size.width / 3.f - 20);
    
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[CCityHomeCell class] forCellWithReuseIdentifier:homeCollectionCellReuseId];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeCollectionSectionHeaderReuseId];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeCollectionSectionFooterReuseId];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    return collectionView;
}

//    textScrollView
-(UIView*)textScrollView {
    
    UIView* textScrollView = [UIView new];
    textScrollView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageLabel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_quickNews_60x60_"]];
    
    UIView* lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    _quickScrollView = [[SDCycleScrollView alloc]init];
    _quickScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    _quickScrollView.onlyDisplayText = YES;
    _quickScrollView.titlesGroup = @[@"暂无动态",];
    
    _quickScrollView.titleLabelTextColor = [UIColor darkGrayColor];
    _quickScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12];
    _quickScrollView.backgroundColor = [UIColor whiteColor];
    _quickScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
    
    [textScrollView addSubview:lineView];
    [textScrollView addSubview:imageLabel];
    [textScrollView addSubview:_quickScrollView];
    
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(textScrollView).with.offset(10.f);
        make.left.equalTo(textScrollView).with.offset(5.f);
        make.right.equalTo(lineView.mas_left).with.offset(-15.f);
        make.bottom.equalTo(textScrollView).with.offset(-10.f);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_quickScrollView).with.offset(5.f);
        make.left.equalTo(imageLabel.mas_right).with.offset(15.f);
        make.bottom.equalTo(_quickScrollView).with.offset(-5.f);
        make.width.mas_equalTo(1.f);
    }];
    
    [_quickScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(textScrollView).with.offset(5.f);
        make.left.equalTo(lineView.mas_right).with.offset(5.f);
        make.bottom.equalTo(textScrollView).with.offset(-5.f);
        make.right.equalTo(textScrollView).with.offset(-5.f);
    }];
    
    return textScrollView;
}

//    imageScrollView
-(SDCycleScrollView*)imageScrollView {
    
    SDCycleScrollView* imageScrollView = [[SDCycleScrollView alloc]init];
//    imageScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [manager POST:@"service/front/DefaultPicture.ashx" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray* imageNamesArr = responseObject;
            if (imageNamesArr.count <= 0) {  return; }
            NSMutableArray* urlsMuArr = [NSMutableArray new];
           
            NSString* urlStr = [NSString stringWithFormat:@"%@resources/images/%@",CCITY_BASE_URL,imageNamesArr[0]];
            NSString* utf8Str = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [urlsMuArr addObject:[NSURL URLWithString:utf8Str]];
            
            imageScrollView.imageURLStringsGroup = urlsMuArr;
            
            [imageScrollView clearCache];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    
    imageScrollView.autoScroll      = NO;
    imageScrollView.infiniteLoop    = NO;
    imageScrollView.showPageControl = NO;
    return imageScrollView;
}

-(UIControl*)userCenterCon {
    
    UIControl* userCenterCon = [UIControl new];
    
    UIImageView* userHeader = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_uesrcenter_userHeader"]];
    
    userHeader.layer.shadowColor   = [UIColor whiteColor].CGColor;
    userHeader.layer.shadowRadius  = 1.f;
    userHeader.layer.shadowOpacity = .3f;
    userHeader.layer.shadowOffset  = CGSizeMake(0, 0);
    
    _userName = [self userDetailLabel];
    NSString* userNameStr = [CCitySingleton sharedInstance].userName;
    _userName.attributedText = [self getAttributedStringWithStr:userNameStr];
    
    _userFrom = [self userDetailLabel];
    NSString* userFromStr = [CCitySingleton sharedInstance].deptname;
    _userFrom.attributedText = [self getAttributedStringWithStr:userFromStr];
    
    [userCenterCon addSubview:userHeader];
    [userCenterCon addSubview:_userName];
    [userCenterCon addSubview:_userFrom];
    
    [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(userCenterCon);
        make.left.equalTo(userCenterCon).with.offset(20.f);
        make.right.equalTo(userCenterCon).with.offset(-20.f);
        make.height.equalTo(userHeader.mas_width);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(userHeader.mas_bottom).with.offset(5.f);
        make.left.equalTo(userCenterCon);
        make.right.equalTo(userCenterCon);
        make.bottom.equalTo(_userFrom.mas_top);
    }];
    
    [_userFrom mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_userName.mas_bottom);
        make.left.equalTo(userCenterCon);
        make.right.equalTo(userCenterCon);
        make.bottom.equalTo(userCenterCon);
    }];
    
    return userCenterCon;
}

-(UILabel*)userDetailLabel {
    
    UILabel* userDetailLabel = [UILabel new];
    userDetailLabel.font = [UIFont systemFontOfSize:12.f];
    userDetailLabel.textColor = [UIColor whiteColor];
    userDetailLabel.textAlignment = NSTextAlignmentCenter;
    userDetailLabel.shadowOffset = CGSizeMake(1.f, 1.f);
    return userDetailLabel;
}

-(NSAttributedString*)getAttributedStringWithStr:(NSString*)str {
    
    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 2.f;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [UIColor blackColor];
    
    NSAttributedString* attributedStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSShadowAttributeName:shadow}];
    return attributedStr;
}

#pragma mark- --- methods

- (void)userCenterAction {
    
    CCityUserInfoVC* uesrInfoVC = [[CCityUserInfoVC alloc]init];
    [self pushToVC:uesrInfoVC hiddenNavBar:YES];
}

/*
-(void)checkNotific {
    
    if ([UIApplication sharedApplication].currentUserNotificationSettings.types != UIUserNotificationTypeNone) {
        
        return;
    }
    
    if ([CCitySecurity IsShowNotific] && [[CCitySecurity IsShowNotific] isEqualToString:@"NO"]) {
        
        return;
    }
    
    UIAlertController* alertNotificVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"通知并未打开,是否前往设置打开" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction* settingAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL* seetingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:seetingURL]) {
            
            [[UIApplication sharedApplication] openURL:seetingURL];
        }
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction* nomoreTripAction = [UIAlertAction actionWithTitle:@"不在提醒" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [CCitySecurity setIsShowNotific:@"NO"];
    }];
    
    [alertNotificVC addAction:settingAction];
    [alertNotificVC addAction:cancelAction];
    [alertNotificVC addAction:nomoreTripAction];
    
    [self presentViewController:alertNotificVC animated:YES completion:nil];
}
*/

#pragma mark- --- netWork

- (void)configData {
    
    NSArray* titles = @[@"公文办理", @"规划审批", @"消息提示", @"通知通告", @"新闻浏览", @"会议安排", @"综合查询", @"资料查询", @"系统设置"];
    
    _dataMuArr = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (int i = 0 ; i < titles.count; i++) {
        
        CCityHomeModel* model = [CCityHomeModel new];
        model.title = titles[i];
        model.imageName = [NSString stringWithFormat:@"homeCell%d_200x200_",i];
        model.cellStyle = i;
        [_dataMuArr addObject:model];
    }
}

-(void)configNews {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parameters = @{
                                 @"pageIndex":@1,
                                 @"pageSize" :@5
                                 };
    
    [manager POST:@"service/search/GetNewsList.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray* results = responseObject[@"results"];
        NSInteger newsNum = results.count <= 5 ? results.count : 5;
        
        _newsDateArr = [NSMutableArray arrayWithCapacity:newsNum];
        NSMutableArray* scrollTitles = [NSMutableArray arrayWithCapacity:newsNum];
        
        for (int i = 0; i < newsNum; i++) {
            
            CCityNewsModel* model = [[CCityNewsModel alloc]initWithDic:results[i]];
            [_newsDateArr addObject:model];
            [scrollTitles addObject:model.title];
        }
        
        if (scrollTitles.count) {
            
            if ([_quickScrollView.titlesGroup isEqualToArray:scrollTitles]) {   return; }
            
            _quickScrollView.titlesGroup = scrollTitles;
            _quickScrollView.autoScroll  = (scrollTitles.count > 1);
            
            __block NSMutableArray* weakNewsDateArr = _newsDateArr;
            __weak  CCityHomeVC*    weakSelf        = self;
            
            _quickScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                
                if (!weakNewsDateArr.count) {  return; }
                
                CCityNewsModel* model = weakNewsDateArr[currentIndex];
                CCityNewsDetailVC* newsDetailVC = [[CCityNewsDetailVC alloc]initWithModel:model];
                [weakSelf pushToVC:newsDetailVC hiddenNavBar:NO];
            };
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (CCITY_DEBUG) {
            NSLog(@"%@--新闻列表获取失败--error:%@",[self class],error.localizedDescription);
        }
    }];
}

-(void)configBadgeNum {
    
     AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager GET:@"service/front/Default.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger bageNum = 0;
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:^{
                
                [self configBadgeNum];
            }];
            return;
        }
        
        // 公文 审批
        bageNum = [responseObject[@"documentNum"] integerValue];
        [self refreshBadgeNumWithIndex:0 badgeNum:bageNum];
        bageNum = [responseObject[@"projectNum"] integerValue];
        [self refreshBadgeNumWithIndex:1 badgeNum:bageNum];
        // 消息
        bageNum = [responseObject[@"unreadMessagesNum"] integerValue];
        [self refreshBadgeNumWithIndex:2 badgeNum:bageNum];

        // 通知通告
        NSInteger noficNum = [responseObject[@"unreadNoticeNum"] integerValue];
        [self refreshBadgeNumWithIndex:3 badgeNum:noficNum];
        
        // 会议
        NSInteger meetingNum = [responseObject[@"meetingNum"] integerValue];
        [self refreshBadgeNumWithIndex:5 badgeNum:meetingNum];

        bageNum += noficNum;
        bageNum += meetingNum;

        if (bageNum == -1) {   return;   }
        if ( [UIApplication sharedApplication].applicationIconBadgeNumber != bageNum) {
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = bageNum;
//            [GeTuiSdk setBadge:bageNum];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (CCITY_DEBUG) {
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)configCheckUpdate {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [manager GET:@"service/app/IosVersionInfo.ashx" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * version = responseObject[@"data"][@"version"];
        NSString * downloadUrl = responseObject[@"data"][@"downloadUrl"];
        NSString * updateInfo = responseObject[@"data"][@"updateInfo"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSArray * serverVersionArr = [version componentsSeparatedByString:@"."];
        NSArray * appVersionArr = [app_Version componentsSeparatedByString:@"."];

        NSInteger bigServerVersion = 0;
        NSInteger smallServerVersion = 0;
        NSInteger bigAppVersison = 0;
        NSInteger smallAppVersison = 0;

        if (serverVersionArr.count > 0) {
            bigServerVersion = [serverVersionArr[0] integerValue];
        }
        
        if (appVersionArr.count > 0) {
            bigAppVersison = [appVersionArr[0] integerValue];
        }
        
        if(serverVersionArr.count > 1){
            smallServerVersion = [serverVersionArr[1] integerValue];
        }
        
        if (appVersionArr.count > 1) {
            smallAppVersison = [appVersionArr[1] integerValue];
        }
        
        if (bigServerVersion > bigAppVersison) {
            [self showUpdateAlertView:downloadUrl withUpdateInfo:updateInfo];
        }else if (bigServerVersion == bigAppVersison){
            if (smallServerVersion > smallAppVersison) {
                [self showUpdateAlertView:downloadUrl withUpdateInfo:updateInfo];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (CCITY_DEBUG) {
            NSLog(@"%@--检测更新获取失败--error:%@",[self class],error.localizedDescription);
        }
    }];
}

-(void)showUpdateAlertView:(NSString *)downloadUrl withUpdateInfo:(NSString *)updateInfo{
    UIAlertController* alertNotificVC = [UIAlertController alertControllerWithTitle:@"版本更新" message:updateInfo preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction* settingAction = [UIAlertAction actionWithTitle:@"跳转更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    }];
    
    [alertNotificVC addAction:settingAction];
    
    [self presentViewController:alertNotificVC animated:YES completion:nil];
}


#pragma mark- --- methods

-(void)pushToVC:(UIViewController*)vc hiddenNavBar:(BOOL)isHidden{
    
    vc.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)docSearch {
    
    CCityDocSearchVC* searchResultVC = [[CCityDocSearchVC alloc]initDatas:nil url:nil parameters:nil];
    
    [self pushToVC:searchResultVC hiddenNavBar:NO];
}

-(void)aMapAction {
    
    [self pushToVC:[[CCityAMapVC alloc] initWithUrl:A_MAP_URL title:@"一张图"] hiddenNavBar:YES];
}

-(void)refreshBadgeNumWithIndex:(NSInteger)index badgeNum:(NSInteger)badgeNum {
    
    CCityHomeModel* model = _dataMuArr[index];
    
    if ((badgeNum <= 0) || (model.badgeNum == badgeNum)) {    return; }

    model.badgeNum = badgeNum;
    
    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

#pragma mark- --- collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataMuArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityHomeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionCellReuseId forIndexPath:indexPath];
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    if (indexPath.row%3 == 1) {
        
        cell.posintion = CCityHomeCellPositionCenter;
    } else {
        
        cell.posintion = CCityHomeCellPositionSide;
    }
    
    cell.model = _dataMuArr[indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView*  reuseView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeCollectionSectionHeaderReuseId forIndexPath:indexPath];
        UIView* textScrollView =[self textScrollView];
        SDCycleScrollView* imageScrollView = [self imageScrollView];
        
        UIControl* userCenterCon = [self userCenterCon];
        [userCenterCon addTarget:self action:@selector(userCenterAction) forControlEvents:UIControlEventTouchUpInside];
        
        [imageScrollView addSubview:userCenterCon];
        [reuseView addSubview:textScrollView];
        [reuseView addSubview:imageScrollView];
        
        [userCenterCon mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(imageScrollView);
            make.centerY.equalTo(imageScrollView).with.offset(20.f);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [textScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(reuseView);
            make.bottom.equalTo(reuseView);
            make.right.equalTo(reuseView);
            make.height.mas_equalTo(44.f);
        }];
        
        [imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(reuseView).with.offset(-[UIApplication sharedApplication].statusBarFrame.size.height);
            make.left.equalTo(reuseView);
            make.bottom.equalTo(textScrollView.mas_top);
            make.right.equalTo(reuseView);
        }];
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeCollectionSectionFooterReuseId forIndexPath:indexPath];
        
        UIView* bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor whiteColor];
        reuseView.backgroundColor = [UIColor lightGrayColor];
        [reuseView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(reuseView).with.insets(UIEdgeInsetsMake(CCITY_HOME_LINE_WIDTH, 0, 0, 0));
        }];
    }
    
    reuseView.backgroundColor = CCITY_HOME_LINE_COLOR;
    
    return reuseView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityHomeModel* model = _dataMuArr[indexPath.row];
    model.badgeNum = 0;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    switch (model.cellStyle) {
            
        case CCityHomeCellDocStyle:
            
            self.tabBarController.selectedIndex = 1;
            break;
        case CCityHomeCellSPStyle:
            
            self.tabBarController.selectedIndex = 2;
            break;
        case CCityHomeCellMessageStyle:
            
            [self pushToVC:[[CCityMainMessageVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomeCellNotStyle:
            
            [self pushToVC:[[CCityNotficVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomeCellNewsStyle:
            
            [self pushToVC:[[CCityNewsListVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomecellMettingManagerStyle:
            
            [self pushToVC:[[CCityMainMeetingListVC alloc] init] hiddenNavBar:NO];
            break;
        case CCityHomeCellTaskSearchStyle:
            
            [self pushToVC:[[CCityMainTaskSearchVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomeCellDocSearchStyle:
            
            self.navigationController.navigationBar.hidden = NO;
            [self docSearch];
            break;
        case CCityHomeCellAMapStyle:
            self.tabBarController.selectedIndex = 3;
//            [self aMapAction];
            break;
       
        default:
            break;
    }
}

@end
