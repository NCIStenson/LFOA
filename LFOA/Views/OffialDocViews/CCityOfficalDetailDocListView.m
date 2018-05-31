//
//  CCityOfficalDetailDocListView.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/8.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailDocListView.h"
#import "CCityOfficalDetailDocListCell.h"
#import "CCityOfficalDetailDocListView.m"
#import "CCityOfficalFileViewerVC.h"
#import "CCityOfficalDetailSectionView.h"
#import "CCityOfficalDetialDocListSection.h"
#import "CCityOfficalDetailFileListModel.h"
#import "CCityScrollViewVC.h"
#import <WebKit/WebKit.h>
#import "CCityAccessoryManager.h"

static NSString* officalDetailDocListCellReuseId = @"officalDetailDocListCellReuseId";

@implementation CCityOfficalDetailDocListView {
    
    UITableView*        _tableView;
    NSMutableArray*     _dataArr;
    NSMutableArray*     _localDataArr;
}

- (instancetype)initWithUrl:(NSString*)url andIds:(NSDictionary*)ids
{
    self = [super init];
    
    if (self) {
        
        [self layoutMySubViews];
        
        [self configDataWithUrl:url andIds:ids];
        
    }
    return self;
}

-(void)configDataWithUrl:(NSString*)url andIds:(NSDictionary*)ids{
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parameters = @{@"fk_flow":ids[@"fk_flow"], @"workId":ids[@"workId"],};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSArray* results = responseObject[@"results"];
        
        if (!results.count) {   return; }
        
        if (!_dataArr) {
            
            _dataArr = [NSMutableArray arrayWithCapacity:results.count];
            _localDataArr = [NSMutableArray arrayWithCapacity:results.count];
        }
        
        for (int i = 0 ; i < results.count; i++) {
            
            CCityOfficalDetailFileListModel* model = [[CCityOfficalDetailFileListModel alloc]initWithDic:results[i]];
            
            [_dataArr addObject:model];
            
            CCityOfficalDetailFileListModel* emptyModel = [CCityOfficalDetailFileListModel new];
            [_localDataArr addObject:emptyModel];
        }
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
        NSLog(@"%@",error);
    }];
}

- (void)layoutMySubViews {
    
    _tableView = [self tableView];
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
    }];
}

- (UITableView*)tableView {
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1f, .1f)];
    tableView.sectionFooterHeight = .1f;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.rowHeight  = 44.f;
    [tableView registerClass:[CCityOfficalDetailDocListCell class] forCellReuseIdentifier:officalDetailDocListCellReuseId];

    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    return tableView;
}

#pragma mark- --- methods 

- (void)sectionClicked:(CCityOfficalDetialDocListSection*)sectoinHeader {
    
    [_tableView beginUpdates];

    NSInteger section = sectoinHeader.tag - 2000;
     CCityOfficalDetailFileListModel* model = _dataArr[section];
    
    model.isOpen = !model.isOpen;
    
    CCityOfficalDetailFileListModel* localModel = _localDataArr[section];
    
    if (localModel.filesArr.count) {
        
        localModel.filesArr = nil;
    } else {
        
        localModel.filesArr = [model.filesArr mutableCopy];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableView endUpdates];
}

#pragma mark- --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count?_dataArr.count:1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_dataArr.count) {
        CCityNoDataSection* sectionView = [CCityNoDataSection new];
        return sectionView;
    }
    
    CCityOfficalDetailFileListModel* model = _dataArr[section];
    
    CCityOfficalDetialDocListSection* sectionHeader = [[CCityOfficalDetialDocListSection alloc]init];
    
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.tag = 2000 + section;
    
    [sectionHeader addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.isOpen) {
        
         sectionHeader.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_officalList_fileList_dir_open_44x44_"]];
    } else {
        
        sectionHeader.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_officalList_fileList_dir_closed_50x50_"]];
    }

    UILabel* sectionTitleLabel = [UILabel new];
    sectionTitleLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
     if (!_dataArr.count) {   sectionTitleLabel.text = @"无数据";    }
    
     else {
         
         sectionTitleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", model.dirName, (unsigned long)model.filesArr.count];
     }
    
    UIButton * uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.tag = 1000 + section;
    uploadBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 50, 50.0f);
    [uploadBtn setImage:[UIImage imageNamed:@"ccity_officalList_fileList_upload"] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(chooseImageToUpload:) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionHeader addSubview:uploadBtn];
    [sectionHeader addSubview:sectionHeader.imageView];
    [sectionHeader addSubview:sectionTitleLabel];
    
    [sectionHeader.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(sectionHeader).with.offset(10.f);
        make.top.equalTo(sectionHeader).with.offset(11.f);
        make.bottom.equalTo(sectionHeader).with.offset(-11.f);
        make.width.equalTo(sectionHeader.imageView.mas_height);
    }];
    
    [sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(sectionHeader.imageView);
        make.left.equalTo(sectionHeader.imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(sectionHeader.imageView);
        make.right.equalTo(sectionHeader).with.offset(-5.f);
    }];
    
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!_dataArr.count) {  return 0;   }
    
    CCityOfficalDetailFileListModel* model = _localDataArr[section];
    return model.filesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDetailDocListCell* cell = [tableView dequeueReusableCellWithIdentifier:officalDetailDocListCellReuseId];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.2f];
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    CCityOfficalDetailFileListModel* model = _localDataArr[indexPath.section];
    
    cell.model = model.filesArr[indexPath.row];
    
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDetailFileListModel* model = _localDataArr[indexPath.section];
    NSDictionary* fileModel = model.filesArr[indexPath.row];
    [self requestUrlPathWithModel:fileModel];
}

-(void)requestUrlPathWithModel:(NSDictionary*)model {
    
//    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSString* fileType = model[@"filetype"];
    NSString* fileName = model[@"filename"];
    
    NSDictionary* parameters = @{
                                 @"filepath":model[@"filepath"],
                                 @"filetype":fileType,
                                 @"id"      :model[@"id"],
                                 };
    
    CCityAccessoryManager* accessoryManager = [[CCityAccessoryManager alloc]init];
    
    accessoryManager.requestSucess = ^(UIViewController *vc) {
      
        if (self.pushToFileViewerVC) {
            
            self.pushToFileViewerVC(vc);
        }
    };
    
    [accessoryManager OpenFileWithUrl:@"service/form/ReadFile.ashx" parameters:parameters fileType:fileType fileName:fileName];

}

-(void)viewFileWithResponseObject:(NSDictionary*)dic name:(NSString*)fileName {
    
    NSArray* fileUrls = dic[@"urlpath"];
    
    if ([fileName containsString:@"doc"]) {
        
        CCityScrollViewVC* scrollViewVC = [[CCityScrollViewVC alloc]initWithURLs:fileUrls];
        scrollViewVC.title = fileName;
        
          if (self.pushToFileViewerVC) {  self.pushToFileViewerVC(scrollViewVC);    }
    } else {
        
        CCityOfficalFileViewerVC* viewVC = [[CCityOfficalFileViewerVC alloc]initWithUrl:fileUrls[0] title:fileName];
        
        if (self.pushToFileViewerVC) {  self.pushToFileViewerVC(viewVC);    }
    }
}

-(void)chooseImageToUpload:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goUploadFileVC:)]) {
        [self.delegate goUploadFileVC:nil];
    }
    
//    [self showImagePickController:NO];
}

//-(void)showImagePickController:(BOOL)isTaking;
//{
//    [[self getPas] showPhotoLibrary];
//}
//- (ZLPhotoActionSheet *)getPas
//{
//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//    //设置照片最大预览数
//    actionSheet.maxPreviewCount = 3;
//    //设置照片最大选择数
//    actionSheet.maxSelectCount = 3;
//    //设置允许选择的视频最大时长
//    actionSheet.allowSelectVideo = NO;
//    //设置照片cell弧度
//    actionSheet.cellCornerRadio = 5;
//    //单选模式是否显示选择按钮
//    actionSheet.showSelectBtn = NO;
//    //是否在选择图片后直接进入编辑界面
//    actionSheet.editAfterSelectThumbnailImage = NO;
//    //设置编辑比例
//    //是否在已选择照片上显示遮罩层
//    actionSheet.showSelectedMask = NO;
//#pragma required
//    //如果调用的方法没有传sender，则该属性必须提前赋值
//    actionSheet.sender = self;
//    actionSheet.arrSelectedAssets = self.lastSelectAssets;
//    
//    zl_weakify(self);
//    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
//        zl_strongify(weakSelf);
//        
////        strongSelf.imagesArr = [NSMutableArray array];
////        [strongSelf.imagesArr addObjectsFromArray:images];
////        strongSelf.lastSelectAssets = assets.mutableCopy;
//    }];
//    
//    return actionSheet;
//}
//
//#pragma mark - UIImagePickerControllerDelegate
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage * chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
////    [_answerQuesView reloadChoosedImageView:chooseImage];
////    [self.imagesArr addObject:chooseImage];
////    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//-(void)goBackViewWithImages:(NSArray *)imageArr
//{
//    self.imagesArr = [NSMutableArray arrayWithArray:imageArr];
//}
//
//-(void)deleteSelectedImageWIthIndex:(NSInteger)index
//{
//    [self.imagesArr removeObjectAtIndex:index];
//
//    [self.lastSelectAssets removeObjectAtIndex:index];
//}



@end
