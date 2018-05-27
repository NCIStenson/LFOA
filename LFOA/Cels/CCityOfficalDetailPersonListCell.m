

//
//  CCityOfficalDetailPersonListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define kFirstLetterHeight 40.0f

#import "CCityOfficalDetailPersonListCell.h"

@implementation CCityOfficalDetailPersonListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = CCITY_MAIN_BGCOLOR;
    }
    return self;
}

-(void)setFirstLetter:(NSString *)firstLetter{
    UILabel* personLabel = [UILabel new];
    personLabel.backgroundColor = MAIN_DEEPLINE_COLOR;
    personLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    personLabel.textColor = [UIColor blackColor];
    personLabel.text = [NSString stringWithFormat:@"    %@",firstLetter];
    [self.contentView addSubview:personLabel];
    personLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, kFirstLetterHeight);
}

-(void)setProjectModel:(CCityOfficalNewProjectModel *)projectModel
{
    _projectModel = projectModel;
    _checkBox = [self myCheckBox];
    _checkBox.on = projectModel.proChecked;
    _checkBox.tag = 10000;
    
    UILabel* personLabel = [self personNameLabel];
    
    personLabel.backgroundColor = CCITY_MAIN_BGCOLOR;
    personLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    personLabel.textColor = CCITY_MAIN_FONT_COLOR;
    personLabel.text = projectModel.proName;
    
    UIView * lineView = [UIView new];
    lineView.backgroundColor = MAIN_DEEPLINE_COLOR;
    [self.contentView addSubview:lineView];
    
    [self.contentView addSubview:_checkBox];
    [self.contentView addSubview:personLabel];
    
    _checkBox.top = 12.f ;
    _checkBox.left = 30.0f;
    _checkBox.size = CGSizeMake(20, 20);
    
    personLabel.top = _checkBox.top;
    personLabel.left = _checkBox.right + 5.0f;
    personLabel.size = CGSizeMake(SCREEN_WIDTH - _checkBox.right - 20 , 24);
}

-(void)setModelArr:(NSArray *)modelArr{
    for (int i = 0; i < modelArr.count; i ++) {
        CCityOfficalSendPersonDetailModel * model = modelArr[i];
        
        _checkBox = [self myCheckBox];
        _checkBox.on = model.isSelected;
        _checkBox.tag = 10000 + i;
        UIImageView* imageView = [self personImageView];
        
        UILabel* personLabel = [self personNameLabel];
        
        personLabel.backgroundColor = CCITY_MAIN_BGCOLOR;
        personLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
        personLabel.textColor = CCITY_MAIN_FONT_COLOR;
        personLabel.text = model.name;
        
        UIView * lineView = [UIView new];
        lineView.backgroundColor = MAIN_DEEPLINE_COLOR;
        [self.contentView addSubview:lineView];
        
        [self.contentView addSubview:_checkBox];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:personLabel];
        
        _checkBox.top = 12.f + kFirstLetterHeight + 44 * i;
        _checkBox.left = 30.0f;
        _checkBox.size = CGSizeMake(20, 20);

        imageView.top = 10.f + kFirstLetterHeight + 44 * i;
        imageView.left = _checkBox.right + 5.0f;
        imageView.size = CGSizeMake(24, 24);
        
        personLabel.top = imageView.top;
        personLabel.left = imageView.right + 5.0f;
        personLabel.size = CGSizeMake(SCREEN_WIDTH - imageView.left - 20 , 24);
        
        if(i < modelArr.count && i != 0 ){
            lineView.frame = CGRectMake(0,44 * i + kFirstLetterHeight , SCREEN_WIDTH, 0.5);
        }
    }
}

-(UIImageView*)personImageView {
    
    UIImageView * personImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_offical_sendDoc_addPerson_50x50_"]];
    return personImageView;
}

-(UILabel*)personNameLabel {
    
    UILabel* personNameLabel = [UILabel new];
    return personNameLabel;
}

-(BEMCheckBox*)myCheckBox {
    
    BEMCheckBox* checkBox = [[BEMCheckBox alloc]init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onTintColor = CCITY_MAIN_COLOR;
    checkBox.onCheckColor = CCITY_MAIN_COLOR;
    checkBox.userInteractionEnabled = NO;
    return  checkBox;
}

@end
