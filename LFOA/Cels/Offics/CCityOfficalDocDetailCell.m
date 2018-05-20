//
//  CCityOfficalDocDetailCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define ADVIVIC_PLACE_HOLDER @"请给出您的意见"
#define LOCAL_CELL_FONT_SIZE 13.f

#import "CCityOfficalDocDetailCell.h"
//#import "CCHuiQianCell.h"

//static NSString* cellReUseId = @"cellReUseId";

@implementation CCityOfficalDocDetailCell {
    
    CCityOfficalDetailSectionStyle _sectionStyle;
    NSInteger _rowNum;
    NSString* _contentStr;
    NSInteger _selectedRowNum;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if ([reuseIdentifier isEqualToString:@"CCityOfficalDetailDataExcleStyle"]) {
            
            _sectionStyle = CCityOfficalDetailDataExcleStyle;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.textLabel.numberOfLines = 0;
            self.textLabel.backgroundColor = [UIColor whiteColor];
            self.textLabel.font = [UIFont systemFontOfSize:13.f];
            self.imageView.image = [UIImage new];
            _numLabel = [self numberLabel];
            [self.imageView addSubview:_numLabel];
            self.imageView.backgroundColor = [UIColor whiteColor];
        } else {
            
            _sectionStyle = CCityOfficalDetailMutableLineTextStyle;
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self layoutMySubViews];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_sectionStyle == CCityOfficalDetailDataExcleStyle) {
         self.imageView.frame =  CGRectMake(5, 5, 20, 20);
    }
}

-(UILabel*)numberLabel {
    
    UILabel* label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.f];
    label.frame = CGRectMake(0, 0, 20, 20);
    label.layer.cornerRadius = 10.f;
    label.clipsToBounds = YES;
    label.backgroundColor = CCITY_MAIN_COLOR;
    return label;
}

#pragma mark- ---  setter

-(void)setModel:(CCityOfficalDocDetailModel *)model {
    _model = model;
//    [self layoutMySubViews];
//    float height = [CCUtil heightForString:model.value font:[UIFont systemFontOfSize:[UIFont systemFontSize] - 1] andWidth:SCREEN_WIDTH - 20] + 100;

    if (_sectionStyle == CCityOfficalDetailDataExcleStyle) {
        
        CCHuiQianModel* huiqianModel = model.huiQianMuArr[0];
        _rowNum = huiqianModel.contentsMuArr.count<=4?huiqianModel.contentsMuArr.count:4;
    
    } else {
        
        _textView.editable            = model.canEdit;
        
        if (model.canEdit == NO) {
            
            _textView.backgroundColor = CCITY_RGB_COLOR(232, 232, 232, 1.f);
        } else {
            _textView.backgroundColor = CCITY_RGB_COLOR(251,252,253, 1.f);
        }
        
        if (_sectionStyle == CCityOfficalDetailOpinionStyle && _model.canEdit == YES) {
            
            _textView.attributedText = [self getAttributeStrWithText:ADVIVIC_PLACE_HOLDER];
        }
        
        if (!(model.value == NULL)) {
            _textView.text  = model.value;
        }
    }
}

-(void)setHuiqianModel:(CCHuiQianModel *)huiqianModel {
    _huiqianModel = huiqianModel;
    
    NSString* contentStr = @"";
    
    for (int i = 0; i < _rowNum; i++) {
        
        CCHuiQianModel* detailModel = huiqianModel.contentsMuArr[i];
        
        if (i == _rowNum - 1) {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@：%@", detailModel.title, detailModel.content]];
        } else {
            contentStr = [contentStr stringByAppendingString: [NSString stringWithFormat:@"%@：%@\n", detailModel.title, detailModel.content]];
        }
    }
    
    self.textLabel.text = contentStr;
}

#pragma mark- --- layout subviews
-(void)layoutMySubViews {
        
    if (_sectionStyle == CCityOfficalDetailDataExcleStyle) {
        
    } else {
        
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1];
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.borderColor = CCITY_RGB_COLOR(225, 225, 225, 1).CGColor;
        _textView.layer.borderWidth = 1.f;
        
        [self.contentView addSubview:_textView];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(0.f);
            make.left.equalTo(self.contentView).with.offset(10.f);
            make.bottom.equalTo(self.contentView).with.offset(-10.f);
            make.right.equalTo(self.contentView).with.offset(-10.f);
        }];
    }
}

#pragma mark- --- methods

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
    label.font = [UIFont systemFontOfSize:LOCAL_CELL_FONT_SIZE];
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
    
    if ([textView.text isEqualToString:ADVIVIC_PLACE_HOLDER]) {
        
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditingWithCell:)]) {
        
        [self.delegate textViewDidEndEditingWithCell:self];
    }
    
    if (_sectionStyle == CCityOfficalDetailOpinionStyle) {
        
        if (![self checkTextWithText:textView.text]) {
            
            textView.attributedText = [self getAttributeStrWithText:ADVIVIC_PLACE_HOLDER];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewTextDidChange:)]) {
        
        [self.delegate textViewTextDidChange:self];
    }
}

-(void)drawRect:(CGRect)rect {
    
    if (_sectionStyle == CCityOfficalDetailDataExcleStyle ) {
        if (_removeBottomLine == NO) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, CCITY_GRAY_LINECOLOR.CGColor);
            CGContextMoveToPoint(context, 0, self.bounds.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
            CGContextStrokePath(context);
        }
    }
}

@end
