//
//  CCityNoDataCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNoDataCell.h"

@implementation CCityNoDataCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.textLabel.text = @"无数据";
    }
    return self;
}
@end
