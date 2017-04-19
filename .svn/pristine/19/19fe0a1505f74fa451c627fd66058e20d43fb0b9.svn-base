//
//  MatchViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "MatchViewController.h"
#import "CUSFlashLabel.h"
#import "MatchScrollView.h"
#import "GroupStatisticsViewController.h"
#import "SelectPoleView.h"
#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"
@interface MatchViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView  *mainScrollView;

//当前洞号标题
@property(nonatomic,copy)UIView *titleView;
//总杆
//@property(nonatomic,copy)UILabel *GrossLabel;
//标准杆
@property(nonatomic,copy)UILabel  *ParLabel;
//当前比赛所有数据
@property(nonatomic,copy)NSMutableDictionary  *totalDict;
//当前洞号
@property(nonatomic,copy)NSString  *indexPole;
//选中球员
@property(nonatomic,assign)NSInteger  playerTag;
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

@end

@implementation MatchViewController



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
    }else{
    }
    
}

#pragma mark - createView
-(void)createView{
    [self createNavagationView];
    [self createPlayerView];
    [self createScrollView];
    [self createContentView];
    NSString *endPole = [_totalDict objectForKey:@"endPole"];
    CGFloat width = [endPole integerValue]*ScreenWidth;
    [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
}
//创建navagation
-(void)createNavagationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 10, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    
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
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:rightBtn];
    
    //    提示
    EAFeatureItem *top = [[EAFeatureItem alloc]initWithFocusRect:CGRectMake((ScreenWidth - kWvertical(75))/2, kHvertical(23), kWvertical(75), kHvertical(44)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
    [self.view addSubview:_titleView];
    
    [self.navigationController.view showWithFeatureItems:@[top,right,bottom] saveKeyName:@"more" inVersion:nil];

}
//创建球员界面
-(void)createPlayerView{
    
    NSInteger indexPole = [_indexPole integerValue]+1;
    NSArray *playerArray = [_totalDict objectForKey:@"playerArrayKey"];
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];
    
    NSMutableArray *playerImageArray = [NSMutableArray array];//球员头像
    NSMutableArray *playerNameArray = [NSMutableArray array];//球员名称
    NSMutableArray *parArray = [NSMutableArray array];//标准杆
    NSMutableArray *mPrArray = [NSMutableArray array];//推杆
    NSMutableArray *mRArray = [NSMutableArray array];//总杆
    for (int i =0; i<playerArray.count; i++) {
        NSDictionary *playerDict = playerArray[i];
        NSString *name = [playerDict objectForKey:@"nickname"];
        NSString *pic = [playerDict objectForKey:@"pic"];
        [playerNameArray addObject:name];
        [playerImageArray addObject:pic];
        
        NSInteger prNUm = 0;
        NSInteger rNUm = 0;
//        for (int j = 1; j<19; j++) {
            NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
            NSString *par = [poleDict objectForKey:@"par"];
            [parArray addObject:par];
            NSArray *pArray = [poleDict objectForKey:@"p"];
            NSDictionary *pDict = pArray[i];
            NSString *prStr = [pDict objectForKey:@"pr"];
            NSString *rStr = @"0";
            if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",[_indexPole integerValue]+1]]) {
                rStr = [pDict objectForKey:@"r"];
            }
        
            prNUm = prNUm + [prStr integerValue];
            rNUm = rNUm + [rStr integerValue];
//        }
        [mRArray addObject:[NSString stringWithFormat:@"%ld",rNUm]];
        [mPrArray addObject:[NSString stringWithFormat:@"%ld",prNUm]];
    }
    
    NSInteger playerNum = playerNameArray.count;
    
    
    UIView *playerBackGroundView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 64, ScreenWidth, kHvertical(220))];
    
    UIView *parBackView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(ScreenWidth/2 - kWvertical(70), kHvertical(10), kWvertical(140), kHvertical(40))];
    
    UILabel *parTital =[Factory createLabelWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(50), kHvertical(20.0f), kWvertical(100), kHvertical(28)) textColor:BlackColor fontSize:kHorizontal(20) Title:@"PAR"];
    _ParLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(50), kHvertical(20.0f), kWvertical(100), kHvertical(28)) textColor:BlackColor fontSize:kHorizontal(20) Title:[NSString stringWithFormat:@"%@",parArray[indexPole-1]]];
    [parTital sizeToFit];
    [_ParLabel sizeToFit];
    
    parTital.frame = CGRectMake((ScreenWidth - parTital.width - _ParLabel.width)/2, kHvertical(20), parTital.width, kHvertical(28));
    _ParLabel.frame = CGRectMake(parTital.x_width, parTital.y, _ParLabel.width, kHvertical(28));
    
    [_ParLabel setTextAlignment:NSTextAlignmentCenter];
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ParLabelClick)];
    parBackView.userInteractionEnabled = YES;
    [parBackView addGestureRecognizer:tgp];
    
    [playerBackGroundView addSubview:parBackView];
    [playerBackGroundView addSubview:parTital];
    [playerBackGroundView addSubview:_ParLabel];
    
    
    for (int i = 0; i < playerNum; i++) {
        UIButton *PlayerBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/playerNum*i, kHvertical(70), ScreenWidth/playerNum, kHvertical(150)) target:self selector:@selector(playerSelect:) Title:nil];
        PlayerBtn.tag = 100+i;
        PlayerBtn.backgroundColor = WhiteColor;
        
        UIImageView *headerView = [Factory createImageViewWithFrame:CGRectMake((PlayerBtn.width - kHvertical(64))/2, 0, kHvertical(64), kHvertical(64)) Image:nil];
        [headerView sd_setImageWithURL:[NSURL URLWithString:playerImageArray[i]]];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = kHvertical(32);
        headerView.layer.borderWidth = 3.0f;
        headerView.layer.borderColor = ClearColor.CGColor;
        
        headerView.alpha = 0.48;
        
        UILabel *playerNameLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(5), headerView.y_height + kHvertical(10), PlayerBtn.width - kWvertical(10), kHvertical(18)) textColor:rgba(186,186,186,1) fontSize:kHorizontal(13) Title:playerNameArray[i]];
        [playerNameLabel setTextAlignment:NSTextAlignmentCenter];
        
        //杆数和推杆
        UILabel *grossLabel = [Factory createLabelWithFrame:CGRectMake(0, playerNameLabel.y_height + kHvertical(7), PlayerBtn.width, kHvertical(42)) textColor:rgba(214,214,214,1) fontSize:kHorizontal(30) Title:mRArray[i]];
        grossLabel.tag = 105+i;
        UILabel *puttersLabel = [Factory createLabelWithFrame:CGRectMake(grossLabel.x, grossLabel.y, 0, kHvertical(21)) textColor:rgba(214,214,214,1) fontSize:kHorizontal(15) Title:mPrArray[i]];

        [grossLabel sizeToFit];
        [puttersLabel sizeToFit];
        
        grossLabel.frame = CGRectMake((PlayerBtn.width - grossLabel.width - puttersLabel.width)/2, playerNameLabel.y_height + kHvertical(7), grossLabel.width, kHvertical(42));
        puttersLabel.frame = CGRectMake(grossLabel.x_width, grossLabel.y, puttersLabel.width, kHvertical(21));
        
        
        if (i==0) {
            _playerTag = 100;
            headerView.layer.borderColor = rgba(53,141,227,1).CGColor;
            headerView.alpha = 1.0f;
            playerNameLabel.textColor = rgba(51,51,51,1);
            grossLabel.textColor = rgba(51,51,51,1);
            puttersLabel.textColor = rgba(51,51,51,1);
        }
        
        [PlayerBtn addSubview:headerView];
        [PlayerBtn addSubview:playerNameLabel];
        [PlayerBtn addSubview:grossLabel];
        [PlayerBtn addSubview:puttersLabel];
        
        [playerBackGroundView addSubview:PlayerBtn];
    }
    
    [self.view addSubview:playerBackGroundView];
    
    
    
}

//创建scrollView
-(void)createScrollView{
    
    UIScrollView *mainScreollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + kHvertical(220), ScreenWidth, ScreenHeight - 64 - kHvertical(220))];
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
        NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
        
        NSMutableArray *grossArray = [NSMutableArray array];
        NSMutableArray *puttersArray = [NSMutableArray array];
        
        for (int j = 0; j<pArray.count; j++) {
            NSDictionary *pDict =pArray[j];//当前用户数据
            NSString *gross = [pDict objectForKey:@"r"];
            NSString *putters = [pDict objectForKey:@"pr"];
            [grossArray addObject:gross];
            [puttersArray addObject:putters];
        }
        
        NSDictionary *indexPoleData = @{
                                        @"Par":Par,
                                        @"gross":grossArray[_playerTag-100],
                                        @"putters":puttersArray[_playerTag-100],
                                        };
        MatchScrollView *scrollViewContentView = [[MatchScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, _mainScrollView.height) data:indexPoleData];
        scrollViewContentView.indexLocation = [NSString stringWithFormat:@"%d",i];
        __weak __typeof(self)weakSelf = self;
        [scrollViewContentView setBlock:^(NSDictionary *indexDict) {
                weakSelf.indexPole = [indexDict objectForKey:@"index"];
                [weakSelf dataChange:indexDict];
                [weakSelf reloadPlayerData];
            
        }];
        
        [scrollViewContentView setChangeBLock:^(NSDictionary *indexDict) {
            [weakSelf reloadPlayerData];
        }];
        
        [_mainScrollView  addSubview:scrollViewContentView];
    }
}

//设置上下文字内容
-(void)createContentView{
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
    
    
    UIButton *PolePoorButton = [Factory createButtonWithFrame:CGRectMake(kWvertical(143) - kHvertical(8),ScreenHeight - kHvertical(92), kHvertical(32), kHvertical(32)) NormalImage:@"scoring距标准杆默认" SelectedImage:@"scoring距标准杆勾选" target:self selector:@selector(PolePoorButtonClick:)];
    PolePoorButton.selected = NO;
    if ([isSelect isEqualToString:@"1"]) {
        [self changeScrollViewData:PolePoorButton];
        PolePoorButton.selected = YES;
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
//当前球洞数据
-(void)initViewData{
    
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
    //本地数据源
    NSDictionary *dataDict = (NSDictionary *)[self.diskCache objectForKey:disckCacheKey];
    _playerTag = 100;
    
    _totalDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
}


//按洞提交没洞数据
-(void)sendIndexPoleData:(NSInteger)index{
    
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];
    
    if (index==18) {
        [self sendIndexPoleData:19];
    }
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",index-1];
    if ([indexStr isEqualToString:@"0"]) {
        indexStr = @"1";
    }else if ([indexStr isEqualToString:@"2"]){
        [self sendIndexPoleData:1];
    }
    if (![selectArray containsObject:indexStr]) {
        return;
    }
    
    
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
    
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



#pragma mark - Action
//
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//
-(void)rightBtnClick{
    NSInteger indexPole = [_indexPole integerValue]+1;
    [self sendIndexPoleData:indexPole+1];
    GroupStatisticsViewController *vc = [[GroupStatisticsViewController alloc] init];
    [vc setBlock:^(NSString *poleNum) {
        CGFloat width = [poleNum integerValue]*ScreenWidth;
        [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }];

    vc.groupId = _gid;
    vc.loginNameId = userDefaultId;
    vc.nameUid = userDefaultUid;
    vc.status = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
//标准杆点击
-(void)ParLabelClick{
    NSInteger parNum = [_ParLabel.text integerValue];
    
    switch (parNum) {
        case 3:{
            parNum++;
        }break;
        case 4:{
            parNum++;
        }break;
        case 5:{
            parNum = 3;
        }break;
        default:
            break;
    }
    _ParLabel.text = [NSString stringWithFormat:@"%ld",(long)parNum];
    
    MatchScrollView *subView = _mainScrollView.subviews[[_indexPole integerValue]];
    NSMutableDictionary *poleDict = [NSMutableDictionary dictionaryWithDictionary:[_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]]];
    NSString *Par = _ParLabel.text;//标准杆
    NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
    
    NSMutableArray *grossArray = [NSMutableArray array];
    NSMutableArray *puttersArray = [NSMutableArray array];
    
    for (int j = 0; j<pArray.count; j++) {
        NSDictionary *pDict =pArray[j];//当前用户数据
        NSString *gross = [pDict objectForKey:@"r"];
        NSString *putters = [pDict objectForKey:@"pr"];
        [grossArray addObject:gross];
        [puttersArray addObject:putters];
    }
    
    NSDictionary *indexPoleData = @{
                                    @"Par":Par,
                                    @"gross":grossArray[_playerTag-100],
                                    @"putters":puttersArray[_playerTag-100],
                                    };

    [subView refreshData:indexPoleData];
}

//更新用户信息

-(void)reloadPlayerData{
//    _playerTag
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];
    
    NSArray *playerArray = [_totalDict objectForKey:@"playerArrayKey"];
    //    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];//是否距标准杆
    NSMutableArray *playerImageArray = [NSMutableArray array];//球员头像
    NSMutableArray *playerNameArray = [NSMutableArray array];//球员名称
    NSMutableArray *parArray = [NSMutableArray array];//标准杆
    NSMutableArray *mPrArray = [NSMutableArray array];//推杆
    NSMutableArray *mRArray = [NSMutableArray array];//总杆
    NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
    NSString *par = [poleDict objectForKey:@"par"];

    for (int i =0; i<playerArray.count; i++) {
        NSDictionary *playerDict = playerArray[i];
        NSString *name = [playerDict objectForKey:@"nickname"];
        NSString *pic = [playerDict objectForKey:@"pic"];
        [playerNameArray addObject:name];
        [playerImageArray addObject:pic];
        
        NSInteger prNUm = 0;
        NSInteger rNUm = 0;
        if ([_indexPole integerValue]==18) {
            return;
        }
        [parArray addObject:par];
        NSArray *pArray = [poleDict objectForKey:@"p"];
        NSDictionary *pDict = pArray[i];
        NSString *prStr = [pDict objectForKey:@"pr"];
        NSString *rStr = @"0";
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",[_indexPole integerValue]+1]]) {
            rStr = [pDict objectForKey:@"r"];
        }
        prNUm = prNUm + [prStr integerValue];
        rNUm = rNUm + [rStr integerValue];
        [mRArray addObject:[NSString stringWithFormat:@"%ld",rNUm]];
        [mPrArray addObject:[NSString stringWithFormat:@"%ld",prNUm]];
    }

    NSInteger playerNum = playerNameArray.count;
    
    for (NSInteger i=0; i<playerNum; i++) {
        UIButton *slectBtn = (UIButton *)[self.view viewWithTag:100+i];
        UILabel *grossLabel = (UILabel *)[slectBtn.subviews objectAtIndex:3];
        UILabel *puttersLabel = (UILabel *)[slectBtn.subviews objectAtIndex:4];
        
        NSString *grossStr = mRArray[i];
        if (![grossStr isEqualToString:@"0"]) {
            NSString *isSelect =  [_totalDict objectForKey:@"isSelectKey"];
            if ([isSelect isEqualToString:@"1"]) {
                grossStr = [NSString stringWithFormat:@"%ld",[grossStr integerValue]-[par integerValue]];
                if ([grossStr integerValue]>0) {
                    grossStr = [NSString stringWithFormat:@"+%@",grossStr];
                }
            }
        }
        
        grossLabel.text = grossStr;
        puttersLabel.text =  mPrArray[i];
        
        CGFloat yy = grossLabel.y;
        [grossLabel sizeToFit];
        [puttersLabel sizeToFit];
        
        grossLabel.frame = CGRectMake((slectBtn.width  - grossLabel.width - puttersLabel.width)/2, yy , grossLabel.width, kHvertical(42));
        puttersLabel.frame = CGRectMake(grossLabel.x_width, grossLabel.y, puttersLabel.width, kHvertical(21));
    }
    
    
}



//球员选中
-(void)playerSelect:(UIButton *)sender{
    _playerTag = sender.tag;
    
    NSArray *playerArray = [_totalDict objectForKey:@"playerArrayKey"];
    NSMutableArray *playerNameArray = [NSMutableArray array];//球员名称
    
    for (int i =0; i<playerArray.count; i++) {
        NSDictionary *playerDict = playerArray[i];
        NSString *name = [playerDict objectForKey:@"nickname"];
        [playerNameArray addObject:name];
    }
    NSInteger playerNum = playerNameArray.count;
    
    for (NSInteger i=0; i<playerNum; i++) {
        UIButton *totalBtn = (UIButton *)[self.view viewWithTag:100+i];
        UIImageView *headerView = (UIImageView *)[totalBtn.subviews objectAtIndex:1];
        UILabel *playerNameLabel = (UILabel *)[totalBtn.subviews objectAtIndex:2];
        UILabel *grossLabel   = (UILabel *)[totalBtn.subviews objectAtIndex:3];
        UILabel *puttersLabel = (UILabel *)[totalBtn.subviews objectAtIndex:4];
        
        headerView.layer.borderColor = ClearColor.CGColor;
        headerView.alpha = 0.48;
        playerNameLabel.textColor = rgba(186,186,186,1);
        grossLabel.textColor = rgba(214,214,214,1);
        puttersLabel.textColor = rgba(214,214,214,1);
        
        if ([sender isEqual:totalBtn]) {
            headerView.layer.borderColor = rgba(53,141,227,1).CGColor;
            headerView.alpha = 1.0f;
            playerNameLabel.textColor = rgba(51,51,51,1);
            grossLabel.textColor = rgba(51,51,51,1);
            puttersLabel.textColor = rgba(51,51,51,1);
        }
    }
    [self changeScrollViewData:@"1"];
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
    
    [self changeScrollViewData:btn];
    [self reloadPlayerPoleData];
}

//更新用户当前洞数据
-(void)reloadPlayerPoleData{

    NSString *isSelect =  [_totalDict objectForKey:@"isSelectKey"];
    NSDictionary *indexPoleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
    NSArray *playerArray = [indexPoleDict objectForKey:@"p"];
    NSInteger playerNum = playerArray.count;
    NSString *par = [indexPoleDict objectForKey:@"par"];
    
    for (int i = 0; i<playerNum; i++) {
        
        UIButton *slectBtn = (UIButton *)[self.view viewWithTag:100+i];
        UILabel *grossLabel = (UILabel *)[slectBtn.subviews objectAtIndex:3];
        UILabel *puttersLabel = (UILabel *)[slectBtn.subviews objectAtIndex:4];

        NSDictionary *playerDict = playerArray[i];
        NSString *poleStr = [playerDict objectForKey:@"r"];
        if (![poleStr isEqualToString:@"0"]) {
        if ([isSelect isEqualToString:@"1"]) {
            
            poleStr = [NSString stringWithFormat:@"%ld",[poleStr integerValue]-[par integerValue]];
            if ([poleStr integerValue]>0) {
                poleStr = [NSString stringWithFormat:@"+%@",poleStr];
            }
        }
        grossLabel.text = poleStr;
        
        CGFloat yy = grossLabel.y;
        [grossLabel sizeToFit];
        [puttersLabel sizeToFit];
        
        grossLabel.frame = CGRectMake((slectBtn.width  - grossLabel.width - puttersLabel.width)/2, yy , grossLabel.width, kHvertical(42));
        puttersLabel.frame = CGRectMake(grossLabel.x_width, grossLabel.y, puttersLabel.width, kHvertical(21));
        }

    }
    
    
    
}




/**
 *  更新scrollViewData
 *
 *  @param sender 为@"button"时表示只更新距标准杆
 */
-(void)changeScrollViewData:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        for (int i = 0; i<18; i++) {
            MatchScrollView *SubView = _mainScrollView.subviews[i];
            
            NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%d",i+1]];
            NSString *Par = [poleDict objectForKey:@"par"];//标准杆
            NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
            NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
            
            NSMutableArray *grossArray = [NSMutableArray array];
            NSMutableArray *puttersArray = [NSMutableArray array];
            
            
            for (int j = 0; j<pArray.count; j++) {
                NSDictionary *pDict =pArray[j];//当前用户数据
                NSString *gross = [pDict objectForKey:@"r"];
                NSString *putters = [pDict objectForKey:@"pr"];
                [grossArray addObject:gross];
                [puttersArray addObject:putters];
            }
            NSDictionary *indexPoleData = @{
                                            @"Par":Par,
                                            @"gross":grossArray[_playerTag-100],
                                            @"putters":puttersArray[_playerTag-100],
                                            @"isSelectStr":isSelect,
                                            };
            
            [SubView changePolePoorButton:btn Data:indexPoleData];
        }
        if (btn.selected) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    }else{
        if ([_indexPole isEqualToString:@"18"]) {
            return;
        }
        MatchScrollView *subView = _mainScrollView.subviews[[_indexPole integerValue]];
        NSDictionary *poleDict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
        NSString *Par = [poleDict objectForKey:@"par"];//标准杆
        NSArray *pArray = [poleDict objectForKey:@"p"];//球员数组
        NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];
        
        NSMutableArray *grossArray = [NSMutableArray array];
        NSMutableArray *puttersArray = [NSMutableArray array];
        
        for (int j = 0; j<pArray.count; j++) {
            NSDictionary *pDict =pArray[j];//当前用户数据
            NSString *gross = [pDict objectForKey:@"r"];
            NSString *putters = [pDict objectForKey:@"pr"];
            [grossArray addObject:gross];
            [puttersArray addObject:putters];
        }
        
        NSDictionary *indexPoleData = @{
                                        @"Par":Par,
                                        @"gross":grossArray[_playerTag-100],
                                        @"putters":puttersArray[_playerTag-100],
                                        @"isSelectStr":isSelect,
                                        };
        
        [subView refreshData:indexPoleData];
    }
}

//记分数据变化
-(void)dataChange:(NSDictionary *)dict{
    NSInteger playerIndex = _playerTag -100;
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_totalDict objectForKey:@"selectArrayKey"]];//已选球洞
    
    NSMutableDictionary *poleDict = [NSMutableDictionary dictionaryWithDictionary:[_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]]];//当前球洞的数据
    NSString *par = [dict objectForKey:@"Par"];//标准杆
    NSMutableArray *pArray = [NSMutableArray arrayWithArray:[poleDict objectForKey:@"p"]];//球员数组
    NSString *isSelect = [_totalDict objectForKey:@"isSelectKey"];//是否距标准杆
    NSDictionary *pDict =pArray[playerIndex];//当前用户数据
    NSString *uid = [pDict objectForKey:@"uid"];
    //更改过的数据
    NSString *grossStr = [dict objectForKey:@"Gross"];
    NSString *putters = [dict objectForKey:@"Putters"];

//    if ([grossStr isEqualToString:@"0"]&&![putters isEqualToString:@"0"]) {
//        grossStr = par;
//        if ([isSelect isEqualToString:@"1"]) {
//            grossStr = @"0";
//        }
//    }
    
    if (![grossStr isEqualToString:@"0"]) {
        NSString *selectIndexPole = [NSString stringWithFormat:@"%ld",[_indexPole integerValue]+1];
        if (![selectArray containsObject:selectIndexPole]) {
            if (selectArray.count==17) {
                _pushStatistics = true;
            }
            [selectArray addObject:selectIndexPole];
            [_totalDict setValue:selectArray forKey:@"selectArrayKey"];
        }
    }
    
    
//    if ([isSelect isEqualToString:@"1"]&&![grossStr isEqualToString:@"0"]) {
//        grossStr = [NSString stringWithFormat:@"%ld",[par integerValue] + [grossStr integerValue]];
//    }
    NSDictionary *afterChangeDict = @{
                                      @"pr":putters,
                                      @"r":grossStr,
                                      @"uid":uid
                                      };
    
    [pArray replaceObjectAtIndex:playerIndex withObject:afterChangeDict];
    [poleDict setValue:pArray forKey:@"p"];
    [poleDict setValue:par forKey:@"par"];
    [_totalDict setValue:poleDict forKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
    
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,_gid];
    [_totalDict setValue:_indexPole forKey:@"endPole"];
    
    [self.diskCache setObject:_totalDict forKey:disckCacheKey];
    
    [self reloadPlayerData];
}


//切换球洞
-(void)selectPole:(UITapGestureRecognizer *)tgp{
    if (!tgp.delaysTouchesBegan) {
        NSInteger indexPole = [_indexPole integerValue]+1;
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
        int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
        NSString *indexStr = [NSString stringWithFormat:@"%d",page];
        if (contenOffset < _begianPosition) {
            if (contenOffset<0) {
                _begianPosition = 0;
                [_mainScrollView setContentOffset:CGPointMake(ScreenWidth*18, 0) animated:NO];
            }
        }
        if (page<0||[_indexPole isEqualToString:indexStr]) {
            return;
        }
        _indexPole = indexStr;
        
        [self reloadPlayerData];
        UIButton *selectBtn = (UIButton *)[self.view viewWithTag:100];
        [self playerSelect:selectBtn];

        if (_pushStatistics) {
            _pushStatistics = false;
            GroupStatisticsViewController *vc = [[GroupStatisticsViewController alloc] init];
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
                UILabel *titlelabel =  [_titleView.subviews objectAtIndex:0];
                UIImageView *arrowView = [_titleView.subviews objectAtIndex:1];
                titlelabel.text = poleNameArray[page];
                [titlelabel sizeToFitSelf];
                arrowView.frame =  CGRectMake(titlelabel.x_width + 3, 41, 11, 6);
                _titleView.frame = CGRectMake((ScreenWidth - titlelabel.width - arrowView.width - 23)/2, 0, titlelabel.width + arrowView.width + 23, 64);
                NSDictionary *Dict = [_totalDict objectForKey:[NSString stringWithFormat:@"pole%ld",[_indexPole integerValue]+1]];
                NSMutableDictionary *indexPoleData = [NSMutableDictionary dictionaryWithDictionary:Dict];
                _ParLabel.text = [NSString stringWithFormat:@"%@",[indexPoleData objectForKey:@"par"]];
            }
        }

        if (_lastPageIndex==17) {
            _lastPageIndex = 0;
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


#pragma mark - Others
/**
 *  设置不同label显示大小字体
 *
 *  @param Text       显示文字
 *  @param selectRang 选中改变文字的Rang
 *  @param normolFont 默认大小
 *  @param changFont  选中的大小
 *
 *  @return 改变过的文字
 */
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)Text range:(NSRange )selectRang normolFont:(CGFloat )normolFont changFont:(CGFloat)changFont
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:Text];
    UIFont *font = [UIFont systemFontOfSize:normolFont];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, selectRang.location)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:changFont] range:NSMakeRange(selectRang.location,selectRang.length)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(selectRang.location+selectRang.length, Text.length - (selectRang.location + selectRang.length))];
    return attrString;
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

