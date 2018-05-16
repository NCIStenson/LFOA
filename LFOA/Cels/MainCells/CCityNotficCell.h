//
//  CCityNotficCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityNotficModel.h"

@interface CCityNotficCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityNotficModel* model;
@property(nonatomic, strong) UIImageView* huarryImageView;
@property(nonatomic, strong) UIImageView* haveFilesImageView;
@property(nonatomic, strong) UILabel* fromLabel;
@property(nonatomic, strong) UILabel* nameLabel;
@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) UILabel* contentLabel;
@property(nonatomic, strong) UILabel* isReadLabel;

@end
