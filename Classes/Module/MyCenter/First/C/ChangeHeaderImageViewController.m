//
//  ChangeHeaderImageViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/7/12.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "ChangeHeaderImageViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageTool.h"
#import "DownLoadDataSource.h"
#import "NewSelf_ViewController.h"
@interface ChangeHeaderImageViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) MBProgressHUD   *HUD;

@property (copy, nonatomic) NSString    *covPid;

@end

@implementation ChangeHeaderImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)createUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHiddenGroundView)];
    [self.view addGestureRecognizer:tap];
    
    _headerPicture = [[UIImageView alloc]initWithImage:_avatarView.image];
    _headerPicture.frame = [_avatarView.superview convertRect:_avatarView.frame toView:self.view];
    if (_controlID == 1) {
        
        [_headerPicture sd_setImageWithURL:[NSURL URLWithString:_pictureUrl] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
        
    }else{
        [_headerPicture sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    }
    
    _headerPicture.contentMode = UIViewContentModeScaleAspectFit;
    _headerPicture.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressLongImage:)];
    [_headerPicture addGestureRecognizer:longpress];
    [self.view addSubview:_headerPicture];
    if (_controlID == 1) {
        
    }else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((ScreenWidth - WScale(26.7))/2, HScale(82.6), WScale(26.7), HScale(4.5));
        
        [button setTitle:@"更换头像" forState:UIControlStateNormal];
        button.titleLabel.textColor = WhiteColor;
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 3.0f;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        _headerPicture.frame = CGRectMake(0, (ScreenHeight - ScreenWidth) /2, ScreenWidth, ScreenWidth);
    }];
}

-(void)clickToHiddenGroundView{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark ---- 点击更换按钮
-(void)clickToChangeHeaderView{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.tag = 1000;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
#pragma mark ---- 长按保存
-(void)pressLongImage:(UILongPressGestureRecognizer *)longPress{
    //    UIButton *btn = (UIButton *)longPress.view;
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil, nil];
        actionSheet.tag = 1001;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001) {
        
        switch (buttonIndex) {
            case 0:
                
                UIImageWriteToSavedPhotosAlbum(self.headerPicture.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
                }else {
                    //                    NSLog(@"不支持 拍照 功能");
                }
                break;
            case 1:
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                }else {
                    //                    NSLog(@"不支持 相册 功能");
                }
                break;
                
            default:
                break;
        }
    }
}

-(void)clickBtn{
    /**
     编辑按钮/弹框选择
     */
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的用户，为了保持“打球去”社区的高尔夫特质和纯粹性，我们将对您最新上传的头像进行审核，审核通过后，我们将在第一时间通过系统消息通知您。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickToChangeHeaderView];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)loadImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    //
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
/**
 *  获取并裁剪图片
 *
 *  @param picker
 *  @param info   图片数据
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth  = image.size.width;
    CGFloat scale = imageHeight/imageWidth;     //裁剪比例
    UIImage *resizedImage;      //裁剪之后的图
    if (scale<1) {
        if (imageWidth > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600, 600*scale)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
        }
    }
    if (scale>1) {
        if (imageHeight > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600/scale, 600)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
            
        }
    }
    if (scale == 1) {
        if (imageHeight > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600, 600)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
            
        }
    }
    

    NSString *path = [NSString stringWithFormat:@"%@upload.php",apiHeader120];
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"type":@"0"
                                 };
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"text/plain",
                                                         @"multipart/form-data",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(resizedImage, 1.0f);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        [weakself.headerPicture setImage:resizedImage];
        NSError *error = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSString *code = data[@"code"];
        if ([code isEqualToString:@"1"]) {
            
            weakself.pictureid = data[@"pid"][0];
            weakself.pictureUrl = data[@"url"][0];
            
            [userDefaults setValue:self.pictureid forKey:@"pic_id"];
            [userDefaults setObject:self.pictureUrl forKey:@"pic"];
            
            [weakself changeHeaderImage];
            
        }else{
            [self alertShowView:@"上传失败"];
        }
        
        [weakself dismissViewControllerAnimated:YES completion:NULL];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        
        [self alertShowView:@"上传失败"];

    }];
}
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)changeHeaderImage{
    
    NSDictionary *parameter = @{@"name_id" : userDefaultId,
                                @"avatorpid" : _pictureid};
    
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=changephoto",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        
        if (success) {
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"0"]) {
                
            }else{
//                NSLog(@"失败");
            }
        }
    }];
}

#pragma mark ---- 保存在本地
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        [self clickToHiddenGroundView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",  nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
}


@end
