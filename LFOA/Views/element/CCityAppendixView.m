//
//  CCityAppendixView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAppendixView.h"
#import "CCityImageTypeManager.h"

@implementation CCityAppendixView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self layoutMySubviews];
    }
    return self;
}

-(void)layoutMySubviews {
        
    _padding = 5.f;
    
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3f].CGColor;
    self.layer.borderWidth = 2.f;
    
    _imageView = [[UIImageView alloc]init];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = CCITY_MAIN_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:13.f];
    
    _sizeLabel = [[UILabel alloc]init];
    _sizeLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    _sizeLabel.font = [UIFont systemFontOfSize:13.f];
    
    UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_arrow_toRight_44x44_"]];
    
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
    [self addSubview:_sizeLabel];
    [self addSubview:arrowImageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).with.offset(3*_padding);
        make.left.equalTo(self).with.offset(_padding);
        make.bottom.equalTo(self).with.offset(-3*_padding);
        make.width.equalTo(_imageView.mas_height);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).with.offset(18.f);
        make.bottom.equalTo(self).with.offset(-18.f);
        make.right.equalTo(self).with.offset(-2*_padding);
        make.width.equalTo(arrowImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).with.offset(_padding);
        make.left.equalTo(_imageView.mas_right).with.offset(_padding);
        make.bottom.equalTo(_sizeLabel.mas_top).with.offset(-_padding);
        make.right.equalTo(arrowImageView.mas_left).with.offset(-10.f);
        make.height.equalTo(_sizeLabel);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(_padding);
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(self).with.offset(-_padding);
        make.right.equalTo(_titleLabel);
        make.height.equalTo(_titleLabel);
    }];
}

-(void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    _titleLabel.textColor = _titleColor;
}

-(void)setType:(NSString *)type {
    _type = type;
    
    _imageView.image = [UIImage imageNamed:[CCityImageTypeManager getImageNameWithType:type]];
}

@end
