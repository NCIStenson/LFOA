//
//  CCityDatePickerVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/1.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCityDatePickerVC : UIViewController

@property(nonatomic, strong)UIDatePicker* datePicker;
@property(nonatomic, copy)void(^slelectAction)(NSString* date);

@property(nonatomic, assign) CCityOfficalDetailSectionStyle style;
@property(nonatomic, copy) NSString * dateFormatStr;

- (instancetype)initWithDate:(NSDate*)date withIsShowTime:(CCityOfficalDetailSectionStyle)style;
@end
