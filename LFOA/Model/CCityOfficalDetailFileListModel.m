//
//  CCityOfficalDetailFileListModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailFileListModel.h"

@implementation CCityOfficalDetailFileListModel

- (instancetype)initWithDic:(NSDictionary*)dataDic
{
    self = [super init];
    if (self) {
      
        [self configDataWithDic:dataDic];
    }
    return self;
}

- (void) configDataWithDic:(NSDictionary*)dataDic {
    
    _dirName  = dataDic[@"templatename"];
    _filesArr = dataDic[@"children"];
}

@end
