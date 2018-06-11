//
//  CCityDatePickerVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityDatePickerVC.h"
#import "CCityNavBar.h"

@interface CCityDatePickerVC ()

@end

@implementation CCityDatePickerVC {
    
    NSDate* _date;
}

- (instancetype)initWithDate:(NSDate*)date withIsShowTime:(CCityOfficalDetailSectionStyle)style
{
    self = [super init];
    
    if (self) {
        _style = style;
        _date = date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    if (_style == CCityOfficalDetailDateTimeStyle) {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.frame = self.view.bounds;
    [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    
    if (_date) {    _datePicker.date = _date;   }
    
    CCityNavBar* navBar = [self navBar];
    
    UIButton* okBtn =  [self bottomBtnWithTitle:@"取消"];
    [okBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
  
    UIButton* cancelBtn =  [self bottomBtnWithTitle:@"确定"];
    [cancelBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_datePicker];
    [self.view addSubview:okBtn];
    [self.view addSubview:cancelBtn];
    [self.view addSubview:navBar];
    
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@64.f);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(10.f);
        if ([CCITY_SYSTEM_TYPE isEqualToString:@"X"]) {
            make.bottom.equalTo(self.view).with.offset(-30.f);
        }
        make.bottom.equalTo(self.view).with.offset(-15.f);
        make.right.equalTo(cancelBtn.mas_left).with.offset(-30.f);
        make.width.equalTo(cancelBtn);
        make.height.equalTo(@40.f);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(okBtn);
        make.left.equalTo(okBtn.mas_right).with.offset(30.f);
        make.bottom.equalTo(okBtn);
        make.right.equalTo(self.view).with.offset(-10.f);
    }];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(okBtn.mas_top);
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

-(CCityNavBar*)navBar {
    
    CCityNavBar* navBar       = [[CCityNavBar alloc]init];
    navBar.titleLabel.text    = @"请编辑日期和时间";
    
    [navBar.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(navBar).with.insets(UIEdgeInsetsMake(24, 0, 0, 0));
    }];
    
    navBar.backControl.hidden = YES;
    navBar.tintColor          = [UIColor whiteColor];
    navBar.barTintColor       = CCITY_MAIN_COLOR;
    navBar.tintColor          = [UIColor whiteColor];
    
    [navBar.backControl addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    return navBar;
}

-(UIButton*)bottomBtnWithTitle:(NSString*)title {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.clipsToBounds = YES;
    bottomBtn.layer.cornerRadius = 5.f;
    return bottomBtn;
}

#pragma mark- --- methods

- (void) okAction {
    
    NSString *str = [self dateToString:_datePicker.date withDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    if (self.slelectAction) {
        self.slelectAction(str);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (void) dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
