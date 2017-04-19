//
//  PublishPhotoViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishPhotoViewController.h"
#import "PublishCollectionViewCell.h"
#import "ShlTextView.h"
#import "ChoicePhotoViewController.h"
#import "ReviewPhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PublishPhotoHeader.h"
#import "PublishPhotoFooter.h"
#import "BallParkSelectModel.h"
#import "PublishSelectAddressViewController.h"

#import "EmojiKeybordView.h"

@interface PublishPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>{
    //文本框
    ShlTextView *_textView;
    //带切换按钮的View
    UIView *_emojiKeybordView;
    //表情键盘
    EmojiKeybordView *_emojiView;
    //选择图标
    UIImageView *_KeybordEmojiIcon;
}

@property(nonatomic,strong)UICollectionView  *mainCollectionView;
//位置信息
@property(nonatomic,copy)NSString  *locationStr;
//所有球场信息
@property(nonatomic,strong)NSMutableArray  *PlaceDataSouce;
@end

@implementation PublishPhotoViewController


-(NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _dataArry = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"PublishPhotosArray"]];
    if (_dataArry.count<3) {
        [_dataArry addObject:@"PublishAdd"];
    }
    [_mainCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createCollectionView];
    [self createBackView];
    [self createEmojiView];

}


//创建上导航
-(void)createNavigationView{
    UserTopNavigation *vc = [[UserTopNavigation alloc] init];
    UILabel *cancelLel = [Factory createLabelWithFrame:CGRectMake(kWvertical(11.5), kHvertical(35), kWvertical(30), kHvertical(14.5)) textColor:GPColor(20, 21, 22) fontSize:kHorizontal(15) Title:@"取消"];
    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(30), kHvertical(14.5))  textColor:BlackColor fontSize:kHorizontal(15) Title:@"发送"];
    [vc.leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [vc.rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [vc createLeftWithImage:cancelLel];
    [vc createRightWithImage:sendLabel];
    [vc createTitleWith:@"发布动态"];
    [self.view addSubview:vc];
}
//创建collectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];

//    _mainCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    
    [_mainCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:@"PublishCollectionViewCellId"];
    
    
    [_mainCollectionView registerClass:[PublishPhotoHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishCollectionHeaderViewId"];
    [_mainCollectionView registerClass:[PublishPhotoFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PublishCollectionFooterViewId"];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}

-(void)createBackView{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(330), ScreenWidth, ScreenHeight - kHvertical(330))];
    bView.backgroundColor = GPColor(241, 243, 249);
    [self.view addSubview:bView];
    
}


//创建表情键盘
-(void)createEmojiView{
    _emojiView = [[EmojiKeybordView alloc] initWithFrame:CGRectMake(0, ScreenHeight - kHvertical(216), ScreenWidth, kHvertical(216))];
    __weak __typeof(self)weakSelf = self;
    _emojiView.selectEmoji = ^(id select){
        [weakSelf textViewChange:select];
    };
    
    _emojiKeybordView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(44))];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWvertical(44), kHvertical(44))];
    [btn addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    _KeybordEmojiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(10), kHvertical(10), kWvertical(24), kHvertical(24))];
    _KeybordEmojiIcon.image = [UIImage imageNamed:@"EmojiKeybord"];
    [btn addSubview:_KeybordEmojiIcon];
    btn.selected  = NO;
    [_emojiKeybordView addSubview:btn];
}


#pragma mark - 请求数据
-(void)initData{
    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"jingdu":lon,
                           @"weidu":lat
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_qiuchang_all",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            _PlaceDataSouce = [NSMutableArray array];
            for (NSDictionary *temp in dic[@"data"]) {
                
                BallParkSelectModel *model = [BallParkSelectModel paresFromDictionary:temp];
                [self.PlaceDataSouce addObject:model];
            }
            NSDictionary *temp = dic[@"data"][0];
            NSLog(@"%@",temp);
            _locationStr = [temp objectForKey:@"qiuchang_name"];
            [_mainCollectionView reloadData];
        }
    }];
}
//表情键盘操作
-(void)textViewChange:(NSString *)emojiStr{
    
    
    NSString *mStr = _textView.text;
    NSString *mStr1 = [NSString string];
    BOOL isEmoji = NO;
    
    
    if ([emojiStr isEqualToString:@"EmojiDeleat"]) {
        if ([mStr length]==0) {
            return;
        }
        if ([mStr length]>=2) {
            mStr1 = [mStr substringWithRange:NSMakeRange(mStr.length-2, 2)];
           isEmoji = [self isEmoji:mStr1];
        }
        
        mStr = [mStr substringToIndex:mStr.length-1];
        if (isEmoji) {
            mStr = [mStr substringToIndex:mStr.length-1];
        }
    }else{
        mStr = [NSMutableString stringWithFormat:@"%@%@", _textView.text,emojiStr];
    }
    _textView.text = mStr;
    [_textView textViewDidChange:mStr];
}


//判断Emoji
- (BOOL)isEmoji:(NSString *)emoji {
    const unichar high = [emoji characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F77F)
    if (0xd800 <= high && high <= 0xdbff) {
        const unichar low = [emoji characterAtIndex: 1];
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
        
        return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27bf);
    }
}


#pragma mark - 点击事件
//返回
-(void)cancelClick{
        [self.navigationController popViewControllerAnimated:YES];
}
//发送
-(void)sendClick{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (int i = 0; i<_dataArry.count-1; i++) {
        if ([_dataArry[i] isKindOfClass:[NSData class]]) {
            NSData *headImageData = _dataArry[i];
            NSString* encoderStr = [headImageData base64EncodedStringWithOptions:0];
            headImageData= [encoderStr dataUsingEncoding:NSUTF8StringEncoding];
            NSString *photo = [[ NSString alloc] initWithData:headImageData encoding:NSUTF8StringEncoding];
            
            [photoArray addObject:photo];
            
            if (photoArray.count == _dataArry.count-1) {
                [self postData:photoArray];
            }
        }else{
        NSString *str = _dataArry[i];
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSURL *url=[NSURL URLWithString:str];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            NSData *iamgeData = UIImageJPEGRepresentation(image,0.8);
            if (!iamgeData) {
                iamgeData = UIImagePNGRepresentation(image);
            }
            
            NSData *headImageData = iamgeData;
            NSString* encoderStr = [headImageData base64EncodedStringWithOptions:0];
            headImageData= [encoderStr dataUsingEncoding:NSUTF8StringEncoding];
            NSString *photo = [[ NSString alloc] initWithData:headImageData encoding:NSUTF8StringEncoding];

            [photoArray addObject:photo];
            
            if (photoArray.count == _dataArry.count-1) {
                [self postData:photoArray];
            }
            
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
         ];
        }
    }

    NSLog(@"11");
}
//提交数据
-(void)postData:(NSMutableArray *)photoArray{
    
    NSString *dynamicContent = _textView.text;
    
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:photoArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if ([jsonData length] > 0){
        jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userTestId,
                           @"dynamicContent":dynamicContent,
                           @"photoJSON":jsonString,
                           @"position":_locationStr
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insertDynamic?",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSString *content = [data objectForKey:@"content"];
            NSString *str2 = [content stringByRemovingPercentEncoding];
            _textView.text = [NSString stringWithFormat:@"上传数据为:%@",str2];
        }
        
    }];
}

//删除照片
-(void)DeleatPhoto:(UIButton *)sender{
    NSInteger deleatIndex = sender.tag - 105;
    [_dataArry removeObjectAtIndex:deleatIndex];
    [_dataArry removeObject:@"PublishAdd"];
    [userDefaults setValue:_dataArry forKey:@"PublishPhotosArray"];
    [_dataArry addObject:@"PublishAdd"];
    [_mainCollectionView reloadData];

}
//选择位置
-(void)selectLoaction{
    PublishSelectAddressViewController *ballPark = [[PublishSelectAddressViewController alloc]init];
    __weak __typeof(self)weakSelf = self;
    
    ballPark.selectAddress = ^(id selectPark){
        if ([selectPark isKindOfClass:[NSString class]]) {
            weakSelf.locationStr = [NSString stringWithFormat:@"%@",selectPark];
        } else {
            BallParkSelectModel *SelectPark = selectPark;
            weakSelf.locationStr = [NSString stringWithFormat:@"%@",SelectPark.name];
        }
        [weakSelf.mainCollectionView reloadData];
    };
    ballPark.dataSouce = _PlaceDataSouce;
    [self.navigationController pushViewController:ballPark animated:YES];

}

//键盘切换
-(void)changeKeyboard:(UIButton *)btn{
    
    if (btn.selected) {
        btn.selected = NO;
        _KeybordEmojiIcon.frame = CGRectMake(kWvertical(10), kHvertical(10), kWvertical(24), kHvertical(24));

        _KeybordEmojiIcon.image = [UIImage imageNamed:@"EmojiKeybord"];

    }else{
        btn.selected = YES;
        _KeybordEmojiIcon.frame = CGRectMake(kWvertical(10), kHvertical(13.5), kWvertical(24), kHvertical(17));

        _KeybordEmojiIcon.image = [UIImage imageNamed:@"KeybordEmojiIcon"];
    }
    
    if ([_textView.inputView isEqual:_emojiView])
    {
        _textView.inputView = nil;
    }
    else
    {
        _textView.inputView = _emojiView;

    }
    _emojiKeybordView.hidden = YES;
    [_textView resignFirstResponder];
    [_textView becomeFirstResponder];
    _emojiKeybordView.hidden = NO;
    
}

#pragma mark - Delegate
//textView长度改变
-(void)textViewDidChange:(UITextView *)textView{
    [_textView textViewDidChange:textView.text];
    
}
//点击空白隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}
//滚动代理
-(void)scrollViewDidScroll:(UICollectionView *)scrollView{
    if (scrollView == _mainCollectionView) {
        [_textView resignFirstResponder];
    }
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
    return _dataArry.count;
}
//collectionDlegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell *cell = (PublishCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PublishCollectionViewCellId" forIndexPath:indexPath];
    
    cell.deleatBtn.tag = 105+indexPath.item;
    [cell.deleatBtn addTarget:self action:@selector(DeleatPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [cell configName:_dataArry[indexPath.item]];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kWvertical(84),kWvertical(84));
}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //设置headerView的尺寸大小
    return CGSizeMake(self.view.width, kHvertical(86));
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.width,  kHvertical(86));
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(kWvertical(4), kWvertical(4), 0, kWvertical(4));

    return UIEdgeInsetsMake(0, kWvertical(14), 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kWvertical(7);
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kWvertical(4);
}

//设置HeaderView与FooterView “PublishCollectionHeaderViewId”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PublishPhotoHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishCollectionHeaderViewId" forIndexPath:indexPath];
        headerView.textView.delegate = self;
        _textView = headerView.textView;
        
        return headerView;
    }
    
    PublishPhotoFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PublishCollectionFooterViewId" forIndexPath:indexPath];
    footerView.loactionLabel.text = @"所在位置";
    footerView.loactionLabel.userInteractionEnabled = NO;
    if (_locationStr) {
        footerView.loactionLabel.text = _locationStr;
        footerView.loactionLabel.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLoaction)];
    [footerView addGestureRecognizer:tpg];
    return footerView;
}





//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"PublishPhotosArray"]];

    if (index==selectArray.count&&selectArray.count<3) {
        ChoicePhotoViewController *menuViewController = [[ChoicePhotoViewController alloc] init];
        [userDefaults setValue:@"3" forKey:@"PublishLogInType"];
        
        UIViewController * controller = self.view.window.rootViewController;
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        menuViewController.view.backgroundColor = [UIColor whiteColor];
        menuViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController * jackNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
        [jackNavigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:jackNavigationController animated:YES completion:nil];
        
    }else{
        ReviewPhotosViewController *vc = [[ReviewPhotosViewController alloc] init];
        vc.logInController = @"PublishPhotoViewController";
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:_dataArry];
        [dataArray removeObject:@"PublishAdd"];
        vc.currenIndex = indexPath.item;
        [vc setDataArray:dataArray];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    NSLog(@"%ld",(long)indexPath.item);
}


#pragma mark - 键盘通知

-(void)keyboardShow:(NSNotification *)notification{
    // 消息的信息
    NSDictionary *dic = notification.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    [self.view addSubview:_emojiKeybordView];
    
    _emojiKeybordView.frame = CGRectMake(0, ScreenHeight - kHvertical(44) - kbSize.height, ScreenWidth, kHvertical(44));

}

-(void)keyboardHide:(NSNotification *)notification{

    [_emojiKeybordView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
