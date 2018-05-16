//
//  CCityOfficalDetailSectionView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_OFFICAL_DETAIL_SECTION_HEIGHT 44.f

#import "CCityOfficalDetailSectionView.h"

@implementation CCityOfficalDetailSectionView

- (instancetype)initWithStyle:(CCityOfficalDetailSectionStyle)sectionStyle
{
    self = [super init];
    
    if (self) {
        
        _contentStyle  = sectionStyle;
        _hasTopLine    = YES;
        _hasBottomLine = NO;
        [self layoutMysubviews];
    }
    return self;
}

-(void)setModel:(CCityOfficalDocDetailModel *)model {
    _model = model;
    
    _titleLabel.text  = model.title;
    _valueLabel.text = model.value;

    if (_valueLabel) {
        
        _titleLabel.frame = CGRectMake(10, 5, model.titleLabelSize.width, model.titleLabelSize.height);

        if (model.titleLabelSize.width > [UIScreen mainScreen].bounds.size.width * 2 / 3) {
            
            CGRect titleFrame = _titleLabel.frame;
            titleFrame.origin.y = 10;
            _titleLabel.frame = titleFrame;
            
            _valueLabel.textAlignment = NSTextAlignmentLeft;
            _valueLabel.frame = CGRectMake(10, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width - 20, model.sectionHeight - model.titleLabelSize.height - 20);
        } else {
            
            _valueLabel.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 20, _titleLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - _titleLabel.frame.origin.x - _titleLabel.frame.size.width - 20 - 10, model.sectionHeight - 10);
        }
    }
    
    if (self.imageView) {
        
        if (model.isOpen) {
            
            [self.imageView setImage:[UIImage imageNamed:@"ccity_officalDetail_opened_24x24"]];
        } else {
            
            [self.imageView setImage:[UIImage imageNamed:@"ccity_officalDetail_add_24x24"]];
        }
    }
}

#pragma mark- --- layout subviews

-(void)layoutMysubviews {
    
    _titleLabel               = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font          = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor     = [UIColor blackColor];
    
    [self addSubview:_titleLabel];

    if (_contentStyle == CCityOfficalDetailOpinionStyle) {
        
         _imageView = [[UIImageView alloc]init];
    } else if (_contentStyle == CCityOfficalDetailMutableLineTextStyle) {
        self.userInteractionEnabled = NO;
//        _imageView = [[UIImageView alloc]init];
    } else if (_contentStyle == CCityOfficalDetailDataExcleStyle) {
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.backgroundColor = [UIColor whiteColor];
        [_addBtn setImage:[UIImage imageNamed:@"cc_single_add_24x24"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"cc_gray_single_add_24x24"] forState:UIControlStateHighlighted];
        _addBtn.imageView.contentMode = UIViewContentModeRight;

    } else {
        
        _valueLabel = [UILabel new];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.numberOfLines = 0;
        _valueLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] -1];
        [self addSubview:_valueLabel];
    }
    
    if (_imageView) {
        
        [self addSubview:_imageView];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.left.equalTo(self).offset(10.f);
            make.bottom.equalTo(self);
            make.right.equalTo(_imageView.mas_left).with.offset(-10.f);
        }];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).with.offset(10.f);
            make.right.equalTo(self).with.offset(-10.f);
            make.bottom.equalTo(self).with.offset(-10.f);
            make.width.equalTo(_imageView.mas_height);
        }];
    } else if (_addBtn) {
        
        [self addSubview:_addBtn];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.left.equalTo(self).offset(10.f);
            make.bottom.equalTo(self);
            make.right.equalTo(_addBtn.mas_left).with.offset(-10.f);
        }];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).with.offset(1.f);
            make.right.equalTo(self).with.offset(-10.f);
            make.bottom.equalTo(self).with.offset(0.f);
            make.width.equalTo(@44.f);
        }];
    } else {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.left.equalTo(self).offset(10.f);
            make.bottom.equalTo(self);
            make.right.equalTo(self).with.offset(-10.f);
        }];
    }
}

#pragma mark- --- methods

-(void)drawRect:(CGRect)rect {
    
    if (_hasTopLine == NO && _hasBottomLine == NO) {    return; }
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, CCITY_GRAY_LINECOLOR.CGColor);
    if (_hasTopLine) {
        
        CGContextMoveToPoint(contextRef, 3, 0);
        CGContextAddLineToPoint(contextRef, self.bounds.size.width-3, 0);
    }

//    if (_hasBottomLine) {
//
//        CGContextMoveToPoint(contextRef, 3,  self.bounds.size.height);
//        CGContextAddLineToPoint(contextRef, self.bounds.size.width-3, self.bounds.size.height);
//    }
    
    CGContextStrokePath(contextRef);
}

@end
