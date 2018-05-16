//
//  CCityHomeCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/5.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityHomeCell.h"

@implementation CCityHomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutMysubViews];
    }
    return self;
}

#pragma mark- --- layout

-(void)layoutMysubViews {
    
    self.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark- --- setter

-(void)setModel:(CCityHomeModel *)model {
    _model = model;
    
    UIView* contentView = [UIView new];
    
    contentView.backgroundColor = [UIColor whiteColor];
    
    _mainImageView = [self myMainImageView];
    _titleLabel    = [self myTitleLabel];
    [self myBadgeViewWithSuperView:_mainImageView];

    _titleLabel.text = model.title;
    _mainImageView.image = [UIImage imageNamed:model.imageName];
        
    if (model.badgeNum <= 0) {
        _badgeView.hidden = YES;
    } else {
        _badgeView.badgeText = [NSString stringWithFormat:@"%d",(int)model.badgeNum];
    }

    [self.contentView addSubview:contentView];
    [contentView addSubview:_mainImageView];
    [contentView addSubview:_titleLabel];
    
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
            
            make.left.equalTo(contentView).with.offset(32.5f);
            make.right.equalTo(contentView).with.offset(-32.5f);
        } else {
            
            make.left.equalTo(contentView).with.offset(40.f);
            make.right.equalTo(contentView).with.offset(-40.f);
        }

        make.bottom.equalTo(_titleLabel.mas_top);
        make.width.equalTo(_mainImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        
        if ([UIScreen mainScreen].bounds.size.width <= 320 ) {
            
            make.bottom.equalTo(contentView).with.offset(-5.f);

        } else {
            
            make.bottom.equalTo(contentView).with.offset(-10.f);
        }
        
        make.height.mas_equalTo(30.f);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        UIEdgeInsets insets;
        
        if (_posintion == CCityHomeCellPositionCenter) {
            
            insets = UIEdgeInsetsMake(.5f, .5f, 0, .5f);
        } else {
            
            insets = UIEdgeInsetsMake(.5f, 0, 0, 0);
        }
        
        make.edges.equalTo(self.contentView).with.insets(insets);
    }];
}

- (UIImageView*)myMainImageView {
    
    _mainImageView = [[UIImageView alloc]init];
    return _mainImageView;
}

-(JSBadgeView*)myBadgeViewWithSuperView:(UIView*)superView {
    
    _badgeView = [[JSBadgeView alloc]initWithParentView:superView alignment:JSBadgeViewAlignmentTopRight];
    
    if ([UIScreen mainScreen].bounds.size.width >= 414) {
        
        _badgeView.badgePositionAdjustment = CGPointMake(-7, 8);
    } else {
        
        _badgeView.badgePositionAdjustment = CGPointMake(-5, 5);
    }
    
    _badgeView.badgeTextFont = [UIFont systemFontOfSize:12.f];
    _badgeView.badgeStrokeColor = [UIColor whiteColor];
    _badgeView.badgeStrokeWidth = 2.f;
    
    return _badgeView;
}

-(UILabel*)myTitleLabel {
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:13.f];
    return _titleLabel;
}

/*
- (UILabel*)myBadgeLabel {
    
    _badgeLable = [UILabel new];
    _badgeLable.text = @"9";
    _badgeLable.backgroundColor = [UIColor redColor];
    _badgeLable.textColor = [UIColor whiteColor];
    _badgeLable.layer.borderColor = [UIColor whiteColor].CGColor;
    _badgeLable.layer.borderWidth = 2.f;
    _badgeLable.clipsToBounds = YES;
    _badgeLable.textAlignment = NSTextAlignmentCenter;
    _badgeLable.font = [UIFont systemFontOfSize:11.f];
    return _badgeLable;
}
*/
@end
