//
//  CCityNewNotiMeetingCell.h
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCityNotficModel.h"
#import "MyView.h"
#import "CCityLogInCheckBoxBtn.h"

@class CCityNewNotiCell;

@protocol CCityNewNotiCellDelegate <NSObject>

@optional
- (void)textViewWillEditingWithCell:(CCityNewNotiCell*)cell;
- (void)textViewDidEndEditingWithCell:(CCityNewNotiCell*)cell;
- (void)textViewTextDidChange:(CCityNewNotiCell*)cell;

- (void)showDatePickerVCWithIndex:(NSIndexPath *)indexPath;

- (void)showDepartmentOption:(NSIndexPath *)indexpath withButton:(UIButton *)btn;

- (void)isSendMessage:(BOOL)isSend withIndexpath:(NSIndexPath *)indexpath;
- (void)isHeightLever:(BOOL)isHeightLever withIndexpath:(NSIndexPath *)indexpath;

/**
 接收人员界面
 */
- (void)goReceiverView;

- (void)showChooseFileVC;

- (void)didDeleteBtnWithIndex:(NSInteger)index;

@end
@interface CCityNewNotiCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic, strong)MyView *                    notiTitleTextView;
@property(nonatomic, strong)MyView *                    notiContentTextView;

@property(nonatomic, assign)CCityNewTypeStyle currentNewType;

@property(nonatomic, assign)CCityNewNotiMeetingStyle    newStyle;
@property(nonatomic, strong)NSIndexPath *               indexPath;

@property(nonatomic, assign) BOOL                   isHeightLevel;
@property(nonatomic, assign) BOOL                   isSendMessage;
@property(nonatomic, strong)CCityLogInCheckBoxBtn *     isHeightBtn;
@property(nonatomic, strong)CCityLogInCheckBoxBtn *    isSendMessageBtn;

@property (nonatomic, strong)NSArray *         choosedFileArr;

@property(nonatomic, assign)BOOL                        removeBottomLine;

@property(nonatomic, weak)id<CCityNewNotiCellDelegate> delegate;

@end
