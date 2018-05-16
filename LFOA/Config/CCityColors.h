//
//  CCityColors.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#ifndef CCityColors_h
#define CCityColors_h

#define CCITY_RGB_COLOR(r ,g ,b ,a)    [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define CCITY_MAIN_COLOR   CCITY_RGB_COLOR(0 ,183 ,255 ,1) // 00B7FF
#define CCITY_MAIN_BGCOLOR CCITY_RGB_COLOR(231 ,231 ,231 ,231)

#define CCITY_MAIN_FONT_COLOR CCITY_RGB_COLOR(0 ,0 ,0 ,1)
#define CCITY_GRAY_TEXTCOLOR [UIColor grayColor]
#define CCITY_GRAY_LINECOLOR CCITY_RGB_COLOR(0 ,0 ,0 ,.3f)

#define MAIN_ARM_COLOR [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1]
#define MAIN_LINE_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]
#define MAIN_DEEPLINE_COLOR [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]

#endif /* CCityColors_h */
