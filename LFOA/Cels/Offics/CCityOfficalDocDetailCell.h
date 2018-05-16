//
//  CCityOfficalDocDetailCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@class CCityOfficalDocDetailCell;

@protocol CCityOfficalDocDetailDelegate <NSObject>

- (void)textViewWillEditingWithCell:(CCityOfficalDocDetailCell*)cell;
- (void)textViewDidEndEditingWithCell:(CCityOfficalDocDetailCell*)cell;
- (void)textViewTextDidChange:(CCityOfficalDocDetailCell*)cell;

@end

#import <UIKit/UIKit.h>
#import "CCityOfficalDocDetailModel.h"

//UITableViewDelegate, UITableViewDataSource

@interface CCityOfficalDocDetailCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic, strong)UITextView*                 textView;
@property(nonatomic, strong)CCityOfficalDocDetailModel* model;
@property(nonatomic, strong)CCHuiQianModel*             huiqianModel;
@property(nonatomic, strong)UILabel*                    numLabel;
@property(nonatomic, assign)BOOL                        removeBottomLine;

@property(nonatomic, weak)id<CCityOfficalDocDetailDelegate> delegate;

@property(nonatomic, copy) void(^innerCellSelectedAction)(NSIndexPath* indexPath);
@property(nonatomic, copy) void(^deleteCellAction)(CCHuiQianModel* huiQianModel);

@end
