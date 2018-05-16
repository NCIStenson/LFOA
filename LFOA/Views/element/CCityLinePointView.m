//
//  CCityLinePointView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/30.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_CIRCLE_RADIUS 4.f

#import "CCityLinePointView.h"

@implementation CCityLinePointView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.size.width /2 - 7, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width /2 - 7, self.bounds.size.height - 2*CCITY_CIRCLE_RADIUS);
    CGContextAddLineToPoint(context, self.bounds.size.width-5, self.bounds.size.height - 2*CCITY_CIRCLE_RADIUS);
    
    CGContextStrokePath(context);
    
    CGRect circleRect = CGRectMake(self.bounds.size.width - 2.5*CCITY_CIRCLE_RADIUS, self.bounds.size.height - 3*CCITY_CIRCLE_RADIUS, 2*CCITY_CIRCLE_RADIUS, 2*CCITY_CIRCLE_RADIUS);
    
    [[UIColor whiteColor] set];
    UIRectFrame(circleRect);
    CGContextAddEllipseInRect(context, circleRect);
    [CCITY_MAIN_COLOR set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
