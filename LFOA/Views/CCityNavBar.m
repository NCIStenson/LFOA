//
//  CCityNavBar.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNavBar.h"
#import "CCityBackToLeftView.h"

@implementation CCityNavBar {
    
    CCityBackToLeftView* _backToLeftView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self layoutMySubViews];
    }
    return self;
}

-(void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    if (showBottomLine) {
        
        CALayer* line = [self line];
        [self.layer addSublayer:line];
    }
}

-(CALayer*)line {
    
    CALayer* line = [CALayer new];
    line.frame = CGRectMake(0, 63.f, [UIScreen mainScreen].bounds.size.width, 1.f);
    line.backgroundColor = CCITY_GRAY_LINECOLOR.CGColor;
    return line;
}

-(void)layoutMySubViews {
    
    _backControl = [UIControl new];
    
    _backToLeftView = [CCityBackToLeftView new];
    _backToLeftView.tintColor = [UIColor blackColor];
    _backToLeftView.backgroundColor = [UIColor whiteColor];
    
    _backLabel = [UILabel new];
    _backLabel.text = @"返回";
    _backLabel.font = [UIFont systemFontOfSize:17.f];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    [_backControl addSubview:_backLabel];
    [_backControl addSubview:_backToLeftView];
    [self addSubview:_backControl];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_backControl.mas_right).with.offset(5.f);
        make.bottom.equalTo(_backControl);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 200.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_backToLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_backControl);
        make.bottom.equalTo(_backControl).with.offset(-10.f);
        make.width.equalTo(@15.f);
        make.height.mas_equalTo(24.f);
    }];
    
    [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_backToLeftView);
        make.left.equalTo(_backToLeftView.mas_right).with.offset(3.f);
        make.bottom.equalTo(_backToLeftView);
        make.right.equalTo(_backControl);
    }];
    
    [_backControl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).with.offset(20.f);
        make.left.equalTo(self).with.offset(10.f);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(90.f);
    }];
}

-(void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    
    self.backgroundColor = barTintColor;
    _backToLeftView.backgroundColor = barTintColor;
}

-(void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    _backLabel.textColor = tintColor;
    _titleLabel.textColor = tintColor;
    _backToLeftView.tintColor = tintColor;
}

@end
