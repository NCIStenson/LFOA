//
//  CCityOfficalDetailPsrsonListVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@protocol CCityOffialPersonListDelegate <NSObject>

-(void)viewControllerDismissActoin;

@end

#import "CCityBaseViewController.h"

@interface CCityOfficalDetailPsrsonListVC : CCityBaseViewController

@property(nonatomic, weak)id<CCityOffialPersonListDelegate> delegate;

- (instancetype)initWithIds:(NSDictionary*)ids;

@end
