//
//  CCityOfficalDetailMenuVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailMenuVC.h"
#import "CCityOfficalDocNavMenuBtn.h"
#import "CCityOfficalProLogVC.h"
#import "CCityOfficalDetailProTreeVC.h"
#import "CCityOfficalDetailProListVC.h"

@interface CCityOfficalDetailMenuVC ()

@end

@implementation CCityOfficalDetailMenuVC {
    
    UIView* _menuView;
    CCityOfficalMainStyle _style;
}

- (instancetype)initWithStyle:(CCityOfficalMainStyle)style
{
    self = [super init];
    
    if (self) {
        
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutMySubViews];
}

- (void)layoutMySubViews {
    
    if (!_menuView) {
        
        _menuView = [self menuView];
        
        _menuView.frame = CGRectMake(self.view.bounds.size.width - 140.f, 64, 130, 0.f);
    
        _menuView.alpha = 0.f;
        [self.view addSubview:_menuView];
    }
    
    // menu animation
    __block CGRect menuFrame = _menuView.frame;
    
    if (_menuView.alpha == 0) {
        
        _menuView.alpha = 1.f;
        
        if (_style == CCityOfficalMainSPStyle && _contentMode == 0) {
            
            menuFrame.size.height = 200;
        } else {
            
            menuFrame.size.height = 150;
        }
        
        _menuView.frame = menuFrame;
    } else {
        
        [UIView animateWithDuration:.1f animations:^{
            
            _menuView.alpha = 0.f;
            menuFrame.size.height = 50.f;
            _menuView.frame = menuFrame;
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                menuFrame.size.height = 0;
                _menuView.frame = menuFrame;
            }
        }];
    }
}

// menu view
- (UIView*) menuView {
    
    UIView* menuView = [UIView new];
    menuView.backgroundColor = [UIColor whiteColor];
    
    CCityOfficalDocNavMenuBtn* docListBtn = [CCityOfficalDocNavMenuBtn buttonWithType:UIButtonTypeCustom];
    docListBtn.tag = 1501;
    [docListBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [docListBtn setImage:[UIImage imageNamed:@"ccity_officalDetail_navMenu_list_20x20_"] forState:UIControlStateNormal];
    
    CCityOfficalDocNavMenuBtn* docTreeBtn = [CCityOfficalDocNavMenuBtn buttonWithType:UIButtonTypeCustom];
    docTreeBtn.tag = 1502;
    [docTreeBtn setImage:[UIImage imageNamed:@"ccity_officalDetail_navMenu_tree_20x20"] forState:UIControlStateNormal];
    [docTreeBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CCityOfficalDocNavMenuBtn* docLogBtn = [CCityOfficalDocNavMenuBtn buttonWithType:UIButtonTypeCustom];
    docLogBtn.tag = 1503;
    [docLogBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [docLogBtn setImage:[UIImage imageNamed:@"ccity_officalDetail_navMenu_log_20x20"] forState:UIControlStateNormal];
    
    if (_style == CCityOfficalMainSPStyle) {
        
        [docListBtn setTitle:@" 项目表单" forState:UIControlStateNormal];
        [docTreeBtn setTitle:@" 项目树" forState:UIControlStateNormal];
        [docLogBtn setTitle:@" 项目日志" forState:UIControlStateNormal];
    } else if (_style == CCityOfficalMainDocStyle) {
        
        [docListBtn setTitle:@" 公文表单" forState:UIControlStateNormal];
        [docTreeBtn setTitle:@" 公文树" forState:UIControlStateNormal];
        [docLogBtn setTitle:@" 公文日志" forState:UIControlStateNormal];
    }
    
    [menuView addSubview:docListBtn];
    [menuView addSubview:docTreeBtn];
    [menuView addSubview:docLogBtn];
    
    NSArray* viewsArr;
    
    if (_style == CCityOfficalMainSPStyle && _contentMode == 0) {
        
        CCityOfficalDocNavMenuBtn* goBackBtn = [CCityOfficalDocNavMenuBtn buttonWithType:UIButtonTypeCustom];
        goBackBtn.tag = 1504;
        [goBackBtn setTitle:@" 回退" forState:UIControlStateNormal];
        [goBackBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [goBackBtn setImage:[UIImage imageNamed:@"ccity_goback_20x20_"] forState:UIControlStateNormal];
        [menuView addSubview:goBackBtn];
        
        viewsArr = @[goBackBtn, docListBtn, docTreeBtn, docLogBtn];
    } else {
        
        viewsArr = @[docListBtn, docTreeBtn, docLogBtn];
    }
    
    [viewsArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [viewsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(menuView).with.offset(0.f);
        make.right.equalTo(menuView);
    }];
    
    return menuView;
}

// doc list
- (void)menuBtnClicked:(CCityOfficalDocNavMenuBtn*)btn {
   
    CCityOfficalDetialMenuBaseVC* menuVC;
   __block UIAlertController* alertVC;
    __block CCityOfficalDetailMenuVC* blockSelf = self;
    
    NSDictionary* ids = @{
                          @"workid" :_ids[@"workId"],
                          @"fk_flow":_ids[@"fk_flow"],
                          @"fk_node":_ids[@"fkNode"],
                          };
    switch (btn.tag) {
        case 1501:
            
            menuVC = [[CCityOfficalDetailProListVC alloc]initWithIds:ids];
            break;
        case 1502:
            
            menuVC = [[CCityOfficalDetailProTreeVC alloc]initWithIds:ids];
            break;
        case 1503:
            
            menuVC = [[CCityOfficalProLogVC alloc]initWithIds:ids];
            break;
            
        case 1504:
            
            alertVC = [UIAlertController alertControllerWithTitle:@"回退" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               
                textField.placeholder = @"回退意见";
            }];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [blockSelf goBackAction:alertVC];
            }]];
            
            break;
            
        default:
            break;
    }
    
    if (menuVC) {
        
        menuVC.mainStyle = _style;
        menuVC.contentMode = _contentMode;
        [self dismissViewControllerAnimated:NO completion:nil];
        if (self.pushToNextVC) {    self.pushToNextVC(menuVC);  }
    } else {
        
        if (alertVC) {
            
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    }
  
}

-(void)goBackAction:(UIAlertController*)alertCon {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parmaeters = @{
                                 @"token" :[CCitySingleton sharedInstance].token,
                                 @"workId"  :_ids[@"workId"],
                                 @"fkFlow"  :_ids[@"fk_flow"],
                                 @"fkNode"  :_ids[@"fkNode"],
                                 @"rollText":alertCon.textFields[0].text,
                                 };
    
    [manager POST:@"service/form/RollBack.ashx" parameters:parmaeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        
        if ([errorNoManager requestSuccess:responseObject]) {
            [self dismissViewControllerAnimated:NO completion:nil];
            
            if (self.pushToRoot) {
                self.pushToRoot();
            }
        } else {
            
            [errorNoManager getErrorNum:responseObject WithVC:self WithAction:nil loginSuccess:nil];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}

@end
