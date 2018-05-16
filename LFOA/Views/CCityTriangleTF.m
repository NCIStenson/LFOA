
//
//  CCityTriangleTF.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/8.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityTriangleTF.h"

@implementation CCityTriangleTF

-(CGRect)rightViewRectForBounds:(CGRect)bounds {
    
    [UIFont systemFontSize];
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= _rightViewpadding;
    return rect;
}

-(CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x +=5;
    rect.size.width -= 5;
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x +=5;
    rect.size.width -= 5;
    return rect;
}

@end
