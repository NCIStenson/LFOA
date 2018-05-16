//
//  CCityMainDetailTaskSearchCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CCityMainDetailTaskSearchCellStyle) {
    
    CCityMainDetailTaskSearchCellNormalStyle,
    CCityMainDetailTaskSearchCellNormalTFStyle,
    CCityMainDetailTaskSearchCellTriangleTFStyle,
    CCityMainDetailTaskSearchCellDateStyle,
};

@class CCityMainDetailTaskSearchCell;

@protocol CCityMainDetailTaskSearchCellDelegate <NSObject>

-(void)valueSelected:(CCityMainDetailTaskSearchCell*)cell;
-(void)timeDidselected:(CCityMainDetailTaskSearchCell*)cell tag:(NSInteger)tag;

@end

#import <UIKit/UIKit.h>
#import "CCityMainDetailSearchModel.h"
#import "CCityTriangleTF.h"

@interface CCityMainDetailTaskSearchCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic, assign)id<CCityMainDetailTaskSearchCellDelegate> delegate;

@property(nonatomic, strong)CCityMainDetailSearchModel* model;
@property(nonatomic, assign)CCityMainDetailTaskSearchCellStyle searchStyle;
@property(nonatomic, copy)void(^timeDidSelectAction)(NSString* selectedTime,NSInteger tag);
@property(nonatomic, strong)CCityTriangleTF* myTextField;

@property(nonatomic, strong)CCityTriangleTF* beginTimeTF;
@property(nonatomic, strong)CCityTriangleTF* endTimeTF;


@end
