//
//  CCityCommonWordsModel.h
//  LFOA
//
//  Created by Stenson on 2018/7/13.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityCommonWordsModel : NSObject

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * idx;
@property (nonatomic,copy) NSString * loginname;
@property (nonatomic,copy) NSString * context;
@property (nonatomic,assign) BOOL isShowFullText;

- (instancetype)initWithDic:(NSDictionary*)dataDic;

@end
