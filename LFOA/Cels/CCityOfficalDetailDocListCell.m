//
//  CCityOfficalDetailDocListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/17.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailDocListCell.h"
#import "CCityImageTypeManager.h"

@implementation CCityOfficalDetailDocListCell

-(void)setModel:(NSDictionary *)model {
    _model = model;
    
    UIImageView* imageView = [UIImageView new];
    
    imageView.image = [UIImage imageNamed:[CCityImageTypeManager getImageNameWithType:model[@"filetype"]]];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = model[@"filename"];
    titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    titleLabel.textColor = CCITY_MAIN_FONT_COLOR;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(10.f);
        make.left.equalTo(self.contentView).with.offset(30.f);
        make.bottom.equalTo(self.contentView).with.offset(-10.f);
        make.width.equalTo(imageView.mas_height);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(imageView);
        make.right.equalTo(self.contentView).with.offset(-5.f);
    }];
    
}

@end
