//
//  CCityWebViewController.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityWebViewController.h"
#import "CCityAlterManager.h"

@interface CCityWebViewController ()<WKNavigationDelegate>

@end

@implementation CCityWebViewController {
    
    UIProgressView* _progressView;
    NSString*       _url;
}

- (instancetype)initWithUrl:(NSString*)url title:(NSString*)title
{
    self = [super init];
    if (self) {
        
        self.title = title;
        _url = url;
        _webView = [self myWebView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _progressView = [self myProgressView];
    _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2.f);
    
    _webView.frame = self.view.bounds;
    self.view = _webView;
    [self.view addSubview:_progressView];
    
    if (_url) {
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}

-(void)dealloc {
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark- --- layout subviews

-(WKWebView*)myWebView {
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 30.f;
    WKWebView* webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    webView.navigationDelegate = self;
    return webView;
}

- (UIProgressView*) myProgressView {
    
    UIProgressView* progressView = [[UIProgressView alloc]init];
    
    return progressView;
}

#pragma mark- --- methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        _progressView.progress = _webView.estimatedProgress;
        
        if (_progressView.progress == 1) {
            
          [UIView animateWithDuration:.25 delay:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
             
              _progressView.transform = CGAffineTransformMakeScale(1.0, 1.4);
          } completion:^(BOOL finished) {
              
              _progressView.hidden = YES;
          }];
        }
    } else {
    
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark- --- wkwebview delegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    _progressView.hidden = NO;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    _progressView.hidden = YES;
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    
    _progressView.hidden = YES;
    [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
}

@end
