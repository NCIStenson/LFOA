//
//  CCityMessageModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/19.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityMessageModel : CCityBaseModel

@property(nonatomic, assign)BOOL      isOpen;

@property(nonatomic, strong)NSString* content;
@property(nonatomic, strong)NSString* time;
@property(nonatomic, strong)NSString* userName;
@property(nonatomic, strong)NSString* messageType;
@property(nonatomic, strong)NSString* messageId;
@property(nonatomic, strong)NSString* secondLevelType;
@property(nonatomic, strong)NSDate*   date;

@property(nonatomic, assign)CCityOfficalDocContentMode docStyle;

@property(nonatomic, assign)CCityOfficalMainStyle mainStyle;

@end
