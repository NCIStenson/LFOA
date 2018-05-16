//
//  CCityNewsListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//
#define CC_BG_COLOR [UIColor whiteColor]
#import "CCityNewsListCell.h"

@implementation CCityNewsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self layout];
    }
    return self;
}

-(void)layout {
    
    _mytitleLabel = [UILabel new];
    _mytitleLabel.backgroundColor = CC_BG_COLOR;
    
    _typeLabel = [self titleLabel];
    _typeLabel.textColor = CCITY_MAIN_COLOR;
    _typeLabel.backgroundColor = CC_BG_COLOR;
    
    _timeLabel = [self detailLabel];
    _timeLabel.backgroundColor = CC_BG_COLOR;
    
    _briefLabel = [self detailLabel];
    _briefLabel.backgroundColor = CC_BG_COLOR;
    
    [self.contentView addSubview:_mytitleLabel];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_briefLabel];
    
    [_mytitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(5.f);
        make.left.equalTo(self.contentView).with.offset(10.0f);
        make.right.equalTo(self.contentView).with.offset(-5.0f);
        make.bottom.equalTo(_typeLabel.mas_top).with.offset(-5.f);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_mytitleLabel.mas_bottom).with.offset(5.f);
        make.left.equalTo(_mytitleLabel);
        make.right.equalTo(_timeLabel.mas_left).with.offset(-5.f);
        make.bottom.equalTo(_briefLabel.mas_top).with.offset(-5.f);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_typeLabel);
        make.bottom.equalTo(_typeLabel);
        make.right.equalTo(_mytitleLabel);
        make.width.mas_equalTo(95.f);
    }];
    
    [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_typeLabel.mas_bottom).with.offset(5.f);
        make.left.equalTo(_mytitleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-5.f);
        make.right.equalTo(_mytitleLabel);
    }];
}

-(void)setModel:(CCityNewsModel *)model {
    _model = model;
    
    _mytitleLabel.text = model.title;
    _typeLabel.text = [NSString stringWithFormat:@"[%@]", model.type];
    _timeLabel.text = model.time;
    _briefLabel.text = model.brief;
}

-(UILabel*)titleLabel {
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    return titleLabel;
}

-(UILabel*)detailLabel {
    
    UILabel* detailLabel = [UILabel new];
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    detailLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    
    return detailLabel;
}

@end
