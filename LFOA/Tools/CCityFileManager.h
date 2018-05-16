//
//  CCityFileManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityFileManager : NSObject

-(NSString*)getCacheDir;

-(BOOL)writeToCacheDirWithFileName:(NSString*)fileName data:(NSData*)data;

-(NSString*)getCacheDirFileWithFileName:(NSString*)fileName;

@end
