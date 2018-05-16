//
//  CCLeftBarBtnItem.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCityBackToLeftView.h"

@interface CCLeftBarBtnItem : UIControl

@property(nonatomic, strong)CCityBackToLeftView* arrow;
@property(nonatomic, strong)UILabel* label;
@property(nonatomic, copy)  void (^action)(void);

@end
