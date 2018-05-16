//
//  CCityNewsDetailVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsDetailVC.h"
#import "CCityBaseTableViewCell.h"
#import "CCityNavBar.h"
#import <WebKit/WebKit.h>
#import "CCitySystemVersionManager.h"

@interface CCityNewsDetailVC ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@end

@implementation CCityNewsDetailVC {
    
    CCityNewsModel* _model;
    UIActivityIndicatorView* _activityView;
    UITableView* _tableView;
    
    WKWebView* _webView;
}

- (instancetype)initWithModel:(CCityNewsModel*)model

{
    self = [super init];
    if (self) {
        
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
    
    CCityNavBar* navBar = [self navBar];
    _webView = [self webView];
    [_webView loadHTMLString:[self formatHtmlStr:_model.content] baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].resourcePath]];

    [self.view addSubview:navBar];
    [self.view addSubview:_webView];

    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.height.mas_equalTo(84.f);
        } else {
            
            make.height.mas_equalTo(64.f);
        }
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layout

-(CCityNavBar*)navBar {
    
    CCityNavBar* navBar = [CCityNavBar new];
    [navBar.backControl addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    navBar.titleLabel.text = @"新闻详情";
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = CCITY_MAIN_COLOR;
    
    return navBar;
}

-(UIView*)tableViewHeaderView {
    
    UIView* headerView = [UIView new];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    titleLabel.text = _model.title;
    titleLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width - 20.f, MAXFLOAT);
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10.f, 10.f, self.view.frame.size.width-20.f, titleLabel.bounds.size.height);
    
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, titleLabel.bounds.size.height +20.f);
    
    [headerView addSubview:titleLabel];
    return headerView;
}

-(WKWebView*)webView {
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc]init];
    
//    config.preferences.minimumFontSize = 45.f;
    WKWebView* webView = [[WKWebView alloc]initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width - 20.f, self.view.bounds.size.height - 34.f) configuration:config];
    webView.navigationDelegate = self;
    return webView;
}

-(void)activityView {
    
   _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_tableView.tableFooterView addSubview:_activityView];
    
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_tableView.tableFooterView).with.offset(-_tableView.tableFooterView.bounds.size.height/3);
        make.centerX.equalTo(_tableView.tableFooterView);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
}

#pragma mark- --- methods

-(NSString*)formatHtmlStr:(NSString*)str {
    
    NSString* htmlStr = @"<html>";
    htmlStr = [htmlStr stringByAppendingString:@"<head>"];
    htmlStr = [htmlStr stringByAppendingString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"newDetail.css\">"];
    htmlStr = [htmlStr stringByAppendingString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\">"];
    htmlStr = [htmlStr stringByAppendingString:@"</head>"];
    htmlStr =  [htmlStr stringByAppendingString:@"<body>"];
//    align = \"center\" 
    htmlStr = [htmlStr stringByAppendingString:[NSString stringWithFormat:@"<h2 id='title' >%@</h2>", _model.title]];
    htmlStr = [htmlStr stringByAppendingString:[NSString stringWithFormat:@"<div id='section'><span style=\" color: gray;\">%@</span><span id='news-type'>%@</span></div>",_model.time, _model.type]];
    htmlStr = [htmlStr stringByAppendingString:_model.content];
    htmlStr = [htmlStr stringByAppendingString:@"</body>"];
    htmlStr = [htmlStr stringByAppendingString:@"</html>"];
    
    return htmlStr;
}

-(void)pop {
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSAttributedString*)attributeStrWithTitle:(NSString*)title content:(NSString*)content {
    
    NSMutableAttributedString* attributedStr;
    if (title.length) {
        
            attributedStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]}];
    }

    if (content.length) {
        
            [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}] ];
    }

    return attributedStr;
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityBaseTableViewCell* cell = [CCityBaseTableViewCell new];
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    
    [cell.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(0, 10, 0, 5));
    }];
    
    switch (indexPath.row) {
            
        case 0:
            
            contentLabel.attributedText = [self attributeStrWithTitle:@"所属分类：" content:_model.type];
            break;
            
        case 1:
            
            contentLabel.attributedText = [self attributeStrWithTitle:@"文章简介：" content:_model.brief];
            break;
            
        case 2:
            
            contentLabel.attributedText = [self attributeStrWithTitle:@"发布时间：" content:_model.time];
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark- --- webView delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [_activityView startAnimating];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [_activityView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    
    [_activityView stopAnimating];
}

@end
