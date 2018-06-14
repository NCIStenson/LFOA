//
//  CCityNewMeetingCell.m
//  LFOA
//
//  Created by Stenson on 2018/6/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//


#define kDateBtnTag 1000
#define kAlertBoxBtnTag 1001

#define kMeetingType @"会议类型"
#define kMeetingNum @"会议编号"
#define kMeetingTitle @"会议名称"
#define kMeetingPerson @"参会人"
#define kMeetingTime @"会议时间"
#define kMeetingRoom @"会议室"
#define kMeetingDepartment @"组织部门"
#define kMeetingZZDW @"组织单位"
#define kMeetingRecorder @"记录人"
#define kMeetingCJYR @"传纪要人"
#define kMeetingKQR @"考勤人"
#define kMeetingZCR @"主持人"
#define kMeetingContent @"会议内容"

#define kNewNotiFontSize 14

#import "CCityNewMeetingCell.h"

@implementation CCityNewMeetingCell {
    
    NSInteger _rowNum;
    NSString* _contentStr;
    NSInteger _selectedRowNum;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark- ---  setter

-(void)setNewStyle:(CCityNewNotiMeetingStyle)newStyle
{
    _newStyle =  newStyle;
    switch (_newStyle) {
        case CCityNewNotiMeetingStyleInput:
            [self layoutMySubViews];
            break;
            
        case CCityNewNotiMeetingStyleDate:
            [self initDateView];
            break;
            
        case CCityNewNotiMeetingStyleAlert:
            [self initDropdownBoxView];
            break;
            
        case CCityNewNotiMeetingStyleNextPage:
            [self initReceiverView];
            break;
            
        case CCityNewNotiMeetingStyleTextView:
            [self initTextView];
            break;
            
        case CCityNewNotiMeetingStyleUpload:
            [self initUploadImageView];
            break;
            
        case CCityNewNotiMeetingStyleOther:
            [self initIsHeightView];
            break;
            
        default:
            break;
    }
    
}
#pragma mark- --- layout subviews
-(void)layoutMySubViews {
    _notiTitleTextView = [MyView new];
    _notiTitleTextView.delegate = self;
    _notiTitleTextView.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    _notiTitleTextView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 34);
    _notiTitleTextView.contentInset = UIEdgeInsetsMake(0, -5, 0, -5);
    [self.contentView addSubview:_notiTitleTextView];
}

-(void)initDateView
{
    _commonBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_commonBtn setTitleColor:CCITY_GRAY_TEXTCOLOR forState:UIControlStateNormal];
    [_commonBtn addTarget:self action:@selector(showDataAlertView) forControlEvents:UIControlEventTouchUpInside];
    _commonBtn.titleLabel.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    [self.contentView addSubview:_commonBtn];
    _commonBtn.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 34);
    _commonBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _commonBtn.tag = kDateBtnTag;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_calendar_50x50_" color:CCITY_GRAY_TEXTCOLOR]];
    [self.contentView addSubview:imageView];
    imageView.frame = CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//  下拉框
-(void)initDropdownBoxView
{
    _commonBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_commonBtn setTitleColor:CCITY_GRAY_TEXTCOLOR forState:UIControlStateNormal];
    [_commonBtn addTarget:self action:@selector(showPublishGroup:) forControlEvents:UIControlEventTouchUpInside];
    _commonBtn.titleLabel.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    [self.contentView addSubview:_commonBtn];
    _commonBtn.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 34);
    _commonBtn.tag = kAlertBoxBtnTag;
    _commonBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
}

-(void)initReceiverView
{
    _commonLab  = [UILabel new];
    _commonLab.numberOfLines = 0;
    _commonLab.text = @"接收人员";
    _commonLab.textColor = CCITY_GRAY_TEXTCOLOR;
    _commonLab.frame = CGRectMake(10, 5, SCREEN_WIDTH - 44, 34);
    _commonLab.tag = kAlertBoxBtnTag;
    _commonLab.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    [self.contentView addSubview:_commonLab];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_officalDetail_add_24x24"]];
    [self.contentView addSubview:imageView];
    imageView.frame = CGRectMake(SCREEN_WIDTH - 34, 10, 24, 24);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.centerY = self.bounds.size.height / 2;
}

-(void)initIsHeightView
{
    UILabel * lab = [UILabel new];
    lab.frame = CGRectMake(10, 3, 50, 30);
    [self.contentView addSubview:lab];
    lab.textColor = [UIColor blackColor];
    lab.text = @"可选项";
    lab.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    
    _isHeightBtn = [CCityLogInCheckBoxBtn buttonWithType:UIButtonTypeCustom];
    [_isHeightBtn addTarget:self action:@selector(isHeightLevel:) forControlEvents:UIControlEventTouchUpInside];
    _isHeightBtn.selectedValue = NO;
    [self.contentView addSubview:_isHeightBtn];
    [_isHeightBtn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    [_isHeightBtn setTitle:@" 是否紧急" forState:UIControlStateNormal];
    [_isHeightBtn setTitleColor:[UIColor redColor ] forState:UIControlStateNormal];
    _isHeightBtn.frame = CGRectMake(lab.right + 20, lab.top , 80, 30);
    
    _isSendMessageBtn = [CCityLogInCheckBoxBtn buttonWithType:UIButtonTypeCustom];
    [_isSendMessageBtn addTarget:self action:@selector(isSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    _isSendMessageBtn.selectedValue = NO;
    [self.contentView addSubview:_isSendMessageBtn];
    [_isSendMessageBtn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    [_isSendMessageBtn setTitle:@" 发送信息" forState:UIControlStateNormal];
    _isSendMessageBtn.frame = CGRectMake(_isHeightBtn.right + 30, lab.top , 80, 30);
    
    self.removeBottomLine = YES;
}
-(void)initTextView{
    _notiContentTextView = [MyView new];
    _notiContentTextView.delegate = self;
    _notiContentTextView.font = [UIFont systemFontOfSize:kNewNotiFontSize];
    _notiContentTextView.clipsToBounds = YES;
    _notiContentTextView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 100);
    _notiContentTextView.contentInset = UIEdgeInsetsMake(-5, -5, -5, -5);
    [self.contentView addSubview:_notiContentTextView];
}

-(void)initUploadImageView
{
    float btnWidth = (SCREEN_WIDTH - 50) / 4;
    for (int i = 0 ; i < _choosedFileArr.count + 1 ; i ++) {
        if (i == 0) {
            UIButton * uploadView = [UIButton new];
            [self.contentView addSubview:uploadView];
            uploadView.frame = CGRectMake(10, 10,(SCREEN_WIDTH - 50) / 4, (SCREEN_WIDTH - 50) / 4);
            [uploadView setImageEdgeInsets:UIEdgeInsetsMake((SCREEN_WIDTH - 50) / 16, (SCREEN_WIDTH - 50) / 16, (SCREEN_WIDTH - 50) / 16, (SCREEN_WIDTH - 50) / 16)];
            [uploadView setImage:[UIImage imageNamed:@"icon_uploadFile.png"] forState:UIControlStateNormal];
            [uploadView addTarget:self action:@selector(uploadFileClick) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UIImageView * fileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (btnWidth + 10) * (i%4), 10 + (btnWidth + 10) * (i / 4), btnWidth, btnWidth)];
            fileImageView.image = _choosedFileArr[i - 1];
            [self.contentView addSubview:fileImageView];
            
            UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.tag = i + 500;
            [self.contentView addSubview:deleteBtn];
            deleteBtn.frame = CGRectMake(0, 0, 30, 30);
            [deleteBtn setImage:[UIImage imageNamed:@"icon_delete" ] forState:UIControlStateNormal];
            deleteBtn.center = CGPointMake(fileImageView.right - 15,fileImageView.top + 15);
            [deleteBtn addTarget:self action:@selector(deleteSelectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark- --- methods

-(void)setChoosedFileArr:(NSArray *)choosedFileArr
{
    _choosedFileArr = choosedFileArr;
    
    while (self.contentView.subviews.lastObject) {
        [self.contentView.subviews.lastObject removeFromSuperview];
    }
    
    [self initUploadImageView];
}

-(void)setIsHeightLevel:(BOOL)isHeightLevel
{
    _isHeightLevel = isHeightLevel;
    _isHeightBtn.selectedValue = _isHeightLevel;
    if (_isHeightLevel) {
        [_isHeightBtn setImage:[UIImage imageNamed:@"ccity_login_selected_15x15"] forState:UIControlStateNormal];
    }else{
        [_isHeightBtn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    }
}


-(void)setIsSendMessage:(BOOL)isSendMessage
{
    _isSendMessage = isSendMessage;
    _isSendMessageBtn.selectedValue = _isHeightLevel;
    if (_isSendMessage) {
        [_isSendMessageBtn setImage:[UIImage imageNamed:@"ccity_login_selected_15x15"] forState:UIControlStateNormal];
    }else{
        [_isSendMessageBtn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    }
}

- (BOOL)checkTextWithText:(NSString*)text {
    
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        
        return NO;
    }
    
    return YES;
}

- (NSAttributedString*) getAttributeStrWithText:(NSString*)text {
    
    NSAttributedString* attStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    return attStr;
}

-(CGFloat)rowHeightWithIndexPath:(NSIndexPath*)indexPath {
    
    if (!_contentStr.length) {  return 0; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.text = _contentStr;
    label.numberOfLines = 0;
    CGFloat rightPadding = 35;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30 - 20 -rightPadding, MAXFLOAT);
    [label sizeToFit];
    return label.bounds.size.height + 10.f;
}

#pragma mark- --- uitextview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewWillEditingWithCell:)]) {
        
        [self.delegate textViewWillEditingWithCell:self];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditingWithCell:)]) {
        [self.delegate textViewDidEndEditingWithCell:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewTextDidChange:)]) {
        [self.delegate textViewTextDidChange:self];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:
(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)showDataAlertView{
    if ([self.delegate respondsToSelector:@selector(showDatePickerVCWithIndex:)]) {
        [self.delegate showDatePickerVCWithIndex:_indexPath];
    }
}

-(void)isHeightLevel:(CCityLogInCheckBoxBtn *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"ccity_login_selected_15x15"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(isHeightLever:withIndexpath:)]) {
        [self.delegate isHeightLever:btn.selected withIndexpath:_indexPath];
    }
}

-(void)isSendMessage:(CCityLogInCheckBoxBtn *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"ccity_login_selected_15x15"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"ccity_login_unselect_15x15"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(isSendMessage:withIndexpath:)]) {
        [self.delegate isSendMessage:btn.selected withIndexpath:_indexPath];
    }
}

-(void)showPublishGroup:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(showDepartmentOption:withButton:)]) {
        [self.delegate showDepartmentOption:_indexPath withButton:btn];
    }
}

-(void)goReceiverView
{
//    if ([self.delegate respondsToSelector:@selector(goReceiverView)]) {
//        [self.delegate goReceiverView];
//    }
}

-(void)uploadFileClick
{
    if ([self.delegate respondsToSelector:@selector(showChooseFileVC)]) {
        [self.delegate showChooseFileVC];
    }
}

-(void)deleteSelectedPhoto:(UIButton *)btn
{
    NSInteger index = btn.tag - 501;
    if ([self.delegate respondsToSelector:@selector(didDeleteBtnWithIndex:)]) {
        [self.delegate didDeleteBtnWithIndex:index];
    }
}


-(void)drawRect:(CGRect)rect {
    if (_removeBottomLine == NO) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, CCITY_GRAY_LINECOLOR.CGColor);
        CGContextMoveToPoint(context, 0, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextStrokePath(context);
    }
}

@end

