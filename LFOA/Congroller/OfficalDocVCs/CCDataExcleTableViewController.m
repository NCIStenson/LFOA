//
//  CCDataExcleTableViewController.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

static NSString* cellReuseId = @"cellReuseId";

#import "CCDataExcleTableViewController.h"

@interface CCDataExcleTableViewController ()

@end

@implementation CCDataExcleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    
    return cell;
}

@end
