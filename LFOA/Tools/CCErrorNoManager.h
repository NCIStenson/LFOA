//
//  CCErrorNoManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/27.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCErrorNoManager : NSObject

-(BOOL)requestSuccess:(NSDictionary*)response;

- (void) getErrorNum:(NSDictionary*)response WithVC:(UIViewController*)viewController WithAction:(void (^)(void))handle loginSuccess:(void(^)(void))logInSuccess;

@end
