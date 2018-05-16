//
//  CCityNewsModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityNewsModel : CCityBaseModel

@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* brief;
@property(nonatomic, strong)NSString* sender;
@property(nonatomic, strong)NSString* time;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, strong)NSString* type;

@end
