//
//  CCityMainTaskSearchCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainTaskSearchCell.h"

@implementation CCityMainTaskSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self layoutMySubViews];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width -= 50.f;
    self.textLabel.frame = textLabelFrame;
}

-(void)layoutMySubViews {
    
    UIControl* xCon = [[UIControl alloc]init];
    [xCon addTarget:self action:@selector(deleteSelfAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_x_24x24_"]];
    
    [self.contentView addSubview:xCon];
    [xCon addSubview:imageView];
    
    [xCon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@54.f);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(xCon).with.insets(UIEdgeInsetsMake(15, 15, 15, 25));
    }];
}

- (void)deleteSelfAction {
    
    if (self.deleteSelf) {
        self.deleteSelf(self);
    }
}

@end
