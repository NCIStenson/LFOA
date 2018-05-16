//
//  CCityMainMessageCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@class CCityMainMessageCell;

@protocol CCityMainMessageCellDelegate<NSObject>

-(void)openBtnSelectedAction:(CCityMainMessageCell*)cell;

@end

#import <UIKit/UIKit.h>
#import "CCityMessageModel.h"
#import <YYKit.h>
#import "NSAttributedString+YYText.h"
@interface CCityMainMessageCell : UITableViewCell

@property(nonatomic, strong)CCityMessageModel* model;
@property(nonatomic, weak)id<CCityMainMessageCellDelegate> delegate;
@property(nonatomic, strong) UIView* tailView;
@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) YYLabel* contentLabel;
@property(nonatomic, strong) UIView* typeImageView;
@property(nonatomic, strong) UIImageView* myImageView;
@end
