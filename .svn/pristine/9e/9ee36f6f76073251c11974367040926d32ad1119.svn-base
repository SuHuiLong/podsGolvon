//
//  AddSelfPhotosViewController.m
//  Golvon
//
//  Created by shiyingdong on 16/4/12.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "AddSelfPhotosViewController.h"
#import "AddSelfPhotoTableViewCell.h"
#import "ImageTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DownLoadDataSource.h"
#import "MBProgressHUD.h"
#import "CLCropImageViewController.h"


@interface AddSelfPhotosViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,clCropImageViewControllerDlegate,MBProgressHUDDelegate>{
    
    UITableView *_mainTableView;
    UITextView *_DescTextView;
    UILabel *_CellLabel;
    MBProgressHUD *_HUB;
}

@property(nonatomic,copy)NSMutableArray *PhotoArr;
@property(nonatomic,copy)NSMutableArray *DescArr;
@property(nonatomic,assign)NSInteger PhotoNum;
@property(nonatomic,assign)NSInteger SentPhotoNum;


@end

@implementation AddSelfPhotosViewController



-(NSMutableArray *)DescArr{
    if (_DescArr == nil) {
        _DescArr = [NSMutableArray array];
    }
    return _DescArr;
}

-(NSMutableArray *)PhotoArr{
    if (_PhotoArr == nil) {
        _PhotoArr = [NSMutableArray array];
    }
    return _PhotoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createNaviTitle];
    [self initData];
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    [viewControllers removeObjectAtIndex:viewControllers.count-2];
    self.navigationController.viewControllers = viewControllers;
}

-(void)initData{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DescFri"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DescSec"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DescThr"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DescFou"];

}

#pragma mark -创建上导航

-(void)createNaviTitle{
    UIImageView *NaviTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    NaviTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:NaviTitleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, ScreenWidth, 30)];
    titleLabel.text = @"添加图片";
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    UIButton *NaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NaviBtn.frame = CGRectMake(0, 20, 44, 44);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [NaviBtn addSubview:backImage];
    [NaviBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NaviBtn];

    
    UIButton *SaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-50, 32, 35, 25)];
    [SaveBtn addTarget:self action:@selector(SavePhoto) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    SaveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];

    [SaveBtn setTitleColor:GPColor(11, 177, 172) forState:UIControlStateNormal];
    [self.view addSubview:SaveBtn];
    
}

#pragma mark - 提交更改

-(void)SavePhoto{
    NSUserDefaults *userDict = [NSUserDefaults standardUserDefaults];
    NSString *Fri= [userDict objectForKey:@"DescFri"];
    NSString *Sec= [userDict objectForKey:@"DescSec"];
    NSString *Thr= [userDict objectForKey:@"DescThr"];
    NSString *Fou= [userDict objectForKey:@"DescFou"];
    _PhotoNum = 1;
    _SentPhotoNum = 0;
    NSInteger photoNum = _PhotoArr.count;
    
    
    self.DescArr = [[NSMutableArray alloc] initWithObjects:Fri,Sec,Thr,Fou,nil];
    if (self.PhotoArr.count==0) {
         dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片后重试" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        _HUB.hidden = YES;
        _HUB = nil;

        return;
    }
    

    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.delegate = self;
    _HUB.labelText = @"图片上传中";
    
    NSMutableArray *PhotoPostArry = [NSMutableArray array];
    for (NSInteger i = 0; i<self.PhotoArr.count; i++) {
        NSString *photo = [self.PhotoArr[i] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
       
        [PhotoPostArry addObject:photo];
    }
    _HUB.labelText = [NSString stringWithFormat:@"第1/%lu张图片上传中",(unsigned long)self.PhotoArr.count];
    for (int i = 0; i<self.PhotoArr.count; i++) {
        
        NSData *headImageData = self.PhotoArr[i];
        NSString* encoderStr = [headImageData base64EncodedStringWithOptions:0];
        headImageData= [encoderStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *photo = [[ NSString alloc] initWithData:headImageData encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *dict = @{
                               @"photo":photo,
                               @"phone":[userDefaults objectForKey:@"phone"],
                               };
        NSString *PhotoDesc = _DescArr[i];
        DownLoadDataSource *SourceManager = [[DownLoadDataSource alloc] init];
        
        NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
        [nsdf2 setDateStyle:NSDateFormatterShortStyle];
        [nsdf2 setDateFormat:@"YYYYMMDDHHmmssSSSS"];
        NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
        long curr=[t2 longLongValue];
        NSLog(@"开始时间%ld",curr);
        NSString *url = urlHeader120;
//        @"http://120.26.122.102:80/";
        [SourceManager downloadWithUrl:[NSString stringWithFormat:@"%@GolvonImage/receive_picture",url]parameters:dict complicate:^(BOOL success, id data) {
            if (success) {
                NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
                [nsdf2 setDateStyle:NSDateFormatterShortStyle];
                [nsdf2 setDateFormat:@"YYYYMMDDHHmmssSSSS"];
                NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
                long curr=[t2 longLongValue];

                NSLog(@"结束时间%ld",curr);
                _PhotoNum++;

                if (_PhotoNum == self.PhotoArr.count+1) {
                    _HUB.hidden = YES;
                    _HUB = nil;
                    
                    _DescArr = [NSMutableArray array];
                    _DescTextView.text = [NSString string];
                    _PhotoArr = [NSMutableArray array];
                    [_mainTableView reloadData];
                }else{
                }

                NSString *PhotoUrl = [data objectForKey:@"url"];
                
                NSDictionary *urlDict = @{
                                          @"picture_url":PhotoUrl,
                                          @"picture_name":PhotoDesc,
                                          @"name_id":userDefaultId,
                                          @"picture_state":@"0",
                                          @"picture_grouping":@"默认"
                                          };
                DownLoadDataSource *imageManager = [[DownLoadDataSource alloc] init];
                [imageManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_picture",urlHeader120 ] parameters:urlDict complicate:^(BOOL success, id data) {
                    if (success) {
                        _SentPhotoNum ++;
                        if (_SentPhotoNum==photoNum) {


                        }else{
                            _HUB.labelText = [NSString stringWithFormat:@"第%ld/%lu张图片上传中",(long)_SentPhotoNum,(unsigned long)self.PhotoArr.count];                        }
                        
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
            _HUB.hidden = YES;
            _HUB = nil;
//
//             dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                
//                [self presentViewController:alertController animated:YES completion:nil];
//            });
                SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: @"网络错误"];
                [self.view addSubview:sView];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    sView.hidden = YES;
                });
            }
        }];
    }
}

/**
 *  pop跳转
 *
 *  @param sender <#sender description#>
 */
-(void)popBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  创建tableView
 */
-(void)createTableView{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-44)];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor colorWithRed:244/256.0  green:245/256.0  blue:246/256.0  alpha:1.0f];
    tableview.separatorStyle = NO;
    _mainTableView = tableview;
    [self.view addSubview:tableview];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = YES;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
/**
 *  点击空白隐藏键盘
 */
-(void)hideKeyBoard
{
    [_DescTextView endEditing:YES];
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HScale(19.8);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.PhotoArr.count<4) {
        return self.PhotoArr.count+1;
    }else{
        return self.PhotoArr.count;
    }
}
#pragma mark - tableviewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"AddSelfPhotoTableViewCell";
    
    AddSelfPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddSelfPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    cell.backgroundColor = [UIColor colorWithRed:244/256.0  green:245/256.0  blue:246/256.0  alpha:1.0f];
    if ((indexPath.row == self.PhotoArr.count)&&(!(indexPath.row == 4))) {
        cell.UserImageView.image = [UIImage imageNamed:@"UploadPhoto"];
    }else{
        cell.UserImageView.image = [UIImage imageWithData:self.PhotoArr[indexPath.row]];
    }
    if (indexPath.row == self.PhotoArr.count ){
        UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddPhoto)];
        cell.UserImageView.userInteractionEnabled = YES;
        [cell.UserImageView addGestureRecognizer:tpg];
    }else{
        cell.UserImageView.userInteractionEnabled = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消cell的高亮状态
    cell.PalaceLabel.text = @"请用一句话描述这张图片(40字以内)";
    cell.PalaceLabel.numberOfLines = 0;
    _CellLabel = cell.PalaceLabel;
    _CellLabel.tag = 100+indexPath.row;
    cell.DescLabel.delegate = self;
    _DescTextView = cell.DescLabel;
    _DescTextView.delegate = self;
    _DescTextView.tag = indexPath.row;
    return cell;
}
#pragma mark - 左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.PhotoArr.count) {
        return FALSE;
    }else{
        return TRUE;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.PhotoArr removeObjectAtIndex:indexPath.row];
        [_mainTableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        
    }
}

-(void)textViewDidChange:(UITextView *)textView{

    
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
    int a = 40 - [len intValue];
    if (a<=0) {
        NSString *str = textView.text;
        textView.text = [str substringToIndex:39];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"图片描述最多40字" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });

    }else{
    }
}






#pragma mark - 滑动tableView隐藏键盘
-(void)scrollViewDidScroll:(UITableView *)tableview{
    if (tableview == _mainTableView) {
        [_DescTextView resignFirstResponder];
    }
    
    
}


#pragma mark - 点击return隐藏键盘

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=40) {
        return NO;
    }else{
        return YES;
    }
}


//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }else if (range.location>39) {
//        return NO;
//    }else{
//        return YES;
//    }
//}
/**
 *  获取图片描述`
 *
 *  @param textView cell的textView
 */
-(void)textViewDidChangeSelection:(UITextView *)textView{
    UILabel *find_label = (UILabel *)[self.view viewWithTag:100+textView.tag];
    find_label.hidden = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str1 = [[NSString alloc] initWithString:[user objectForKey:@"DescFri"]];
    NSString *str2 = [[NSString alloc] initWithString:[user objectForKey:@"DescSec"]];
    NSString *str3 = [[NSString alloc] initWithString:[user objectForKey:@"DescThr"]];
    NSString *str4 = [[NSString alloc] initWithString:[user objectForKey:@"DescFou"]];

    switch (textView.tag) {
        case 0:
            str1 = [NSString stringWithFormat:@"%@",textView.text];
            break;
        case 1:
            str2 = textView.text;
            break;
        case 2:
            str3 = textView.text;
            break;
        case 3:
            str4 = textView.text;
            break;
            
        default:
            break;
    }
    NSLog(@"1--%@2--%@3--%@4--%@",str1,str2,str3,str4);
    [[NSUserDefaults standardUserDefaults] setValue:str1 forKey:@"DescFri"];
    [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:@"DescSec"];
    [[NSUserDefaults standardUserDefaults] setValue:str3 forKey:@"DescThr"];
    [[NSUserDefaults standardUserDefaults] setValue:str4 forKey:@"DescFou"];
    
}


/**i
 *  选择图片
 */
-(void)AddPhoto{
    [_DescTextView resignFirstResponder];
    [self UploadPhoto];
    
}

/**
 *  制定上传方式选择框
 */
-(void)UploadPhoto{
    UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:@"图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    sheetView.tag = 4444;
    sheetView.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheetView showInView:self.view];
}

/**
 *  选择上传方式
 *
 *  @param actionSheet
 *  @param buttonIndex 0:相册 1:摄像头
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
            }else {
                NSLog(@"不支持 拍照 功能");
            }
            break;
        case 1:
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }else {
                NSLog(@"不支持 相册 功能");
            }
            break;
            
        default:
            break;
    }
    
}
/**
 *  选择图片
 *
 *  @param type <#type description#>
 */
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
    UIImage *headImage = [[UIImage alloc] init];
    if (image.size.width == image.size.height) {
        headImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(1242, 1242) sizeOfImage:image];
    }else{
        CGFloat centerWith = 0;
        CGFloat imageWith =image.size.width;
        CGFloat imageHeight =image.size.height;

        
        if (imageHeight<imageWith) {
            
            centerWith = imageHeight;
            
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],CGRectMake((imageWith-imageHeight)/2, 0, centerWith, centerWith));
            
            UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
        
            headImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(1242, 1242) sizeOfImage:elementImage];
            
        } else {
            
            centerWith = imageWith;
            
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],CGRectMake(0, (imageHeight-imageWith)/2, centerWith, centerWith));
            
            UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
            headImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(1242, 1242) sizeOfImage:elementImage];

        }
        
//        headImage = [[ImageTool shareTool] reCenterSizeImage:CenterImage toSize:CGSizeMake(621,621)];
    }

    
    NSData *iamgeData = UIImageJPEGRepresentation(headImage,0.8);
    if (!iamgeData) {
        iamgeData = UIImagePNGRepresentation(headImage);
    }
    
    NSLog(@"%u",iamgeData.length/1024);
     /**
     *  向服务器发送图片
     */

    //图片转成bate64;
//    NSData *headImageData = UIImageJPEGRepresentation(image, 0.1);
    
    [self.PhotoArr addObject:iamgeData];

        /**
         *  发送修改图片的通知
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadPhotoArry" object:self.PhotoArr];

        [_mainTableView reloadData];
        
        NSLog(@"%@",image);
        [picker dismissViewControllerAnimated:YES completion:nil];

 
    
}



- (void)clCropImageViewController:(CLCropImageViewController *)cropImageViewController didFinish:(UIImage *)image
{
    NSData *iamgeData = UIImageJPEGRepresentation(image,0.8);
    if (!iamgeData) {
        iamgeData = UIImagePNGRepresentation(image);
    }
    NSLog(@"%u",iamgeData.length/1024);
    [self.PhotoArr addObject:iamgeData];
    
    /**
     *  发送修改图片的通知
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadPhotoArry" object:self.PhotoArr];

    
    [cropImageViewController dismissViewControllerAnimated:YES completion:NULL];
    [_mainTableView reloadData];

}
- (void)clCropImageViewControllerDidCancel:(CLCropImageViewController *)cropImageViewController
{
    
    [cropImageViewController dismissViewControllerAnimated:YES completion:NULL];
    
    
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
