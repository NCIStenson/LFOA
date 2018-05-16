//
//  CCityOfficalDetialDocListSection.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetialDocListSection.h"

@implementation CCityOfficalDetialDocListSection

-(void)drawRect:(CGRect)rect {
    
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contexRef, kCGLineCapSquare);
    CGContextSetLineWidth(contexRef, .5f);
    CGContextSetStrokeColorWithColor(contexRef, [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor);
    CGContextBeginPath(contexRef);
    CGContextMoveToPoint(contexRef, 0, self.bounds.size.height);
    CGContextAddLineToPoint(contexRef, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(contexRef);
}

@end
