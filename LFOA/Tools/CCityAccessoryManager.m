//
//  CCityAccessoryManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAccessoryManager.h"

@implementation CCityAccessoryManager {
    
    NSURLSessionDataTask* _dataTask;
}

-(void)OpenFileWithUrl:(NSString*) url parameters:(NSDictionary*)parameters fileType:(NSString*)fileType fileName:(NSString*)fileName {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    if ([fileType containsString:@"txt"]) {
        
        AFHTTPResponseSerializer* response = [AFHTTPResponseSerializer serializer];
        AFJSONRequestSerializer* request = [AFJSONRequestSerializer serializer];
        [response setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/plan",nil]];
        manager.requestSerializer = request;
        manager.responseSerializer = response;
    }
    
    _dataTask = [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        CCErrorNoManager* errorNoManager = [CCErrorNoManager new];
        if (![errorNoManager requestSuccess:responseObject]) {
            
            [errorNoManager getErrorNum:responseObject WithVC:[[CCitySingleton sharedInstance] getCurrentVisibleVC] WithAction:nil loginSuccess:nil];
            return;
        }
        
        if ([fileType containsString:@"txt"]) {
            
            NSData* date  = [NSData dataWithData:responseObject];
            NSString* str = [[NSString alloc]initWithData:date encoding:NSUTF8StringEncoding];
            
            CCityOfficalFileViewerVC* fileViewVC = [[CCityOfficalFileViewerVC alloc]initWithUrl:nil title:fileName];
            
            [fileViewVC.webView loadHTMLString:str baseURL:nil];
          
            [self successVC:fileViewVC];
        } else {
            
            [self viewFileWithResponseObject:responseObject name:fileType];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"---%@",error);
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
    }];
}

-(void)viewFileWithResponseObject:(NSDictionary*)dic name:(NSString*)fileName {
    
    NSArray* fileUrls = dic[@"urlpath"];
    
    if ([fileName containsString:@"doc"]) {
        
        CCityScrollViewVC* scrollViewVC = [[CCityScrollViewVC alloc]initWithURLs:fileUrls];
        scrollViewVC.title = fileName;
        
        [self successVC:scrollViewVC];
        
    } else {
        
        CCityOfficalFileViewerVC* viewVC = [[CCityOfficalFileViewerVC alloc]initWithUrl:fileUrls[0] title:fileName];
        
        [self successVC:viewVC];
    }
}

- (void)successVC:(UIViewController*)vc {
    
    if (self.requestSucess) {
        
        self.requestSucess(vc);
    }
}

-(void)cancelRequest {
    
    [_dataTask cancel];
}

@end
