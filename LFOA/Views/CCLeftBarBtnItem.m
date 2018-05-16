//
//  CCLeftBarBtnItem.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCLeftBarBtnItem.h"

@implementation CCLeftBarBtnItem

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        [self layoutMySubViews];
    }
    return self;
}

-(void)layoutMySubViews {
    
    self.frame = CGRectMake(0, 0, 60, 44.f);
    _arrow = [CCityBackToLeftView new];
    _label = [UILabel new];
    _label.text = @"返回";
    _label.frame = CGRectMake(15, 0, 45, 44.f);

    [self addSubview:_arrow];
    [self addSubview:_label];
    
    [self addTarget:self action:@selector(insideAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)insideAction {
    
    if (self.action) {  self.action();  }
}

@end
