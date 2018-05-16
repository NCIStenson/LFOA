//
//  CCityOfficalDocDetailModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHuiQianModel:NSObject<NSCopying>

@property(nonatomic, strong)NSMutableArray* contentsMuArr;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, strong)NSString* field;
@property(nonatomic, strong)NSString* rowId;

-(NSString*)currentFormatTime;

@end



@interface CCityOfficalDocDetailModel : NSObject

@property(nonatomic, assign)BOOL              isOpen;
@property(nonatomic, strong)NSString*         title;
@property(nonatomic, assign)CCityOfficalDetailSectionStyle style;
@property(nonatomic, assign)CGFloat           sectionHeight;
@property(nonatomic, assign)CGSize            titleLabelSize;

/*
 * 数据网格 cell 的数量
 */
@property(nonatomic, assign)NSInteger         cellNum;
@property(nonatomic, assign)BOOL              canEdit;

@property(nonatomic, assign)BOOL              isRequired; //  是否必填
@property(nonatomic, strong)NSString*         RequiredMessage; //  必填项未填写提示框

@property(nonatomic, strong)NSString*         dataType;
@property(nonatomic, strong)NSString*         table;
@property(nonatomic, strong)NSString*         value;
@property(nonatomic, strong)NSString*         field;
@property(nonatomic, strong)NSArray*          switchContentArr;
@property(nonatomic, strong)NSString*         groupId;
@property(nonatomic, strong)NSMutableArray*   huiQianMuArr;
@property(nonatomic, strong)CCHuiQianModel*   emptyHuiQianModel;

- (instancetype)initWithDic:(NSDictionary*)dic;
- (void)updataValue;
@end
