//
//  CCityDataPickerVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityDataPickerVC.h"
#import <MarqueeLabel.h>
#import "CCityNavBar.h"

@interface CCityDataPickerVC ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CCityDataPickerVC {
    
    NSArray* _datas;
    NSInteger _selectedIndex;
}

- (instancetype)initWtihDatas:(NSArray*)datas
{
    self = [super init];
    
    if (self) {
        
        _datas = datas;
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIndex = _datas.count/2;
    
    CCityNavBar* navView = [self navView];
    
    
    UIPickerView* pickerView = [self dataPickerView];
    
    UIButton* okBtn = [self bottomBtnWithTitle:@"确认"];
    okBtn.tag = 40001;
    
    UIButton* cancelBtn = [self bottomBtnWithTitle:@"取消"];
    
    [self.view addSubview:navView];
    [self.view addSubview:pickerView];
    [self.view addSubview:okBtn];
    [self.view addSubview:cancelBtn];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64.f);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.view).with.offset(15.f);
        make.bottom.equalTo(self.view).with.offset(-15.f);
        make.left.equalTo(cancelBtn.mas_left).with.offset(-30.f);
        make.width.equalTo(cancelBtn);
        make.height.equalTo(@40.f);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(okBtn);
        make.right.equalTo(okBtn.mas_right).with.offset(30.f);
        make.bottom.equalTo(okBtn);
        make.left.equalTo(self.view).with.offset(-15.f);
        make.width.equalTo(okBtn);
    }];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(navView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(okBtn.mas_top);
        make.right.equalTo(self.view);
    }];
}

#pragma mark- --- layout subviews
-(CCityNavBar*)navView {
    
    CCityNavBar* navBar = [CCityNavBar new];
    navBar.backControl.hidden = YES;
//    navBar.showBottomLine = YES;
    navBar.titleLabel.text = self.title;
    navBar.barTintColor = CCITY_MAIN_COLOR;
    navBar.tintColor = [UIColor whiteColor];
    return navBar;
}

-(UIPickerView*)dataPickerView {
    
    UIPickerView* dataPickerView = [[UIPickerView alloc]init];
    dataPickerView.delegate = self;
    dataPickerView.dataSource = self;
    [dataPickerView selectRow:_datas.count/2 inComponent:0 animated:NO];
    return dataPickerView;
}

-(UIButton*)bottomBtnWithTitle:(NSString*)title {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.layer.cornerRadius = 5.f;
    bottomBtn.clipsToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return bottomBtn;
}

#pragma mark- --- methods

- (void)bottomBtnAction:(UIButton*)btn {
    
    if (!_datas.count) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if (btn.tag == 40001) {
        
        if (self.didSelectData) {
            self.didSelectData(_datas[_selectedIndex]);
        }
    }
}

#pragma mark- --- uipickerview datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    MarqueeLabel* lable = [[MarqueeLabel alloc]init];
    lable.text = _datas[row];
    lable.fadeLength = 30.f;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.holdScrolling = YES;
    lable.labelize = YES;
    return lable;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _datas.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    MarqueeLabel* label = (MarqueeLabel*)[pickerView viewForRow:row forComponent:component];
    label.holdScrolling = NO;
    label.labelize = NO;
    _selectedIndex = row;
}

@end
