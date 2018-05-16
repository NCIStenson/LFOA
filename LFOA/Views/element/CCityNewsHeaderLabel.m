//
//  CCityNewsHeaderLabel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsHeaderLabel.h"

@implementation CCityNewsHeaderLabel

-(void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets insets = {0, 5, 0, 60};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
