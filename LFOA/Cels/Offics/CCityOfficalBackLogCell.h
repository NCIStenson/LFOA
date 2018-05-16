//
//  CCityOfficalBackLogCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityOfficalDocModel.h"

@interface CCityOfficalBackLogCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityOfficalDocModel*      model;
@property(nonatomic, assign) CCityOfficalMainStyle mainStyle;
@property(nonatomic, assign) CCityOfficalDocContentMode myContentMode;
@property(nonatomic, strong) UIImageView* docImageView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mainStyle:(CCityOfficalMainStyle)mainStyle conentMode:(CCityOfficalDocContentMode)contentMode;

@end
