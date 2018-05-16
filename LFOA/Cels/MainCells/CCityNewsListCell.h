//
//  CCityNewsListCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityNewsModel.h"

@interface CCityNewsListCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityNewsModel* model;
@property(nonatomic, strong) UILabel* mytitleLabel;
@property(nonatomic, strong) UILabel* typeLabel;
@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) UILabel* briefLabel;
@end
