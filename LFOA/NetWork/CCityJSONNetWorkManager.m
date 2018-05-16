//
//  CCityJSONNetWorkManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityJSONNetWorkManager.h"

@implementation CCityJSONNetWorkManager

+ (AFHTTPSessionManager*) sessionManager {
    
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:CCITY_BASE_URL]];
    
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    return manager;
}

+(AFJSONResponseSerializer*)responseSerializer {

    AFJSONResponseSerializer* response = [AFJSONResponseSerializer serializer];
    [response setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/plan",nil]];
    return response;
}

+(AFHTTPRequestSerializer*)requestSerializer {
    
    AFHTTPRequestSerializer* request = [AFHTTPRequestSerializer serializer];
    return request;
}

@end
