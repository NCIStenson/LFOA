//
//  CCityAlterManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityAlterManager : NSObject
// auto hidde
+(void)showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title detail:(NSString*)message;

// hidde with tap
+(void)showAlertWithVC:(UIViewController*)VC Str:(NSString*)title detail:(NSString*)detial handle:(void(^)(UIAlertAction* action))handle;

+(void)showAlertWithVC:(UIViewController*)VC Str:(NSString*)title detail:(NSString*)detial okHandle:(void (^)(UIAlertAction *))handle;
@end

