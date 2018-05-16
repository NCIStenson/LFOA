//
//  CCityBaseContentView.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@class CCityBaseContentView;

@protocol CCityBaseContentViewDelegate <NSObject>

-(void)headerRefresh:(CCityBaseContentView*)homeNotficMessageView;
-(void)footerRefresh:(CCityBaseContentView*)homeNotficMessageView;
@end

#import <UIKit/UIKit.h>

@interface CCityBaseContentView : UIView<UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)NSMutableArray* dataArr;

@property(nonatomic, assign)BOOL showRefreshHeader;
@property(nonatomic, assign)BOOL showRefreshFooter;

@property(nonatomic, weak) id<CCityBaseContentViewDelegate> delegate;

@end
