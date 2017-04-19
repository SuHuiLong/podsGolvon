//
//  BeginViewController.m
//  NaLiWan
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 xinfu. All rights reserved.
//

#import "BeginViewController.h"
#import "RegistViewController.h"
#import "TabBarViewController.h"
#import "BeginCollectionViewCell.h"
#import "DDPageControl.h"


#define kScreen [UIScreen mainScreen].bounds.size


@interface BeginViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageDataArr;

@property (strong, nonatomic) NSMutableArray      *titleDataArr;

@property (strong, nonatomic) NSMutableArray      *contentArr;
@property (nonatomic, strong) DDPageControl *page;
@property (nonatomic, strong) UIView *skipView;
@end

static NSString *kCellId = @"BeginCollectionViewCell";
@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    [self createPageController];
    
}
-(void)createCollectionView{
    
    self.imageDataArr = [[NSMutableArray alloc] initWithObjects:@"launch_one",@"launch_two",@"launch_three",nil];
    self.titleDataArr = [[NSMutableArray alloc] initWithObjects:@"球友圈动态",@"更专业的计分",@"全新视觉体验", nil];
    self.contentArr = [[NSMutableArray alloc] initWithObjects:@"推荐热门球友，查看最新动态",@"操作更便捷，记分更方便",@"前所未有的高尔夫体验", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = kScreen;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreen.width , kScreen.height) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BeginCollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    self.collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;

    
    _skipView = [[UIView alloc]init];
    _skipView.frame = CGRectMake((ScreenWidth - WScale(72))/2, kHvertical(543), WScale(72), HScale(10));
    _skipView.backgroundColor = [UIColor clearColor];
    _skipView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToRegist)];
    [_skipView addGestureRecognizer:tap];
    [self.view addSubview:_skipView];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _imageDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BeginCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        
        cell.registBtn.hidden = YES;
        cell.imageView.frame = CGRectMake((ScreenWidth - kWvertical(212))/2, kHvertical(117), kWvertical(212), kWvertical(212));
    }else if(indexPath.item == 1){
        
        cell.registBtn.hidden = YES;
        cell.imageView.frame = CGRectMake((ScreenWidth - kWvertical(216))/2, kHvertical(94), kWvertical(216), kWvertical(259));
    }else{
        cell.registBtn.hidden = NO;
        cell.imageView.frame = CGRectMake((ScreenWidth - kWvertical(252))/2, kHvertical(91), kWvertical(252), kWvertical(264));
    }
    
    [cell relayoutImageWithName:self.imageDataArr[indexPath.item] andTitle:self.titleDataArr[indexPath.item] andContent:self.contentArr[indexPath.item]];
    
    return cell;
}
-(void)clickToRegist{
    
    //获取版本号
    NSString *versionKey = @"CFBundleVersion";
    //上一次使用的版本
    NSString *lastVersion = [userDefaults objectForKey:versionKey];
    //当前使用的版本
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    BOOL Bigger = [self isVersion:currentVersion biggerThanVersion:lastVersion];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (Bigger) {
        
        window.rootViewController = [[RegistViewController alloc] init];
        
    }else{
        [userDefaults setObject:currentVersion forKey:versionKey];

        if ([userDefaultId isEqualToString:@"0"]) {
            
            window.rootViewController = [[RegistViewController alloc] init];
        }else{
            if (userDefaultId) {
                window.rootViewController = [[TabBarViewController alloc]init];
            }else{
                window.rootViewController = [[RegistViewController alloc] init];
            }
        }
    }

    
    
    
}

//判断版本号
- (BOOL)isVersion:(NSString*)versionA biggerThanVersion:(NSString*)versionB
{
    NSArray *arrayNow = [versionB componentsSeparatedByString:@"."];
    NSArray *arrayNew = [versionA componentsSeparatedByString:@"."];
    BOOL isBigger = NO;
    NSInteger i = arrayNew.count > arrayNow.count? arrayNow.count : arrayNew.count;
    NSInteger j = 0;
    BOOL hasResult = NO;
    for (j = 0; j < i; j ++) {
        NSString* strNew = [arrayNew objectAtIndex:j];
        NSString* strNow = [arrayNow objectAtIndex:j];
        if ([strNew integerValue] > [strNow integerValue]) {
            hasResult = YES;
            isBigger = YES;
            break;
        }
        if ([strNew integerValue] < [strNow integerValue]) {
            hasResult = YES;
            isBigger = NO;
            break;
        }
    }
    if (!hasResult) {
        if (arrayNew.count > arrayNow.count) {
            NSInteger nTmp = 0;
            NSInteger k = 0;
            for (k = arrayNow.count; k < arrayNew.count; k++) {
                nTmp += [[arrayNew objectAtIndex:k]integerValue];
            }
            if (nTmp > 0) {
                isBigger = YES;
            }
        }
    }
    return isBigger;
}
-(void)createPageController{
    _page = [[DDPageControl alloc]init];
    _page.frame = CGRectMake((ScreenWidth-30) / 2, kHvertical(623), 30, 10);
    _page.numberOfPages = 3;

    [_page setType:DDPageControlTypeOnFullOffFull];
    [_page setOnColor:localColor];
    [_page setOffColor:GPColor(229, 229, 229)];
    [_page setIndicatorDiameter: 8.f];
    [_page setIndicatorSpace: 10.f];
    [self.view  addSubview:_page];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    int index = scrollView.contentOffset.x/ScreenWidth;
    if (index == 2) { // 这个需根据图片数量总数来判断
        _skipView.hidden = NO;
    } else {
        _skipView.hidden = YES;
    }
    
    int page = scrollView.contentOffset.x/ScreenWidth;
    if (page == 3) {
        _page.currentPage = 0;
        self.collectionView.contentOffset = CGPointZero;
    }else{
        _page.currentPage = page;
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    if (page == 3) {
        _page.currentPage = 0;
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
