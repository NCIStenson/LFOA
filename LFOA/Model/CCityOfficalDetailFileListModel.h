//
//  CCityOfficalDetailFileListModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CCityOfficalDetialListType) {
    
    CCityDocDetailListDirType,
    CCityDocDetailListDocType,
    CCityDocDetailListPdfType,
    CCityDocDetailListImgType,
    CCityDocDetailListExcelType,
};

@interface CCityOfficalDetailFileListModel : NSObject

@property(nonatomic, strong)NSString* dirName;
@property(nonatomic, copy)  NSArray*  filesArr;
@property(nonatomic, assign)CCityOfficalDetialListType contentType;
@property(nonatomic, assign) BOOL isOpen;

- (instancetype)initWithDic:(NSDictionary*)dataDic;

@end
