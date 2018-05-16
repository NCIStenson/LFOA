//
//  CCityLogInVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"

@interface CCityLogInVC : CCityBaseViewController

@property(nonatomic, strong)NSDictionary* notificDic;
@property(nonatomic, strong)void(^logInSuccess)(void);

@end
