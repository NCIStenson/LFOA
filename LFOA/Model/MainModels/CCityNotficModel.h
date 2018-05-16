//
//  CCityNotficModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseModel.h"

@interface CCityFileModel : CCityBaseModel

@property(nonatomic, strong)NSString* fileName;
@property(nonatomic, strong)NSString* fileSize;
@property(nonatomic, strong)NSString* fileUrl;
@property(nonatomic, strong)NSString* type;

@end

@interface CCityNotficModel : CCityBaseModel<NSMutableCopying>

@property(nonatomic, assign)BOOL      isHaveFile;
@property(nonatomic, assign)BOOL      isHeightLevel;
@property(nonatomic, assign)BOOL      isRead;

@property(nonatomic, strong)NSString* messageId;
@property(nonatomic, strong)NSString* notficFromName;
@property(nonatomic, strong)NSString* notficPostTime;
@property(nonatomic, strong)NSString* notficTitle;
@property(nonatomic, strong)NSString* notficContent;

@property(nonatomic, strong)NSArray* files;

@end
