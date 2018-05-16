//
//  CCityScrollViewVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityScrollViewVC.h"
#import <UIImageView+WebCache.h>
#import "CCLeftBarBtnItem.h"

@interface CCityScrollViewVC ()

@end

@implementation CCityScrollViewVC {
    
    NSArray* _urls;
}

- (instancetype)initWithURLs:(NSArray*)urls
{
    self = [super init];
    if (self) {
        
        _urls = urls;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // back navbar
    CCLeftBarBtnItem* backCon = [CCLeftBarBtnItem new];
    backCon.label.text = @"";
    backCon.action = ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
    
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*_urls.count, self.view.bounds.size.height);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < _urls.count; i++) {
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.bounds.size.width*i, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        [imageView sd_setImageWithURL:_urls[i]];
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];
}

#pragma mark- --- methods


@end
