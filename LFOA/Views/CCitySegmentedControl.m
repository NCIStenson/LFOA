//
//  CCitySegmentedControl.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCitySegmentedControl.h"

#import "CCitySegmentBtn.h"

@implementation CCitySegmentedControl {
    
    CCitySegmentBtn* oldBtn;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray<NSString*>*)items
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutsubviewsWithItems:items];
        
    }
    return self;
}

#pragma mark- --- layout subviews
- (void)layoutsubviewsWithItems:(NSArray*)items {
    
    float itemsWidth = self.bounds.size.width / items.count;
    
    for (int i = 0; i < items.count; i++) {
        
        CCitySegmentBtn* segBtn = [CCitySegmentBtn buttonWithType:UIButtonTypeCustom];
        [segBtn addTarget:self action:@selector(segBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [segBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        segBtn.forgroundColor = CCITY_MAIN_COLOR;
        
        [segBtn setTitle:items[i] forState:UIControlStateNormal];
        segBtn.tag = 1000 + i;
        
        if (i == 0) {
            
            oldBtn = segBtn;
            segBtn.selectValue = YES;
        }
        
        [self addSubview:segBtn];
        
        [segBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(itemsWidth*i);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(itemsWidth);
        }];
    }
}

#pragma mark- --- setters
-(void)setSelectedIndex:(int)selectedIndex {
    _selectedIndex = selectedIndex;
    
    CCitySegmentBtn* btn = [self viewWithTag:selectedIndex+1000];
    [self segBtnSelected:btn];
}

#pragma mark- --- methods

- (void) segBtnSelected:(CCitySegmentBtn*)btn {
    
    if (oldBtn == btn) {    return; }
    
    oldBtn.selectValue = !oldBtn.selectValue;
    btn.selectValue    = !btn.selectValue;
    
    if (_selectedIndex != (int)btn.tag - 1000) {
        
        _selectedIndex = (int)btn.tag - 1000;
    }
    
    //
    //   if ([self.delegate respondsToSelector:@selector(didSelectItemWithIndex:)]) {
    //
    //        [self.delegate didSelectItemWithIndex:btn.tag - 1000];
    //    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    oldBtn = btn;
}

-(void)drawRect:(CGRect)rect {
    
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contexRef, kCGLineCapSquare);
    CGContextSetLineWidth(contexRef, 1.f);
    CGContextSetStrokeColorWithColor(contexRef, [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor);
    CGContextBeginPath(contexRef);
    CGContextMoveToPoint(contexRef, 0, self.bounds.size.height);
    CGContextAddLineToPoint(contexRef, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(contexRef);
}

@end
