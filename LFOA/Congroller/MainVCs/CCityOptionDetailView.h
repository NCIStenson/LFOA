//
//  CCityOptionDetailView.h
//  LFOA
//
//  Created by Stenson on 2018/6/11.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCityOptionDetailView;

@protocol CCityOptionDetailViewDelegate <NSObject>

-(void)didSelectOption:(NSObject *)obj;

@end

@interface CCityOptionDetailView : UIView
{
    CGRect _frameRect;
}

@property (nonatomic,weak) id <CCityOptionDetailViewDelegate> delegate;

-(id)initWithData:(NSArray *)arr withType:(CCityDropdownBox)showType withFrame:(CGRect)frame;

@end
