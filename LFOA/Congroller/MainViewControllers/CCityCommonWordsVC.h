//
//  CCityCommonWordsVC.h
//  LFOA
//
//  Created by Stenson on 2018/7/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//


#import "CCityBaseViewController.h"

typedef void(^didSelectWords)(NSString * str);
//typedef void(^createNewsSuccess)(void);

@interface CCityCommonWordsVC : CCityBaseViewController


@property (nonatomic,assign) ENTER_COMMONWORDS_TYPE enterType;
@property (nonatomic,copy) didSelectWords successSelectBlock;

@end
