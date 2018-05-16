//
//  CCityOfficalProLogCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCityProLogDetailModel.h"

#define CCITY_DAY_LINE_COLOR CCITY_RGB_COLOR(245, 245, 245, 1)

@interface CCityOfficalProLogCell : UITableViewCell

@property(nonatomic, strong)CCityProLogDetailModel* model;
@property(nonatomic, assign)BOOL isBottom;

@end
