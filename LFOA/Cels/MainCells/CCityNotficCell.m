//
//  CCityNotficCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_SPACING 5.f
#define CCITY_PADDING 10.f
#define CC_BG_COLOR  [UIColor whiteColor]
#import "CCityNotficCell.h"

@implementation CCityNotficCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self layout];
    }
    
    return self;
}

-(void)layout {
    
    _huarryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_ji_20x20_"]];
    _huarryImageView.backgroundColor = CC_BG_COLOR;
    _fromLabel = [UILabel new];
    _fromLabel.backgroundColor = CC_BG_COLOR;
    _timeLabel = [self detailsLabel];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel = [self myNameLabel];
    _contentLabel = [self detailsLabel];
    _isReadLabel = [self isRead];
    
    [self.contentView addSubview:_huarryImageView];
    [self.contentView addSubview:_fromLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_isReadLabel];
    
    [_huarryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(8.f);
        make.left.equalTo(self.contentView).with.offset(CCITY_PADDING);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(10.f);
        make.left.equalTo(_huarryImageView.mas_right).with.offset(CCITY_SPACING);
        make.right.equalTo(_timeLabel.mas_left).with.offset(-CCITY_SPACING);
        make.bottom.equalTo(_nameLabel.mas_top).with.offset(-CCITY_SPACING);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_fromLabel);
        make.right.equalTo(self.contentView).with.offset(-CCITY_PADDING);
        make.bottom.equalTo(_fromLabel);
        make.width.mas_equalTo(80.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_fromLabel.mas_bottom).with.offset(CCITY_SPACING);
        make.left.equalTo(_fromLabel);
        make.bottom.equalTo(_contentLabel.mas_top).with.offset(-CCITY_SPACING);
        make.right.equalTo(_isReadLabel.mas_left).with.offset(-CCITY_SPACING);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(CCITY_SPACING);
        make.left.equalTo(_fromLabel);
        make.bottom.equalTo(self.contentView).with.offset(-CCITY_SPACING);
        make.right.equalTo(self.contentView).with.offset(-CCITY_PADDING);
    }];
    
    [_isReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_nameLabel);
        make.right.equalTo(_timeLabel);
        make.bottom.equalTo(_nameLabel);
        make.width.mas_equalTo(45.f);
    }];
}

-(void)setModel:(CCityNotficModel *)model {
    _model = model;
    
    if (model.isHeightLevel == NO) {
        
        _huarryImageView.hidden = YES;
    }
    
    _fromLabel.text = model.notficFromName;
    
    _timeLabel.text = model.notficPostTime;
    
    _nameLabel.text = model.notficTitle;
    
    _contentLabel.text = model.notficContent;
    
    if (model.isRead) {
        _isReadLabel.text = @"[已读]";
        _isReadLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    } else {
        _isReadLabel.text = @"[未读]";
        _isReadLabel.textColor = CCITY_MAIN_COLOR;
    }
    
    if (_haveFilesImageView) {
        [_haveFilesImageView removeFromSuperview];
        _haveFilesImageView = nil;
    }
    
    if (model.isHaveFile) {
        
        _haveFilesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_accessonary_30x30_"]];
        _haveFilesImageView.backgroundColor = CC_BG_COLOR;
        [self.contentView addSubview:_haveFilesImageView];

        [_haveFilesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(5.f);
            make.right.equalTo(self.contentView).with.offset(-CCITY_SPACING);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [_isReadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_nameLabel);
            make.bottom.equalTo(_nameLabel);
            make.right.equalTo(_haveFilesImageView.mas_left).with.offset(-CCITY_SPACING);
            make.width.mas_equalTo(45.f);
        }];
    }
}

-(UILabel*)isRead {
    
    UILabel* detailsLabel = [UILabel new];
    detailsLabel.backgroundColor = CC_BG_COLOR;
    detailsLabel.textAlignment = NSTextAlignmentRight;
    detailsLabel.font = [UIFont systemFontOfSize:15.f];
    return detailsLabel;
}

-(UILabel*)detailsLabel {
    
    UILabel* detailsLabel = [UILabel new];
    detailsLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    detailsLabel.backgroundColor = CC_BG_COLOR;
    detailsLabel.font = [UIFont systemFontOfSize:13.f];
    return detailsLabel;
}

-(UILabel*)myNameLabel {
    
    UILabel* myNameLabel = [UILabel new];
    myNameLabel.backgroundColor = CC_BG_COLOR;
    myNameLabel.font = [UIFont systemFontOfSize:15.f];
    return myNameLabel;
}

@end
