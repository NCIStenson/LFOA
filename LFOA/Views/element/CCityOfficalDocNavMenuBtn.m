

//
//  CCityOfficalDocNavMenuBtn.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocNavMenuBtn.h"

@implementation CCityOfficalDocNavMenuBtn

+(instancetype)buttonWithType:(UIButtonType)buttonType {
    
    CCityOfficalDocNavMenuBtn* btn = [super buttonWithType:buttonType];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:CCITY_MAIN_COLOR forState:UIControlStateNormal];
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    return btn;
}

-(void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, CCITY_GRAY_LINECOLOR.CGColor);
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    CGContextSetLineWidth(contextRef, 1.f);
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, 0, self.bounds.size.height);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width, self.bounds.size.height);
    
    CGContextStrokePath(contextRef);
}

@end
