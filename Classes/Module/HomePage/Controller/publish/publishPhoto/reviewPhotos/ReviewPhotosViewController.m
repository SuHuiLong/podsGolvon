//
//  ReviewPhotosViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ReviewPhotosViewController.h"
#import "ReviewPhotoBrownView.h"
#import "TotalPhotoModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageTool.h"


@interface ReviewPhotosViewController ()<UIScrollViewDelegate>{
//    UIScrollView *_scrollView;
    NSInteger _index;
}
@property(nonatomic,strong)UIScrollView  *scrollView;
@property(nonatomic,strong)NSMutableArray  *createArry;


@end

@implementation ReviewPhotosViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;    
}


- (void)viewDidLoad {
    self.view.backgroundColor = BlackColor;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.selectIndexBlock !=nil) {
        self.selectIndexBlock(self.selectDataArray);
    }
}

-(void)initViewData{
    _createArry = [NSMutableArray array];

}

#pragma mark - 创建view
-(void)createView{
    [self createScrollView];
    [self createNavigationBar];
    [self createBottomBar];
}
//创建scrollview
-(void)createScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight+20)];
    scrollView.backgroundColor = BlackColor;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.contentSize = CGSizeMake(ScreenWidth*_dataArray.count, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    self.scrollView.delegate = self;
    //设置是否可以进行画面切换
    
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_currenIndex];
    NSString *index2 = [NSString stringWithFormat:@"%ld",(long)_currenIndex-1];
    NSString *index3 = [NSString stringWithFormat:@"%ld",(long)_currenIndex+1];
    self.scrollView.pagingEnabled = YES;
    [self setupPage:_currenIndex];
    [_createArry addObject:index];
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*(_currenIndex), 0) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_currenIndex>1) {
                [self setupPage:_currenIndex-1];
                [_createArry addObject:index2];

            }
            if (_currenIndex<_dataArray.count-1) {
                [self setupPage:_currenIndex+1];
                [_createArry addObject:index3];

            }
    });
    
}


//创建上导航
-(void)createNavigationBar{
    UIView *vc = [Factory createViewWithBackgroundColor:GPColor(70, 70, 70) frame:CGRectMake(0, 0, ScreenWidth, 64)];
    vc.alpha = 0.5;

    UIImageView *selectView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(35), kHvertical(30), kWvertical(23), kWvertical(23)) Image:[UIImage imageNamed:@"PublishAlbumsNormal"]];
    selectView.tag = 101;
    
    
    UIButton *selectButton = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(60), 0, kWvertical(60), 64) NormalImage:@"" SelectedImage:@"" target:self selector:@selector(imageSlect:)];
    selectButton.backgroundColor = ClearColor;
    selectButton.tag = 102;
    
    UIView *backArrowBakGrougd = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, WScale(15), 64)];
    backArrowBakGrougd.userInteractionEnabled = YES;
    
    UIImageView *backArrow = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(33), kWvertical(11), kHvertical(19)) Image:[UIImage imageNamed:@"WhiteBack"]];

    
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick:)];
    
    [backArrowBakGrougd addGestureRecognizer:tgp];
    
    for (TotalPhotoModel *model in _selectDataArray) {
        if ([model isEqual:_dataArray[_currenIndex]]) {
            selectButton.selected = YES;
            [selectView setImage:[UIImage imageNamed:@"PublishAlbumsSelect"]];
            break;
        }else{
            selectButton.selected = NO;
            [selectView setImage:[UIImage imageNamed:@"PublishAlbumsNormal"]];
        }
    }

    if ([_logInController isEqualToString:@"PublishPhotoViewController"]) {
    }else{
        [self.view addSubview:vc];
        [self.view addSubview:backArrowBakGrougd];
        [self.view addSubview:backArrow];
        [self.view addSubview:selectView];
        [self.view addSubview:selectButton];

    }
    
    
}

//创建下导航
-(void)createBottomBar{
    //底部View
    UIView *bottom = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight - kHvertical(45), ScreenWidth, kHvertical(45))];
    //底部确认按钮
    NSString *SelectNum = [NSString stringWithFormat:@"确定 (%ld)",(long)_selectDataArray.count];
    UIButton *DoneButton = [Factory createButtonWithFrame:CGRectMake( ScreenWidth - kWvertical(81), kHvertical(9), kWvertical(70), kHvertical(28))titleFont:14.0f textColor:WhiteColor backgroundColor:GPColor(110, 184, 184) target:self selector:@selector(doneClick:) Title:SelectNum];
    if ([SelectNum integerValue]>0) {
        [DoneButton setBackgroundColor:RGBA(32,190,189,1)];
    }
    
    DoneButton.tag = 106;
    
    
    NSString *textStr = [NSString stringWithFormat:@"%ld/%ld",_currenIndex+1,_dataArray.count];
    UILabel *indexLabel = [Factory createLabelWithFrame:CGRectMake(0, ScreenHeight - kHvertical(34), ScreenWidth, kHvertical(22)) textColor:WhiteColor fontSize:kHorizontal(16.0f) Title:textStr];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.tag = 107;
    if ([_logInController isEqualToString:@"PublishPhotoViewController"]) {
        [self.view addSubview:indexLabel];
    }else{
        [self.view addSubview:bottom];
        [bottom addSubview:DoneButton];
    }
}

//创建指定的页面
- (void)setupPage:(NSInteger )sender
{
    ReviewPhotoBrownView *pImageView = [[ReviewPhotoBrownView alloc] initWithFrame:CGRectMake(ScreenWidth*sender, 0, ScreenWidth, ScreenHeight)];
    [pImageView.singleTap addTarget:self action:@selector(sendClick:)];
    NSString *str = [NSString string];
    if ([_dataArray[sender] isKindOfClass:[NSData class]]) {
        UIImage *image= [UIImage imageWithData:_dataArray[sender]];
        CGFloat Width = image.size.width;
        CGFloat Height = image.size.height;
        CGFloat scale = 1.0;
        if (Width>ScreenWidth) {
            scale = ScreenWidth/Width;
        }
        if (Height>ScreenHeight) {
            if (scale>ScreenHeight/Height) {
                scale = ScreenHeight/Height;
            }
        }
        Width = image.size.width*scale;
        Height = image.size.height*scale;
        [pImageView setImage:image];
        pImageView.tag = 1000+sender;

    }else{
    if ([_logInController isEqualToString:@"PublishPhotoViewController"]) {
        str = _dataArray[sender];
        
    }else{
        TotalPhotoModel *model = _dataArray[sender];
        str = model.url;
    }
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:str];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        CGFloat Width = image.size.width;
        CGFloat Height = image.size.height;
        CGFloat scale = 1.0;
        if (Width>ScreenWidth) {
            scale = ScreenWidth/Width;
        }
        if (Height>ScreenHeight) {
            if (scale>ScreenHeight/Height) {
                scale = ScreenHeight/Height;
            }
        }
        Width = image.size.width*scale;
        Height = image.size.height*scale;
        [pImageView setImage:image];
        pImageView.tag = 1000+sender;
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
    }
    [self.scrollView addSubview:pImageView];
        
}


#pragma mark - Action

//返回
-(void)sendClick:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTouches == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//选择照片点击
-(void)imageSlect:(UIButton *)btn{

    TotalPhotoModel *model = _dataArray[_currenIndex];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
    if (btn.selected) {
        btn.selected = NO;
        [_selectDataArray removeObject:_dataArray[_currenIndex]];
        model.isSelect = NO;
        [imageView setImage:[UIImage imageNamed:@"PublishAlbumsNormal"]];
    }else{
        NSArray *selectArray = [userDefaults objectForKey:@"PublishPhotosArray"];
        NSInteger total = _selectDataArray.count;
        
        if (selectArray) {
            total = total + selectArray.count;
        }
        if (total>=3) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多显示三张照片" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
            return;
        }
        btn.selected = YES;
        model.isSelect = YES;
        [imageView setImage:[UIImage imageNamed:@"PublishAlbumsSelect"]];
        [_selectDataArray addObject:_dataArray[_currenIndex]];
    }
    [_dataArray replaceObjectAtIndex:_currenIndex withObject:model];
    UIButton *DoneButton = (UIButton *)[self.view viewWithTag:106];
    [DoneButton setTitle:[NSString stringWithFormat:@"确定 (%ld)",(long)_selectDataArray.count] forState:UIControlStateNormal];
    
    if (_selectDataArray.count==0) {
        //当选中个数为0时
        [DoneButton setBackgroundColor:GPColor(110, 184, 184)];
        
        DoneButton.userInteractionEnabled = NO;
    }else{
        [DoneButton setBackgroundColor:RGBA(32,190,189,1)];
        DoneButton.userInteractionEnabled = YES;
    }
}

- (void) selectArray:(SelectIndexBlock)block
{
    self.selectIndexBlock = block;
}


//完成按钮
-(void)doneClick:(UIButton *)btn{
    /**
     *  longinType 2:尚未选择添加
     */
    NSString *longinType = [userDefaults objectForKey:@"PublishLogInType"];
    NSMutableArray *SelectArray = [NSMutableArray array];
    for (TotalPhotoModel *model in _selectDataArray) {
        [SelectArray addObject:model.url];
    }
    
    if ([longinType isEqualToString:@"2"]) {
        [userDefaults setValue:SelectArray forKey:@"PublishPhotosArray"];
    }else{
        NSMutableArray *totalArray = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"PublishPhotosArray"]];
        [totalArray addObjectsFromArray:SelectArray];
        [userDefaults setValue:totalArray forKey:@"PublishPhotosArray"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//scrollView滚动代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat indexFloat = scrollView.contentOffset.x/ScreenWidth;
    NSInteger indexInteger = indexFloat;
    
    if (indexInteger != _currenIndex) {
        _index = indexInteger;
        
        UIButton *indexBtn = (UIButton *)[self.view viewWithTag:102];
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:101];
        UILabel *indexLabel = (UILabel *)[self.view viewWithTag:107];
        NSString *textStr = [NSString stringWithFormat:@"%ld/%ld",indexInteger+1,_dataArray.count];
        [indexLabel setText:textStr];

        indexBtn.selected = NO;
        [imageView setImage:[UIImage imageNamed:@"PublishAlbumsNormal"]];

        for (TotalPhotoModel *model in _selectDataArray) {
            if ([model isEqual:_dataArray[_index]]) {
                indexBtn.selected = YES;
                [imageView setImage:[UIImage imageNamed:@"PublishAlbumsSelect"]];
                break;
            }
        }
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexInteger+1];

        if (_currenIndex>indexInteger) {
            indexStr = [NSString stringWithFormat:@"%ld",(long)indexInteger-1];
        }
        _currenIndex = indexInteger;
        if (indexInteger==0||indexInteger >= _dataArray.count-1) {
            return;
        }

        NSInteger i = 0;
        for (NSString *indexStr2  in _createArry) {
            if ([indexStr isEqualToString:indexStr2]) {
                i++;
            }
        }
        if (i==0) {
            [_createArry addObject:indexStr];
            [self setupPage:[indexStr integerValue]];
            
        }
    }
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
