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
#import "Follow_ViewController.h"
#import "TotalPhotoViewController.h"

#import "TotalPhotoModel.h"
#import "PublishPhotoViewController.h"
#import "NewAlertView.h"

#import "ImageTool.h"

@interface ChoicePhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UICollectionView *_mainCollectionView;
    
    UserTopNavigation *_TopNavigation;
    
    //提示框
    MBProgressHUD *_HUB;
}

@property(nonatomic,strong)NSMutableArray       *selectIndexArray;//选择照片位置

@property(nonatomic,copy)NSString  *indexLib;// 获取数据时当前分组

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
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - CreateView
-(void)createView{

    [self createNavigationView];
    [self createCollectionView];
    [self createBottomView];
    [self createHUB];
}

//创建上导航
-(void)createNavigationView{
    _TopNavigation = [[UserTopNavigation alloc] init];
    
    UIImageView *backArrow = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(32), kWvertical(11), kHvertical(19)) Image:[UIImage imageNamed:@"BlackBack"]];
    
    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(60), kHvertical(14.5))  textColor:BlackColor fontSize:kHorizontal(15) Title:@"取消"];
    [_TopNavigation.leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_TopNavigation.rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_TopNavigation createLeftWithImage:backArrow];
    [_TopNavigation createRightWithImage:sendLabel];
    if (!_titleStr) {
        _titleStr = @"个人照片";
    }
    [_TopNavigation createTitleWith:_titleStr];
    [self.view addSubview:_TopNavigation];
}


//创建CollectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-kHvertical(55)) collectionViewLayout:layout];
    _mainCollectionView.alwaysBounceVertical = YES;
    _mainCollectionView.pagingEnabled = NO;

    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    [_mainCollectionView setBackgroundColor:WhiteColor];

    [_mainCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:@"PublishCollectionViewCellId"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishCollectionHeaderViewId"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PublishCollectionFooterViewId"];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}

//创建底部栏
-(void)createBottomView{
//底部栏
    UIView *bottomView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight-kHvertical(45), ScreenWidth, kHvertical(45))];
    [self.view addSubview:bottomView];
//预览按钮
    UIButton *reviewButton = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(45), kHvertical(45)) target:self selector:@selector(reViewClick:) Title:nil];
    [reviewButton setTitle:@"预览" forState:UIControlStateNormal];
    [reviewButton setTitleColor:localColor forState:UIControlStateNormal];
    reviewButton.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    reviewButton.backgroundColor = WhiteColor;
    reviewButton.tag = 102;
    reviewButton.userInteractionEnabled = NO;
    [bottomView addSubview:reviewButton];
    
    UIButton *DoneButton = [Factory createButtonWithFrame:CGRectMake( ScreenWidth - kWvertical(81), kHvertical(9), kWvertical(70), kHvertical(28))titleFont:14.0f textColor:WhiteColor backgroundColor:localColor target:self selector:@selector(doneClick) Title:@"确定 (0)"];
    DoneButton.tag = 106;
    [bottomView addSubview:DoneButton];
    
}


-(void)createHUB{
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
}

#pragma mark - 加载数据
-(void)initData{
    
    if (![_logInType isEqualToString:@"1"]) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"PublishCamera"];
    }else{
        [_HUB removeFromSuperview];
        return;
    }
    _selectIndexArray = [NSMutableArray array];
    _totalDataDict = [NSMutableDictionary dictionary];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    TotalPhotoModel *model = [[TotalPhotoModel alloc] init];
                    model.libName = _indexLib;
                    UIImage *thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                    model.url = @{
                                  @"thumbnail":thumbnail,
                                  @"fullScreenImage":urlstr
                                  };
                    
                    
                    
                    model.isSelect = NO;
                    [_dataArray insertObject:model atIndex:1];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUB removeFromSuperview];
                    [_mainCollectionView reloadData];
                });
            }
        };
        
        //获取单个分组
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (stop) {
                
            }
            if (group!=nil) {
                NSString *indexName= [group valueForProperty:ALAssetsGroupPropertyName];
                _indexLib = indexName;
                NSLog(@"gg:%@",indexName);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                if (![_logInType isEqualToString:@"1"]) {
                    if ([_indexLib isEqualToString:_titleStr]) {
                        _dataArray = [NSMutableArray array];
                        [_dataArray addObject:@"PublishCamera"];
                        [group enumerateAssetsUsingBlock:groupEnumerAtion];
                    }
                }
            }
        };
        //获取相册所有数据
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:nil];
    });

}



//更新底部数据
-(void)reloadBottomData{

    UIButton *reviewButton = (UIButton *)[self.view viewWithTag:102];
    UIButton *DoneButton = (UIButton *)[self.view viewWithTag:106];
    [DoneButton setTitle:[NSString stringWithFormat:@"确定 (%ld)",(long)_selectIndexArray.count] forState:UIControlStateNormal];

    if (_selectIndexArray.count==0) {
        //当选中个数为0时
        [DoneButton setBackgroundColor:localColor];
        reviewButton.userInteractionEnabled = NO;
        DoneButton.userInteractionEnabled = NO;
    }else{
        [DoneButton setBackgroundColor:localColor];
        reviewButton.userInteractionEnabled = YES;
        DoneButton.userInteractionEnabled = YES;
    }
}
//更新回调数据
-(void)selectBlock:(NSMutableArray *)selectArray{
    for (int j=1; j<self.dataArray.count-1; j++) {
        TotalPhotoModel *totalModel = self.dataArray[j];
        totalModel.isSelect = NO;
        [self.dataArray replaceObjectAtIndex:j withObject:totalModel];
    }
    self.selectIndexArray = selectArray;
    for (int i = 1; i<self.dataArray.count-1; i++) {
        TotalPhotoModel *totalModel = self.dataArray[i];
        for (TotalPhotoModel *model in selectArray) {
            if ([model.url isEqual:totalModel.url]) {
                model.isSelect = YES;
                [self.dataArray replaceObjectAtIndex:self.dataArray.count - [model.indexStr integerValue] - 1 withObject:model];
            }
        }
    }
    [self reloadBottomData];
    [_mainCollectionView reloadData];
}

#pragma mark - 点击事件
//返回
-(void)cancelClick{
    TotalPhotoViewController *vc = [[TotalPhotoViewController alloc] init];
    [_dataArray removeAllObjects];
    vc.totalDateDict = _totalDataDict;

    [self.navigationController pushViewController:vc animated:YES];
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
        NSData *data = [userDefaults objectForKey:@"PublishPhotosArray"];
        NSArray *selectArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        NSInteger total = _selectIndexArray.count;
        
        if (selectArray) {
            total = total + selectArray.count;
        }
        if (total>=6) {
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

    NSMutableArray *SelectArray = [NSMutableArray array];
    for (TotalPhotoModel *model in _selectIndexArray) {
        if (model.url) {
            [SelectArray addObject:model.url];
        }else{
            [SelectArray addObject:model.imageData];
        }
    }
    NSData *Data = [userDefaults objectForKey:@"PublishPhotosArray"];
    NSMutableArray *totalArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:Data]];
    [totalArray addObjectsFromArray:SelectArray];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:totalArray];


    [userDefaults setValue:data forKey:@"PublishPhotosArray"];
    [userDefaults setValue:_titleStr forKey:@"boolSendPhoto"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//预览按钮
-(void)reViewClick:(UIButton *)btn{
    ReviewPhotosViewController *vc = [[ReviewPhotosViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    [vc selectArray:^(NSMutableArray *selectArray) {
        [weakSelf selectBlock:selectArray];
    }];
    vc.selectDataArray = _selectIndexArray;
    vc.dataArray = _selectIndexArray;
    vc.currenIndex = 0;
    vc.titleStr = _titleStr;
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
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishCollectionViewCellId" forIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.imageView.backgroundColor = [UIColor clearColor];

    [cell configImage:_dataArray[indexPath.item]];
    
    NSInteger btnTag = 1000 + indexPath.item;
    cell.selectBtn.tag = btnTag;
    [cell.selectBtn addTarget:self action:@selector(imageSlect:) forControlEvents:UIControlEventTouchUpInside];
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
        if (imagePickerController) {
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else {
        NSMutableArray *sendArray = [NSMutableArray arrayWithArray:_dataArray];
        ReviewPhotosViewController *vc = [[ReviewPhotosViewController alloc] init];
        [sendArray removeObjectAtIndex:0];
        __weak __typeof(self)weakSelf = self;
        [vc selectArray:^(NSMutableArray *selectArray) {
            [weakSelf selectBlock:selectArray];
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
    image = [[ImageTool shareTool] fixOrientation:image];
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
