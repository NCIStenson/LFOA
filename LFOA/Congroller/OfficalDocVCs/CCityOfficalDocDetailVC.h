//
//  CCityOfficalDocDetailVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights

#import "CCityBaseTableViewVC.h"
#import "CCityOfficalDetailMenuVC.h"

@interface CCityOfficalDocDetailVC : CCityBaseTableViewVC

@property(nonatomic, assign)CCityOfficalMainStyle      mainStyle;
@property(nonatomic, assign)CCityOfficalDocContentMode conentMode;
@property(nonatomic, assign)BOOL                       isEnd;
@property(nonatomic, strong)NSIndexPath*               indexPath;
@property(nonatomic, strong)NSString*                  passPerson;
@property(nonatomic, strong)NSString*                  passOponio;

@property (nonatomic,assign)BOOL                       isNewProject; // 是否是新建流程
@property (nonatomic,strong)NSDictionary*              resultDic; // 新建流程时传入数据

@property(nonatomic, strong)NSString* url;

@property(nonatomic, copy)void(^reloadData)(void);
@property(nonatomic, copy)void (^sendActionSuccessed)(NSIndexPath* indexPath);

- (instancetype)initWithItmes:(NSArray *)items Id:(NSDictionary*)docId contentModel:(CCityOfficalDocContentMode)contentMode;

@end
