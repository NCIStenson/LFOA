//
//  CCityAMapVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/11/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAMapVC.h"

@interface CCityAMapVC ()

@end

@implementation CCityAMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
