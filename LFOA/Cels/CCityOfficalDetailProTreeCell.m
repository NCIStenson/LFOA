
//
//  CCityOfficalDetailProTreeCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailProTreeCell.h"
#import "CCityLinePointView.h"

@implementation CCityOfficalDetailProTreeCell

-(void)setModel:(CCityOfficalProTreeModel *)model {
    _model = model;
    
    _localImageView = [[UIImageView alloc]init];

    UILabel* titleLabel = [UILabel new];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:_localImageView];
    
    if (model.children.count) {
        
        _localImageView.image = [UIImage imageNamed:@"ccity_trangle_24x24_"];
        
        [_localImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(15.f);
            make.left.equalTo(self.contentView).with.offset(10 + model.level * 10);
            make.bottom.equalTo(self.contentView).with.offset(-15.f);
            make.width.equalTo(_localImageView.mas_height);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_localImageView);
            make.left.equalTo(_localImageView.mas_right).with.offset(5.f);
            make.bottom.equalTo(_localImageView);
            make.right.equalTo(self.contentView).with.offset(-5.f);
        }];

    } else {
        
        CCityLinePointView* linePoint = [CCityLinePointView new];
        linePoint.backgroundColor = [UIColor whiteColor];
        
        [_localImageView addSubview:linePoint];
        
        [_localImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(5.f);
            make.left.equalTo(self.contentView).with.offset(10 + model.level * 10);
            make.bottom.equalTo(self.contentView).with.offset(-10.f);
            make.width.equalTo(_localImageView.mas_height);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(_localImageView.mas_right).with.offset(7.f);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.right.equalTo(self.contentView).with.offset(-10.f);
        }];
        
        [linePoint mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(_localImageView).with.insets(UIEdgeInsetsMake(3, 0, 3, 0));
        }];
    }
}

@end
