//
//  CCityOfficalDetailDocListView.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/8.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCityOfficalDetailFileListModel.h"

@class CCityOfficalDetailDocListView;

@protocol CCityOfficalDetailDocListViewDelegate <NSObject>

-(void)goUploadFileVC:(CCityOfficalDetailFileListModel *)model;

@end

@interface CCityOfficalDetailDocListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <CCityOfficalDetailDocListViewDelegate> delegate;
@property(nonatomic, copy)void(^pushToFileViewerVC)(UIViewController* fileViewerVC);

- (instancetype)initWithUrl:(NSString*)url andIds:(NSDictionary*)ids;

@end
