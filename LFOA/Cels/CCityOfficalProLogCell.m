

//
//  CCityOfficalProLogCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalProLogCell.h"

#define CCITY_CIRCLE_RADIDUS   12.f

@implementation CCityOfficalProLogCell

-(void)setModel:(CCityProLogDetailModel *)model {
    _model = model;
    
    UILabel* dayLabel = [UILabel new];
    
    UIColor* bgColor;
    
    NSInteger dayNum = [model.day integerValue];
    
    if (dayNum > 1 && dayNum <= 10) {
        
        bgColor = CCITY_RGB_COLOR(116, 116, 116, 1);
    } else if (dayNum > 10 && dayNum <= 20){
        
        bgColor = CCITY_RGB_COLOR(0, 176, 207, 1);
    } else {
        
        bgColor = CCITY_RGB_COLOR(155, 255, 156, 1);
    }
    
    UIView* lineView = [UIView new];
    lineView.backgroundColor = CCITY_DAY_LINE_COLOR;
    
    dayLabel.backgroundColor = bgColor;
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.text = model.day;
    dayLabel.clipsToBounds = YES;
    dayLabel.layer.cornerRadius = 17.f;
    
    UILabel* timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    timeLabel.text = model.time;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    titleLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    
    titleLabel.text = [NSString stringWithFormat:@"%@（%@）",model.title, model.name];
    
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:dayLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:titleLabel];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (_isBottom) {
            
            make.bottom.equalTo(self.contentView).with.offset(-20.f);
        } else {
            
            make.bottom.equalTo(self.contentView);
        }
        
        make.top.equalTo(self.contentView).with.offset(20.f);
        make.left.equalTo(self.contentView).with.offset(40.f);
        make.width.mas_equalTo(dayLabel.mas_height);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(3.f);
        make.center.equalTo(dayLabel);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(dayLabel);
        make.left.equalTo(dayLabel.mas_right).with.offset(10.f);
        make.bottom.equalTo(dayLabel);
        make.width.mas_equalTo(40.f);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(timeLabel);
        make.left.equalTo(timeLabel.mas_right).with.offset(10.f);
        make.bottom.equalTo(timeLabel);
        make.right.equalTo(self.contentView).with.offset(-5.f);
    }];
}

@end
