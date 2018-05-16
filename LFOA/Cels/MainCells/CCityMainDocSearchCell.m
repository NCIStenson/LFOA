//
//  CCityMainDocSearchCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define SPACING 5.f

#import "CCityMainDocSearchCell.h"

@implementation CCityMainDocSearchCell {
    
    UILabel*     _numLabel;
    UILabel*     _reMarkLabel;
    UIImageView* _arrowImageView;
    UIControl*   _accessoryCon;
}

-(void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    
    if (isOpen) {
        
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        UILabel* dateLabel = [self detailsLabel];
        dateLabel.text = [NSString stringWithFormat:@"发行日期：%@", _model.time];

        _numLabel = [self detailsLabel];
        _numLabel.text = [NSString stringWithFormat:@"发行编号：%@", _model.number];
        
        _reMarkLabel = [self detailsLabel];
        _reMarkLabel.text = [NSString stringWithFormat:@"备注：%@", _model.info];
        _reMarkLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_numLabel];
        [self.contentView addSubview:_reMarkLabel];
        [self.contentView addSubview:dateLabel];
        
        NSMutableArray* accessConViewArr;
        
        if (_model.accessoryArr.count) {
            
            accessConViewArr = [NSMutableArray arrayWithCapacity:_model.accessoryArr.count];
            
            _accessoryCon = [[UIControl alloc]init];
            [self.contentView addSubview:_accessoryCon];
            
            [_accessoryCon mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_titleLabel);
                make.bottom.equalTo(self.contentView).with.offset(-SPACING);
                make.right.equalTo(_titleLabel);
                make.height.equalTo(@(_model.accessoryArr.count * 50.f + 5.f));
            }];
        }
        
        for(int i = 0; i < _model.accessoryArr.count; i++) {
            
            CCityAccessoryModel* accessoryModel = _model.accessoryArr[i];
            NSArray* names = [accessoryModel.accessoryName componentsSeparatedByString:@"."];
            CCityAppendixView* accessCon = [[CCityAppendixView alloc]init];
            
            accessCon.titleLabel.text = accessoryModel.accessoryName;
            accessCon.sizeLabel.text = accessoryModel.accessorySize;
            accessCon.url = accessoryModel.accessoryUrl;
            accessCon.type = [names lastObject];
            [_accessoryCon addSubview:accessCon];
            
            [accessCon mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(_accessoryCon).with.offset(i*50.f);
                make.left.equalTo(_accessoryCon);
                make.right.equalTo(_accessoryCon);
                make.height.mas_equalTo(@45.f);
            }];
            
            [accessConViewArr addObject:accessCon];
        }
        
        if (accessConViewArr) {
            _accessoryConArr = [accessConViewArr mutableCopy];
        }
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_fromLabel.mas_bottom);
            make.right.equalTo(_fromLabel);
            make.left.equalTo(_fromLabel);
            make.height.mas_equalTo(20.f);
        }];
        
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(dateLabel.mas_bottom).with.offset(SPACING);
            make.left.equalTo(_titleLabel);
            make.bottom.equalTo(_reMarkLabel.mas_top).with.offset(-SPACING);
            make.right.equalTo(_titleLabel);
        }];
        
        [_reMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numLabel.mas_bottom).with.offset(SPACING);
            make.left.equalTo(_titleLabel);
            
            if (_model.accessoryArr.count > 0) {
                
                make.bottom.equalTo(_accessoryCon.mas_top).with.offset(-SPACING * 2 );
            } else {
                
                make.bottom.equalTo(self.contentView).with.offset(-SPACING);
            }

            make.right.equalTo(_titleLabel);
        }];
        
    } else {
        
        if (_numLabel) {
            [_numLabel removeFromSuperview];
            _numLabel = nil;
        }
        
        if (_reMarkLabel) {
            [_reMarkLabel removeFromSuperview];
            _reMarkLabel = nil;
        }
        
        if (_accessoryCon) {
            [_accessoryCon removeFromSuperview];
            _accessoryCon = nil;
        }
    }
}

-(void)setModel:(CCityMainDocsearchDetailModel *)model {
    _model = model;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_home_info_50x50_"]];
   
    _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_arrow_toBottom_30x30_"]];
    
    _titleLabel = [self mytitleLabel];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = model.name;
    
    _fromLabel = [self detailsLabel];
    _fromLabel.text = [NSString stringWithFormat:@"发行机关：%@", model.from];
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_fromLabel];
    [self.contentView addSubview:_arrowImageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(15.f);
        make.left.equalTo(self.contentView).with.offset(20.f);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(25.f);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(2*SPACING);
        make.left.equalTo(imageView.mas_right).with.offset(SPACING);
        make.right.equalTo(_arrowImageView.mas_left).with.offset(-SPACING);
        make.bottom.equalTo(_fromLabel.mas_top).with.offset(-SPACING);
    }];
    
    [_fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(SPACING);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(_titleLabel);
        make.height.mas_equalTo(20.f);
    }];
}

-(UILabel*)mytitleLabel {
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    return titleLabel;
}

-(UILabel*)detailsLabel {
    
    UILabel* detailsLabel = [UILabel new];
    detailsLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    detailsLabel.font = [UIFont systemFontOfSize:13.f];
    return detailsLabel;
}

-(CGFloat)getCellHeightWithModel:(CCityMainDocsearchDetailModel*)model {
    
    CGFloat cellHeight;
    
    UILabel* titlelabel = [self mytitleLabel];
    titlelabel.numberOfLines = 0;
    titlelabel.text = model.name;
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 30 - 15 - 30 - 2*SPACING;
    
    titlelabel.text  = model.name;
    titlelabel.frame = CGRectMake(0, 0, labelWidth, MAXFLOAT);
    [titlelabel sizeToFit];
    
    UILabel* detailLabel = [self detailsLabel];
    detailLabel.numberOfLines = 0;
    detailLabel.text = [NSString stringWithFormat:@"备注：%@",model.info];
    detailLabel.frame = CGRectMake(0, 0, labelWidth, MAXFLOAT);
    [detailLabel sizeToFit];
    
    if (model.isOpen) {
        
        if (model.accessoryArr.count > 0) {
            
            cellHeight = 90 + model.accessoryArr.count * 50.f + 5.f;
        } else {
            
            cellHeight = 90.f;
        }
        
        cellHeight += titlelabel.bounds.size.height;
        cellHeight += detailLabel.bounds.size.height;
    } else {
        
        cellHeight = 40.f;
        cellHeight += titlelabel.bounds.size.height;

    }
    
    return cellHeight;
}

@end
