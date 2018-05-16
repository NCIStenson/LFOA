
//
//  CCityOfficalDetailProTreeVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailProTreeVC.h"
#import "CCityOfficalDetailProTreeCell.h"
#import "CCityOfficalProTreeModel.h"

@interface CCityOfficalDetailProTreeVC ()

@end

static NSString* ccityOfficalDetailProTreeCellReuseId = @"CCityOfficalDetailProTreeCell";

@implementation CCityOfficalDetailProTreeVC {
    
    NSMutableArray* localArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.mainStyle == CCityOfficalMainDocStyle) {
        
        self.titleLabel.text = @"公文树";
    } else if (self.mainStyle == CCityOfficalMainSPStyle) {
        
        self.titleLabel.text = @"项目树";
    }

    [self layoutSubViews];
    [self configData];
}

#pragma mark- --- layout subviews

- (void)layoutSubViews {
 
    [self.tableView registerClass:[CCityOfficalDetailProTreeCell class] forCellReuseIdentifier:ccityOfficalDetailProTreeCellReuseId];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark- --- methods

- (void)tableViewHeaderAction:(UIControl*)headerCon {
    
    
}

#pragma mark- ---  netWork
- (void)configData {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:@"service/form/GetProjectTree.ashx" parameters:self.ids progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
       
        self.dataMuArr = [NSMutableArray arrayWithCapacity:1];
        
        CCityOfficalProTreeModel* model = [[CCityOfficalProTreeModel alloc]initWithDic:responseObject];
        
        [self.dataMuArr addObject:model];
        
        localArr = [self.dataMuArr mutableCopy];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- uitableView delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return localArr.count?localArr.count:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataMuArr.count) {
        
        UITableViewCell* cell = [UITableViewCell new];
        cell.textLabel.text = @"无数据";
        return cell;
    } else {
        
        CCityOfficalDetailProTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficalDetailProTreeCellReuseId];
        
        if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        while ([cell.contentView.subviews lastObject]) {
            
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        CCityOfficalProTreeModel* model = localArr[indexPath.row];
        
        cell.model = model;
        if (indexPath.row == 0) {
            
            UIView* lineView = [UIView new];
            lineView.backgroundColor = CCITY_GRAY_LINECOLOR;
            lineView.frame = CGRectMake(3, 0, self.view.bounds.size.width-6, .5f);
            [cell.contentView addSubview:lineView];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalProTreeModel* model = localArr[indexPath.row];
    
    if (!model.children.count) {   return; }
    
    model.isOpen = !model.isOpen;
    
    CCityOfficalDetailProTreeCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:.3f animations:^{
        
        if (model.isOpen) {
            
            cell.localImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            
            cell.localImageView.transform = CGAffineTransformMakeRotation(4*M_PI);
        }
    }];
    
    NSMutableArray* muArr = [NSMutableArray arrayWithCapacity:model.children.count];
    
    [tableView beginUpdates];

    
    for (int i = 0; i < model.children.count; i++) {
        
        if (model.isOpen) {
            
            [muArr addObject: [NSIndexPath indexPathForRow: indexPath.row+i +1 inSection: indexPath.section]];

            CCityOfficalProTreeModel* children = model.children[i];
            children.level = model.level +1;
            [localArr insertObject:children atIndex:localArr.count];
        } else {
            
            NSMutableArray* removeMuArr = [NSMutableArray array];
            
            for (int i = (int)indexPath.row+1; i < localArr.count; i++) {
                
                CCityOfficalProTreeModel* removeModel = localArr[i];
                                
                if (removeModel.level > model.level) {
                    
                    [removeMuArr addObject:removeModel];
                } else {
                    
                    break;
                }
            }
            
            [localArr removeObjectsInArray:removeMuArr];
        }
    }
    
    if (model.isOpen) {
        
        [tableView insertRowsAtIndexPaths:muArr withRowAnimation:UITableViewRowAnimationFade];
    } else {
        
        [tableView deleteRowsAtIndexPaths:[self closeIndexsWithModel:model indexPath:indexPath muArr:nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView endUpdates];
}

-(NSMutableArray*)closeIndexsWithModel:(CCityOfficalProTreeModel*)model indexPath:(NSIndexPath*)indexPath muArr:(NSMutableArray*)muArr {
    
    if (!muArr) {
        
        muArr = [NSMutableArray array];
    }
    
    for (int i = 1; i <= model.children.count; i++) {
        
        [muArr addObject: [NSIndexPath indexPathForRow: indexPath.row+i inSection: indexPath.section]];
        
        CCityOfficalProTreeModel* children = model.children[i-1];
        
            if (children.isOpen && children.children) {
                
               NSIndexPath* lowIndexPath = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
                children.isOpen = NO;
                [self closeIndexsWithModel:children indexPath:lowIndexPath muArr:muArr];
        }
    }
    return muArr;
}

@end
