//
//  CCityMainMessageCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 20 17/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CC_BG_COLOR

#import "CCityMainMessageCell.h"
#import <JSBadgeView.h>
#import "CCityImageTypeManager.h"

@implementation CCityMainMessageCell {
    
    //    YYLabel* _contentLabel;
    UITextField* _openTF;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layout];
    }
    
    return self;
}

-(void)layout {
    
    _tailView = [UIView new];
    
    // type imageView
    _typeImageView = [[UIView alloc] init];
    _typeImageView.layer.cornerRadius = 20.f;
    _typeImageView.clipsToBounds = YES;
    
    _myImageView = [[UIImageView alloc]init];
    
    // content label
    _contentLabel = [YYLabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15.f];
    _contentLabel.numberOfLines = 2;
    _contentLabel.backgroundColor = [UIColor whiteColor];
    // trangleView
    
    // time label
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13.f];
    _timeLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    _timeLabel.backgroundColor = [UIColor whiteColor];
    
    // layout subviews
    [_typeImageView addSubview:_myImageView];
    [self.contentView addSubview:_typeImageView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_contentLabel];
    
    [_myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_typeImageView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(5.f);
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_typeImageView);
        make.left.equalTo(_typeImageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(_timeLabel.mas_top).with.offset(-5.f);
        make.right.equalTo(self.contentView).with.offset(-5.f);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(5.f);
        make.right.equalTo(_contentLabel);
        make.bottom.equalTo(self.contentView).with.offset(-5.f);
        make.width.mas_equalTo(130.f);
        make.height.mas_equalTo(16.f);
    }];
}

-(void)setModel:(CCityMessageModel *)model {
    _model = model;
    
    NSArray* imageTypeArr;
    if ([self.model.messageType isEqualToString:@"案卷消息"]) {
        
        imageTypeArr = [CCityImageTypeManager getMeetingImageNameWithType:self.model.secondLevelType];
    } else {
        
        imageTypeArr = [CCityImageTypeManager getMeetingImageNameWithType:self.model.messageType];
    }
    
    _typeImageView.backgroundColor = imageTypeArr[0];
    _myImageView.backgroundColor = _typeImageView.backgroundColor;
    _myImageView.image = [UIImage imageNamed:imageTypeArr[1]];
    
    _contentLabel.attributedText = [self contentAttStrWithContent:self.model.content];
    
    if (_openTF) {
        
        [_openTF removeFromSuperview];
        _openTF = nil;
    }
    
    if ([self checkMaxHeightWithText:_contentLabel]) {
        
        _openTF = [UITextField new];
        _openTF.font = _contentLabel.font;
        _openTF.rightViewMode = UITextFieldViewModeAlways;
        _openTF.backgroundColor = [UIColor whiteColor];
        
        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_arrow_toBottom_30x30_"]];
        rightView.frame = CGRectMake(0, 0, 20, 20);
        rightView.backgroundColor = [UIColor whiteColor];
        _openTF.rightView = rightView;
        
        UIControl* openCon = [UIControl new];
        [openCon addTarget:self action:@selector(isOpenAction) forControlEvents:UIControlEventTouchUpInside];
        openCon.backgroundColor = [UIColor whiteColor];
        [_openTF addSubview:openCon];
        
        [openCon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(_openTF);
        }];
        
        [_contentLabel addSubview:_openTF];
        
        [_openTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_contentLabel);
            make.bottom.equalTo(_contentLabel);
            
            if (self.model.isOpen) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            } else {
                make.size.mas_equalTo(CGSizeMake(35, 20));
            }
        }];
        
        if (self.model.isOpen) {
            
            _contentLabel.numberOfLines = 0;
            _tailView.frame = CGRectMake(0, 0, 35, 20);
            _openTF.transform = CGAffineTransformMakeRotation(M_PI);
            _openTF.text = @"";
        } else {
            
            _contentLabel.numberOfLines = 2;
            _tailView.frame = CGRectMake(0, 0, 35, 20);
            _openTF.text = @"...";
        }
        
        
        if (_tailView.hidden != YES) {
            _tailView.hidden = YES;
        }
        
        NSAttributedString* truncationToken = [NSAttributedString  attachmentStringWithContent:_tailView contentMode:UIViewContentModeBottomLeft attachmentSize:_tailView.bounds.size alignToFont:_contentLabel.font alignment:YYTextVerticalAlignmentCenter];
        
        _contentLabel.truncationToken = truncationToken;
        
    } else {
   
    }
    
    _timeLabel.text = _model.time;
}

#pragma mark- --- methods

-(void)isOpenAction {
    
    _model.isOpen = !_model.isOpen;
    
    if ([self.delegate respondsToSelector:@selector(openBtnSelectedAction:)]) {
        [self.delegate openBtnSelectedAction:self];
    }
}

-(BOOL)checkMaxHeightWithText:(YYLabel*)label {
    
    YYLabel* modeLabel = [[YYLabel alloc]init];
    modeLabel.font = label.font;
    modeLabel.numberOfLines = 2;
    modeLabel.text = label.text;
    
    YYLabel* localLabel = [[YYLabel alloc]init];
    localLabel.text = label.text;
    localLabel.font = label.font;
    localLabel.numberOfLines = 0;
    localLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 60.f, MAXFLOAT);
    modeLabel.frame = localLabel.frame;
    
    [localLabel sizeToFit];
    [modeLabel sizeToFit];
    
    return localLabel.bounds.size.height > modeLabel.bounds.size.height;
}

-(NSAttributedString*)contentAttStrWithContent:(NSString*) content {
    
    UIColor* textColor = [UIColor blackColor];
    UIFont* textFont = [UIFont systemFontOfSize:15.f];
    
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]init];
    
    for (int i = 0 ; i <content.length; i++) {
        
        NSString* temp = [content substringWithRange:NSMakeRange(i, 1)];
        
        if ([temp isEqualToString:@"["]) {
            
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:temp attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor}]];
            textColor = CCITY_MAIN_COLOR;
        } else if([temp isEqualToString:@"]"]) {
            
            textColor = [UIColor blackColor];
            
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:temp attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor}]];
        } else {
            
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:temp attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor}]];
        }
    }
    
    return attStr;
}

#pragma mark- --- drawRect
-(void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor grayColor] colorWithAlphaComponent:.3f].CGColor);
    
    CGContextSetLineWidth(contextRef, 1.f);
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, 70.f, self.bounds.size.height);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(contextRef);
}

@end

