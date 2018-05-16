//
//  CCityMainSearchTaskModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityMainSearchTaskModel : CCityBaseModel

@property(nonatomic, assign)NSInteger mainStyle;

@property(nonatomic, strong)NSString* workId;
@property(nonatomic, strong)NSString* fkNode;
@property(nonatomic, strong)NSString* formId;
@property(nonatomic, strong)NSString* fkFlow;

@property(nonatomic, strong)NSString* registeTime;
@property(nonatomic, strong)NSString* proName;
@property(nonatomic, strong)NSString* proNum;
@property(nonatomic, strong)NSString* proType;

@end
