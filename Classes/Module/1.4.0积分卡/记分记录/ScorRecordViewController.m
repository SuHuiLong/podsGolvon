//
//  ScorRecordViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/10/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ScorRecordViewController.h"
#import "ScorRecordTableViewCell.h"
#import "LoopProgressView.h"
#import "UserBallParkViewController.h"
#import "PublicBenefitViewController.h"
#import "ScorRecordModel.h"
#import "ScorRecordListModel.h"
#import "SingleMatchViewController.h"
#import "MatchViewController.h"
#import "NewStatisticsViewController.h"
#import "GroupStatisticsViewController.h"
#import "ScoreCardViewController.h"
#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"
#import "SimpleInterest.h"
#import "NewStatisticsViewController.h"

#import "TabBarViewController.h"

@interface ScorRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

//导航栏颜色 no为透明 yes白色
@property(nonatomic,assign)BOOL  blackOrWhite;


@property(nonatomic,copy)UITableView  *mainTableView;
@property(nonatomic,copy)UIView  *mainTableViewBackView;

//环形视图
@property(nonatomic,copy)LoopProgressView  *custom;
//总数据源
@property(nonatomic,strong)NSArray  *DataArray;
//顶部导航
@property(nonatomic, copy)UIView  *naviView;
//返回按钮
@property(nonatomic,strong)UIButton *leftBtn;
//二维码按钮
@property(nonatomic,copy)UIButton  *rightBtn;
//标题
@property(nonatomic,copy)UILabel  *titlelabel;
//头部视图
@property(nonatomic,copy)NSDictionary  *headerDataDict;
//是否显示动画
@property(nonatomic,assign)BOOL  Animation;
//等待页面
@property (strong, nonatomic) UIView    *placeView;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation ScorRecordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    CGFloat yYY = kHvertical(214) - 64;
    if (_mainTableView.contentOffset.y<yYY) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    self.navigationController.navigationBarHidden = YES;
    
    [_mainTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *firstSubView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:firstSubView];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)CreateView{
    [self createTableView];
    [self createNavagationView];
    [self createPromptView];
    
}

//创建navagation
-(void)createNavagationView{
    _naviView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, 64)];
    _naviView.alpha = 0;
    _leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"白色统一返回"] target:self selector:@selector(leftBtnClick) Title:nil];
    [_leftBtn setImage:[UIImage imageNamed:@"BlackBack"] forState:UIControlStateSelected];
    _leftBtn.selected = NO;
    
    _rightBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth-90, 0, 90, 64) image:[UIImage imageNamed:@"scoring我的二维码白色"] target:self selector:@selector(rightBtnClick) Title:nil];
    [_rightBtn setImage:[UIImage imageNamed:@"scoring我的二维码黑色"] forState:UIControlStateSelected];
    _rightBtn.selected = NO;
    
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 34)];
    
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 59, 13, 13)];
    
    _titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:WhiteColor fontSize:18 Title:@"记分记录"];
    _titlelabel.backgroundColor = ClearColor;
    [_titlelabel setFont:[UIFont boldSystemFontOfSize:18]];
    [_titlelabel setTextAlignment:NSTextAlignmentCenter];
    
    
    [self.view addSubview:_naviView];
    [self.view addSubview:_leftBtn];
    [self.view addSubview:_titlelabel];
}

//等待
-(void)createProgress{
    
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
}
-(void)createTableView{
    _mainTableViewBackView = [Factory createViewWithBackgroundColor:rgba(85,162,252,1) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = ClearColor;
    [mainTableView registerClass:[ScorRecordTableViewCell class] forCellReuseIdentifier:@"ScorRecordTableViewCell"];
    [self.view addSubview:_mainTableViewBackView];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

-(void)createPromptView{
    
    if ([_nameUid isEqualToString:userDefaultUid]) {
        
        [self createDrawArc];
    }
}

-(void)createDrawArc{
    EAFeatureItem *left;
    EAFeatureItem *right;
    
    if (ScreenHeight < 667) {
        
        left = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(kWvertical(40), kHvertical(87), kWvertical(86), kWvertical(86)) focusCornerRadius:kWvertical(43) focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        left.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        left.introduce = @"点击进入排行榜";
        left.labelFrame = CGRectMake(kWvertical(40), kHvertical(208), kWvertical(137), kHvertical(36));
        left.indicatorImageName = @"top_short";
        left.imageFrame = CGRectMake(kWvertical(65), kHvertical(179), kWvertical(23), kWvertical(23));
        
        right = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(ScreenWidth - kWvertical(40)-kWvertical(80), kHvertical(87), kWvertical(86), kWvertical(86)) focusCornerRadius:kWvertical(43) focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        right.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        right.introduce = @"点击进入球场列表";
        right.labelFrame = CGRectMake(ScreenWidth - kWvertical(176), kHvertical(243), kWvertical(143), kHvertical(36));
        right.indicatorImageName = @"top_long";
        right.imageFrame = CGRectMake(ScreenWidth - kWvertical(100), kHvertical(179), kWvertical(54), kWvertical(54));
        
    }else{
        
        left = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(kWvertical(29), kHvertical(87), kWvertical(80), kWvertical(80)) focusCornerRadius:kWvertical(40) focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        left.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        left.introduce = @"点击进入排行榜";
        left.labelFrame = CGRectMake(kWvertical(34), kHvertical(203), kWvertical(137), kHvertical(36));
        left.indicatorImageName = @"top_short";
        left.imageFrame = CGRectMake(kWvertical(57), kHvertical(174), kWvertical(23), kWvertical(23));
        
        
        
        right = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(ScreenWidth - kWvertical(29)-kWvertical(80), kHvertical(87), kWvertical(80), kWvertical(80)) focusCornerRadius:kWvertical(40) focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        right.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        right.introduce = @"点击进入球场列表";
        right.labelFrame = CGRectMake(ScreenWidth - kWvertical(176), kHvertical(243), kWvertical(143), kHvertical(36));
        right.indicatorImageName = @"top_long";
        right.imageFrame = CGRectMake(ScreenWidth - kWvertical(90), kHvertical(174), kWvertical(54), kWvertical(54));
        
    }
    
    [self.navigationController.view showWithFeatureItems:@[left,right] saveKeyName:@"scorrecord" inVersion:nil];
    
}


#pragma mark ---- LoadData
-(void)initViewData{
    [self loadHeaderData];
}

-(void)initData{
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_placeView];

    [self requestWithScoreData:@"0"];
}

//请求头部数据
-(void)loadHeaderData{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_nameUid
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=memberreport",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _headerDataDict = [NSDictionary dictionaryWithDictionary:data];
                [_mainTableView reloadData];
                [_mainTableView reloadData];
            }
        }
    }];
}

//请求记分信息数据
-(void)requestWithScoreData:(NSString *)year{
    [self createProgress];

    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_nameUid,
                           @"year":year,
//                           @"page":@"1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=gamelist",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        _placeView = [UIView new];
        [_HUD removeFromSuperview];
        [_placeView removeFromSuperview];
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *keysArray = [data allKeys];
                NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
                NSWidthInsensitiveSearch|NSForcedOrderingSearch;
                NSComparator sort = ^(NSString *obj1,NSString *obj2){
                    NSRange range = NSMakeRange(0,obj1.length);
                    return [obj2 compare:obj1 options:comparisonOptions range:range];
                };
                NSMutableArray *mAllletters = [NSMutableArray arrayWithArray: [keysArray sortedArrayUsingComparator:sort]];
                NSLog(@"字符串数组排序结果%@",mAllletters);
                NSMutableArray *mDataArray = [NSMutableArray array];
                
                if ([year isEqualToString:@"0"]) {
                    _DataArray = [NSArray array];
                    for (NSInteger i = 0; i<keysArray.count; i++) {
                        NSDictionary *yearDict = [data objectForKey:mAllletters[i]];
                        ScorRecordModel *model = [ScorRecordModel modelWithDictionary:yearDict];
                        model.year = mAllletters[i];
                        model.hidenList = true;
                        NSInteger year = [self getNowYear];
                        if ([model.year integerValue] == year) {
                            model.hidenList = false;
                        }
                        [mDataArray addObject:model];
                    }
                }else{
                    for (NSInteger i = 0; i<keysArray.count; i++) {
                        NSString *yearKey = mAllletters[i];
                        ScorRecordModel *model = _DataArray[i];
                        if ([yearKey isEqualToString:year]) {
                            NSDictionary *yearDict = [data objectForKey:yearKey];
                            model = [ScorRecordModel modelWithDictionary:yearDict];
                            model.year = year;
                        }
                        [mDataArray addObject:model];
                    }
                }
                _DataArray = [NSArray arrayWithArray:mDataArray];
            }
        }
        if (!_mainTableView) {
            [self CreateView];
        }
        //        [_mainTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        [_mainTableView reloadData];
    }];
}

//删除
-(void)deleatIndexrow:(NSString *)groupId{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_logInNameId,
                           @"gid":groupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@/scoreapi.php?func=delgroup",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                if ([code isEqualToString:@"0"]) {
                    
                    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
                    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,groupId];
                    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
                    
                    NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
                    [gidArray removeObject:groupId];
                    if (gidArray.count>0) {
                        [diskCache setObject:gidArray forKey:userGidKey];
                        [diskCache removeObjectForKey:disckCacheKey];
                    }
//                    [self requestWithScoreData];
                }
            }
        }
    }];
}

//分享点击
-(void)clickToshare:(NSIndexPath *)indexPath{
    
    
    ScorRecordModel *model = _DataArray[indexPath.section-1];
    NSArray *listArray = model.list;
    ScorRecordListModel *model2 = listArray[indexPath.row];
    [self viewScoreCard:model2];
    
}

//记分人请求本地不存在记分数据
-(void)initLocationData:(NSString *)groupId{
    
    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,groupId];
    if ([diskCache containsObjectForKey:userGidKey]) {
        NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
        if ([gidArray containsObject:groupId]) {
            NSDictionary *totalDict = (NSDictionary *)[diskCache objectForKey:disckCacheKey];
            NSArray *playerArray = [totalDict objectForKey:@"playerArrayKey"];
            if (playerArray.count==1) {
                SingleMatchViewController *vc = [[SingleMatchViewController alloc] init];
                vc.gid = groupId;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }else{
                MatchViewController *vc = [[MatchViewController alloc] init];
                vc.gid = groupId;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_nameUid,
                           @"gid":groupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=getgroupdetail",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                NSString *begainTime = [data objectForKey:@"time"];   //创建时间
                NSString *gameduration = [NSString stringWithFormat:@"%@",[data objectForKey:@"gameduration"]];//比赛用时
                NSString *jluid      = [data objectForKey:@"jluid"];  //记录人
                NSString *status     = [data objectForKey:@"status"]; //0：进行1：有效2：无效记分3：未完成
                NSString *isftp      = [data objectForKey:@"isftp"];  //是否距标准杆0，1
                NSDictionary *qinfo  = [data objectForKey:@"qinfo"];  //球场信息
                NSArray  *order      = [data objectForKey:@"order"];  //前9后9
                NSArray  *menbers    = [data objectForKey:@"members"];//球员
                NSArray  *holes      = [data objectForKey:@"holes"];  //已完成球洞
                NSArray  *secores    = [data objectForKey:@"secores"];//已完成成绩
                NSArray *parinfo     = [data objectForKey:@"parinfo"];//标准杆
                
                
                NSMutableArray *orderArray = [NSMutableArray array];
                if (orderArray.count >= 9 ) {
                    for (int i = 0; i<order.count; i++) {
                        for (int j = 1; j<10; j++) {
                            [orderArray addObject:[NSString stringWithFormat:@"%@%d",order[i],j]];
                        }
                    }
                }else{
                
                    for (int i = 1; i<19; i++) {
                        [orderArray addObject:[NSString stringWithFormat:@"第%d洞",i]];
                    }
                }
                NSMutableArray *playersArray = [NSMutableArray array];
                for (int i = 0; i<menbers.count; i++) {
                    NSDictionary *playerDict = menbers[i];
                    
                    NSDictionary *indexPlayerDict = @{
                                                      @"nameId":[playerDict objectForKey:@"uid"],
                                                      @"pic":[playerDict objectForKey:@"avator"],
                                                      @"nickname":[playerDict objectForKey:@"nickname"],
                                                      @"tcolor":[playerDict objectForKey:@"tcolor"]
                                                      };
                    [playersArray addObject:indexPlayerDict];
                }
                if (holes==nil) {
                    holes = [NSArray array];
                }
                
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setValue:isftp forKey:@"isSelectKey"];
                [mDict setValue:qinfo forKey:@"qinfo"];
                [mDict setValue:playersArray forKey:@"playerArrayKey"];
                [mDict setValue:jluid forKey:@"jluid"];
                [mDict setValue:holes forKey:@"selectArrayKey"];
                [mDict setValue:orderArray forKey:@"poleNameKey"];
                [mDict setValue:begainTime forKey:@"begainTime"];
                [mDict setValue:gameduration forKey:@"gameduration"];
                [mDict setValue:order forKey:@"poleOrderArray"];
                
                
                NSMutableArray *parArray = [NSMutableArray arrayWithArray:@[@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3"]];//标准杆
                if (parinfo.count>0) {
                    if (parinfo.count==9) {
                        for (int j = 0; j<2; j++) {
                            for (int i = 0; i<9; i++) {
                                NSDictionary *parDict = parinfo[i];
                                NSString *par = [parDict objectForKey:@"par"];
                                NSString *hn = [parDict objectForKey:@"hn"];
                                [parArray replaceObjectAtIndex:[hn integerValue]+9*j-1 withObject:par];
                            }
                        }
                    }else{
                        for (int i = 0; i<18; i++) {
                            NSDictionary *parDict = parinfo[i];
                            NSString *par = [parDict objectForKey:@"par"];
                            NSString *hn = [parDict objectForKey:@"hn"];
                            [parArray replaceObjectAtIndex:[hn integerValue]-1 withObject:par];
                        }
                    }
                    
                }
                
                for (int i = 1; i<19; i++) {
                    NSMutableArray *requestArray = [NSMutableArray array];
                    for (int j = 0; j<menbers.count; j++) {
                        NSDictionary *requestDict = [NSDictionary dictionary];
                        NSDictionary *playerDict = menbers[j];
                        NSString *indexUid = [playerDict objectForKey:@"uid"];//当前uid
                        NSString *polePar = @"3";
                        
                        
                        for (int m = 0; m<secores.count; m++) {
                            NSDictionary *poleDict = secores[m];
                            NSString *hn = [poleDict objectForKey:@"hn"];
                            NSString *par = [poleDict objectForKey:@"par"];
                            [parArray replaceObjectAtIndex:[hn integerValue]-1 withObject:par];
                        }
                        
                        
                        
                        NSMutableArray *poleNumArray = [NSMutableArray array];
                        for (NSDictionary *indexDict in secores) {
                            
                            NSString *hn = [indexDict objectForKey:@"hn"];
                            [poleNumArray addObject:hn];
                        }
                        NSString *iStr = [NSString stringWithFormat:@"%d",i];
                        if ([poleNumArray containsObject:iStr]) {
                            NSArray *poleIndexPlayerArray = [NSArray array];
                            for (NSDictionary *indexDict in secores) {
                                NSString *hn = [indexDict objectForKey:@"hn"];
                                int ii = i;
                                if ([hn integerValue]==ii) {
                                    poleIndexPlayerArray = [indexDict objectForKey:@"p"];
                                }
                            }

                            NSDictionary *poleIndexDict = poleIndexPlayerArray[0];
                            if (poleIndexPlayerArray.count>j) {
                                poleIndexDict = poleIndexPlayerArray[j];
                            }
                            NSString *pr = [poleIndexDict objectForKey:@"pushrod"];
                            if ([pr integerValue]<0) {
                                pr = @"0";
                            }
                            requestDict = @{
                                            @"pr":pr,
                                            @"r":[poleIndexDict objectForKey:@"score"],
                                            @"uid":[poleIndexDict objectForKey:@"uid"]
                                            };
                            
                        }else{
                            requestDict = @{
                                            @"pr":@"0",
                                            @"r":polePar,
                                            @"uid":indexUid,
                                            };
                        }
                        [requestArray addObject:requestDict];
                    }
                    NSDictionary *poleDict = @{
                                               @"p":requestArray,
                                               @"hn":[NSString stringWithFormat:@"%d",i],
                                               @"par":parArray[i-1]
                                               };
                    [mDict setValue:poleDict forKey:[NSString stringWithFormat:@"pole%d",i]];
                
                }
                if ([status isEqualToString:@"0"]||[status isEqualToString:@"3"] ){
                    if ([jluid isEqualToString:userDefaultUid]) {
                        
                        [diskCache setObject:mDict forKey:disckCacheKey];
                        
                        
                        if (playersArray.count==1) {
                            SingleMatchViewController *vc = [[SingleMatchViewController alloc] init];
                            vc.gid = groupId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            MatchViewController *vc = [[MatchViewController alloc] init];
                            vc.gid = groupId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }
                }else{
                    NSInteger vcStatus = 0;
                    switch ([status integerValue]) {
                        case 0:
                            vcStatus = 1;
                            break;
                        case 1:
                            vcStatus = 3;
                            break;
                        case 2:
                            vcStatus = 2;
                            break;
                        case 3:
                            vcStatus = 1;
                            break;
                            
                        default:
                            break;
                    }
                    if (playersArray.count==1) {
                        NewStatisticsViewController *vc = [[NewStatisticsViewController alloc] init];
                        vc.loginNameId = _logInNameId;
                        vc.nameUid = _nameUid;
                        vc.groupId = groupId;
                        vc.isLoadDta  = YES;
                        vc.status = vcStatus;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        GroupStatisticsViewController *vc = [[GroupStatisticsViewController alloc] init];
                        vc.loginNameId = _logInNameId;
                        vc.nameUid = _nameUid;
                        vc.groupId = groupId;
                        vc.isLoadDta  = YES;
                        vc.status = vcStatus;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        }
    }];
}


#pragma mark - Action
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    
}
//进入记分卡详情
-(void)viewScoreCard:(ScorRecordListModel *)model2{
    
    NSString *groupId = model2.gid;
    NSString *jiuser= model2.jiuid;
    NSString *playerNum = model2.gnum;
    NSString *statue = model2.status;
    if ([jiuser isEqualToString:userDefaultUid]&&([statue integerValue]==3||[statue integerValue]==0)) {
        [self initLocationData:groupId];
    }else{
        NSInteger vcStatus = 0;
        switch ([statue integerValue]) {
            case 0:
                vcStatus = 1;
                break;
            case 1:
                vcStatus = 3;
                break;
            case 2:
                vcStatus = 2;
                break;
            case 3:
                vcStatus = 1;
                break;
                
            default:
                break;
        }
        
        if ([playerNum integerValue]==1) {
            
            NewStatisticsViewController *vc = [[NewStatisticsViewController alloc] init];
            vc.loginNameId = _logInNameId;
            vc.nameUid = _nameUid;
            vc.groupId = groupId;
            vc.isLoadDta = YES;
            vc.status = vcStatus;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            GroupStatisticsViewController *vc = [[GroupStatisticsViewController alloc] init];
            vc.loginNameId = _logInNameId;
            vc.nameUid = _nameUid;
            vc.groupId = groupId;
            vc.isLoadDta = YES;
            vc.status = vcStatus;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//开始比赛
-(void)GoStart{
    
//    UINavigationController *recordController = self.tabBarController.childViewControllers[2];
//    if (recordController) {
//        [recordController popToRootViewControllerAnimated:NO];
//    }
//    self.tabBarController.selectedIndex = 2;
//    
//    TabBarViewController *customTabBarontroller = (TabBarViewController*)self.tabBarController;
//    [customTabBarontroller.button setImage:[UIImage imageNamed:@"NavigationBar_ScoreCardSelected"] forState:UIControlStateNormal];
//    
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    
}
//点击获取比赛记录
-(void)getDetailFromSection:(NSInteger)section{
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:_DataArray];
    ScorRecordModel *model = mArray[section];
    NSString *year = model.year;
    
    if (model.list.count==0) {
        [self requestWithScoreData:year];
    }else{
        if (model.hidenList) {
            model.hidenList = false;
        }else{
            model.hidenList = true;
        }
        [mArray replaceObjectAtIndex:section withObject:model];
        [_mainTableView reloadData];
    }
    
}


#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_DataArray) {
        return _DataArray.count+1;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    ScorRecordModel *model = _DataArray[section-1];
    NSArray *listArray =  model.list;
    BOOL hidenList = model.hidenList;
    if (hidenList) {
        return 0;
    }
    return listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(68);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        BOOL hasGame = false;
        for (int i = 0; i<_DataArray.count; i++) {
            ScorRecordModel *model = _DataArray[i];
            NSString *totalgames = model.totalgames;
            if ([totalgames integerValue]>0) {
                hasGame = true;
            }
        }
        if (!hasGame) {
            return ScreenHeight;
        }
        NSString *personalbest = [_headerDataDict objectForKey:@"personalbest"];
        if ([personalbest isEqualToString:@"0"]) {
            return kHvertical(296);
        }
        
        return kHvertical(336);
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    ScorRecordModel *model = _DataArray[section-1];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    if (section>1||(tableView.numberOfSections==2&&![model.year isEqualToString:currentDateStr])){
        if (!model.hidenList) {
            return kHvertical(101);
        }
        return kHvertical(98);
    }
    return kHvertical(35);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScorRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScorRecordTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ScorRecordModel *model = _DataArray[indexPath.section-1];
    NSArray *listArray = model.list;
    ScorRecordListModel *model2 = listArray[indexPath.row];
    [cell relayoutWithDictionary:model2];
    if ([model2.status isEqualToString:@"1"]) {
        if (![_nameUid isEqualToString:userDefaultUid]) {
            cell.underwayShareLabel.hidden = YES;
            cell.underwayShare.hidden = YES;
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (_headerDataDict==nil) {
            return nil;
        }
        //白色 0.5 0.4
        NSArray *headerNameArray = @[@"场次(场)",@"球场(个)"];
        NSArray *headerDataArray = @[[_headerDataDict objectForKey:@"totalgames"],[_headerDataDict objectForKey:@"totalcourse"]];
        NSString *charity = [_headerDataDict objectForKey:@"charity"];
        NSString *bestgid = [_headerDataDict objectForKey:@"bestgid"];
        NSString *personalbest = [_headerDataDict objectForKey:@"personalbest"];
        NSArray *topArray = @[@"平均推杆：",@"抓鸟：",@"标ON率："];
        NSString *avgpushrod = [_headerDataDict objectForKey:@"avgpushrod"];
        if ([avgpushrod isEqualToString:@"-1"]) {
            avgpushrod = @"0";
        }
        NSArray *topDataArray = @[avgpushrod,[_headerDataDict objectForKey:@"birdnum"], [_headerDataDict objectForKey:@"biaoonrate"]];
        
        UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(kHvertical(298)))];
        //蓝色背景
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(214));
        [backView.layer addSublayer:gradientLayer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(__bridge id)rgba(85,162,252,1).CGColor,
                                 (__bridge id)rgba(53,141,227,1).CGColor];
        gradientLayer.locations = @[@(0.0f) ,@(1.0f)];
        
        
        //场次&&球场
        for (int i = 0; i<2; i++) {
            UILabel *Name = [Factory createLabelWithFrame:CGRectMake(kWvertical(48), kHvertical(106), kWvertical(60), kHvertical(17)) textColor:WhiteColor fontSize:kHorizontal(12) Title:headerNameArray[i]];
            Name.font = [UIFont fontWithName:Light size:kHorizontal(13)];
            [Name sizeToFit];
            
            if (i==1) {
                Name.frame = CGRectMake((ScreenWidth - Name.width - kWvertical(42))*i, Name.y, Name.width, Name.height);
            }
            
            UILabel *NumStr = [Factory createLabelWithFrame:CGRectMake((ScreenWidth-kWvertical(96)-Name.width)*i , Name.y_height, kWvertical(96)+Name.width, kHvertical(38)) textColor:WhiteColor fontSize:kHorizontal(27) Title:headerDataArray[i]];
            [NumStr setTextAlignment:NSTextAlignmentCenter];
            
            
            __weak __typeof(self)weakSelf = self;
            UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                if (i==0) {
                    __block NSUInteger rankVCIndex = self.tabBarController.selectedIndex;
                    NSArray<UINavigationController *> *navVCArray = self.tabBarController.viewControllers;
                    
                    [navVCArray enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([[obj.viewControllers firstObject] isKindOfClass:[ScoreCardViewController class]])  {
                            rankVCIndex = idx;
                        }
                    }];
                    
                    SimpleInterest *manger = [SimpleInterest sharedSingle];
                    manger.supportNameID = [[NSMutableString alloc]initWithString:_nameUid];
                    manger.isFromA = YES;
                    
                    self.tabBarController.selectedIndex = rankVCIndex;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                } else {
                    UserBallParkViewController *vc = [[UserBallParkViewController alloc] init];
                    vc.name_id = _nameUid;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            NumStr.userInteractionEnabled = YES;
            [NumStr addGestureRecognizer:tgp];
            
            NumStr.font = [UIFont fontWithName:Light size:kHorizontal(27)];
            
            [backView addSubview:Name];
            [backView addSubview:NumStr];
        }
        
        _custom = [[LoopProgressView alloc]initWithFrame:CGRectMake((ScreenWidth - kHvertical(112))/2, kHvertical(78), kHvertical(112), kHvertical(112))];
        
        if (!_Animation) {
            _Animation = true;
            _custom.progress = 2;
        }else{
            _custom.progress = 0;
        }
        _custom.poleNumber = [_headerDataDict objectForKey:@"avgrod"];
        [backView addSubview:_custom];
        
        BOOL hasGame = false;
        for (int i = 0; i<_DataArray.count; i++) {
            ScorRecordModel *model = _DataArray[i];
            NSString *totalgames = model.totalgames;
            if ([totalgames integerValue]>0) {
                hasGame = true;
            }
        }
        if (!hasGame) {
            
            UIView *nerverBackView = [Factory createViewWithBackgroundColor:[UIColor clearColor] frame:CGRectMake(0, kHvertical(214), ScreenWidth, ScreenHeight - kHvertical(214))];
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"零记录icon"]];
            imageView.frame = CGRectMake((ScreenWidth - kWvertical(101))/2, kHvertical(81), kHvertical(101), kHvertical(101));
            UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, imageView.y_height+kHvertical(8), ScreenWidth, kHvertical(21)) textColor:rgba(58,60,72,1) fontSize:kHorizontal(15) Title:@"你还未记录过一场打球记分"];
            descLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *BottmLabel = [Factory createLabelWithFrame:CGRectMake(0, descLabel.y_height+kHvertical(8), ScreenWidth, kHvertical(16)) textColor:rgba(184,185,189,1) fontSize:kHorizontal(11) Title:@"与球友一起打球记分，参与榜单排行"];
            BottmLabel.textAlignment = NSTextAlignmentCenter;
            
            
            
//            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            Btn.frame = CGRectMake((ScreenWidth - kWvertical(126))/2, BottmLabel.y_height + kHvertical(31), kWvertical(126), kHvertical(32));
//            [Btn setTitle:@"打球记分" forState:UIControlStateNormal];
//            [Btn setTitleColor:localColor forState:UIControlStateNormal];
//            Btn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//            Btn.layer.masksToBounds = YES;
//            Btn.layer.cornerRadius = 2;
//            Btn.layer.borderWidth = 1;
//            Btn.layer.borderColor = [localColor CGColor];
//            
//            [Btn addTarget:self action:@selector(GoStart) forControlEvents:UIControlEventTouchUpInside];
//            Btn.backgroundColor = WhiteColor;
//            
            
            [nerverBackView addSubview:imageView];
            [nerverBackView addSubview:descLabel];
            [nerverBackView addSubview:BottmLabel];
//            [nerverBackView addSubview:Btn];
            [backView addSubview:nerverBackView];
            
            return backView;
        }
        
        
        
        
        //平均推杆&&抓鸟&&标ON率
        for (int i = 0; i<3; i++) {
            UILabel *topLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i , kHvertical(214) + kHvertical(19), ScreenWidth/3 , kHvertical(18)) textColor:BlackColor fontSize:kHorizontal(13) Title:[NSString stringWithFormat:@"%@%@",topArray[i],topDataArray[i]]];
            [topLabel setTextAlignment:NSTextAlignmentCenter];
            [backView addSubview:topLabel];
            if (i>0) {
                UIView *LinView = [Factory createViewWithBackgroundColor:rgba(226,226,226,1) frame:CGRectMake(ScreenWidth/3*i - 0.5, kHvertical(214) +kHvertical(23), 1, kHvertical(11))];
                [backView addSubview:LinView];
            }
        }
        
        UIView *Line = [Factory createViewWithBackgroundColor:rgba(226,226,226,1)  frame:CGRectMake(0, kHvertical(263), ScreenWidth, 0.5)];
        [backView addSubview:Line];
        
        
        UIImageView *PublicImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(45),Line.y_height + kHvertical(11), kWvertical(97), kHvertical(13)) Image:[UIImage imageNamed:@"scoring球童公益基金"]];
        
        UILabel *TotalContribute = [Factory createLabelWithFrame:CGRectMake(0, Line.y_height + kHvertical(9), kWvertical(100), kHvertical(17)) textColor:rgba(131,131,131,1) fontSize:kHorizontal(12) Title:@"累计捐助 ¥"];
        [TotalContribute sizeToFit];
        TotalContribute.frame = CGRectMake(ScreenWidth - TotalContribute.width - kWvertical(91), Line.y_height + kHvertical(9), TotalContribute.width, kHvertical(17));
        UILabel *Moneylabel = [Factory createLabelWithFrame:CGRectMake(TotalContribute.x_width, TotalContribute.y, kWvertical(100), TotalContribute.height) textColor:rgba(53,141,227,1) fontSize:kHorizontal(12) Title:charity];
        
        UIView *LevelLinView = [Factory createViewWithBackgroundColor:rgba(226,226,226,1) frame:CGRectMake(ScreenWidth/2 - 0.5, Line.y_height +kHvertical(12), 1, kHvertical(12))];
        [backView addSubview:PublicImageView];
        [backView addSubview:TotalContribute];
        [backView addSubview:Moneylabel];
        [backView addSubview:LevelLinView];
        
        UIView *pushView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, Line.y, ScreenWidth, kHvertical(33))];
        __weak __typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            PublicBenefitViewController *vc = [[PublicBenefitViewController alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [pushView addGestureRecognizer:tap];
        [backView addSubview:pushView];
        
        if ([personalbest isEqualToString:@"0"]) {
            return backView;
        }
        
        UIView *bestView = [Factory createViewWithBackgroundColor:[UIColor clearColor] frame:CGRectMake(0, Line.y_height + kHvertical(37), ScreenWidth, kHvertical(33))];
        bestView.userInteractionEnabled = YES;

        
        UITapGestureRecognizer *bestViewTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            ScorRecordListModel *model = [[ScorRecordListModel alloc] init];
            model.gid = [_headerDataDict objectForKey:@"bestgid"];
            model.status = @"1";
            model.gnum = [_headerDataDict objectForKey:@"bestgid_mutiplayer"];
            [weakSelf viewScoreCard:model];
//            for (ScorRecordModel *model in _DataArray) {
//                NSArray *listArray = model.list;
//                for (ScorRecordListModel *model2 in listArray) {
//                    NSString *groupId = model2.gid;
//                    if ([groupId isEqualToString:bestgid]) {
//                        [self viewScoreCard:model2];
//                    }
//                }
//            }
            
        }];
        [bestView addGestureRecognizer:bestViewTap];
        
        UIView *BestLineView = [Factory createViewWithBackgroundColor:rgba(226,226,226,1) frame:CGRectMake(0, Line.y_height + kHvertical(37), ScreenWidth, 1)];
        
        UIImageView *BestImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(102),BestLineView.y_height + kHvertical(9), kHvertical(20), kHvertical(20)) Image:[UIImage imageNamed:@"scoring最好成绩"]];
        
        UILabel *BestLabel = [Factory createLabelWithFrame:CGRectMake(BestImageView.x_width + kWvertical(6), BestLineView.y_height + kHvertical(10),kWvertical(20), kHvertical(18)) textColor:rgba(85,85,85,1) fontSize:kHorizontal(13) Title:@"最佳成绩"];
        [BestLabel sizeToFitSelf];
        
        UILabel *BestNumLabel = [Factory createLabelWithFrame:CGRectMake(BestLabel.x_width + kWvertical(8), BestLineView.y_height + kHvertical(9), kWvertical(20), kHvertical(20)) textColor:rgba(53,141,227,1) fontSize:kHorizontal(14) Title:personalbest];
        [BestNumLabel sizeToFitSelf];
        
        UILabel *PoleLabel = [Factory createLabelWithFrame:CGRectMake(BestNumLabel.x_width + kWvertical(2), BestLineView.y_height +kHvertical(11), kWvertical(20), kHvertical(16)) textColor:rgba(85,85,85,1) fontSize:kHorizontal(11) Title:@"杆"];
        [PoleLabel sizeToFitSelf];
        
        
        BestImageView.frame = CGRectMake((ScreenWidth - PoleLabel.x_width + kWvertical(102))/2, BestImageView.y, BestImageView.width, BestImageView.height);
        BestLabel.frame = CGRectMake(BestImageView.x_width + kWvertical(6), BestLabel.y, BestLabel.width, BestLabel.height);
        BestNumLabel.frame = CGRectMake(BestLabel.x_width + kWvertical(8), BestNumLabel.y, BestNumLabel.width, BestNumLabel.height);
        PoleLabel.frame = CGRectMake(BestNumLabel.x_width + kWvertical(2), BestLabel.y, BestLabel.width, BestLabel.height);
        
        
        [backView addSubview:BestLineView];
        [backView addSubview:BestImageView];
        [backView addSubview:BestLabel];
        [backView addSubview:BestNumLabel];
        [backView addSubview:PoleLabel];
        
        
        [backView addSubview:bestView];
        return backView;
        
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    
    ScorRecordModel *model = _DataArray[section-1];
    
    UIView *backView = [Factory createViewWithBackgroundColor:GPRGBAColor(238, 239, 241, 1) frame:CGRectMake(0, 0, ScreenWidth, kHvertical(34))];
    
//    if (section>1||(tableView.numberOfSections==2&&![model.year isEqualToString:currentDateStr])){
    if (section>1) {
        
        if (!model.hidenList) {
            backView.height = kHvertical(101);
        }
        backView.height = kHvertical(98);
    }

    
    UIImageView *colorArrow = [Factory createImageViewWithFrame:CGRectMake( kWvertical(9),   kHvertical(15), kWvertical(8), kHvertical(5)) Image:[UIImage imageNamed:@"scoring向下角标"]];
    if (model.hidenList) {
        colorArrow.frame = CGRectMake(kWvertical(13), kHvertical(11), kWvertical(6), kHvertical(11));
        [colorArrow setImage:[UIImage imageNamed:@"message_notifi_arrow"]];
    }
    
    
    backView.userInteractionEnabled = YES;
    
    __weak typeof(self) weakself = self;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself getDetailFromSection:section-1];
    }];
    
    [backView addGestureRecognizer:tag];
    

    NSString *completegames = model.completegames;
    
    UILabel *StatisticsLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(25), 0, kWvertical(80), kHvertical(35)) textColor:rgba(72,72,72,1) fontSize:kHorizontal(12) Title:[NSString stringWithFormat:@"记分统计(%@)",completegames]];
    
    UILabel *timeLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2, 0,ScreenWidth/2 - kWvertical(14), kHvertical(34)) textColor:rgba(72,72,72,1) fontSize:kHorizontal(12) Title:[NSString stringWithFormat:@"%@年",model.year]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    
    
    UIView *whiteColorView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(34), ScreenWidth, kHvertical(65))];
    NSArray *titleArray = @[@"最佳成绩",@"平均杆",@"标ON率"];
    NSArray *dataArray = @[model.personalbest,model.avgrod,model.biaoonrate];
    for (int i = 0; i<3; i++) {
        UILabel *dataLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i, kHvertical(12), ScreenWidth/3, kHvertical(28)) textColor:rgba(72,72,72,1) fontSize:kHorizontal(20.f) Title:dataArray[i]];
        UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i, dataLabel.y_height, ScreenWidth/3, kHvertical(16)) textColor:rgba(72,72,72,1) fontSize:kHorizontal(11) Title:titleArray[i]];
        
        [dataLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [whiteColorView addSubview:dataLabel];
        [whiteColorView addSubview:titleLabel];
    }
    
    
    
    [backView addSubview:colorArrow];
    [backView addSubview:StatisticsLabel];
    [backView addSubview:timeLabel];
    NSInteger year = [self getNowYear];

    if (model.year.integerValue<year) {
        [backView addSubview:whiteColorView];
    }
    return backView;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    ScorRecordModel *model = _DataArray[indexPath.section-1];
    NSArray *listArray = model.list;
    ScorRecordListModel *model2 = listArray[indexPath.row];
//    NSString *groupId = model2.gid;
    NSString *status = model2.status;
    NSString *jiuid = model2.jiuid;
    
    if ([jiuid isEqualToString:userDefaultUid]&&(![status isEqualToString:@"1"])) {
        return YES;
    }
    if ([_nameUid isEqualToString:userDefaultUid]&&[status isEqualToString:@"2"]) {
        return YES;
    }
//    if (![jiuid isEqualToString:userDefaultUid]&&[status isEqualToString:@"0"]) {
//        return FALSE;
//    }
//    if ([status isEqualToString:@"1"]) {
//        return FALSE;
//    }
//    
//    if ([_nameUid isEqualToString:userDefaultUid]) {
//        return TRUE;
//    }
    return FALSE;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<1) {
        return nil;
    }
    ScorRecordModel *model = _DataArray[indexPath.section-1];
    NSArray *listArray = model.list;
    ScorRecordListModel *model2 = listArray[indexPath.row];
    NSString *groupId = model2.gid;
    NSString *status = model2.status;
    NSString *jiuid = model2.jiuid;
    
    NSString *title = @"删除";
    
    if ((![jiuid isEqualToString:userDefaultUid])&&[status isEqualToString:@"0"]) {
        title = @"退出";
    }
    
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if ([status isEqualToString:@"1"]) {
            [self clickToshare:indexPath];
        }else{
            ScorRecordModel *ScorModel = _DataArray[0];
            NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:ScorModel.list];
            [mDataArray removeObjectAtIndex:indexPath.row];
            ScorModel.list = [NSArray arrayWithArray:mDataArray];
            _DataArray = @[ScorModel];
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.mainTableView reloadData];
            });
            
            [self deleatIndexrow:groupId];
        }
    }];
    NSArray *arr = @[layTopRowAction1];
    return arr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScorRecordModel *model = _DataArray[indexPath.section-1];
    NSArray *listArray = model.list;
    ScorRecordListModel *model2 = listArray[indexPath.row];
    [self viewScoreCard:model2];
}


#pragma mark - scrollView

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<ScreenHeight/2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            });
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    CGFloat header = 64;//这个header其实是section1 的header到顶部的距离
    
    CGFloat yYY = kHvertical(214) - 64;
    if (scrollView.contentOffset.y<yYY) {
        _naviView.alpha = scrollView.contentOffset.y/yYY;
//        if (scrollView.contentOffset.y<0) {
//            _mainTableView.backgroundColor = rgba(85,162,252,1);
//        }else{
//            _mainTableView.backgroundColor = WhiteColor;
//        }
        if (!_blackOrWhite) {
            _blackOrWhite = true;
            _rightBtn.selected = NO;
            _leftBtn.selected = NO;
            _titlelabel.textColor = WhiteColor;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            });
        }
        
    }else if(scrollView.contentOffset.y>yYY){
        if (_blackOrWhite) {
            _blackOrWhite = false;
            _naviView.alpha = 1.0f;
            _rightBtn.selected = YES;
            _leftBtn.selected = YES;
            _titlelabel.textColor = BlackColor;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
    
    
}

-(NSInteger)getNowYear{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    return year;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
