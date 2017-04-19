//
//  SingleMatchViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SingleMatchViewController.h"
#import "CUSFlashLabel.h"
#import "SingleMatchScrollView.h"
#import "NewStatisticsViewController.h"
#import "SelectPoleView.h"
#import "GolfersModel.h"
#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"

@interface SingleMatchViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView  *mainScrollView;

//总数据源
@property(nonatomic,strong)NSMutableDictionary  *totalDict;
//选球洞点击
@property(nonatomic,copy)UIView  *titleView;
//总杆
@property(nonatomic,copy)UILabel *GrossLabel;
//推杆
@property(nonatomic,copy)UILabel *PuttersLabel;
//当前洞号
@property(nonatomic,copy)NSString  *indexPole;
//数据保存类
@property(nonatomic,strong)YYDiskCache *diskCache;
//上次提交数据的位置
@property(nonatomic,assign)NSInteger  lastPageIndex;
//记录上次滑动的位置判断滑动方向
@property(nonatomic,assign)CGFloat    begianPosition;
//是否有没有提交失败的数据
@property(nonatomic,assign)BOOL  pushErrow;
//是否跳转至积分卡
@property(nonatomic,assign)BOOL pushStatistics;


@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIImageView *bottomImage;

@end

@implementation SingleMatchViewController


-(YYDiskCache *)diskCache{
    if (_diskCache==nil) {
        NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        self.diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
    }
    return _diskCache;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initViewData];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    _indexPole = @"0";
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_pushErrow){
        [self sendTotalData];
        
    }

}

#pragma mark - createView
-(void)createView{
    [self createNavagationView];
    [self createScrollView];
    [self createContentView];
    NSString *endPole =   [_totalDict objectForKey:@"endPole"];
    CGFloat width = [endPole integerValue]*ScreenWidth;
    [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:YES];

}
-(void)showFeatureGuideView
{
    
    
}
//创建navagation
-(void)createNavagationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"操作记录"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(ScreenWidth-64, 10, 64, 64);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _titleView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake((ScreenWidth - 100)/2, 0, 100, 64)];
    NSArray *poleNameKey = [_totalDict objectForKey:@"poleNameKey"];
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(10, 30, _titleView.width, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:poleNameKey[0]];
    
    [titlelabel sizeToFitSelf];
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(titlelabel.x_width + 3, 41, 11, 6) Image:[UIImage imageNamed:@"scoring向下角标"]];
    
    _titleView.frame = CGRectMake((ScreenWidth - titlelabel.width - arrowView.width - 23)/2, 0, titlelabel.width + arrowView.width + 23, 64);
    
    
    [_titleView addSubview:titlelabel];
    [_titleView addSubview:arrowView];
    
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPole:)];
    _titleView.userInteractionEnabled = YES;
    [_titleView addGestureRecognizer:tgp];

    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    
    
//    提示
    EAFeatureItem *top = [[EAFeatureItem alloc]initWithFocusRect:CGRectMake((ScreenWidth - kWvertical(75))/2, kHvertical(23), kWvertical(75), kHvertical(42)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    top.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    top.introduce = @"选择出发球洞&切换球洞";
    top.labelFrame = CGRectMake(kWvertical(34), kHvertical(94), kWvertical(188), kHvertical(42));
    top.indicatorImageName = @"top_short";
    top.imageFrame = CGRectMake((ScreenWidth - kHvertical(23))/2, kHvertical(70), kWvertical(23), kHvertical(23));
    EAFeatureItem *right;
    if (ScreenHeight<667) {
        
        right = [[EAFeatureItem alloc]initWithFocusRect:CGRectMake((ScreenWidth - (kWvertical(64))), kHvertical(23), kWvertical(48), kHvertical(42)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        right.introduce = @"查看本场成绩";
        right.labelFrame = CGRectMake(ScreenWidth - kWvertical(147), kHvertical(130), kWvertical(137), kHvertical(42));
        right.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        right.indicatorImageName = @"top_long";
        right.imageFrame = CGRectMake(ScreenWidth - kWvertical(53), kHvertical(70), kWvertical(23), kHvertical(57));
        
    }else{
        
        right = [[EAFeatureItem alloc]initWithFocusRect:CGRectMake((ScreenWidth - (kWvertical(54))), kHvertical(23), kWvertical(48), kHvertical(42)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        right.introduce = @"查看本场成绩";
        right.labelFrame = CGRectMake(ScreenWidth - kWvertical(147), kHvertical(130), kWvertical(137), kHvertical(42));
        right.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        right.indicatorImageName = @"top_long";
        right.imageFrame = CGRectMake(ScreenWidth - kWvertical(53), kHvertical(70), kWvertical(23), kHvertical(57));
    }


    
    
    EAFeatureItem *bottom = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake((ScreenWidth - kWvertical(120))/2+kWvertical(5), ScreenHeight - kHvertical(95), kWvertical(120), kHvertical(38)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    bottom.introduce = @"切换(总杆/杆差)记分模式";
    bottom.labelFrame = CGRectMake(kWvertical(10),kHvertical(498), kWvertical(203), kHvertical(42));
    bottom.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    bottom.indicatorImageName = @"right_bottom";
    bottom.imageFrame = CGRectMake(kWvertical(152), kHvertical(548), kWvertical(19), kHvertical(19));

    
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:rightBtn];
    [Uvc addSubview:_titleView];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
    
    
    [self.navigationController.view showWithFeatureItems:@[top,right,bottom] saveKeyName:@"button" inVersion:nil];
    
}

//创建scrollView
-(void)createScrollView{
    
    UIScrollView *mainScreollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+kHvertical(65), ScreenWidth, ScreenHeight - 64 - kHvertical(92))];
    mainScreollView.delegate = self;
    [self.view addSubview:mainScreollView];
    _mainScrollView = mainScreollView;
    [_mainScrollView setContentSize:CGSizeMake(ScreenWidth*18, mainScreollView.height)];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delaysContentTouches = NO;
    for (int i = 0; i<18; i++) {
        
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%d",i+1]];
        NSString *Par = [poleDict objectForKey:@"par"];//标准杆
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = [pDict objectForKey:@"r"];
        NSString *putters = [pDict objectForKey:@"pr"];
        
        NSDictionary *indexPoleData = @{
                                        @"Par":Par,
                                        @"gross":gross,
                                        @"putters":putters,
                                        };
        SingleMatchScrollView *scrollViewContentView = [[SingleMatchScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, _mainScrollView.height) data:indexPoleData];
        scrollViewContentView.indexLocation = [NSString stringWithFormat:@"%d",i];
        __weak __typeof(self)weakSelf = self;
        [scrollViewContentView setBlock:^(NSDictionary *indexDict) {
            weakSelf.indexPole = [indexDict objectForKey:@"index"];
            [weakSelf dataChange:indexDict];
        }];
        for (id obj in scrollViewContentView.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches = NO;
                break;
            }  
        }
        [_mainScrollView  addSubview:scrollViewContentView];
    }
}

//设置上下文字内容
-(void)createContentView{
    NSString *isSelectStr = [_totalDict objectForKey:@"isSelectKey"];//是否选择距标准杆
    NSArray *selectArray = [_totalDict objectForKey:@"selectArrayKey"];//已选球洞
    //计算总杆
    NSInteger totalNum = 0;
    NSInteger totalPutter = 0;
    for (NSInteger i = 0; i < 18; i++) {
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",i+1]];
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSString *Par = [poleDict objectForKey:@"par"];//标准杆
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = @"0";
        NSString *putter = @"0";
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",i+1]]) {
            gross = [pDict objectForKey:@"r"];
            putter = [pDict objectForKey:@"pr"];
        }
        totalNum = totalNum + [gross integerValue];
        if ([isSelectStr isEqualToString:@"1"]) {
            if ([gross integerValue]>0) {
                totalNum = totalNum - [Par integerValue];
            }
        }
    }
    
    NSString *grossTotalStr = [NSString stringWithFormat:@"%ld",totalNum];
    if ([isSelectStr isEqualToString:@"1"]&&totalNum>0) {
        grossTotalStr = [NSString stringWithFormat:@"+%ld",totalNum];
    }
    

    _GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, 64 + kHvertical(13), kWvertical(77), kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(24.0f) Title:grossTotalStr];
    [_GrossLabel sizeToFitSelf];
    
    _GrossLabel.x = kWvertical(38.5)-_GrossLabel.width/2;
    
    
    _PuttersLabel = [Factory createLabelWithFrame:CGRectMake(_GrossLabel.x_width, 64 + kHvertical(9), kWvertical(40), kHvertical(16)) textColor:rgba(51,51,51,1) fontSize:kHorizontal(11) Title:[NSString stringWithFormat:@"%ld",totalPutter]];
    
    UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(0, _GrossLabel.y_height, kWvertical(77), kHvertical(20)) textColor:rgba(118,118,118,1) fontSize:kHorizontal(14.0f) Title:@"总杆"];
    [_GrossLabel setTextAlignment:NSTextAlignmentCenter];
    [Gross setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_GrossLabel];
    [self.view addSubview:_PuttersLabel];
    [self.view addSubview:Gross];
    
    UIButton *PolePoorButton = [Factory createButtonWithFrame:CGRectMake(kWvertical(143) - kHvertical(8),ScreenHeight - kHvertical(92), kHvertical(32), kHvertical(32)) NormalImage:@"scoring距标准杆默认" SelectedImage:@"scoring距标准杆勾选" target:self selector:@selector(PolePoorButtonClick:)];
    if ([isSelectStr isEqualToString:@"1"]) {
        [self changeScrollViewData:PolePoorButton];
        PolePoorButton.selected = YES;
    }else{
        PolePoorButton.selected = NO;
    }
    [PolePoorButton setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(8), kHvertical(8), kHvertical(8), kHvertical(8))];
    
    UILabel *PolePoorLabel = [Factory createLabelWithFrame:CGRectMake(PolePoorButton.x_width, ScreenHeight - kHvertical(92), kWvertical(80), kHvertical(32)) textColor:rgba(169,169,169,1) fontSize:kHorizontal(16.0f) Title:@"距标准杆"];
    [PolePoorLabel sizeToFit];
    
    PolePoorButton.frame = CGRectMake((ScreenWidth - kWvertical(32) - PolePoorLabel.width)/2, ScreenHeight - kHvertical(92),kHvertical(32), kHvertical(32));
    PolePoorLabel.frame = CGRectMake(PolePoorButton.x_width, ScreenHeight - kHvertical(92), PolePoorLabel.width, kHvertical(32));
    
    
    
    CUSFlashLabel *label2 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight - kHvertical(35), ScreenWidth, kHvertical(20))];
    [label2 setText:@"左右滑动切换球洞"];
    [label2 setFont:[UIFont systemFontOfSize:kHorizontal(14.0f)]];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:rgba(169,169,169,1)];
    [label2 setSpotlightColor:[UIColor whiteColor]];
    [label2 setContentMode:UIViewContentModeTop];
    [label2 startAnimating];
    [self.view addSubview:PolePoorButton];
    [self.view addSubview:PolePoorLabel];
    [self.view addSubview:label2];
    
}
#pragma mark - initData

-(void)initViewData{
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
    //本地数据源
    NSDictionary *dataDict = (NSDictionary *)[self.diskCache objectForKey:disckCacheKey];

    _totalDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    
}

//按洞提交没洞数据
-(void)sendIndexPoleData:(NSInteger)index{
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
    if (index==18) {
        [self sendIndexPoleData:19];
    }
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",index-1];
    if ([indexStr isEqualToString:@"0"]) {
        indexStr = @"1";
    }else if ([indexStr isEqualToString:@"2"]){
        [self sendIndexPoleData:1];
    }
    if (![selectArray containsObject:indexStr]) {
        return;
    }
/*
    NSInteger totalNum = 0;
    NSInteger totalPutter = 0;
    for (NSInteger i = 0; i < 18; i++) {
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",i+1]];
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = @"0";
        NSString *putter = @"0";
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",i+1]]) {
            gross = [pDict objectForKey:@"r"];
            putter = [pDict objectForKey:@"pr"];
        }
        totalNum = totalNum + [gross integerValue];
        totalPutter = totalPutter + [putter integerValue];
    }
    _PuttersLabel.text = [NSString stringWithFormat:@"%ld",totalPutter];
    _GrossLabel.text = [NSString stringWithFormat:@"%ld",totalNum];
    [_GrossLabel sizeToFitSelf];
    _GrossLabel.x = kWvertical(38.5)-_GrossLabel.width/2;
    _PuttersLabel.x =_GrossLabel.x_width;
*/
    NSInteger indexPole = index;
    if (indexPole==1) {
        indexPole=2;
    }

    NSDictionary *indexPoleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",indexPole-1]];
    NSMutableArray *scoreArray = [NSMutableArray array];
    [scoreArray addObject:indexPoleDict];
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:scoreArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if ([jsonData length] > 0){
        jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"gid":_gid,
                           @"isftp":isSelect,
                           @"scores":jsonString
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=score",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {

        if (success) {
            
        }else{
            _pushErrow = YES;
        }
    }];
    
}
//提交18洞数据
-(void)sendTotalData{

    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
    NSArray *selectArray = [_totalDict objectForKey:@"selectArrayKey"];
    
    NSMutableArray *scoreArray = [NSMutableArray array];
    for (NSInteger i = 1; i<19; i++) {
        NSDictionary *indexPoleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",i]];
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",i]]) {
            [scoreArray addObject:indexPoleDict];
        }
    }
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:scoreArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if ([jsonData length] > 0){
        jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"gid":_gid,
                           @"isftp":isSelect,
                           @"scores":jsonString
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=score",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
        }
        
    }];

}

//距标准杆保存
-(void)changeScrollViewData:(UIButton *)sender{

    
//    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
//    [_totalDict setValue:_indexPole forKey:@"endPole"];
//    [self.diskCache setObject:_totalDict forKey:disckCacheKey];
    
    
    
    for (int i = 0; i<18; i++) {
        SingleMatchScrollView *SubView = _mainScrollView.subviews[i];
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%d",i+1]];
        NSString *Par = [poleDict objectForKey:@"par"];//标准杆
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = [pDict objectForKey:@"r"];
        NSString *putters = [pDict objectForKey:@"pr"];

        NSDictionary *indexPoleData = @{
                                        @"Par":Par,
                                        @"gross":gross,
                                        @"putters":putters,
                                        };
        
        [SubView changePolePoorButton:sender Data:indexPoleData];
    }

}

#pragma mark - Action
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    NSInteger indexPole = [_indexPole integerValue]+1;
    [self sendIndexPoleData:indexPole+1];
    
    NewStatisticsViewController *vc = [[NewStatisticsViewController alloc] init];
    [vc setBlock:^(NSString *poleNum) {
        CGFloat width = [poleNum integerValue]*ScreenWidth;
        [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }];
    vc.groupId = _gid;
    vc.loginNameId = userDefaultId;
    vc.nameUid = userDefaultUid;
    [self.navigationController pushViewController:vc animated:YES];

}
//记分数据变化
-(void)dataChange:(NSDictionary *)dict{
    
    NSInteger indexPole = [_indexPole integerValue]+1;
    NSMutableDictionary *poleDict = [NSMutableDictionary dictionaryWithDictionary:[_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",indexPole]]];
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];//已选球洞
    
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];//是否距标准杆
    NSString *par = [dict objectForKey:@"Par"];//标准杆
    NSString *putters = [dict objectForKey:@"Putters"];//推杆
    NSString *grossStr = [dict objectForKey:@"Gross"];//总杆
    NSString *selectIndexPole = [NSString stringWithFormat:@"%ld",[_indexPole integerValue]+1];
    if (![selectArray containsObject:selectIndexPole]) {
        if (selectArray.count==17) {
            _pushStatistics = true;
        }
        [selectArray addObject:selectIndexPole];
        [_totalDict setValue:selectArray forKey:@"selectArrayKey"];
    }
    
    
//    if ([isSelect isEqualToString:@"1"]) {
//        grossStr = [NSString stringWithFormat:@"%ld",[par integerValue] + [grossStr integerValue]];
//    }
    [poleDict setValue:par forKey:@"par"];

    
    NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
    NSMutableDictionary *pDict = [NSMutableDictionary dictionaryWithDictionary:pArray[0]] ;//当前用户数据
    
    [pDict setValue:grossStr forKey:@"r"];
    [pDict setValue:putters forKey:@"pr"];
    
    pArray = @[pDict];
    [poleDict setValue:pArray forKey:@"p"];
    
    [_totalDict setValue:poleDict forKey:[NSString stringWithFormat:@"pole%ld",indexPole]];

    
    NSInteger totalNum = 0;
    NSInteger totalPutter = 0;
    for (NSInteger i = 0; i < 18; i++) {
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",i+1]];
        NSString *indexPar = [poleDict objectForKey:@"par"];
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = @"0";
        NSString *putter = @"0";
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",i+1]]) {
            gross = [pDict objectForKey:@"r"];
            putter = [pDict objectForKey:@"pr"];
        }
        
        totalNum = totalNum + [gross integerValue];
        totalPutter = totalPutter + [putter integerValue];
        
        if ([isSelect isEqualToString:@"1"]) {
            if ([gross integerValue]>0) {
                totalNum = totalNum - [indexPar integerValue];
            }
        }
    }
    
    _PuttersLabel.text = [NSString stringWithFormat:@"%ld",totalPutter];
    _GrossLabel.text = [NSString stringWithFormat:@"%ld",totalNum];
    if ([isSelect isEqualToString:@"1"]&&totalNum>0) {
        _GrossLabel.text = [NSString stringWithFormat:@"+%ld",totalNum];
    }
    
    [_GrossLabel sizeToFitSelf];
    _GrossLabel.x = kWvertical(38.5)-_GrossLabel.width/2;
    _PuttersLabel.x =_GrossLabel.x_width;
    [_totalDict setValue:_indexPole forKey:@"endPole"];

    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
    
    
    [self.diskCache setObject:_totalDict forKey:disckCacheKey];
    

}


//是否距标准杆
-(void)PolePoorButtonClick:(UIButton *)btn{
    NSString *isSelect = @"1";
    if (btn.selected) {
        isSelect = @"0";
    }
    [userDefaults  setValue:isSelect forKey :@"isPoleSelect"];
    [_totalDict setValue:isSelect forKey:@"isSelectKey"];

    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
    [self.diskCache setObject:_totalDict forKey:disckCacheKey];
    
    
    NSInteger totalNum = 0;
    for (int i = 0; i<18; i++) {
        SingleMatchScrollView *SubView = _mainScrollView.subviews[i];
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%d",i+1]];
        NSString *Par = [poleDict objectForKey:@"par"];//标准杆
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSDictionary *pDict =pArray[0];//当前用户数据
        NSString *gross = [pDict objectForKey:@"r"];
        NSString *putters = [pDict objectForKey:@"pr"];
        
        NSDictionary *indexPoleData = @{
                                        @"Par":Par,
                                        @"gross":gross,
                                        @"putters":putters,
                                        };
        
        [SubView changePolePoorButton:btn Data:indexPoleData];
        
        totalNum = totalNum + [gross integerValue];
        if ([isSelect isEqualToString:@"1"]) {
            if ([gross integerValue]>0) {
                totalNum = totalNum - [Par integerValue];
            }
        }

    }
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
    _GrossLabel.text = [NSString stringWithFormat:@"%ld",totalNum];
    if ([isSelect isEqualToString:@"1"]&&totalNum>0) {
        _GrossLabel.text = [NSString stringWithFormat:@"+%ld",totalNum];
    }
    [_GrossLabel sizeToFitSelf];
    _GrossLabel.x = kWvertical(38.5)-_GrossLabel.width/2;
    _PuttersLabel.x =_GrossLabel.x_width;


}


//切换球洞
-(void)selectPole:(UITapGestureRecognizer *)tgp{
    if (!tgp.delaysTouchesBegan) {
        
        NSInteger indexPole = [_indexPole integerValue]+1;
//        _isFristPole=false;
        if (indexPole!=1) {
            [self sendIndexPoleData:indexPole+1];
        }
        
        NSMutableArray *ParArray = [NSMutableArray array];
        for (int i = 0; i<18; i++) {
            NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%d",i+1]];
            NSString *par = [poleDict objectForKey:@"par"];
            [ParArray addObject:par];
        }
        
        NSArray *selectArray = [_totalDict objectForKey:@"selectArrayKey"];
        
        
        NSArray *poleNameArray = [_totalDict objectForKey:@"poleNameKey"];
        
        NSDictionary *selectPoleData = @{
                                         @"index":_indexPole,
                                         @"selectArray":selectArray,
                                         @"ParArray":ParArray,
                                         @"poleNameArray":poleNameArray
                                         };
        
        SelectPoleView *vc = [[SelectPoleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) dataDict:selectPoleData];

        __weak typeof(self) weakself = self;
        vc.indexBlock = ^(NSInteger index){
            [weakself.mainScrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
        };
        [self.view addSubview:vc];

    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _begianPosition = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *poleNameArray = [_totalDict objectForKey:@"poleNameKey"];
    if ([scrollView isEqual:_mainScrollView]) {
        
        CGFloat contenOffset = scrollView.contentOffset.x;
        int page = contenOffset/scrollView.frame.size.width  +((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
        NSString *indexStr = [NSString stringWithFormat:@"%d",page];
        if (contenOffset < _begianPosition) {
            if (contenOffset<0) {
                _begianPosition = 0;
                [_mainScrollView setContentOffset:CGPointMake(ScreenWidth*18, 0) animated:NO];
            }
        }
        
        if ([_indexPole isEqualToString:indexStr]) {
            return;
        }
        if (page<0) {
            page = 0;
        }

        _indexPole = indexStr;
        UILabel *titlelabel =  [_titleView.subviews objectAtIndex:0];
        UIImageView *arrowView = [_titleView.subviews objectAtIndex:1];

        if (_pushStatistics) {
            _pushStatistics = false;
            NewStatisticsViewController *vc = [[NewStatisticsViewController alloc] init];
            [vc setBlock:^(NSString *poleNum) {
                CGFloat width = [poleNum integerValue]*ScreenWidth;
                [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:NO];
            }];
            vc.loginNameId = userDefaultId;
            vc.nameUid = userDefaultUid;
            vc.groupId = _gid;
            vc.status = 0;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            if (page == 18) {
                if (_begianPosition!=0) {
                    _begianPosition = -2000;
                    [_mainScrollView setContentOffset:CGPointMake(-ScreenWidth, 0) animated:NO];
                }
            }else{
                titlelabel.text = poleNameArray[page];
                [titlelabel sizeToFitSelf];
                arrowView.frame =  CGRectMake(titlelabel.x_width + 3, 41, 11, 6);
                _titleView.frame = CGRectMake((ScreenWidth - titlelabel.width - arrowView.width - 23)/2, 0, titlelabel.width + arrowView.width + 23, 64);
            }
        }
        if ([_indexPole integerValue]>=_lastPageIndex) {
            _lastPageIndex = [_indexPole integerValue];
            if (self.lastPageIndex==1) {
                [self sendIndexPoleData:self.lastPageIndex];
            }else{
                [self sendIndexPoleData:_lastPageIndex+1];
            }
        }else{
            _lastPageIndex = [_indexPole integerValue]-1;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigatio
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

