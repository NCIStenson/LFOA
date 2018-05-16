//
//  CCityAccessoryManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCityOfficalFileViewerVC.h"
#import "CCityScrollViewVC.h"

@interface CCityAccessoryManager : NSObject

@property(nonatomic, copy) void (^requestSucess)(UIViewController* vc);

-(void)OpenFileWithUrl:(NSString*) url parameters:(NSDictionary*)parameters fileType:(NSString*)fileType fileName:(NSString*)fileName;

-(void)cancelRequest;

@end
