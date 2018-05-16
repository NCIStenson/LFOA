//
//  CCityImageTypeManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityImageTypeManager : NSObject

+(NSString*)getImageNameWithType:(NSString*)fileType;
+(NSArray*)getMeetingImageNameWithType:(NSString*)type;

@end
