//
//  NewStartScoringViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/8.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewStartScoringViewController.h"
#import "NewStartScrolTableViewCell.h"
#import "AddGolferViewController.h"
#import "MatchViewController.h"
#import "SingleMatchViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeGenerator.h"
#import "ScorRecordViewController.h"

#import "MyCodeViewController.h"
#import "ScoringPlayerCollectionViewCell.h"
#import "PublishSelectAddressViewController.h"
#import "NearParkModel.h"
#import "GolfersModel.h"
#import "SignUpViewController.h"
#import "BallParkViewController.h"
#import "GroupStatisticsViewController.h"

#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"
#import "TabBarViewController.h"

#import "BMKLocationService.h"
@interface NewStartScoringViewController ()<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource,BMKLocationServiceDelegate>{
    //心跳请求
    dispatch_source_t _timer;
}
//球场
@property(nonatomic,strong)UILabel  *parklabel;
//箭头
@property(nonatomic,copy)UIImageView *arrowView;
//附近球场数组
@property(nonatomic,strong)NSMutableArray  *nearParkArray;
//球场列表
@property(nonatomic,copy)UITableView  *mainTableView;
//球场列表背景
@property(nonatomic,copy)UIView *tableviewBackView;
//球员collectionView
@property(nonatomic,copy)UICollectionView  *PlayerCollectionView;
//出发按钮
@property(nonatomic,copy)UIButton *startButton;
//球员数组
@property(nonatomic,strong)NSMutableArray  *playerArray;
//球场model
@property(nonatomic,strong)NearParkModel  *parkModel;
//选洞按钮
@property(nonatomic,copy)UIView  *poleButtonBackView;
//前9洞
@property(nonatomic,copy)NSString  *topPole;
//后9洞
@property(nonatomic,copy)NSString  *bottomPole;
//是否显示继续记分
@property(nonatomic,assign)BOOL  isViewContinue;
//是否继续
@property(nonatomic,copy)GolvonAlertView    *alertView;
//移除提示
@property(nonatomic,copy)GolvonAlertView    *removeAlertView;
//是否查询用户信息
@property(nonatomic,assign)BOOL reloadPlayerData;
//是否开始心跳
@property(nonatomic,assign)BOOL endTimer;

//菊花加载
@property(nonatomic,copy)MBProgressHUD *HUD;
//地图管理类
@property (strong, nonatomic) BMKLocationService  *locationManager;
//根据距离更新位置信息
@property(nonatomic, assign) CLLocationDistance distanceFilter;

@end
@implementation NewStartScoringViewController

-(NSMutableArray *)nearParkArray{
    if (_nearParkArray==nil) {
        _nearParkArray = [NSMutableArray array];
    }
    return _nearParkArray;
}

-(NSMutableArray *)playerArray{
    if (_playerArray==nil) {
        
        NSString *nickname = [userDefaults objectForKey:@"nickname"];
        NSString *avator = [userDefaults objectForKey:@"pic"];
        NSString *nameuid = userDefaultUid;
        NSDictionary *selfDict = @{
                                   @"nickname":nickname,
                                   @"avator":avator,
                                   @"uid":nameuid,
                                   };
        
        NSDictionary *dict = @{
                               @"nickname":@"添加",
                               @"avator":@"scoring队伍添加",
                               @"uid":@""
                               };
        GolfersModel *model = [[GolfersModel alloc] init];
        [model configData:selfDict];
        model.isSelect = YES;
        GolfersModel *model2 = [[GolfersModel alloc] init];
        [model2 configData:dict];
        model2.isSelect = YES;
        
        
        _playerArray = [NSMutableArray arrayWithArray:@[model,model2]];
    }
    return _playerArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self resevNotic];
    if (!_isViewContinue) {
        [self viewBoolContinue];
    }
    _endTimer = false;
    //心跳请求
    [self timerLoadUserData];
    //出发按钮激活
    _startButton.userInteractionEnabled = YES;
    //请求附近球场
    if (!_reloadPlayerData) {
        [self loadNearParkData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建定位
    [self createLocation];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _isViewContinue = NO;
//    _reloadPlayerData = true;
    _endTimer = true;
    dispatch_source_cancel(_timer);
    [self.locationManager stopUserLocationService];
    self.navigationController.navigationBarHidden = NO;

}

#pragma mark- 接收自定义推送消息
-(void)resevNotic{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//接收透传
-(void)networkDidReceiveMessage:(NSNotification *)noti{
    NSLog(@"%@",noti);
    id dict = noti.userInfo;
    NSDictionary *extras = [dict objectForKey:@"extras"];
    NSString *PushToStat = [extras objectForKey:@"JPushCode"];
    if ([PushToStat isEqualToString:@"12"]) {
        [self loadUserData];
    }
}


#pragma mark - createUI
-(void)createView{
    _topPole = @"";
    _bottomPole = @"";
    [self createNavagationView];
    [self createMainView];
}
//创建导航栏
-(void)createNavagationView{
    
    UIView *navagationView = [Factory createViewWithBackgroundColor:rgba(249,249,249,1) frame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:navagationView];
    
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, 25) textColor:BlackColor fontSize:18.0f Title:@"记分"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    
    [navagationView addSubview:titleLabel];
    
    UIButton *leftButton = [Factory createButtonWithFrame:CGRectMake(0, 20, 44, 44) image:[UIImage imageNamed:@"scoring记录"] target:self selector:@selector(leftButtonClick) Title:nil];
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(12, 15, 11, 8)];
    [navagationView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"scoring扫描"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(ScreenWidth-64, 10, 64, 64);
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *rightButton = [Factory createButtonWithFrame:CGRectMake(ScreenWidth-44, 20, 44, 44) image:[UIImage imageNamed:@"scoring扫描"] target:self selector:@selector(rightButtonClick) Title:nil];
//    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(12, 15, 11, 8)];
    [navagationView addSubview:rightButton];
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    [self.view addSubview:lineView];
    
    [self createPrompt];
}
-(void)createPrompt{
    EAFeatureItem *top;
    EAFeatureItem *bottom;
    if (ScreenHeight < 667) {
        
        top = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(ScreenWidth - kWvertical(60), kHvertical(27), kWvertical(44), kHvertical(42)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        top.imageFrame = CGRectMake(ScreenWidth - kWvertical(50), kHvertical(70), kWvertical(23), kWvertical(23));
        top.indicatorImageName = @"top_short";
        top.labelFrame = CGRectMake(kWvertical(233), kHvertical(100), kWvertical(137), kHvertical(54));
        top.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        top.introduce = @"点击扫描加入球友记分";
        
        
        bottom = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(kWvertical(14), kHvertical(225), kWvertical(82), kWvertical(82)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        bottom.imageFrame = CGRectMake(kWvertical(55), kHvertical(320), kWvertical(23), kHvertical(23));
        bottom.indicatorImageName = @"top_short";
        bottom.labelFrame = CGRectMake(kWvertical(14), kHvertical(348), kWvertical(109), kHvertical(35));
        bottom.introduce = @"我是记分人";
        
    }else{
        
        top = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(ScreenWidth - kWvertical(54), kHvertical(23), kWvertical(42), kHvertical(32)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        top.imageFrame = CGRectMake(kWvertical(346), kHvertical(65), kWvertical(23), kWvertical(23));
        top.indicatorImageName = @"top_short";
        top.labelFrame = CGRectMake(kWvertical(233), kHvertical(98), kWvertical(137), kHvertical(54));
        top.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
        top.introduce = @"点击扫描加入球友记分";
    
        
        bottom = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(kWvertical(14), kHvertical(210), kWvertical(82), kWvertical(82)) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        bottom.imageFrame = CGRectMake(kWvertical(55), kHvertical(295), kWvertical(23), kHvertical(23));
        bottom.indicatorImageName = @"top_short";
        bottom.labelFrame = CGRectMake(kWvertical(14), kHvertical(323), kWvertical(109), kHvertical(35));
        bottom.introduce = @"我是记分人";
        
    }
    [self.navigationController.view showWithFeatureItems:@[top,bottom] saveKeyName:@"first" inVersion:nil];
}
//创建主界面
-(void)createMainView{
    self.view.backgroundColor = rgba(238, 239, 241, 1);
    //球场
    UIButton *parkBackView = [Factory createButtonWithFrame:CGRectMake(0, 64.5, ScreenWidth, kHvertical(45)) target:self selector:@selector(viewNearPark) Title:nil];
    parkBackView.backgroundColor = rgba(255,255,255,1);
    [self.view addSubview:parkBackView];
    _parklabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(14), ScreenWidth, kHvertical(20)) fontSize:kHvertical(14.f) Title:@"请选择球场"];
    [parkBackView addSubview:_parklabel];
    
    _arrowView = [Factory createImageViewWithFrame:CGRectMake(_parklabel.x_width + kWvertical(6), kHvertical(21), kWvertical(9), kHvertical(5)) Image:[UIImage imageNamed:@"scoring向下角标"]];
    [parkBackView addSubview:_arrowView];
    
    [self parkSizeToFit];
    
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(0, kHvertical(45)-0.5, ScreenWidth, 0.5)];
    
    [parkBackView addSubview:lineView];
    //球洞
    UIView *poleView = [Factory createViewWithBackgroundColor:rgba(255,255,255,1) frame:CGRectMake(0, parkBackView.y_height+kHvertical(5), ScreenWidth, kHvertical(90))];
    [self.view addSubview:poleView];
    _poleButtonBackView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(90))];
    
    
    
    [poleView addSubview:_poleButtonBackView];
    UIView *poloLineView = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(kWvertical(16), kHvertical(45), ScreenWidth-kWvertical(16), 0.5)];
    [poleView addSubview:poloLineView];
    //添加球员&&二维码
    UIView *QRCode = [Factory createViewWithBackgroundColor:rgba(255,255,255,1) frame:CGRectMake(0, poleView.y_height+kHvertical(5), ScreenWidth, ScreenHeight - poleView.y_height - kHvertical(5) - kHvertical(89) - 49)];
    [self.view addSubview:QRCode];
    
    //UICollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kWvertical(10), 0, ScreenWidth-kWvertical(20), kWvertical(89)) collectionViewLayout:layout];
    
    mainCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[ScoringPlayerCollectionViewCell class] forCellWithReuseIdentifier:@"PublishCollectionViewCellId"];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [mainCollectionView setScrollEnabled:NO];
    [QRCode addSubview:mainCollectionView];
    _PlayerCollectionView = mainCollectionView;
    
    
    UIView *QRCodeLineView = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(0, kHvertical(89), ScreenWidth, 0.5f)];
    [QRCode addSubview:QRCodeLineView];
    
    CGFloat QRCodeImageViewWidth = QRCode.height - kHvertical(115) - kHvertical(47);
    UIImageView *QRCodeImageView = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth- QRCodeImageViewWidth)/2, kHvertical(115), QRCodeImageViewWidth,QRCodeImageViewWidth) Image:nil];
    
    NSString *nameId = userDefaultId;
    nameId = [nameId substringToIndex:4];
    
    NSString *QRCodeLabelStr = [NSString stringWithFormat:@"golvon%@%@",nameId,userDefaultUid];
    
    UIImage *Fristimage = [QRCodeGenerator qrImageForString:QRCodeLabelStr imageSize:(int)QRCodeImageView.frame.size.width];
    QRCodeImageView.image = Fristimage;
    
    [QRCode addSubview:QRCodeImageView];
    
    UILabel *QRCodeLabel = [Factory createLabelWithFrame:CGRectMake(0, QRCodeImageView.y_height+kHvertical(9), ScreenWidth, kHvertical(17)) textColor:rgba(171,171,171,1) fontSize:kHorizontal(12.0f) Title:@"扫二维码加入我的组队"];
    [QRCodeLabel setTextAlignment:NSTextAlignmentCenter];
    [QRCode addSubview:QRCodeLabel];
    
    _startButton = [Factory createButtonWithFrame:CGRectMake(kWvertical(21), QRCode.y_height + kHvertical(19), ScreenWidth-kWvertical(42), kHvertical(40)) titleFont:16.0f textColor:rgba(255,255,255,1) backgroundColor:rgba(53,141,227,0.98) target:self selector:@selector(startClick:) Title:@"出发"];
    [_startButton setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(9), 0, kHvertical(9), 0)];
    _startButton.layer.masksToBounds = YES;
    _startButton.layer.cornerRadius = 4;
    [self.view addSubview:_startButton];
    [self createSelectPoleView];
    
}
//创建选杆
-(void)createSelectPoleView{
    [_poleButtonBackView removeAllSubviews];
    
    NSArray *pardata = _parkModel.pardata;
    _parklabel.text = _parkModel.qname;
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i<5; i++) {
        if (i<pardata.count) {
            NSDictionary *dict = pardata[i];
            NSString *name = [dict objectForKey:@"name"];
            [mArray addObject:name];
        }else{
            [mArray addObject:@"1"];
        }
    }
    
    NSArray *headerArry = [NSArray arrayWithObjects:@"前9洞",mArray[0],mArray[1],mArray[2],mArray[3],mArray[4], nil];
    NSArray *footerArry = [NSArray arrayWithObjects:@"后9洞",mArray[0],mArray[1],mArray[2],mArray[3],mArray[4], nil];
    
    NSArray *PoloArray = @[headerArry,footerArry];
    
    for (int i=0; i<2; i++) {
        for (int j=0; j<5; j++) {
            UIButton *poloButton = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/5*j, kHvertical(45)*i, ScreenWidth/5, kHvertical(45)) titleFont:13.f textColor:rgba(51,52,54,1) backgroundColor:BlueColor target:self selector:@selector(poloButtonClick:) Title:PoloArray[i][j]];
            [poloButton setTitleColor:rgba(255,255,255,1) forState:UIControlStateSelected];
            [poloButton setTitleEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
            poloButton.layer.masksToBounds = YES;
            poloButton.layer.cornerRadius = 4;
            poloButton.userInteractionEnabled=YES;
            if (j==0) {
                [poloButton setUserInteractionEnabled:NO];
                [poloButton setBackgroundColor:ClearColor];
                [poloButton setTitleColor:rgba(131,131,131,1) forState:UIControlStateNormal];
            }else{
                [poloButton setFrame:CGRectMake(ScreenWidth/5 + kWvertical(8) +ScreenWidth/5*(j-1), kHvertical(9)+kHvertical(45)*i, ScreenWidth/5-kWvertical(16),kHvertical(kHvertical(26)))];
                [poloButton setBackgroundColor:rgba(249,249,249,1)];
            }
            poloButton.tag = 100+j+5*i;
            poloButton.selected = NO;
            
            if (poloButton.tag>104) {
                if ([poloButton.titleLabel.text isEqualToString:_bottomPole]) {
                    poloButton.selected = YES;
                    poloButton.backgroundColor = rgba(53,141,227,1);
                }
            }else{
                if ([poloButton.titleLabel.text isEqualToString:_topPole]) {
                    poloButton.selected = YES;
                    poloButton.backgroundColor = rgba(53,141,227,1);
                }
            }
            
            [_poleButtonBackView addSubview:poloButton];
            if ([PoloArray[i][j] isEqualToString:@"1"]) {
                poloButton.hidden = YES;
            }
        }
    }
    
    
    
}

//创建tableview
-(void)createTableView{
    [_tableviewBackView removeFromSuperview];
    [_mainTableView removeFromSuperview];

    CGFloat height = (self.nearParkArray.count+1)*kHvertical(45);
    if (height>ScreenHeight-kHvertical(87)-64-kHvertical(110)) {
        height = ScreenHeight-kHvertical(87)-64-kHvertical(110);
    }
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+kHvertical(45)+0.5, ScreenWidth, height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    mainTableView.allowsSelection = YES;
    
    [mainTableView registerClass:[NewStartScrolTableViewCell class] forCellReuseIdentifier:@"NewStartScrolTableViewCell"];

    _mainTableView = mainTableView;
    
    _tableviewBackView = [Factory createViewWithBackgroundColor:GPRGBAColor(0, 0, 0, 0.3) frame:CGRectMake(0, _mainTableView.y_height, ScreenWidth, ScreenHeight - _mainTableView.y_height)];
    __weak __typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        weakSelf.tableviewBackView.hidden = YES;
        weakSelf.mainTableView.hidden = YES;
    }];
    [_tableviewBackView addGestureRecognizer:tap];
    
    
    [self.view addSubview:_tableviewBackView];
    [self.view addSubview:_mainTableView];
    
    
}

//是否继续提示
-(void)createContinueAlertView:(NSDictionary *)dataDict{
    UIView *superview = [_alertView superview];
    if (!_alertView||![superview isEqual:self.view]) {
        _alertView = [[GolvonAlertView alloc] initWithFrame:self.view.bounds createContinueAlertViewBool:YES];
        __weak __typeof(self)weakSelf = self;
        
        [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            weakSelf.isViewContinue = YES;
            [weakSelf clickReStart];
            [weakSelf.alertView removeFromSuperview];
            weakSelf.alertView = nil;
            [weakSelf loadNearParkData];

        }];
        
        [_alertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            _isViewContinue = NO;
            [weakSelf continueScoring:dataDict];
            [weakSelf.alertView removeFromSuperview];
        }];
        
        
        [_alertView setBlock:^(NSString *str) {
            weakSelf.isViewContinue = YES;
            [weakSelf clickReStart];
            [weakSelf.alertView removeFromSuperview];
            weakSelf.alertView = nil;
            [weakSelf loadNearParkData];
            
        }];
        
        [self.view addSubview:_alertView];
        
    }
}

//移除提示
-(void)createRemoveAlertView:(NSInteger)index{
    _removeAlertView = [[GolvonAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:@"移除此用户" leftBtn:@"确定" right:@"取消"];
    __weak __typeof(self)weakSelf = self;
    [_removeAlertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        weakSelf.reloadPlayerData = true;
        [weakSelf.playerArray removeObjectAtIndex:index];
        [weakSelf upDataUrl];
        [weakSelf.removeAlertView removeFromSuperview];
    }];
    
    [_removeAlertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakSelf.removeAlertView removeFromSuperview];
    }];
    [self.view addSubview:_removeAlertView];
}


#pragma mark - loadData

-(void)timerLoadUserData{
    
    __weak typeof(self) weakself = self;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),5.0*NSEC_PER_SEC, 0); //每5秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //是否更新分组数据
        if (_endTimer) {
            dispatch_source_cancel(_timer);
        }else{
            if (!weakself.reloadPlayerData) {
                BOOL canLoad = true;
                for (int i = 0; i<_playerArray.count; i++) {
                    GolfersModel *model = [[GolfersModel alloc] init];
                    if (model.phoneStr.length>0&&!model.uid) {
                        canLoad = false;
                    }
                }
                if (canLoad) {
                    [weakself loadUserData];
                }
            }
        }
        
    });
    dispatch_resume(_timer);
}

//获取当前用户信息
-(void)loadUserData{
//    NSLog(@"开始加载");
    if (_reloadPlayerData) {
        _reloadPlayerData = false;
        return ;
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=getgroupinfo",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (_reloadPlayerData) {
            return ;
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *code = [data objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {

                self.playerArray = [NSMutableArray array];
                NSString *nickname = [userDefaults objectForKey:@"nickname"];
                NSString *avator = [userDefaults objectForKey:@"pic"];
                NSString *nameuid = userDefaultUid;
                NSDictionary *selfDict = @{
                                           @"nickname":nickname,
                                           @"avator":avator,
                                           @"uid":nameuid,
                                           };
                NSDictionary *dict = @{
                                       @"nickname":@"添加",
                                       @"avator":@"scoring队伍添加",
                                       @"uid":@""
                                       };
                GolfersModel *model = [[GolfersModel alloc] init];
                [model configData:selfDict];
                model.isSelect = YES;
                GolfersModel *model2 = [[GolfersModel alloc] init];
                [model2 configData:dict];
                model2.isSelect = YES;
                _playerArray = [NSMutableArray arrayWithArray:@[model,model2]];
                [_PlayerCollectionView reloadData];

            }
            if (code==nil) {
                NSString *isbuild = [data objectForKey:@"isbuild"];
                if ([isbuild isEqualToString:@"0"]) {
                    __weak typeof(self) weakself = self;
                    if (!_endTimer) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SignUpViewController *vc = [[SignUpViewController alloc] init];
                        [weakself.navigationController pushViewController:vc animated:YES];
                    });
                    }
                    _endTimer = true;

                }else if ([isbuild isEqualToString:@"1"]){
                    
                    NSArray *list = [data objectForKey:@"list"];
                    NSMutableArray *mPlayerArray = [NSMutableArray array];
                    for (int i = 0; i<list.count; i++) {
                        NSDictionary *dict = list[i];
                        GolfersModel *model = [GolfersModel modelWithDictionary:dict];
                        model.isSelect = YES;
                        [mPlayerArray addObject:model];
                    }
                    NSDictionary *dict = @{
                                           @"nickname":@"添加",
                                           @"avator":@"scoring队伍添加",
                                           @"uid":@""
                                           };
                    GolfersModel *model = [[GolfersModel alloc] init];
                    [model configData:dict];
                    [mPlayerArray addObject:model];
                    _playerArray = [NSMutableArray arrayWithArray:mPlayerArray];
                    [_PlayerCollectionView reloadData];
                }
            }
        }
    }];
    
}
//是否继续记分
-(void)viewBoolContinue{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=hasgametoday",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *games = [data objectForKey:@"games"];
                
                if ([games integerValue]>0) {
                    NSString *jluid = [data objectForKey:@"jluid"];
                    if ([jluid isEqualToString:userDefaultUid]) {
                        
                    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
                    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
                    if ([diskCache containsObjectForKey:userGidKey]) {
                        NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
                        if (gidArray.count>0) {
                            [self createContinueAlertView:data];
                        }
                    }
                    }else{
                        [self createContinueAlertView:data];
                    }
                    if (_nearParkArray.count>0) {
                        _nearParkArray = [NSMutableArray arrayWithArray:@[_nearParkArray[0]]];
                        [_mainTableView removeFromSuperview];
                        [_tableviewBackView removeFromSuperview];
                        [_mainTableView reloadData];
                    }
                        
                }
            }
        }
    }];
}

-(void)initData{
//    [self loadNearParkData];
    [self loadUserData];
}

//加载附近球场数据
-(void)loadNearParkData{
    if (_playerArray.count>2) {
        return;
    }

    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"lng":lon,
                           @"lat":lat,
                           @"name_id":userDefaultId,
                           @"nearby":@"1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=courselist",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [data objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {
                    NSMutableArray *mArray = [NSMutableArray array];
                    for (NSInteger i = 0; i<dataArray.count; i++) {
                        NSDictionary *pordataDict = dataArray[i];
                        NearParkModel *model = [[NearParkModel alloc] init];
                        [model configData:pordataDict];
                        BOOL canAdd = false;
                        for (NearParkModel *parkModel in mArray) {
                            if ([parkModel.qname isEqualToString:model.qname]) {
                                canAdd = true;
                            }
                        }
                        if (!canAdd) {
                            [mArray addObject:model];
                        }
                    }
                    _nearParkArray = mArray;
                    NearParkModel *model = _nearParkArray[_nearParkArray.count-1];
                    _parkModel = model;
                    NSArray *parAaray = model.pardata;
                    
                    for (int i = 0; i<parAaray.count; i++) {
                        NSDictionary *parDict = parAaray[i];
                        if (parAaray.count==1) {
                            _topPole = [parDict objectForKey:@"name"];
                            _bottomPole = _topPole;
                        }else{
                            if (i==0) {
                                _topPole = [parDict objectForKey:@"name"];
                            }else if (i==1){
                                _bottomPole = [parDict objectForKey:@"name"];
                            }
                        }
                    }
                    [self createSelectPoleView];
                    _parklabel.text = model.qname;
                    [self parkSizeToFit];
                    if (_nearParkArray.count>1&&_alertView==nil) {
                        [self createTableView];
                    }
                }
            }
        }
    }];
}
//获取添加用户的nameId

-(void)getNameId{
    
//:(NSMutableArray *)mArray
    for (int i = 0; i<_playerArray.count; i++) {
        GolfersModel *model = _playerArray[i];
        if ([model.addType integerValue]>0) {
            DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
            NSDictionary *dict = @{
                                   @"name_id":userDefaultId,
                                   @"phone":model.phoneStr,
                                   };
            if (model.nickname) {
                dict = @{
                         @"name_id":userDefaultId,
                         @"phone":model.phoneStr,
                         @"nickname":model.nickname
                         };
            }
            [manager downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=useradd",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {

                if (success) {
                    GolfersModel *model = [[GolfersModel alloc] init];
                    model.uid = [data objectForKey:@"newuid"];
                    model.nickname = [data objectForKey:@"nickname"];
                    model.avator = [data objectForKey:@"pic"];
                    model.phoneStr = [data objectForKey:@"phone"];
                    
                    BOOL boolRemove = false;
                    for (int k = 0; k<_playerArray.count; k++) {
                        GolfersModel *testModel = _playerArray[k];
                        if ([testModel.uid isEqualToString:model.uid]) {
                            boolRemove = true;
                        }
                    }
                    if (boolRemove) {
                        for (int k = 0; k<_playerArray.count; k++) {
                            GolfersModel *testModel = _playerArray[k];
                            if ([testModel.phoneStr isEqualToString:model.phoneStr]) {
                                [_playerArray removeObjectAtIndex:k];
                                [_PlayerCollectionView reloadData];
//                                return ;
                            }
                        }
                    }
                    
                    for (int j = 0; j<_playerArray.count; j++) {
                        GolfersModel *Model = _playerArray[j];
                        NSString *phoneStr = Model.phoneStr;
                        if ( (phoneStr.length>0&&[phoneStr isEqualToString:model.phoneStr])||[Model.uid isEqualToString:model.uid]) {
                            [_playerArray replaceObjectAtIndex:j withObject:model];
                        }
                    }
                }
                [self upDataUrl];
                [_PlayerCollectionView reloadData];
            }];
        }
    }
}


//更新组队数据
-(void)upDataUrl{
    //    if (_playerArray.count==2) {
    //        return;
    //    }
    
    NSString *playerIdStr = [NSString string];
    for (NSInteger i=0; i<_playerArray.count; i++) {
        GolfersModel *model = _playerArray[i];
        NSString *playerId = model.uid;
        if (playerId.length>0) {
            if (playerIdStr.length>0) {
                playerIdStr = [NSString stringWithFormat:@"%@,%@",playerIdStr,playerId];
            }else{
                playerIdStr = [NSString stringWithFormat:@"%@",playerId];
            }
        }
    }
    NSString *aft = [NSString stringWithFormat:@"%@",_topPole];
    NSString *bef = [NSString stringWithFormat:@"%@",_bottomPole];
    if (aft.length==0) {
        aft = @"0";
    }
    if (bef.length==0) {
        bef = @"0";
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"qid":_parkModel.qid,
                           @"bef":bef,
                           @"aft":aft,
                           @"memberids":playerIdStr
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=updategroupinfo",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (_reloadPlayerData) {
            _reloadPlayerData = false;
            [self loadUserData];
            return ;
        }
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                if ([code isEqualToString:@"0"]) {
                    NSLog(@"成功");
                    [_mainTableView reloadData];
                    [_PlayerCollectionView reloadData];
                }
            }
        }
    }];
    
}
//继续记分点击
-(void)continueScoring:(NSDictionary *)dict{
    NSString *jlUid = [dict objectForKey:@"jluid"];
    NSString *groupId = [dict objectForKey:@"gid"];
    if ([jlUid isEqualToString:userDefaultUid]) {
        NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
        NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
        NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
        NSString *groupId = [gidArray lastObject];
        NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,groupId];
        NSDictionary *mDict = (NSDictionary *)[diskCache objectForKey:disckCacheKey];
        NSArray *playerArray = [mDict objectForKey:@"playerArrayKey"];
        NSInteger  playerNum = playerArray.count;
        if (playerNum==1) {
            SingleMatchViewController *vc = [[SingleMatchViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.gid = groupId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MatchViewController *vc = [[MatchViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.gid = groupId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
        group.loginNameId = userDefaultId;
        group.nameUid = userDefaultUid;
        group.groupId = groupId;
        group.isLoadDta = YES;
        group.status = 1;
        group.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:group animated:YES];

    }

}

//比赛出发请求
-(void)gameStart:(UIButton *)btn{
    
    NSInteger playerNum = _playerArray.count-1;
    NSString *playerIdStr = [NSString string];
    for (NSInteger i=0; i<playerNum; i++) {
        GolfersModel *model = _playerArray[i];
        NSString *playerId = model.uid;
        if (playerId.length>0) {
            if (playerIdStr.length>0) {
                playerIdStr = [NSString stringWithFormat:@"%@,%@",playerIdStr,playerId];
            }else{
                playerIdStr = [NSString stringWithFormat:@"%@",playerId];
            }
        }
    }
    NSString *aft = [NSString stringWithFormat:@"%@",_topPole];
    NSString *bef = [NSString stringWithFormat:@"%@",_bottomPole];
    NSString *qid = _parkModel.qid;
    if (!qid) {
        return;
    }
    if (aft.length==0) {
        return;
    }
    if (bef.length==0) {
        return;
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"qid":qid,
                           @"aft":bef,
                           @"bef":aft,
                           };
    if (playerNum>1) {
        dict = @{
                 @"name_id":userDefaultId,
                 @"qid":qid,
                 @"aft":bef,
                 @"bef":aft,
                 @"memberids":playerIdStr
                 };
    }
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.alpha = 0.5;
    
    NSString *url = [NSString stringWithFormat:@"%@scoreapi.php?func=gamebegan",apiHeader120];
    btn.userInteractionEnabled = NO;
    NSLog(@"开始时间%@",[NSDate date]);
    [manager downloadWithUrl:url parameters:dict complicate:^(BOOL success, id data) {
        NSLog(@"结束时间%@",[NSDate date]);
        [_HUD removeFromSuperview];
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *gid = [data objectForKey:@"gid"];
                if (gid) {
                    _isViewContinue = NO;
                    //                    NSString *dataHeader = [NSString stringWithFormat:@"%@_%@_",gid,userDefaultUid];
                    NSString *dataHeader = [NSString string];
                    
                    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
                    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
                    if ([diskCache containsObjectForKey:userGidKey]) {
                        NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
                        [gidArray addObject:gid];
                        [diskCache setObject:gidArray forKey:userGidKey];
                        NSLog(@"%@",diskCache);
                    }else{
                        NSMutableArray *gidArray = [NSMutableArray arrayWithObject:gid];
                        [diskCache setObject:gidArray forKey:userGidKey];
                    }
                    
                    NSArray *ParArray = _parkModel.pardata;
                    NSInteger aftIndex = 0;
                    NSInteger befIndex = 0;
                    
                    for (NSInteger i = 0; i<ParArray.count; i++) {
                        NSDictionary *ParDict = ParArray[i];
                        NSString *name = [ParDict objectForKey:@"name"];
                        if ([name isEqualToString:aft]) {
                            aftIndex = i;
                        }
                        if ([name isEqualToString:bef]) {
                            befIndex = i;
                        }
                    }
                    //标准杆
                    NSMutableArray *mParArray = [NSMutableArray array];
                    for (int i = 0; i<2; i++) {
                        
                        NSDictionary *ParDict = ParArray[aftIndex];
                        if (i==1) {
                            ParDict = ParArray[befIndex];
                        }
                        if ([ParDict containsObjectForKey:@"H1"]) {
                            for (int j = 1; j<10; j++) {
                                NSString *parStr = [ParDict objectForKey:[NSString stringWithFormat:@"H%d",j]];
                                [mParArray addObject:parStr];
                            }
                        }else if ([ParDict containsObjectForKey:@"H10"]){
                            for (int j = 10; j<19; j++) {
                                NSString *parStr = [ParDict objectForKey:[NSString stringWithFormat:@"H%d",j]];
                                [mParArray addObject:parStr];
                            }
                        }
                    }
                    
                    
                    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                    NSMutableArray *mTitlePoleArray = [NSMutableArray array];
                    for (int i = 1; i < 19; i++) {
                        NSString *par = mParArray[i-1];
                        NSString *indexPoleDataKey = [NSString stringWithFormat:@"%@pole%d",dataHeader,i];
                        NSString *PoleNumber = [NSString stringWithFormat:@"%d",i];
                        NSMutableArray *mPlayerProgressArray = [NSMutableArray array];
                        for (int j=0; j<playerNum; j++) {
                            GolfersModel *playerModel = _playerArray[j];
                            NSString *playerNameid = playerModel.uid;
                            NSDictionary *playerProgressDict = @{
                                                                 @"uid":playerNameid,
                                                                 @"r":@"0",
                                                                 @"pr":@"0"
                                                                 };
                            [mPlayerProgressArray addObject:playerProgressDict];
                        }
                        NSDictionary *poleDict = @{
                                                   @"hn":PoleNumber,
                                                   @"par":par,
                                                   @"p":mPlayerProgressArray
                                                   };
                        
                        [mDict setValue:poleDict forKey:indexPoleDataKey];
                        
                        NSString *poleName;
                        if (i<10) {
                            poleName = [NSString stringWithFormat:@"%@%d",aft,i];
                        }else{
                            poleName = [NSString stringWithFormat:@"%@%d",bef,i-9];
                        }
                        
                        [mTitlePoleArray addObject:poleName];
                    }
                    NSString *time = [data objectForKey:@"ts"];
                    //[self TimeStamp:[data objectForKey:@"ts"]];
//                    @"2016:11:06 11:20";
                    NSString *parkName = [NSString stringWithFormat:@"%@",_parkModel.qname];
                    NSString *parkId = [NSString stringWithFormat:@"%@",_parkModel.qid];
                    NSString *parkLoglo = [NSString stringWithFormat:@"%@",_parkModel.qlogo];
                    
                    //已选择球场
                    NSArray *selectArray = [NSArray array];
                    //球场数据和时间
                    NSDictionary *parkData = @{
                                               @"qname":parkName,
                                               @"qid":parkId,
                                               @"qlogo":parkLoglo,
                                               };
                    //球场前9洞与后9洞
                    NSArray *poleOrderArray = [NSArray arrayWithObjects:aft,bef,nil];
                    
                    
                    //比赛球员
                    NSMutableArray *playerArray  = [NSMutableArray array];
                    NSArray *menbersArray = [data objectForKey:@"members"];
                    for (int i = 0; i<playerNum; i++) {
                        NSDictionary *menbersDict = menbersArray[i];
                        NSString *sex = [menbersDict objectForKey:@"gender"];
                        if ([sex isEqualToString:@"1"]) {
                            sex = @"2";
                        }else{
                            sex = @"4";
                        }
                        GolfersModel *playerModel = _playerArray[i];
                        NSDictionary *playerDict = @{
                                                     @"nameId":playerModel.uid,
                                                     @"pic":playerModel.avator,
                                                     @"nickname":playerModel.nickname,
                                                     @"tcolor":sex
                                                     };
                        [playerArray addObject:playerDict];
                    }
                    //是否选择距标准杆
                    NSString *isPoleSelect = [userDefaults objectForKey:@"isPoleSelect"];
                    
                    NSString *isSelect = @"0";
                    if (isPoleSelect) {
                        isSelect = isPoleSelect;
                    }
                    
                    NSString *titlePoleArrayKey = [NSString stringWithFormat:@"%@poleNameKey",dataHeader];
                    NSString *parkDataKey = [NSString stringWithFormat:@"%@qinfo",dataHeader];
                    NSString *selectArrayKey = [NSString stringWithFormat:@"%@selectArrayKey",dataHeader];
                    NSString *playerArrayKey = [NSString stringWithFormat:@"%@playerArrayKey",dataHeader];
                    NSString *isSelectKey = [NSString stringWithFormat:@"%@isSelectKey",dataHeader];
                    
                    NSString *islast9 = [data objectForKey:@"islast9"];
                    
                    [mDict setValue:islast9 forKey:@"islast9"];
                    [mDict setValue:@"0" forKey:@"endPole"];
                    [mDict setValue:userDefaultUid forKey:@"jluid"];
                    [mDict setValue:mTitlePoleArray forKey:titlePoleArrayKey];
                    [mDict setValue:parkData forKey:parkDataKey];
                    [mDict setValue:selectArray forKey:selectArrayKey];
                    [mDict setValue:playerArray forKey:playerArrayKey];
                    [mDict setValue:isSelect forKey:isSelectKey];
                    [mDict setValue:time forKey:@"begainTime"];
                    [mDict setValue:poleOrderArray forKey:@"poleOrderArray"];
                    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",userDefaultUid,gid];
                    
                    [diskCache setObject:mDict forKey:disckCacheKey];
                    if ([diskCache containsObjectForKey:disckCacheKey]) {
                        NSDictionary *dict = (NSDictionary*)[diskCache objectForKey:disckCacheKey];
                        NSLog(@"%@",dict);
                    }
                    
                    
                    if (playerNum==1) {
                        SingleMatchViewController *vc = [[SingleMatchViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.gid = gid;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        MatchViewController *vc = [[MatchViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.gid = gid;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    for (int i = 0; i<playerArray.count-1; i++) {
                        [_playerArray removeObjectAtIndex:1];
                    }
                    
                    [_PlayerCollectionView reloadData];
                    
                }
            }
        }else{
            _startButton.userInteractionEnabled = YES;
        }
    }];
    
}

//点击继续记分取消
-(void)clickReStart{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=gamerestarttm",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {

    
    }];

}


#pragma mark - action
//左按钮点击
-(void)leftButtonClick{
    ScorRecordViewController *vc = [[ScorRecordViewController alloc] init];
    vc.logInNameId = userDefaultId;
    vc.nameUid = userDefaultUid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//右按钮点击
-(void)rightButtonClick{
    
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"%@",resultAsString);
        NSInteger code = [resultAsString integerValue];
        NSString *desc = [NSString string];
        switch (code) {
            case 1:{
                desc = @"网络错误";
            }break;
            case 505:{
                desc = @"二维码格式错误";
            }break;
            case 506:{
                desc = @"二维码格式错误";
            }break;
            case 507:{
                desc = @"该用户已加入其他组队";
            }break;
            case 508:{
                desc = @"组队人员已满";
            }break;
            case 509:{
                desc = @"已在组队状态下，不能加入";
            }break;
            case 510:{
                desc = @"不能加入自己组队";
            }break;
                
            default:
                break;
        }
        [wSelf qrcodeErrowAlert:desc];
        
    }];
    //    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader animated:YES];
}


-(void)qrcodeErrowAlert:(NSString *)desc{
    _removeAlertView = [[GolvonAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:desc leftBtn:@"重试" right:@"取消"];
    __weak __typeof(self)weakSelf = self;
    [_removeAlertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

        [weakSelf rightButtonClick];
        
        [weakSelf.removeAlertView removeFromSuperview];
    }];
    
    [_removeAlertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        
        [weakSelf.removeAlertView removeFromSuperview];
    }];
    [self.view addSubview:_removeAlertView];

}

//选择附近球场
-(void)viewNearPark{
    BallParkViewController *ballPark = [[BallParkViewController alloc]init];
    __weak __typeof(self)weakSelf = self;
    
    ballPark.selectPar = ^(NearParkModel *selectPark){
        NearParkModel *model = [[NearParkModel alloc] init];
        model = selectPark;
        if (![weakSelf.parkModel isEqual:selectPark]) {
            weakSelf.reloadPlayerData = true;
            weakSelf.parkModel = selectPark;
            NSArray *parAaray = model.pardata;
            for (int i = 0; i<parAaray.count; i++) {
                NSDictionary *parDict = parAaray[i];
                if (parAaray.count==1) {
                    _topPole = [parDict objectForKey:@"name"];
                    _bottomPole = _topPole;
                }else{
                    if (i==0) {
                        _topPole = [parDict objectForKey:@"name"];
                    }else if (i==1){
                        _bottomPole = [parDict objectForKey:@"name"];
                    }
                }
            }
            [weakSelf createSelectPoleView];
            weakSelf.parklabel.text = selectPark.qname;
            [weakSelf parkSizeToFit];
            [self upDataUrl];
        }
    };
    
    UIViewController * controller = self.view.window.rootViewController;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    ballPark.view.backgroundColor = [UIColor whiteColor];
    ballPark.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController * jackNavigationController = [[UINavigationController alloc] initWithRootViewController:ballPark];
    [jackNavigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:jackNavigationController animated:YES completion:nil];
    
}


#pragma mark - Action
//出发
-(void)startClick:(UIButton *)btn{
    [self gameStart:btn];
}
//选择球洞按钮点击
-(void)poloButtonClick:(UIButton *)button{
    NSInteger buttonTag = button.tag;
    NSLog(@"%ld",(long)buttonTag);
    
    if (button.selected) {
        if (buttonTag>104) {
            _bottomPole = @"";
        }else{
            _topPole = @"";
        }
        button.selected = NO;
        [button setBackgroundColor:rgba(249,249,249,1)];
        return;
    }
    int i = 0;
    if (buttonTag>104) {
        i = 1;
    }
    
    for (int j=0; j<5; j++) {
        UIButton *poloButton = (UIButton *)[button.superview.subviews objectAtIndex:j+5*i];
        if ([poloButton isEqual:button]) {
            NSLog(@"%ld",(long)poloButton.tag);
        }
        if (j==0) {
            [poloButton setBackgroundColor:ClearColor];
        }else{
            poloButton.selected = NO;
            [poloButton setBackgroundColor:rgba(249,249,249,1)];
        }
    }
    button.backgroundColor = rgba(53,141,227,1);
    button.selected = YES;
    if (buttonTag>104) {
        _bottomPole = button.titleLabel.text;
    }else{
        _topPole = button.titleLabel.text;
    }
    [self upDataUrl];
}



#pragma mark - delegate

//tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return _nearParkArray.count;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(45);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kHvertical(37);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewStartScrolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewStartScrolTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configParkData:_nearParkArray[indexPath.row]];
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(37))];
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(23), 0, ScreenWidth-kWvertical(46), kHvertical(37)) textColor:rgba(140,141,141,1) fontSize:kHorizontal(13.0f) Title:@"为您推荐的球场"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(0, -0.5, ScreenWidth, 0.5)];
    [footerView addSubview:lineView];
    return footerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NearParkModel *model = _nearParkArray[indexPath.row];
    if ([_parkModel isEqual:model]) {
        
    }else{
        _topPole = [NSString string];
        _bottomPole = [NSString string];
        
        _parkModel = model;
        NSArray *parAaray = model.pardata;
        for (int i = 0; i<parAaray.count; i++) {
            NSDictionary *parDict = parAaray[i];
            if (parAaray.count==1) {
                _topPole = [parDict objectForKey:@"name"];
                _bottomPole = _topPole;
            }else{
                if (i==0) {
                    _topPole = [parDict objectForKey:@"name"];
                }else if (i==1){
                    _bottomPole = [parDict objectForKey:@"name"];
                }
            }
        }
        
        [self createSelectPoleView];
        
        _parklabel.text = model.qname;
        [self parkSizeToFit];

    }
    _tableviewBackView.hidden = YES;
    _mainTableView.hidden = YES;

}



#pragma mark - Others
//自适应球场长度
-(void)parkSizeToFit{
    
    
    [_parklabel sizeToFit];
    _parklabel.frame = CGRectMake((ScreenWidth-_parklabel.width)/2, kHvertical(14), _parklabel.width, _parklabel.height);
    _arrowView.frame = CGRectMake(_parklabel.x_width + kWvertical(6), kHvertical(21), kWvertical(9), kHvertical(5));
    
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
    if (self.playerArray.count <= 4) {
        return self.playerArray.count;
    }
    return 4;
}
//collectionDlegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScoringPlayerCollectionViewCell *cell = (ScoringPlayerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PublishCollectionViewCellId" forIndexPath:indexPath];
    GolfersModel *model = self.playerArray[indexPath.item];
    [cell configData:model];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-kWvertical(20))/4,kWvertical(89));
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, kWvertical(0), 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kWvertical(0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
    GolfersModel *addModel = _playerArray[indexPath.item];
    NSString *picUrl = addModel.avator;
    NSString *selectNameId = addModel.uid;
    if ([picUrl isEqualToString:@"scoring队伍添加"]) {
        AddGolferViewController *vc = [[AddGolferViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        __weak __typeof(self)weakSelf = self;
        [vc clickDone:^(NSArray *playerArr) {
            weakSelf.reloadPlayerData = true;
            weakSelf.playerArray = nil;
//            NSMutableArray *reciveArray = [NSMutableArray array];
            for (GolfersModel *model in playerArr) {
                BOOL isContent = false;
                for (GolfersModel *model2 in self.playerArray) {
                    if ([model2.uid isEqualToString:model.uid]) {
                        isContent = true;
                    }
                }
                if (!isContent) {
                    [weakSelf.playerArray insertObject:model atIndex:_playerArray.count-1];
                }
            }
            [weakSelf.PlayerCollectionView reloadData];

            [weakSelf getNameId];
//            [weakSelf getNameId:weakSelf.playerArray];
            
//            [self upDataUrl];
            
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [userDefaults setValue:[NSString stringWithFormat:@"%ld",_playerArray.count] forKey:@"selectPlayerNum"];
        vc.selectPlayerArray = [NSMutableArray arrayWithArray:_playerArray];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }else if (![selectNameId isEqualToString:userDefaultUid]){
        [self createRemoveAlertView:indexPath.item];
        
    }
    
}

-(NSString *)TimeStamp:(NSString *)strTime
{
    NSTimeInterval time=[strTime doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

-(void)createLocation{
    
    self.locationManager = [[BMKLocationService alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager startUserLocationService];
}


#pragma mark - BMKUserLocation Delegate


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CGFloat latitude  = userLocation.location.coordinate.latitude;
    CGFloat longitude = userLocation.location.coordinate.longitude;
    NSString *lat = [NSString stringWithFormat:@"%0.14f",latitude];
    NSString *lon = [NSString stringWithFormat:@"%0.14f",longitude];
    [userDefaults setValue:lat forKey:@"latitude"];
    [userDefaults setValue:lon forKey:@"longitude"];
    [self.locationManager stopUserLocationService];
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
