//
//  CCityMultilevelPersonVC.h
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseViewController.h"

typedef void(^successBlock)(NSArray * arr);
typedef void(^successBlockStr)(NSString * str);

@interface CCityMultilevelPersonVC : CCityBaseViewController

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,copy) successBlock arrBlock ;
@property (nonatomic,copy) successBlockStr strBlock ;

@end
