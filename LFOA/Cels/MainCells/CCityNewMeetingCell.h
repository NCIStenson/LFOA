//
//  CCityNewMeetingCell.h
//  LFOA
//
//  Created by Stenson on 2018/6/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

//   新建会议cell

#import <UIKit/UIKit.h>

#import "CCityMainMeetingListModel.h"
#import "MyView.h"
#import "CCityLogInCheckBoxBtn.h"

@class CCityNewMeetingCell;

@protocol CCityNewMeetingCellDelegate <NSObject>

@optional
- (void)textViewWillEditingWithCell:(CCityNewMeetingCell*)cell;
- (void)textViewDidEndEditingWithCell:(CCityNewMeetingCell*)cell;
- (void)textViewTextDidChange:(CCityNewMeetingCell*)cell;

- (void)showDatePickerVCWithIndex:(NSIndexPath *)indexPath;

- (void)showDepartmentOption:(NSIndexPath *)indexpath withButton:(UIButton *)btn;

- (void)isSendMessage:(BOOL)isSend withIndexpath:(NSIndexPath *)indexpath;
- (void)isHeightLever:(BOOL)isHeightLever withIndexpath:(NSIndexPath *)indexpath;

- (void)showChooseFileVC;

- (void)didDeleteBtnWithIndex:(NSInteger)index;

@end
@interface CCityNewMeetingCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic, strong)MyView *                    notiTitleTextView; //  输入框 文字标题一类
@property(nonatomic, strong)MyView *                    notiContentTextView; //  内容输入框 大文本输入

@property(nonatomic, strong)UIButton  *                 commonBtn;          // 页面普通点击按钮
@property(nonatomic, strong)UILabel *                   commonLab;          // 页面普通展示数据框

@property(nonatomic, assign)CCityNewTypeStyle currentNewType;
@property(nonatomic, assign)CCityNewNotiMeetingStyle    newStyle;
@property(nonatomic, strong)NSIndexPath *               indexPath;

@property(nonatomic, assign) BOOL                   isHeightLevel;
@property(nonatomic, assign) BOOL                   isSendMessage;

@property(nonatomic, strong)CCityLogInCheckBoxBtn *     isHeightBtn;
@property(nonatomic, strong)CCityLogInCheckBoxBtn *    isSendMessageBtn;

@property (nonatomic, strong)NSArray *         choosedFileArr;

@property(nonatomic, assign)BOOL                        removeBottomLine;

@property(nonatomic, weak)id<CCityNewMeetingCellDelegate> delegate;

@end

