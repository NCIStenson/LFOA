//
//  CCHuiqianDetailCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCHuiqianDetailCell.h"

@implementation CCHuiqianDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imageView.image = [UIImage imageNamed:@"cc_point_5x5"];
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = CCITY_RGB_COLOR(100, 100, 100, 1);
    
    self.inputTextView.textColor = CCITY_RGB_COLOR(100, 100, 100, 1);
    _inputTextView.delegate = self;
    self.inputTextView.layer.borderColor = CCITY_RGB_COLOR(241, 241, 241, 1).CGColor;
    self.inputTextView.layer.borderWidth = 1.f;
    self.inputTextView.layer.cornerRadius = 5.f;
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
