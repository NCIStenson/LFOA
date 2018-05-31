//
//  CCityUploadFileVC.m
//  LFOA
//
//  Created by Stenson on 2018/5/30.
//  Copyright © 2018年  abcxdx@sina.com. All rights reserved.
//

#define kMAXNUMPHOTO 50

#import "CCityUploadFileVC.h"
#import <ZLPhotoActionSheet.h>

@interface CCityUploadFileVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView* collectionView;
}
@property (nonatomic,strong) NSMutableArray * imagesArr;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end

@implementation CCityUploadFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上传文件";
    [self.navigationController.navigationBar.layer addSublayer:[self lineLayer]];

    self.view.backgroundColor = [UIColor whiteColor];
    self.imagesArr = [NSMutableArray array];
    self.lastSelectAssets = [NSMutableArray array];
    [self initView];
}

-(CALayer*)lineLayer {
    
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = CCITY_RGB_COLOR(0, 0, 0, .3f).CGColor;
    layer.frame = CGRectMake(0, 44, self.view.bounds.size.width, .5f);
    return layer;
}

-(void)initView{
    
    UICollectionView * collectView = [self collectionView];
    [self.view addSubview:collectView];
    collectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 60);
    
    UIButton * uploadBtn = [self getBottomBtnWithTitle:@"开始上传" sel:@selector(uploadBtnClick)];
    [self.view addSubview:uploadBtn];
    uploadBtn.frame = CGRectMake(20, SCREEN_HEIGHT - NAV_HEIGHT - 50, SCREEN_WIDTH - 40, 40);

}

- (UICollectionView*)collectionView {
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing      = 5.0f;
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - 30) / 4.f, (self.view.bounds.size.width - 30)/ 4.f);
    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    return collectionView;
}

-(UIButton*)getBottomBtnWithTitle:(NSString*)title sel:(SEL)sel {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.clipsToBounds = YES;
    bottomBtn.layer.cornerRadius = 5.f;
    [bottomBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return bottomBtn;
}


#pragma mark - 上传照片

-(void)uploadBtnClick
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArr.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    UIImageView * chooseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    [chooseImageView setImage:[UIImage imageNamed:@"icon_uploadFile.png"]];
    [cell.contentView addSubview:chooseImageView];
    
    
    if (indexPath.row > 0) {
        [chooseImageView setImage:self.imagesArr[indexPath.row - 1]];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = indexPath.row + 500;
        [cell.contentView addSubview:deleteBtn];
        deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        [deleteBtn setImage:[UIImage imageNamed:@"icon_delete" ] forState:UIControlStateNormal];
        deleteBtn.center = CGPointMake(chooseImageView.right - 15,chooseImageView.top + 15);
        [deleteBtn addTarget:self action:@selector(deleteSelectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        chooseImageView.contentMode = UIViewContentModeCenter;
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showImagePickController:NO];
    }
}


/**
 *  @author Stenson, 16-08-01 16:08:07
 *
 *  选取照片
 *
 *  @param isTaking 是否拍照
 */
-(void)showImagePickController:(BOOL)isTaking;
{
    if (self.imagesArr.count == kMAXNUMPHOTO) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多上传%d张照片",kMAXNUMPHOTO]];
        [SVProgressHUD dismissWithDelay:1.5f];
        return;
    }
    [[self getPas] showPhotoLibrary];
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kMAXNUMPHOTO;
    //设置照片最大选择数
    actionSheet.maxSelectCount = kMAXNUMPHOTO;
    //设置允许选择的视频最大时长
    actionSheet.allowSelectVideo = NO;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 5;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = NO;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = NO;
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.imagesArr = [NSMutableArray array];
        [strongSelf.imagesArr addObjectsFromArray:images];
        strongSelf.lastSelectAssets = assets.mutableCopy;
        [collectionView reloadData];

    }];
    
    return actionSheet;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)deleteSelectedPhoto:(UIButton *)btn
{
    NSInteger index = btn.tag - 501;
    
    [self.imagesArr removeObjectAtIndex:index];
    [self.lastSelectAssets removeObjectAtIndex:index];
    
    [collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
