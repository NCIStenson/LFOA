//
//  CCitySystemVersionManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/10/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCitySystemVersionManager : NSObject

// 型号如 X
+(NSString*)deviceStr;
// 型号如 11.0
+(NSString*)OSVersion;

@end
