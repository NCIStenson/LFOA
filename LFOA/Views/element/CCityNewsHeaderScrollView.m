
//
//  CCityNewsHeaderScrollView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsHeaderScrollView.h"

@implementation CCityNewsHeaderScrollView {
    
    UIPageControl* _pageControl;
    UIScrollView* _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self layoutMySubViews];
    }
    return self;
}

- (void)layoutMySubViews{
    
    _scrollView = [self scrollView];
    
    _scrollView.delegate = self;
    
    for (int i = 0; i < 4; i++) {
        
        UIButton* scroolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scroolBtn.frame = CGRectMake(self.bounds.size.width * i,0, self.bounds.size.width,  self.bounds.size.height);
        scroolBtn.tag = 1200 + i;
        
        if (CCITY_DEBUG) {
            scroolBtn.backgroundColor = CCITY_RGB_COLOR(arc4random()%255, arc4random()%255, arc4random()%255, 1);
        }

        [scroolBtn addTarget:self action:@selector(newsImageSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:scroolBtn];
    }
    
    _titleLabel = [self myTitleLabel];
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 30.f, self.bounds.size.width, 30.f);
    _pageControl = [self pageControl];
    _pageControl.frame = CGRectMake(_titleLabel.frame.size.width - 60.f, 0, 60, _titleLabel.frame.size.height);
    _pageControl.transform = CGAffineTransformMakeScale(.7, .7);
    [_titleLabel addSubview:_pageControl];
    
    [self addSubview:_scrollView];
    [self addSubview:_titleLabel];
}

-(UIScrollView*)scrollView {
        
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.bounds.size.width*4, self.bounds.size.height);
    return scrollView;
}

-(CCityNewsHeaderLabel*)myTitleLabel {
    
    CCityNewsHeaderLabel* titleLable = [CCityNewsHeaderLabel new];
    titleLable.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    titleLable.textColor = [UIColor whiteColor];
    return titleLable;
}

-(UIPageControl*)pageControl {
    
    UIPageControl* pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = 4;
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = CCITY_MAIN_COLOR;
    return pageControl;
}

#pragma mark- --- methods

- (void)newsImageSelectAction:(UIButton*)btn {
    
    if ([self.delegate respondsToSelector:@selector(headerBtnDidoSelectWithIndex:)]) {
        
        [self.delegate headerBtnDidoSelectWithIndex:0];
    }
}

#pragma mark- --- delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

@end
