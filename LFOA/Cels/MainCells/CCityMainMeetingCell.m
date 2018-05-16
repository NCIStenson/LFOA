//
//  CCityMainMeetingCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_MEETING_CELL_PADDING 5.f
#define CC_BG_COLOR     [UIColor whiteColor]

#import "CCityMainMeetingCell.h"

@implementation CCityMainMeetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self layout];
    }
    return self;
}

- (void) layout {
    
    _titleLabel = [self _titleLabel];
    _numLabel = [self detailLabel];
    _timeLabel = [self detailLabel];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _placeLabel = [self detailLabel];

    _accessoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_accessonary_30x30_"]];
    _accessoryImageView.backgroundColor = CC_BG_COLOR;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_numLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_accessoryImageView];
    [self.contentView addSubview:_placeLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(self.contentView).with.offset(2*CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(_numLabel.mas_top).with.offset(-5.f);
        make.right.equalTo(self.contentView).with.offset(-CCITY_MEETING_CELL_PADDING);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(_timeLabel.mas_left).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(_placeLabel.mas_top).with.offset(-CCITY_MEETING_CELL_PADDING);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_numLabel);
        make.left.equalTo(_numLabel.mas_right).with.offset(CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(_numLabel);
        make.right.equalTo(_accessoryImageView.mas_left).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.width.mas_equalTo(120.f);
    }];
    
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom);
        make.right.equalTo(_titleLabel);
        make.bottom.equalTo(_timeLabel);
        make.width.equalTo(_accessoryImageView.mas_height);
    }];
    
    [_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_numLabel.mas_bottom).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.right.equalTo(_titleLabel);
    }];
}

-(void)setModel:(CCityMainMeetingListModel *)model {
    _model = model;
    
    _titleLabel.text = model.meetingTitle;
    
    _numLabel.text = model.meetingNum;
    

    _timeLabel.text = model.meetingTime;
    
    _placeLabel.text = model.meetingPlace;
    
    if (model.hasFile == NO) {
        _accessoryImageView.hidden = YES;
    } else {
        _accessoryImageView.hidden = NO;
    }
}

-(UILabel*)_titleLabel {
    
    UILabel* _titleLabel = [UILabel new];
    _titleLabel.backgroundColor = CC_BG_COLOR;
//    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    return _titleLabel;
}

-(UILabel*)detailLabel {
    
    UILabel* detailLabel = [UILabel new];
    detailLabel.backgroundColor = CC_BG_COLOR;
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    detailLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    
    return detailLabel;
}

@end
