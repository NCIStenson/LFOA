//
//  CCityMainDetailTaskSearchCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainDetailTaskSearchCell.h"
#import "CCityTriangleView.h"

@implementation CCityMainDetailTaskSearchCell

-(void)setModel:(CCityMainDetailSearchModel *)model {
    _model = model;
    
    if (_searchStyle != CCityMainDetailTaskSearchCellDateStyle) {
        
        _myTextField = [CCityTriangleTF new];
        _myTextField.font = [UIFont systemFontOfSize:15.f];
        _myTextField.rightViewpadding = 10.f;
        _myTextField.layer.cornerRadius = 3.f;
        _myTextField.clipsToBounds = YES;
        _myTextField.delegate = self;
        _myTextField.placeholder = model.placeHolder;
        
        if (model.value) {
            if (![_myTextField.text isEqual:model.value]) {
                _myTextField.text = model.value;
            }
        }
        
        _myTextField.layer.borderColor = CCITY_RGB_COLOR(222, 222, 222, 1.f).CGColor;
        _myTextField.layer.borderWidth = 1.f;
        _myTextField.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_myTextField];
        
        if (_searchStyle == CCityMainDetailTaskSearchCellTriangleTFStyle) {
            
            _myTextField.rightViewMode = UITextFieldViewModeAlways;
            _myTextField.rightView = [self triangleView];
            _myTextField.userInteractionEnabled = NO;
        }
        
        [_myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
    } else {
        
        UILabel* tagLabel = [UILabel new];
        tagLabel.text = @"登记时间";
        tagLabel.font = [UIFont systemFontOfSize:14.f];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        
        _beginTimeTF = [CCityTriangleTF new];
        _beginTimeTF.text = model.timeBegin;
        _beginTimeTF.rightView = [self triangleView];
        _beginTimeTF.rightViewMode = UITextFieldViewModeAlways;
        _beginTimeTF.backgroundColor = [UIColor whiteColor];
        _beginTimeTF.rightViewpadding = 5.f;
        _beginTimeTF.font = [UIFont systemFontOfSize:15.f];
        UIControl* beginControl = [[UIControl alloc]init];
        beginControl.tag = 30001;
        [beginControl addTarget:self action:@selector(selectTiemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_beginTimeTF addSubview:beginControl];
        
        _endTimeTF = [CCityTriangleTF new];
        _endTimeTF.text = model.timeEnd;
        _endTimeTF.rightView = [self triangleView];
        _endTimeTF.rightViewMode = UITextFieldViewModeAlways;
        _endTimeTF.backgroundColor = [UIColor whiteColor];
        _endTimeTF.rightViewpadding = 5.f;
        _endTimeTF.font = [UIFont systemFontOfSize:15.f];
        UIControl* endTimeControl = [[UIControl alloc]init];
        endTimeControl.tag = 30002;
        [endTimeControl addTarget:self action:@selector(selectTiemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_endTimeTF addSubview:endTimeControl];
        
        [self.contentView addSubview:tagLabel];
        [self.contentView addSubview:_beginTimeTF];
        [self.contentView addSubview:_endTimeTF];
        
        [beginControl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(_beginTimeTF);
        }];
        
        [endTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(_endTimeTF);
        }];
        
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(5.f);
            make.left.equalTo(self.contentView).with.offset(10.f);
            make.bottom.equalTo(self.contentView).with.offset(-10.f);
            make.width.equalTo(@60.f);
        }];
        
        [_beginTimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(tagLabel);
            make.left.equalTo(tagLabel.mas_right).with.offset(10.f);
            make.bottom.equalTo(self.contentView).with.offset(-10.f);
            make.right.equalTo(_endTimeTF.mas_left);
            make.width.equalTo(_endTimeTF);
        }];
        
        [_endTimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_beginTimeTF);
            make.left.equalTo(_beginTimeTF.mas_right);
            make.bottom.equalTo(_beginTimeTF);
            make.right.equalTo(self.contentView).with.offset(-10.f);
            make.width.equalTo(_beginTimeTF);
        }];
        
        __block CCityTriangleTF* blockBgeingTF = _beginTimeTF;
        __block CCityTriangleTF* blockEndTF = _endTimeTF;
        
        self.timeDidSelectAction = ^(NSString *selectedTime, NSInteger tag) {
            
            if (tag == 30001) {
                
                blockBgeingTF.text = selectedTime;
            } else {
                
                blockEndTF.text = selectedTime;
            }
        };
    }
}

- (CCityTriangleView*)triangleView {
    
    CCityTriangleView* triangleView = [[CCityTriangleView alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
    triangleView.backgroundColor = [UIColor whiteColor];
    triangleView.tintColor = CCITY_RGB_COLOR(222, 222, 222, 1.f);
    return triangleView;
}

#pragma mark- --- methods

- (void)selectTiemAction:(UIControl*)control {
    
    if ([self.delegate respondsToSelector:@selector(timeDidselected:tag:)]) {
        
        [self.delegate timeDidselected:self tag:control.tag];
    }
}

#pragma mark- --- textfiled delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        
        if ([self.delegate respondsToSelector:@selector(valueSelected:)]) {
           
            [self.delegate valueSelected:self];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
