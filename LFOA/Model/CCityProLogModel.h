//
//  CCityProLogModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityProLogModel : NSObject

@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSMutableArray* children;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
