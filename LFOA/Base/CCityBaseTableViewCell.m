//
//  CCityBaseTableViewCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"

@implementation CCityBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    
    if (_lineColor) {
         CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(contextRef, [[UIColor grayColor] colorWithAlphaComponent:.3f].CGColor);
    }
    CGContextSetLineWidth(contextRef, 1.f);
    CGContextBeginPath(contextRef);

    CGContextMoveToPoint(contextRef, _linePadding, self.bounds.size.height);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width - _linePadding, self.bounds.size.height);
    CGContextStrokePath(contextRef);
}

@end
