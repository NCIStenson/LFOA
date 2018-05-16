//
//  CCityLogInTF.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityLogInTF.h"

@implementation CCityLogInTF

-(void)drawRect:(CGRect)rect {
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(contex, kCGLineCapSquare);
    
    CGContextSetLineWidth(contex, 2.f);
    CGContextSetStrokeColorWithColor(contex, CCITY_RGB_COLOR(0, 0, 0, .1).CGColor);
    CGContextBeginPath(contex);
    
    CGContextMoveToPoint(contex, 0, self.bounds.size.height);
    CGContextAddLineToPoint(contex, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(contex);
    
}

@end
