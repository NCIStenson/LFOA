//
//  CCityAppendixView.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCityAppendixView : UIControl

@property(nonatomic, strong)UIColor* titleColor;
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UILabel* sizeLabel;
@property(nonatomic, strong)NSString* url;

@property(nonatomic, strong)NSString* type;

@property(nonatomic, assign)CGFloat padding;

@end
