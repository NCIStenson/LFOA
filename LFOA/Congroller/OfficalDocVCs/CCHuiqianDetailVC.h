//
//  CCHuiqianDetailVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

// 新建 编辑 查看

#import <UIKit/UIKit.h>
#import "CCityOfficalDocDetailModel.h"

@interface CCHuiqianDetailVC : UIViewController

@property(nonatomic, assign)BOOL               editable;
@property(nonatomic, assign)NSInteger          outerRowNum;
@property(nonatomic, assign)NSInteger          innerRowNum;
@property(nonatomic, assign)CCHuiQianEditStyle editStyle;
@property(nonatomic, strong)NSDictionary*   parameters;
@property(nonatomic, strong)CCHuiQianModel* huiQianModel;
@property(nonatomic, strong)NSString*       headerTitle;
@property(nonatomic, strong)NSDictionary*   docId;

@property(nonatomic, copy)void(^addSuccess)(void);

- (instancetype)initWithModel:(CCityOfficalDocDetailModel*)model title:(NSString*)title style:(CCHuiQianEditStyle)style;

@end
