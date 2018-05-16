//
//  CCityOfficalBackLogCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define OFFICAL_BACKLOG_CELL_PADDING       5.f
#define OFFICAL_BACKLOG_CELL_IMAGE_PADDING 7.f
#define CC_BG_COLOR      [UIColor whiteColor]

#import "CCityOfficalBackLogCell.h"

@implementation CCityOfficalBackLogCell {
    
    UILabel*     dataLabel;
    UILabel*     DocTitleLabel;
    UILabel*     DocIdLabel;
    UILabel*     _isReadLabel;
    UILabel*     _messageTypeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mainStyle:(CCityOfficalMainStyle)mainStyle conentMode:(CCityOfficalDocContentMode)contentMode {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _mainStyle = mainStyle;
        _myContentMode = contentMode;
        [self layoutMySubviews];
    }
    return self;
}

-(void)setModel:(CCityOfficalDocModel *)model {
    _model = model;
    
    DocTitleLabel.text = model.docTitle;
    DocIdLabel.text    = model.docNumber;
    dataLabel.text     = model.docDate;
    
    if (model.mainStyle == CCityOfficalMainDocStyle) {
        
        switch (model.contentMode) {
                
            case CCityOfficalDocBackLogMode:
                
                _messageTypeLabel.text  = model.messagetype;
                
                break;
                
//            case CCityOfficalDocHaveDoneMode:
//
//                break;
//            case CCityOfficalDocReciveReadMode:
//
//                break;
            default:
                break;
        }
    } else {
        
        switch (model.contentMode) {
                
            case CCityOfficalDocBackLogMode:
                
                _messageTypeLabel.text  = model.messagetype;
                dataLabel.attributedText = [self formatterSurplusStr:_model.surplusDays];
                
                break;
                
//            case CCityOfficalDocHaveDoneMode:
//                break;
//            case CCityOfficalDocReciveReadMode:
//                break;
            default:
                break;
        }
    }
    
    if (_isReadLabel) {
        
        if (_model.isRead) {
            
            if (_isReadLabel.textColor != [UIColor grayColor]) {
                _isReadLabel.textColor = [UIColor grayColor];
                _isReadLabel.text = @"[已阅]";
            }
        } else {
            
            if (_isReadLabel.textColor != CCITY_MAIN_COLOR) {
                _isReadLabel.textColor = CCITY_MAIN_COLOR;
                _isReadLabel.text = @"[未阅]";
            }
        }
    }
}

-(void)layoutMySubviews {

    _docImageView = [[UIImageView alloc]init];
    _docImageView.backgroundColor = CC_BG_COLOR;
    
    UIImageView* arrowImage = [UIImageView new];
    arrowImage.backgroundColor = CC_BG_COLOR;
    arrowImage.tintColor = CCITY_GRAY_TEXTCOLOR;
    arrowImage.image = [UIImage imageNamed:@"ccity_arrow_toRight_44x44_"];
    
    DocTitleLabel = [UILabel new];
    DocTitleLabel.font = [UIFont systemFontOfSize:15.f];
    DocTitleLabel.textColor = CCITY_MAIN_FONT_COLOR;
    DocTitleLabel.backgroundColor = CC_BG_COLOR;
    
    DocIdLabel = [self detailLabel];
    
    dataLabel = [self detailLabel];
    dataLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:arrowImage];
    [self.contentView addSubview:_docImageView];
    [self.contentView addSubview:DocTitleLabel];
    [self.contentView addSubview:DocIdLabel];
    [self.contentView addSubview:dataLabel];
    
    [_docImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.contentView).with.offset(2*OFFICAL_BACKLOG_CELL_IMAGE_PADDING);
        make.left.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_IMAGE_PADDING);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.width.equalTo(arrowImage.mas_height);
        make.height.mas_equalTo(15.f);
    }];
    
    [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(arrowImage.mas_left).with.offset(- 2*OFFICAL_BACKLOG_CELL_PADDING);
        make.top.equalTo(DocIdLabel);
        make.bottom.equalTo(DocIdLabel);
        [dataLabel sizeToFit];
    }];
    
    [DocIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(DocTitleLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.left.equalTo(DocTitleLabel);

        make.right.equalTo(dataLabel.mas_left).with.offset(-5.f);
        make.height.lessThanOrEqualTo(@20.f);
    }];
    
    [DocIdLabel sizeToFit];
    
    if (_mainStyle == CCityOfficalMainDocStyle) {
        
        if (_myContentMode == CCityOfficalDocBackLogMode) {
              
              _messageTypeLabel = [self detailLabel];
              [self.contentView addSubview:_messageTypeLabel];
              
              [_messageTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.top.equalTo(DocIdLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
                  make.left.equalTo(DocIdLabel);
                  make.right.equalTo(dataLabel.mas_left);
                  make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
              }];
          }
    } else {
        
        if (_myContentMode == CCityOfficalDocBackLogMode) {
            
            _messageTypeLabel = [self detailLabel];
            [self.contentView addSubview:_messageTypeLabel];
            [dataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(arrowImage.mas_left).with.offset(- 2*OFFICAL_BACKLOG_CELL_PADDING);
                make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
                make.width.greaterThanOrEqualTo(@50.f);
                make.height.mas_equalTo(15.f);
            }];
            [dataLabel sizeToFit];
            
            [DocIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(DocTitleLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
                make.left.equalTo(DocTitleLabel);
                make.bottom.equalTo(_messageTypeLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
                make.right.equalTo(dataLabel.mas_left).with.offset(-5.f);
            }];

            [_messageTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(DocIdLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
                make.left.equalTo(DocIdLabel);
                make.right.equalTo(dataLabel.mas_left);
                make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
            }];
        }
    }
    
    if (_myContentMode == CCityOfficalDocHaveDoneMode) {
        
        [DocTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
            make.left.equalTo(_docImageView.mas_right).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
            make.right.equalTo(dataLabel.mas_right);
            make.bottom.equalTo(DocIdLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
            make.height.equalTo(DocIdLabel);
        }];
    }
    
    
    if (_mainStyle == CCityOfficalMainDocStyle) {
        
        switch (_myContentMode) {
                
            case CCityOfficalDocBackLogMode:
                
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_backlog_44x44_"];
                [self addIsReadLabel];
                
                break;
                
            case CCityOfficalDocHaveDoneMode:
                
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_haveDone_44x44_"];
                break;
            case CCityOfficalDocReciveReadMode:
                
                [self addIsReadLabel];
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_reciveRead_44x44_"];
                
                break;
            default:
                break;
        }
    } else {
        
        switch (_myContentMode) {
                
            case CCityOfficalDocBackLogMode:
                
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_sp_backlog_50x50_"];
                [self addIsReadLabel];
                break;
                
            case CCityOfficalDocHaveDoneMode:
                
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_sp_haveDone_50x50_"];
                break;
            case CCityOfficalDocReciveReadMode:
                
                _docImageView.image = [UIImage imageNamed:@"ccity_offical_sp_reciveRead_50x50_"];
                [self addIsReadLabel];
                
                break;
            default:
                break;
        }
    }
}

-(void)addIsReadLabel {
    
    _isReadLabel = [UILabel new];
    _isReadLabel.font = [UIFont systemFontOfSize:13.f];
    _isReadLabel.backgroundColor = CC_BG_COLOR;
    [self.contentView addSubview:_isReadLabel];

    [_isReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(DocTitleLabel);
        make.left.equalTo(DocTitleLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(DocTitleLabel);
        make.right.equalTo(dataLabel);
        make.width.mas_greaterThanOrEqualTo(38.f);
    }];
    
    [DocTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.left.equalTo(_docImageView.mas_right).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.right.equalTo(_isReadLabel.mas_left).with.offset(-5.f);
        make.bottom.equalTo(DocIdLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
        make.height.equalTo(DocIdLabel);
    }];
}

-(UILabel*)detailLabel {
    
    UILabel* detailLabel = [UILabel new];
    detailLabel.backgroundColor = CC_BG_COLOR;
    detailLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    return detailLabel;
}

#pragma mark- --- methods

-(NSAttributedString*)formatterSurplusStr:(NSString*)str {
    
    if (str.length > 1) {
       str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([str containsString:@"超期"]) {
        
        str = [str stringByAppendingString:@"天"];
         return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    } else {
        
       str = [NSString stringWithFormat:@"还剩%@天",str];
        
        if ([str integerValue] <= 2) {
            
            return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:CCITY_RGB_COLOR(254, 180, 21, 1.f)}];
        } else {
            
            return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:CCITY_RGB_COLOR(138, 202, 54, 1.f)}];
        }
    }
}

@end
