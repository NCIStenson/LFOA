//
//  CCityOffialSendPersonListModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityOfficalSendPersonDetailModel : NSObject

@property(nonatomic, strong)NSArray * childrenDic;
@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* personId;
@property(nonatomic, strong)NSString* pinyin; // 拼音
@property(nonatomic, strong)NSString* firstLetter; // 首字母
@property(nonatomic, assign)BOOL      isSelected;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end

@interface CCityOffialSendPersonListModel : NSObject

@property(nonatomic, strong)NSString* groupTitle;
@property(nonatomic, strong)NSMutableArray*  groupItmes;
@property(nonatomic, strong)NSString* fkNode;
@property(nonatomic, assign)BOOL      isOpen;

@property(nonatomic, strong)NSMutableArray * firstLetterArr; // 存储现有的首字母
@property(nonatomic, strong)NSMutableDictionary * formatDataDic; // 存储排序过的数据

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
