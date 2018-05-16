//
//  CCitySegmentedControl.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCitySegmentedControl : UIControl

//@protocol CCitySegmentcontrolDelegate <NSObject>
//
//-(void)didSelectItemWithIndex:(int)index;
//
//@end

@property(nonatomic, assign)int      selectedIndex;

//@property(nonatomic, weak)id<CCitySegmentcontrolDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray<NSString*>*)items;

@end
