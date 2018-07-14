//
//  CCityOfficalDetailSectionView.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCityOfficalDocDetailModel.h"

@interface CCityOfficalDetailSectionView : UIControl

@property(nonatomic, strong)CCityOfficalDocDetailModel* model;

@property(nonatomic, assign)CCityOfficalDetailSectionStyle contentStyle;
@property(nonatomic, assign)NSInteger sectionNum;

@property(nonatomic, assign)BOOL hasTopLine;
@property(nonatomic, assign)BOOL hasBottomLine;

@property(nonatomic, strong) UIImageView* imageView;
@property(nonatomic, strong) UIButton* commonWordsBtn;
@property(nonatomic, strong) UILabel*     titleLabel;
@property(nonatomic, strong) UILabel*     valueLabel;
@property(nonatomic, strong) UIButton*    addBtn;

- (instancetype)initWithStyle:(CCityOfficalDetailSectionStyle)sectionStyle;

@end
