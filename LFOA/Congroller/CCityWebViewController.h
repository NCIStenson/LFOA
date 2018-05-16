//
//  CCityWebViewController.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CCityWebViewController : UIViewController

@property(nonatomic, strong) WKWebView* webView;

- (instancetype)initWithUrl:(NSString*)url title:(NSString*)title;

@end
