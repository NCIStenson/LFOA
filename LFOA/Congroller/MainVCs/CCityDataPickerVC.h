//
//  CCityDataPickerVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"

@interface CCityDataPickerVC : CCityBaseViewController

- (instancetype)initWtihDatas:(NSArray*)datas;

@property(nonatomic, strong) void(^didSelectData)(NSString* selectedData);

@end
