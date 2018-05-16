//
//  CCityNoDataSection.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNoDataSection.h"

@implementation CCityNoDataSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel* textLabel = [UILabel new];
        textLabel.text = @"无数据";
        [self addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
        }];
    }
    return self;
}
@end
