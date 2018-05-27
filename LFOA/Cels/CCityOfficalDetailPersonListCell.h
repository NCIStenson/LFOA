//
//  CCityOfficalDetailPersonListCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import <BEMCheckBox.h>
#import "CCityOffialSendPersonListModel.h"
#import "CCityOfficalDocModel.h"
@interface CCityOfficalDetailPersonListCell : CCityBaseTableViewCell

@property(nonatomic, strong)BEMCheckBox* checkBox;

@property(nonatomic, strong)CCityOfficalSendPersonDetailModel* model;

@property(nonatomic, copy) NSString * firstLetter;
@property(nonatomic, strong)NSArray * modelArr;

@property(nonatomic, strong)CCityOfficalNewProjectModel * projectModel;

@end
