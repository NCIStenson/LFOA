//
//  CCErrorNoManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/27.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCErrorNoManager.h"
#import "CCityLogInVC.h"

@implementation CCErrorNoManager

-(BOOL)requestSuccess:(NSDictionary *)response {
    if (![response isKindOfClass:[NSDictionary class]]) {   return NO; }
    /*
     * success/failed
     */
    if ([response[@"status"] isEqualToString:@"failed"]) { return NO; }
    return YES;
}

- (void)getErrorNum:(NSDictionary*)response WithVC:(UIViewController *)viewController WithAction:(void (^)(void))handle loginSuccess:(void (^)(void))logInSuccess {
    
    if (![response isKindOfClass:[NSDictionary class]]) { return; }
    
    NSInteger errorNo = [response[@"errorNo"] integerValue];
    
    if (errorNo == CCNetWorkStateTokenOutOfData) {
        
        if ([viewController isKindOfClass:[CCityLogInVC class]]) {
            return;
        }
        
        CCityLogInVC* loginVC = [[CCityLogInVC alloc]init];
        loginVC.logInSuccess = logInSuccess;
        
        [viewController presentViewController:loginVC animated:YES completion:nil];
        
    } else if (errorNo == CCNetWorkStateLowJurisdiction) {
        
          [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"权限不足" handle:nil];
    } else if (errorNo == CCNetWorkStateInvalidParameter) {
        
        [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"参数无效" handle:nil];
    } else if (errorNo == CCNetWorkStateServerExecuteError) {
        
        [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"服务器内部错误" handle:nil];
    }
    else if (errorNo == CCNetWorkStateListNotConfig) {
        
        [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"此业务目前暂不支持在手机上打开，请联管理员开通" handle:nil];
    } else if (errorNo == CCNetWorkStateListNotExist) {
        
        [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"表单不存在" handle:nil];
    } else {
        
         [CCityAlterManager showAlertWithVC:viewController Str:@"提示" detail:@"操作失败" handle:nil];
    }
}

@end
