
//
//  CCityAlterManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAlterManager.h"

@implementation CCityAlterManager

+(void)showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title detail:(NSString*)message {
    
    UIAlertController* alterController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alterController addAction:okAction];
    
    [viewController presentViewController:alterController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        if (alterController) {
            [alterController dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

+(void)showAlertWithVC:(UIViewController*)VC Str:(NSString*)title detail:(NSString*)detial handle:(void (^)(UIAlertAction *))handle{
    
    UIAlertController* alterController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handle];
    
    [alterController addAction:okAction];
    
    [VC presentViewController:alterController animated:YES completion:nil];
}

+(void)showAlertWithVC:(UIViewController*)VC Str:(NSString*)title detail:(NSString*)detial okHandle:(void (^)(UIAlertAction *))handle{
    
    UIAlertController* alterController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handle];
    UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:handle];
    [alterController addAction:cancleAction];
    [alterController addAction:okAction];
    
    [VC presentViewController:alterController animated:YES completion:nil];
}


@end
