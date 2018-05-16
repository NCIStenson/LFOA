//
//  CCityLogInCheckBoxBtn.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityLogInCheckBoxBtn.h"

@implementation CCityLogInCheckBoxBtn

+ (instancetype) buttonWithType:(UIButtonType)buttonType {
   
    CCityLogInCheckBoxBtn* btn = [super buttonWithType:buttonType];
//    47, 122, 233
    [btn setTitleColor:CCITY_RGB_COLOR(0, 0, 0, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    return btn;
}

@end
