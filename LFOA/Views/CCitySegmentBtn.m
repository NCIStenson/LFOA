//
//  CCitySegmentBtn.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/31.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCitySegmentBtn.h"

@implementation CCitySegmentBtn {
    
    CALayer* bottomLine;
}

-(void)setSelectValue:(BOOL)selectValue {
    _selectValue = selectValue;
        
    if (selectValue) {
        
        [self setTitleColor:_forgroundColor forState:UIControlStateNormal];
        bottomLine.backgroundColor = _forgroundColor.CGColor;
    } else {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bottomLine.backgroundColor = [UIColor clearColor].CGColor;
    }
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (!bottomLine) {  bottomLine = [CALayer layer];   }
    
    if (_selectValue) {
        
        bottomLine.backgroundColor = _forgroundColor.CGColor;
    } else {
        
        bottomLine.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    bottomLine.frame = CGRectMake(0, self.bounds.size.height -2, self.bounds.size.width, 2.f);
    [self.layer addSublayer:bottomLine];
}

@end
