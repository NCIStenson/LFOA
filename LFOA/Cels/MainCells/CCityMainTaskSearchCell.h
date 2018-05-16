//
//  CCityMainTaskSearchCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCityMainTaskSearchCell : UITableViewCell

@property(nonatomic, copy)void(^deleteSelf)(CCityMainTaskSearchCell* cell);

@end
