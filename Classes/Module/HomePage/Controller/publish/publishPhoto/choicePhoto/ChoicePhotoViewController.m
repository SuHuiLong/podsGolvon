//
//  ChoicePhotoViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ChoicePhotoViewController.h"
#import "PublishCollectionViewCell.h"
#import "ReviewPhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "TotalPhotoViewController.h"

#import "TotalPhotoModel.h"
#import "PublishPhotoViewController.h"
#import "NewAlertView.h"

@interface ChoicePhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UICollectionView *_mainCollectionView;
    
    UserTopNavigation *_TopNavigation;
}

@property(nonatomic,strong)NSMutableArray       *selectIndexArray;//选择照片位置

@property(nonatomic,copy)NSString  *indexLib;//获取数据时当前分组
@property(nonatomic,strong)NSMutableArray       *listDataArray;//分组数据源
@property(nonatomic,strong)NSMutableDictionary  *totalDataDict;//分组数据源

@end

@implementation ChoicePhotoViewController

-(NSMutableArray *)dataArry{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)selectIndexArray{
    if (_selectIndexArray==nil) {
        _selectIndexArray = [NSMutableArray array];
    }
    return _selectIndexArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [_mainCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createCollectionView];
    [self createBottomView];
}

//创建上导航
-(void)createNavigationView{
    _TopNavigation = [[UserTopNavigation alloc] init];
    
    UIImageView *backArrow = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(32), kWvertical(11), kHvertical(19)) Image:[UIImage imageNamed:@"BlackBack"]];
    
    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(30), kHvertical(14.5))  textColor:BlackColor fontSize:kHorizontal(15) Title:@"取消"];
    [_TopNavigation.leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_TopNavigation.rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_TopNavigation createLeftWithImage:backArrow];
    [_TopNavigation createRightWithImage:sendLabel];
    if (!_titleStr) {
        _titleStr = @"相机胶卷";
    }
    [_TopNavigation createTitleWith:_titleStr];
    [self.view addSubview:_TopNavigation];
}


//创建CollectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-kHvertical(55)) collectionViewLayout:layout];
    _mainCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    
    [_mainCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:@"PublishCollectionViewCellId"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishCollectionHeaderViewId"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PublishCollectionFooterViewId"];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}
//创建底部栏
-(void)createBottomView{
    /**
     *  <#Description#>
     *
     *  @param bottomView 底部栏
     *  @param reViewLable 预览 101
     *  @param DoneLable 完成 103
     *  @param selectNumView 选择数字背景 104
     *  @param selectNumber 选择数量 105
     *  @param _reviewButton 预览按钮 102
     *  @param _DoneButton 完成按钮 106
     *
     *  @return <#return value description#>
     */
//底部栏
    UIView *bottomView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight-kHvertical(45), ScreenWidth, kHvertical(45))];
    [self.view addSubview:bottomView];
//预览
    UILabel *reViewLable = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), kHvertical(11), kWvertical(40), kHvertical(22)) textColor:GPColor(110, 184, 184) fontSize:kHorizontal(16) Title:@"预览"];
    reViewLable.tag = 101;
    [bottomView addSubview:reViewLable];
//预览按钮
    UIButton *reviewButton = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(45), kHvertical(45)) target:self selector:@selector(reViewClick:) Title:nil];
    reviewButton.backgroundColor = ClearColor;
    [reviewButton addSubview:reViewLable];
    reviewButton.tag = 102;
    reviewButton.userInteractionEnabled = NO;
    [bottomView addSubview:reviewButton];
    
    UIButton *DoneButton = [Factory createButtonWithFrame:CGRectMake( ScreenWidth - kWvertical(81), kHvertical(9), kWvertical(70), kHvertical(28))titleFont:14.0f textColor:WhiteColor backgroundColor:GPColor(110, 184, 184) target:self selector:@selector(doneClick) Title:@"确定 (0)"];
    DoneButton.tag = 106;
    [bottomView addSubview:DoneButton];
    
    
    
////完成
//    UILabel *DoneLable = [Factory createLabelWithFrame:CGRectMake( ScreenWidth - kWvertical(6), kHvertical(20), kWvertical(35), kHvertical(17)) textColor:GPColor(180, 180, 180) fontSize:kHorizontal(16) Title:@"完成"];
//    DoneLable.tag = 103;
//    DoneLable.textAlignment = NSTextAlignmentRight;
//    [DoneLable sizeToFit];
//    CGFloat DoneWide = DoneLable.width;
//    DoneLable.frame = CGRectMake(ScreenWidth - kWvertical(6)-DoneWide,  kHvertical(20), kWvertical(35), kHvertical(17));
//    [bottomView addSubview:DoneLable];
////选择数字背景
//    UIView *selectNumView = [Factory createViewWithBackgroundColor:GPColor(122, 179, 23) frame:CGRectMake(DoneLable.frame.origin.x - kWvertical(17),kHvertical(20), kWvertical(16), kWvertical(16))];
//    selectNumView.tag = 104;
//    selectNumView.layer.masksToBounds = YES;
//    selectNumView.layer.cornerRadius = kWvertical(8);
//    selectNumView.hidden = YES;
////选择数量
//    UILabel *selectNumber = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(2), kWvertical(16), kHvertical(12)) textColor:WhiteColor fontSize:kHorizontal(12) Title:@"1"];
//    selectNumber.tag = 105;
//    selectNumber.textAlignment = NSTextAlignmentCenter;
//    [selectNumView addSubview:selectNumber];
//    [bottomView addSubview:selectNumView];
////完成按钮
//    UIButton *DoneButton = [Factory createButtonWithFrame:CGRectMake(selectNumView.frame.origin.x, 0, ScreenWidth - selectNumView.frame.origin.x, kHvertical(55)) target:self selector:@selector(doneClick:) Title:nil];
//    DoneButton.tag = 106;
//    DoneButton.backgroundColor = ClearColor;
//    DoneButton.userInteractionEnabled = NO;
//    [bottomView addSubview:DoneButton];

}

#pragma mark - 加载数据
-(void)initData{
    if (![_logInType isEqualToString:@"1"]) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"PublishCamera"];
    }
    _selectIndexArray = [NSMutableArray array];
    _listDataArray = [NSMutableArray array];
    _totalDataDict = [NSMutableDictionary dictionary];

    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
//单个分组所有数据
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                             //图片的缩略图小图
                     //NSRange range1=[urlstr rangeOfString:@"id="];
                     //NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    NSString *indexStr = [NSString stringWithFormat:@"%ld",_listDataArray.count];
                    if (!indexStr) {
                        indexStr = @"0";
                    }
                    TotalPhotoModel *model = [[TotalPhotoModel alloc] init];
                    model.libName = _indexLib;
                    model.url = urlstr;
                    model.isSelect = NO;
                    model.indexStr = indexStr;
                    model.totalNum = @"1";
                    [_listDataArray insertObject:model atIndex:0];
                    if (![_logInType isEqualToString:@"1"]) {
                        if ([_indexLib isEqualToString:@"相机胶卷"]) {
                            [_dataArray insertObject:model atIndex:1];
                        }
                    }
                }
            }
            
            if (![_logInType isEqualToString:@"1"]) {
                [_mainCollectionView reloadData];
            }
        };
//获取单个分组
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (stop) {
                
            }
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr;
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }

                if (_indexLib) {
                    if (![_indexLib isEqualToString:g2]) {
                        if (_listDataArray.count > 0) {
                            [_totalDataDict setValue:_listDataArray forKey:_indexLib];
                        }
                        _indexLib = g2;
                        _listDataArray = [NSMutableArray array];
                    }
                }else{
                    _indexLib = g2;
                }
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            if ([_totalDataDict isEqual:@{}]&&_listDataArray.count > 0) {
                [_totalDataDict setValue:_listDataArray forKey:_indexLib];
            }
        };
//获取相册所有数据
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });

}

//更新底部数据
-(void)reloadBottomData{
    //    *  @param reViewLable 预览 101
    //    *  @param reviewButton 预览按钮 102
    //    *  @param DoneButton 完成按钮 106

    UIButton *reviewButton = (UIButton *)[self.view viewWithTag:102];
    UIButton *DoneButton = (UIButton *)[self.view viewWithTag:106];
    UILabel *reviewLabel = (UILabel *)[self.view viewWithTag:101];
    [DoneButton setTitle:[NSString stringWithFormat:@"确定 (%ld)",(long)_selectIndexArray.count] forState:UIControlStateNormal];

    if (_selectIndexArray.count==0) {
        //当选中个数为0时
        [DoneButton setBackgroundColor:GPColor(110, 184, 184)];

        reviewButton.userInteractionEnabled = NO;
        DoneButton.userInteractionEnabled = NO;
        reviewLabel.textColor = GPColor(180, 180, 180);
    }else{
        [DoneButton setBackgroundColor:RGBA(32,190,189,1)];
        reviewButton.userInteractionEnabled = YES;
        DoneButton.userInteractionEnabled = YES;
        reviewLabel.textColor = RGBA(32,190,189,1);
    }
}

#pragma mark - 点击事件
//返回
-(void)cancelClick{
//    [self insert];
    TotalPhotoViewController *vc = [[TotalPhotoViewController alloc] init];
    [_dataArray removeAllObjects];
    [_mainCollectionView reloadData];
    vc.totalDateDict = _totalDataDict;
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:[CAMediaTimingFunction
                                      functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setType:kCATransitionPush];
        [animation setSubtype: kCATransitionFromLeft];
        [self.view.layer addAnimation:animation forKey:@"Reveal"];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];

    [self.navigationController pushViewController:vc animated:NO];
}
//取消
-(void)sendClick{

    [self dismissViewControllerAnimated:YES completion:nil];
  
}
//选择照片点击
-(void)imageSlect:(UIButton *)btn{
    UIView *AlertView = (NewAlertView *)[self.view viewWithTag:107];
    if (AlertView) {
        return;
    }
    
    NSInteger Tag = btn.tag - 1000;
    TotalPhotoModel *indexModel = _dataArray[Tag];
    TotalPhotoModel *dataModel = [[TotalPhotoModel alloc] init];
    dataModel.libName = indexModel.libName;
    dataModel.url = indexModel.url;
    dataModel.totalNum = indexModel.totalNum;
    dataModel.indexStr = indexModel.indexStr;
    if (btn.selected) {
        btn.selected = NO;
        [_selectIndexArray removeObject:indexModel];
        dataModel.isSelect = NO;
    }else{
        NSArray *selectArray = [userDefaults objectForKey:@"PublishPhotosArray"];
        NSInteger total = _selectIndexArray.count;
        
        if (selectArray) {
            total = total + selectArray.count;
        }
        if (total>=3) {
            NewAlertView *alertView = [[NewAlertView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - kHvertical(32), ScreenWidth, kHvertical(64))];
            [alertView setContentWith:nil];
            alertView.tag = 107;
            [self.view addSubview:alertView];
            [self.view addSubview:alertView.contentLabel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView removeFromSuperview];
                [alertView.contentLabel removeFromSuperview];
            });
            return;
        }
        dataModel.isSelect = YES;
        btn.selected = YES;
        [_selectIndexArray addObject:dataModel];
    }
    [_dataArray replaceObjectAtIndex:Tag withObject:dataModel];
    
    [self reloadBottomData];

}
//完成按钮
-(void)doneClick{
    NSString *longinType = [userDefaults objectForKey:@"PublishLogInType"];
    NSMutableArray *SelectArray = [NSMutableArray array];
    for (TotalPhotoModel *model in _selectIndexArray) {
        if (model.url) {
            [SelectArray addObject:model.url];
        }else{
            [SelectArray addObject:model.imageData];
        }
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

//预览按钮
-(void)reViewClick:(UIButton *)btn{
    ReviewPhotosViewController *vc = [[ReviewPhotosViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    [vc selectArray:^(NSMutableArray *selectArray) {
        for (int j=1; j<weakSelf.dataArray.count-1; j++) {
            TotalPhotoModel *totalModel = weakSelf.dataArray[j];
            totalModel.isSelect = NO;
            [weakSelf.dataArray replaceObjectAtIndex:j withObject:totalModel];
        }
        weakSelf.selectIndexArray = selectArray;
        for (int i = 1; i<weakSelf.dataArray.count-1; i++) {
            TotalPhotoModel *totalModel = weakSelf.dataArray[i];
            for (TotalPhotoModel *model in selectArray) {
                if ([model.url isEqualToString:totalModel.url]) {
                    model.isSelect = YES;
                    [weakSelf.dataArray replaceObjectAtIndex:weakSelf.dataArray.count - [model.indexStr integerValue] - 1 withObject:model];
                }
            }
        }
        [weakSelf reloadBottomData];
        [_mainCollectionView reloadData];
    }];
    vc.selectDataArray = _selectIndexArray;
    vc.dataArray = _selectIndexArray;
    vc.currenIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger total = 24;
    total = _dataArray.count;
    return total;
}
//collectionDlegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell *cell = (PublishCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PublishCollectionViewCellId" forIndexPath:indexPath];
    [cell configImage:_dataArray[indexPath.item]];
    NSInteger btnTag = 1000 + indexPath.item;
    cell.selectBtn.tag = btnTag;
    [cell.selectBtn addTarget:self action:@selector(imageSlect:) forControlEvents:UIControlEventTouchUpInside];
//        [_dataArray rep]
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - kWvertical(20))/4,(ScreenWidth - kWvertical(20))/4);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kWvertical(4), kWvertical(4), kWvertical(4), kWvertical(4));
    
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kWvertical(4);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    } else {
        NSMutableArray *sendArray = [NSMutableArray arrayWithArray:_dataArray];
        ReviewPhotosViewController *vc = [[ReviewPhotosViewController alloc] init];
        [sendArray removeObjectAtIndex:0];
        __weak __typeof(self)weakSelf = self;
        [vc selectArray:^(NSMutableArray *selectArray) {
            for (int j=1; j<weakSelf.dataArray.count-1; j++) {
                TotalPhotoModel *totalModel = weakSelf.dataArray[j];
                totalModel.isSelect = NO;
                [weakSelf.dataArray replaceObjectAtIndex:j withObject:totalModel];
            }
            weakSelf.selectIndexArray = selectArray;
            for (int i = 1; i<weakSelf.dataArray.count-1; i++) {
                TotalPhotoModel *totalModel = weakSelf.dataArray[i];
                for (TotalPhotoModel *model in selectArray) {
                    if ([model.url isEqualToString:totalModel.url]) {
                        model.isSelect = YES;
                        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.dataArray.count - [model.indexStr integerValue] - 1 withObject:model];
                    }
                }
            }
            [weakSelf reloadBottomData];
            [_mainCollectionView reloadData];
        }];
        vc.selectDataArray = _selectIndexArray;
        vc.dataArray = sendArray;
        vc.currenIndex = indexPath.row-1;
        [weakSelf reloadBottomData];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//imagepicker代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    NSData *iamgeData = UIImageJPEGRepresentation(image,0.9);
    TotalPhotoModel *model = [[TotalPhotoModel alloc] init];
    model.imageData = iamgeData;
    [_selectIndexArray addObject:model];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self doneClick];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
