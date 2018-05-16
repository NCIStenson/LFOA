//
//  CCityOfficalProTreeModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/18.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityOfficalProTreeModel : NSObject

@property(nonatomic, assign)int       level;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSArray*  children;
@property(nonatomic, strong)NSDictionary* ids;
@property(nonatomic, assign)BOOL      isOpen;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
