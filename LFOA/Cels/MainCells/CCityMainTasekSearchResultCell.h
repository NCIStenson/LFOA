//
//  CCityMainTasekSearchResultCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityMainSearchTaskModel.h"

@interface CCityMainTasekSearchResultCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityMainSearchTaskModel* model;
@property(nonatomic, strong) UILabel* proNameLabel;
@property(nonatomic, strong) UILabel* proNumLabel;
@property(nonatomic, strong) UILabel* proTypeLabel;
@property(nonatomic, strong) UILabel* registeTimeLabel;
@property(nonatomic, strong) UIImageView* myImageView;

-(CGFloat)getHeightWithModel:(CCityMainSearchTaskModel* )model;

@end
