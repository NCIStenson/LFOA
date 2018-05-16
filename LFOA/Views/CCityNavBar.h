//
//  CCityNavBar.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCityNavBar : UIView

@property(nonatomic, strong)UILabel*   backLabel;
@property(nonatomic, strong)UILabel*   titleLabel;
@property(nonatomic, strong)UIControl* backControl;
@property(nonatomic ,strong)UIColor*   barTintColor;

@property(nonatomic, assign)BOOL       showBottomLine;
@end
