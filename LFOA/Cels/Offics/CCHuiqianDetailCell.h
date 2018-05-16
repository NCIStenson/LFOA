//
//  CCHuiqianDetailCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/15.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCHuiqianDetailCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
