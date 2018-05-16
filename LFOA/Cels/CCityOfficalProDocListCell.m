//
//  CCityOfficalProDocListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/17.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalProDocListCell.h"

@implementation CCityOfficalProDocListCell

-(void)setModel:(NSDictionary *)model {
    _model = model;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_officalDetial_doc_list_50x50_"]];
    
    UILabel* nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    nameLabel.textColor = CCITY_MAIN_FONT_COLOR;
    nameLabel.text = model[@"name"];
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:nameLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(10.f);
        make.left.equalTo(self.contentView).with.offset(20.f);
        make.bottom.equalTo(self.contentView).with.offset(-10.f);
        make.width.equalTo(imageView.mas_height);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(imageView);
        make.right.equalTo(self.contentView).with.offset(-5.f);
    }];
}

@end
