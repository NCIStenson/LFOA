//
//  CCityMainDetailSearchModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityMainDetailSearchModel : NSObject

@property(nonatomic, strong)NSString* placeHolder;

@property(nonatomic, strong)NSString* value;
@property(nonatomic, strong)NSString* key;

@property(nonatomic, strong)NSString* timeBegin;
@property(nonatomic, strong)NSString* timeEnd;

@property(nonatomic, strong)NSArray*  switchArr;
@end
