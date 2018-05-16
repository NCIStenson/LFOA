//
//  CCityNewsHeaderScrollView.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@protocol CCityNewsHeaderScollViewDelegate <NSObject>

-(void)headerBtnDidoSelectWithIndex:(int)index;

@end

#import <UIKit/UIKit.h>
#import "CCityNewsHeaderLabel.h"

@interface CCityNewsHeaderScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, strong)CCityNewsHeaderLabel* titleLabel;
@property(nonatomic, weak)id<CCityNewsHeaderScollViewDelegate> delegate;

@end
