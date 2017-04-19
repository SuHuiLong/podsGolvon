//
//  JZAlbumViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/27.
//  Copyright (c) 2015年 suhuilong. All rights reserved.
//

#import "JZAlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PhotoView.h"
#import "UILabel+StringFrame.h"
#import "NewSelf_ViewController.h"

#define screen_height [UIScreen mainScreen].bounds.size.height
#define screen_width [UIScreen mainScreen].bounds.size.width


@interface JZAlbumViewController ()<UIScrollViewDelegate,PhotoViewDelegate>
{
    CGFloat lastScale;
    MBProgressHUD *HUD;
    NSMutableArray *_subViewList;
    UIButton *SetBtn;
    UIButton *DownBtn;
    UIButton *DeletBtn;
    UILabel *Navilabel;
    NSInteger _imageNum;
    int iii ;
    NSInteger _currentPostion;
    
    UIImageView *_testSImageView;

}

@end

@implementation JZAlbumViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        _subViewList = [[NSMutableArray alloc] init];
    }
    return self;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    lastScale = 1.0;
    self.view.backgroundColor = [UIColor blackColor];
    

    [self initScrollView];
    [self addLabels];
    [self createBottom];
    [self setPicCurrentIndex:self.currentIndex];
    [self createNaViTitle];
    [self dataScrollView];
    
}
/**
 *  创建title视图
 */
-(void)createNaViTitle{
    UIImageView *naviTilte = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    naviTilte.image = [UIImage imageNamed:@"photoBrownUp"];
    Navilabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screen_width, 20)];
    if (self.dateArr.count>0) {
        Navilabel.text = [NSString stringWithFormat:@"%@",self.dateArr[self.currentIndex]];
    }
    Navilabel.font = [UIFont systemFontOfSize:13.f];
    Navilabel.textAlignment = NSTextAlignmentCenter;
    Navilabel.textColor = [UIColor whiteColor];
    
    UIButton *DissMissBtn = [[UIButton alloc] init];
    [DissMissBtn addTarget:self action:@selector(DissMissView) forControlEvents:UIControlEventTouchUpInside];

    
    
    DissMissBtn.frame = CGRectMake(0, 20, 44, 44);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [DissMissBtn addSubview:backImage];
    
    
    
    
    
    UILabel *fanhui = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 40, 15)];
    fanhui.text = @"返回";
    fanhui.font = [UIFont systemFontOfSize:13.f];
    fanhui.textColor = [UIColor whiteColor];
//    [DissMissBtn addSubview:fanhui];
    
    [self.view addSubview:Navilabel];
    [self.view addSubview:DissMissBtn];
    [self.view addSubview:naviTilte];
}

-(void)DissMissView{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view insertSubview:self.scrollView atIndex:0];
    [self dataScrollView];
}

-(void)dataScrollView{
    
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    //设置放大缩小的最大，最小倍数
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height);

    for (int i = 0; i < self.imgArr.count; i++) {
        [_subViewList addObject:[NSNull class]];
    }

}
/**
 *  创建底部视图
 */
-(void)createBottom{
    
    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,HScale(94), screen_width, 40)];
//    bottomImage.image = [UIImage imageNamed:@"photoBrownDown"];

    [self.view addSubview:bottomImage];
#pragma mark -设为封面
//    SetBtn = [[UIButton alloc] initWithFrame:CGRectMake(WScale(4.5), HScale(95.8), WScale(4.5), HScale(2.5))];
//    SetBtn.hidden = NO;
//    SetBtn = [[UIButton alloc] initWithFrame:CGRectMake(WScale(4.5), HScale(95.8), WScale(21.4), HScale(3))];
//    SetBtn.backgroundColor = [UIColor clearColor];
//    [SetBtn addTarget:self action:@selector(setSelfBackImage) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScale(4.5), HScale(2.5))];
//    
//    [imageView setImage:[UIImage imageNamed:@"SetHomePage"]];
//    
//    [SetBtn addSubview:imageView];
//    
//    UILabel *SetLabel = [[UILabel alloc] initWithFrame:CGRectMake(WScale(5.5), HScale(0), WScale(16.9), HScale(3))];
//    SetLabel.text = @"设为封面";
//    SetLabel.font = [UIFont systemFontOfSize:13.f];
//    SetLabel.textColor = [UIColor whiteColor];
//    SetLabel.backgroundColor = [UIColor clearColor];
//    [SetBtn addSubview:SetLabel];
    
//    [self.view addSubview:SetBtn];
    
#pragma mark - 下载
//    DownBtn = [[UIButton alloc] initWithFrame:CGRectMake(WScale(28.4)+WScale(4.5), HScale(95.8), WScale(4), HScale(2.5))];
    
    DownBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HScale(93), WScale(15), HScale(6))];

    
    DownBtn.backgroundColor = [UIColor clearColor];
    
    
    
    [DownBtn addTarget:self action:@selector(DownSelfImage) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownSelfImage"]];
    
    downView.frame = CGRectMake(WScale(5), HScale(2.8), WScale(4), HScale(2.5));
    [DownBtn addSubview:downView];
    
//    [DownBtn setImage:[UIImage imageNamed:@"DownSelfImage"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:DownBtn];
#pragma mark - 删除
    DeletBtn = [[UIButton alloc] initWithFrame:CGRectMake(WScale(85), HScale(93), WScale(13), HScale(6))];
    
//    CGRectMake(WScale(91.7), HScale(95.8), WScale(4.5), HScale(2.5))
    DeletBtn.userInteractionEnabled = YES;
    [DeletBtn addTarget:self action:@selector(DeletSelfImage) forControlEvents:UIControlEventTouchUpInside];
   
    UIImageView *deletView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(6.7),HScale(2.8), WScale(4.5), HScale(2.5))];
    deletView.image = [UIImage imageNamed:@"DeleteSelfImage"];
    [DeletBtn addSubview:deletView];
    
    
    [DeletBtn setBackgroundColor:[UIColor clearColor]];
    if ([self.nameId isEqualToString:userDefaultId]) {
        [self.view addSubview:DeletBtn];
    }
    
}

//-(void)SetSelfImage:(id)sender{
//     dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的用户，为了保持“打球去”社区的高尔夫特质和纯粹性，我们将对您最新上传的头像进行审核，审核通过后，我们将在第一时间通过系统消息通知您。" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self setSelfBackImage];
//                }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//                [self presentViewController:alertController animated:YES completion:nil];
//            });
//
//}

//-(void)setSelfBackImage{
//    DownLoadDataSource *PhotoManager = [[DownLoadDataSource alloc] init];
//    NSDictionary *dict = @{
//                           @"picture_id":self.imgId[_currentIndex],
//                           @"name_id":userDefaultId,
//                           @"picture_state":@"1"
//                           };
//    [PhotoManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/updata_picture_user_state",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
//        if (success) {
//            
//            [userDefaults setValue:self.imgId[_currentIndex] forKey:@"pictureid"];
//            dispatch_async(dispatch_get_main_queue(), ^{
////                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
////                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
////                }]];
//                
////                [self presentViewController:alertController animated:YES completion:nil];
//            });
//            
////            [self dismissViewControllerAnimated:NO completion:nil];
//        }
//    }];
//
//}



-(void)DownSelfImage{
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgArr[_currentIndex]]]], self,  @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

-(void)DeletSelfImage{
    
    DeletBtn.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该图片" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self sureDeleat];
        
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DeletBtn.userInteractionEnabled = YES;

        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)sureDeleat{
    
    NSLog(@"删除前%f",self.scrollView.contentSize.width);
    NSString *userPhotoId = [userDefaults objectForKey:@"pic_id"];
    NSString *deletPhotoId = self.imgId[_currentIndex];
    if ([userPhotoId isEqualToString:deletPhotoId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请更新头像后再删除此照片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        DeletBtn.userInteractionEnabled = YES;

        return;

    }else if (self.imgArr.count == 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请至少保留一张照片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        DeletBtn.userInteractionEnabled = YES;
        
        return;
        
    }else{
    
    DownLoadDataSource *PhotoManager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"picture_url":self.imgArr[_currentIndex]
    };
        NSString *url120 = urlHeader120;
//        @"http://120.26.122.102:80/";
        
    [PhotoManager downloadWithUrl:[NSString stringWithFormat:@"%@GolvonImage/delete_picture",url120] parameters:dict complicate:^(BOOL success, id data) {
        DeletBtn.userInteractionEnabled = YES;

        if (success) {

            iii = 3;
            DownLoadDataSource *GolvonManager = [[DownLoadDataSource alloc] init];
 
            NSDictionary *GolvonDic = @{
                                        @"picture_id":deletPhotoId,
                                        @"name_id":userDefaultId
                                            };
            [GolvonManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/delete_picture",urlHeader120] parameters:GolvonDic complicate:^(BOOL success, id data) {
                if (success) {
                    _imageNum = 1000;
                    [self.scrollView removeFromSuperview];
                    [_imgArr removeObjectAtIndex:_currentIndex];
                    [_dateArr removeObjectAtIndex:_currentIndex];
                    [_descArr removeObjectAtIndex:_currentIndex];
                    [_imgId removeObjectAtIndex:_currentIndex];
                    [self initScrollView];
                    if (_currentIndex == _imgArr.count) {
                        [self setPicCurrentIndex:_currentIndex -1];
                    }else{
                        [self setPicCurrentIndex:_currentIndex];
                    }
                    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",(int)self.currentIndex+1,(unsigned long)self.imgArr.count];
                    
                    
                }
            }];
        }
    }];
    }
     
}
#pragma mark - 保存至相册

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
        dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });

    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });

    }
    NSLog(@"message is %@",message);
}
/**
 *  创建label
 */
-(void)addLabels{
    
    UIImageView *backImageView = [[UIImageView alloc] init];
//                                  WithFrame:CGRectMake(0, HScale(76.2), ScreenWidth, HScale(23.8))];
    backImageView.backgroundColor = [UIColor blackColor];
    backImageView.alpha = 0.5f;
    [self.view addSubview:backImageView];
    
    self.descLabel = [UILabel new];
    self.descLabel.numberOfLines = 5;
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.descLabel.textColor = [UIColor whiteColor];
    if (self.descArr.count>0) {
        self.descLabel.text = [NSString stringWithFormat:@"%@",self.descArr[self.currentIndex]];

    }
    
    self.descLabel.font = [UIFont systemFontOfSize:13.0];
    CGSize size = [_descLabel boundingRectWithSize:CGSizeMake(WScale(90.1), 0)];
    self.descLabel.frame = CGRectMake(WScale(4.999), HScale(80), size.width, size.height);

    
    [self.view addSubview:self.descLabel];
    
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 55, screen_height-30-49, 60, 30)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",(int)self.currentIndex+1,(unsigned long)self.imgArr.count];
    backImageView.frame = _descLabel.frame;
    [self.view addSubview:self.sliderLabel];
}




-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    NSLog(@"%ld",(long)currentIndex);
    self.scrollView.contentOffset = CGPointMake(screen_width*currentIndex, 0);
        NSLog(@"%lu,%ld",(unsigned long)self.imgArr.count,(long)index);
    [self loadPhote:_currentIndex];
    [self loadPhote:_currentIndex+1];
    [self loadPhote:_currentIndex-1];
}

-(void)loadPhote:(NSInteger)index{
    NSLog(@"%lu,%ld",(unsigned long)self.imgArr.count,(long)index);
    _currentIndex = index;
    if (index<0 || index >=self.imgArr.count) {
        return;
    }
    id currentPhotoView = [_subViewList objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        //url数组
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imgArr objectAtIndex:index] PhotoDesc:[self.descArr objectAtIndex:index]];
        photoV.tag = index;

        //        if (iii>2) {
        if ([self.scrollView.subviews count] >1) {
            for(int i = 0;i<=[self.scrollView.subviews count] - 1;i++){
                [[ self.scrollView.subviews objectAtIndex:i] removeFromSuperview];
            }
        }
//        if (index>0) {
        
        _testSImageView = [UIImageView new];
        _testSImageView.frame = photoV.frame;
        [_testSImageView addSubview:photoV];
        if (index==0) {
            [self.scrollView insertSubview:_testSImageView atIndex:0];
            _testSImageView.hidden = YES;
        }else{
            [self.scrollView insertSubview:photoV atIndex:0];
        }

        
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
    }else{
        if (_imageNum) {
            
            CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imgArr objectAtIndex:index] PhotoDesc:[self.descArr objectAtIndex:index]];
            
            photoV.delegate = self;
            if ([self.scrollView.subviews count]>1) {
                
            for(int i = 0;i<=[self.scrollView.subviews count] - 1;i++){
                [[ self.scrollView.subviews objectAtIndex:i] removeFromSuperview];
            }
                
                
            }

            
                [self.scrollView insertSubview:photoV atIndex:0];

            [_subViewList replaceObjectAtIndex:index withObject:photoV];
            _imageNum = 0;
        } else {
            PhotoView *photoV = (PhotoView *)currentPhotoView;
        }
        
    }
    _imageNum = _imgArr.count;
    self.descLabel.text = [NSString stringWithFormat:@"%@",self.descArr[index]];
    
    NSString *userPhotoId = [userDefaults objectForKey:@"pic_id"];
    NSString *deletPhotoId = self.imgId[_currentIndex];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.x;
    if (currentPostion - _currentPostion > 25) {
        _currentPostion = currentPostion;
        NSLog(@"ScrollUp now");
    }
    else if (_currentPostion - currentPostion > 25)
    {
        _testSImageView.hidden = YES;

        _currentPostion = currentPostion;
        iii = 0;
        NSLog(@"ScrollDown now");
    }
}



#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)OnTapView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height*lastScale);
    NSLog(@"scale:%f   lastScale:%f",scale,lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    int i = scrollView.contentOffset.x/screen_width+1;
    if (i<1) {
        return;
    }
    [self loadPhote:i-1];
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",i,(unsigned long)self.imgArr.count];
    NSString *descStr = [NSString stringWithFormat:@"%@",self.descArr[i-1]];
    self.descLabel.text = @"";
    if (descStr) {
        self.descLabel.text = descStr;
    }
    self.descLabel.font = [UIFont systemFontOfSize:13.0];
    CGSize size = [_descLabel boundingRectWithSize:CGSizeMake(WScale(90.1), 0)];
    self.descLabel.frame = CGRectMake(WScale(4.999), HScale(78.3), size.width, size.height);
    
    Navilabel.text = self.dateArr[i-1];
    
}

- (BOOL)shouldAutorotate{
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
