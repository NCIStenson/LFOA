//
//  CCityMainDocSearchModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityAccessoryModel:CCityBaseModel

@property(nonatomic, strong)NSString* accessoryName;
@property(nonatomic, strong)NSString* accessorySize;
@property(nonatomic, strong)NSString* accessoryUrl;

@end

@interface CCityMainDocsearchDetailModel : CCityBaseModel

@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* from;
@property(nonatomic, strong)NSString* time;
@property(nonatomic, strong)NSString* info;
@property(nonatomic, strong)NSString* number;

@property(nonatomic, assign)BOOL isOpen;
@property(nonatomic, strong)NSArray* accessoryArr;

@end

@interface CCityMainDocSearchModel : CCityBaseModel

@property(nonatomic, strong)NSString* type;
@property(nonatomic, strong)NSMutableArray*  children;

@property(nonatomic, assign)BOOL isOpen;

@end
