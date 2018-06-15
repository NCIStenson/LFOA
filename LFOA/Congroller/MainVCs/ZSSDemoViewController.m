//
//  ZSSDemoViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 11/29/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//
#define kMAXNUMPHOTO 1

#import "ZSSDemoViewController.h"

#import <ZLPhotoActionSheet.h>
@interface ZSSDemoViewController ()

@end

@implementation ZSSDemoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新闻内容";
    self.view.backgroundColor = [UIColor whiteColor];
    self.alwaysShowToolbar = YES;
    
    // Export HTML
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
    
    // HTML Content to set in the editor
    self.shouldShowKeyboard = NO;
    // Set the HTML contents of the editor

    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarUndo,ZSSRichTextEditorToolbarRedo,ZSSRichTextEditorToolbarBold,ZSSRichTextEditorToolbarTextColor,ZSSRichTextEditorToolbarJustifyLeft,ZSSRichTextEditorToolbarJustifyCenter,ZSSRichTextEditorToolbarJustifyRight];
    
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24, 24.0f)];
    [myButton setImage:[UIImage imageNamed:@"ZSSimageDevice"] forState:UIControlStateNormal];
    [myButton addTarget:self
                 action:@selector(didTapCustomToolbarButton:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self addCustomToolbarItemWithButton:myButton];
    
    [self setPlaceholder:@"新闻内容"];
//    [self setHTML:_htmlStr];
//    NSString * html = @"<div style=\"text-align: right;\">"
//    "<img src=\"http://img2.imgtn.bdimg.com/it/u=3588772980,2454248748&fm=27&gp=0.jpg\">"
//    "<span style=\"background-color:rgb(26,26,255)\">虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。“我觉得那差不多是一次大概10分钟左右的讨论，他（史蒂文斯）告诉我们‘继续努力工作，做这个，做那个等等’，但之后他又留下来大概一小时，回答了我所有的问题。”一位名叫Albano Thomallari的凯尔特人电竞战队成员如此说道。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。虎扑6月15日讯 美国当地时间本周一，凯尔特人训练基地沃尔瑟姆迎来了一些新面孔，那就是凯尔特人官方电子竞技战队的一些成员，他们来到沃尔瑟姆与绿衫军主教练布拉德-史蒂文斯进行了一些交谈。</span></div>\"";
//    [self setHTML:html];

}


-(void)didTapCustomToolbarButton:(UIButton *)btn
{
    NSLog(@"选择并上传");
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];

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
//    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (images.count > 0) {
            [self uploadFile:images[0]];
        }
//        zl_strongify(weakSelf);
//        strongSelf.imagesArr = [NSMutableArray array];
//        [strongSelf.imagesArr addObjectsFromArray:images];
//        strongSelf.lastSelectAssets = assets.mutableCopy;
//        [self.tableView reloadData];
    }];
    
    return actionSheet;
}

-(void)uploadFile:(UIImage *)ima
{
        AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
        NSMutableDictionary * parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[CCitySingleton sharedInstance].token}];
        [SVProgressHUD showWithStatus:@"正在上传"];
        
    [manager                        POST:@"service/news/UploadImg.ashx"
                                  parameters:parameters
                   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            UIImage *image = ima;
                           NSData *imageData = UIImagePNGRepresentation([CCUtil fixOrientation:image]);
                           [formData appendPartWithFileData:imageData name:@"myFile" fileName:[NSString stringWithFormat:@"%@.png",[CCUtil getNowTimeTimestamp3]] mimeType:@"image/png"];
                       
                   }
                                    progress:nil
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         [SVProgressHUD dismiss];
                                         if([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"status"] isEqualToString:@"failed"]){
                                             [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据错误" detail:nil];
                                         }else{
                                             NSArray * arr = responseObject[@"results"];
                                             for (int i = 0 ; i < arr.count; i++) {
                                                 NSDictionary * dic = arr[i];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self insertImage:dic[@"url"] alt:@""];
                                                     [self focusTextEditor];
                                                 });
                                             }
                                             
                                         }
//                                         dispatch_group_leave(group);
                                     }
                                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         [SVProgressHUD dismiss];
//                                         dispatch_group_leave(group);
                                         [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
                                         NSLog(@"%@",error);
                                     }];
    
    
}


- (void)exportHTML {
    
    NSLog(@"%@", [self getHTML]);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)editorDidChangeWithText:(NSString *)text andHTML:(NSString *)html {
    
    NSLog(@"Text Has Changed: %@", text);
    
    NSLog(@"HTML Has Changed: %@", html);
    
}

- (void)hashtagRecognizedWithWord:(NSString *)word {
    
    NSLog(@"Hashtag has been recognized: %@", word);
    
}

- (void)mentionRecognizedWithWord:(NSString *)word {
    
    NSLog(@"Mention has been recognized: %@", word);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
