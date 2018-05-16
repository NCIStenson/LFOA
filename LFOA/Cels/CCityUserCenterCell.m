//
//  CCityUserCenterCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityUserCenterCell.h"

@implementation CCityUserCenterCell

- (instancetype)initWithImageName:(NSString*)imageName title:(NSString*)title showArrow:(BOOL)showArrow
{
    self = [super init];
    if (self) {
        
        [self layoutSubViewWithImageName:imageName title:title showArrow:showArrow];
    }
    return self;
}

- (void)layoutSubViewWithImageName:(NSString*)imageName title:(NSString*)title showArrow:(BOOL)showArrow {
    
    UIView* bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* titleImageView = [self titleImageView];
    titleImageView.image = [UIImage imageNamed:imageName];
    
    UILabel* titleLabel = [self titleLabel];
    titleLabel.text = title;
    
    [self.contentView addSubview:bgView];
    [bgView addSubview:titleImageView];
    [bgView addSubview:titleLabel];
    
    UIImageView* arrowImageView;
    
    if (showArrow) {
        
        arrowImageView = [self arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"ccity_arrow_right_44x44_"];
        
        [bgView addSubview:arrowImageView];
        
        float arrowPadding = 13.f;
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bgView).with.offset(arrowPadding);
            make.bottom.equalTo(bgView).with.offset(-arrowPadding);
            make.right.equalTo(bgView).with.offset(-arrowPadding);
            make.width.equalTo(arrowImageView.mas_height);
        }];
    }
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(3, 0, 0, 0));
    }];
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView).with.offset(20.f);
        make.top.equalTo(bgView).with.offset(10.f);
        make.bottom.equalTo(bgView).with.offset(-10.f);
        make.width.equalTo(titleImageView.mas_height);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(titleImageView);
        make.height.mas_equalTo(20.f);
        make.left.equalTo(titleImageView.mas_right).with.offset(5.f);
        
        if (showArrow) {    make.right.equalTo(arrowImageView.mas_left).with.offset(-5.f);  }
        else          {  make.right.equalTo(bgView).with.offset(-5.f);   }
    }];

}

// image 
-(UIImageView*)titleImageView {
    
    UIImageView* imageView = [UIImageView new];
    return imageView;
}

// title 
-(UILabel*)titleLabel {
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    return titleLabel;
}

// arrow 
-(UIImageView*)arrowImageView {
    
    UIImageView* imageView = [UIImageView new];
    return imageView;
}

@end
