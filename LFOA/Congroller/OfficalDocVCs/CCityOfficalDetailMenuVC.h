//
//  CCityOfficalDetailMenuVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCityOfficalDetailMenuVC : UIViewController

@property(nonatomic, copy)void(^pushToNextVC)(UIViewController* viewController);
@property(nonatomic, copy)void(^pushToRoot)(void);

@property(nonatomic, copy)   NSDictionary* ids;
@property(nonatomic, assign) NSInteger     contentMode;

- (instancetype)initWithStyle:(CCityOfficalMainStyle)style;

@end
