//
//  CCityHomeModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/5.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CCityHomeCellStyle) {
    CCityHomeCellDocStyle,
    CCityHomeCellSPStyle,
    CCityHomeCellMessageStyle,
    CCityHomeCellNotStyle,
    CCityHomeCellNewsStyle,
    CCityHomecellMettingManagerStyle,
    CCityHomeCellTaskSearchStyle,
    CCityHomeCellDocSearchStyle,
    CCityHomeCellAMapStyle
};

#import "CCityBaseModel.h"

@interface CCityHomeModel : CCityBaseModel

@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* imageName;
@property(nonatomic, assign)NSInteger badgeNum;

@property(nonatomic, assign)CCityHomeCellStyle cellStyle;

@end
