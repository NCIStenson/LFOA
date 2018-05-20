//
//  CCityMainMeetingCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityMainMeetingListModel.h"

@interface CCityMainMeetingCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityMainMeetingListModel* model;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UILabel* numLabel;
@property(nonatomic, strong) UILabel* placeLabel;
@property(nonatomic, strong) UIImageView* accessoryImageView;
@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) UILabel* isReadLabel;
@end
