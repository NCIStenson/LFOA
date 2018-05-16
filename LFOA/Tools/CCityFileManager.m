//
//  CCityFileManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityFileManager.h"
#import <SVProgressHUD.h>

@implementation CCityFileManager

-(NSString*)getCacheDir {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* cacheDir = [documentPath stringByAppendingPathComponent:@"cache"];
    BOOL isDir = YES;
    
    if (![fileManager fileExistsAtPath:cacheDir isDirectory:&isDir]) {
        
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cacheDir;
}

-(BOOL)writeToCacheDirWithFileName:(NSString*)fileName data:(NSData*)data{
    
    NSString* cacheDir = [self getCacheDir];
    NSFileManager* fileManager = [NSFileManager defaultManager];
   return [fileManager createFileAtPath:cacheDir contents:data attributes:nil];
}

-(NSString*)getCacheDirFileWithFileName:(NSString*)fileName {
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:fileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return filePath;

}

@end
