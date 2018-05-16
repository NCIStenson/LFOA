//
//  CCityNoficManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/10/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityNoficManager : NSObject

+(void)reciveNotific:(NSDictionary*)dataDic;

+(BOOL)checkNotficService;

@end
