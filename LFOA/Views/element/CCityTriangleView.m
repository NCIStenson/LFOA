//
//  CCityTriangleView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityTriangleView.h"

@implementation CCityTriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 222, 222, 222, 1.f);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width /2, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    [self.tintColor setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
