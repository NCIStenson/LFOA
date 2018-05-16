//
//  CCitySingleton.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCityLogInVC.h"

@interface CCitySingleton : NSObject

@property(nonatomic, assign)BOOL isLogIn;
@property(nonatomic, strong)NSString* token;
@property(nonatomic, strong)NSString* userName;
@property(nonatomic, strong)NSString* deptname;
@property(nonatomic, strong)NSString* occupation;
@property(nonatomic, strong)NSString* organization;
@property(nonatomic, strong)NSString* deviceType;

+ (instancetype)sharedInstance;

- (void)showLogInVCWithPresentedVC:(UIViewController*)currentVC;
- (UIViewController*)getCurrentVisibleVC;

@end
