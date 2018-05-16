//
//  CCityBackToLeftView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBackToLeftView.h"

@implementation CCityBackToLeftView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(-5, 10, 15, 25);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (!_lineWith) {
        _lineWith = 3.f;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextSetLineWidth(context, _lineWith);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, self.bounds.size.width-_lineWith, _lineWith);
    CGContextAddLineToPoint(context, _lineWith, self.bounds.size.height / 2.f);
    CGContextAddLineToPoint(context, self.bounds.size.width-_lineWith, self.bounds.size.height-_lineWith);
    
    CGContextStrokePath(context);
}


@end
