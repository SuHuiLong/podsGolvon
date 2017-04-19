//
//  HomePageViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "HomePageViewController.h"
#import "FriendsImageTableViewCell.h"
#import "NewStatisticsViewController.h"
#import "GroupStatisticsViewController.h"
#import "GolvonAlertView.h"

static NSString *identifierCollection = @"HomePageCollectionViewCell";
static NSString *identifierTableview  = @"FriendsterTableViewCell";
static NSString *identifierLocation   = @"LocationTableViewCell";
static NSString *identifierLike       = @"LikeTableViewCell";
static NSString *FriendsImageTableViewCellIdentifier = @"FriendsImageTableViewCell";

@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    UILabel                 *ownMessage;//个人信息
    UILabel                 *signature;//签名
    UILabel                 *redView;
    UILabel                 *content;//朋友圈发布内容
    UIButton                *resignFirstResponder;//点击取消键盘的第一响应者
    MJRefreshNormalHeader *refreshHeader;
    BOOL                    autoLoadData;
    MBProgressHUD *_HUD;
    //    UIImageView *logoImage;
    /**
     *  访问量
     */
    NSInteger   _viewString;
    FriendsterModel *friendsterModelmdoel;
    
    NewAlertView *_alertView;//超出文字提示界面
    ViewHistoryData *_userCoreData;
    /**
     *  是否需要刷新 YES是不需要 NO为需要
     */
    BOOL _needRefresh;
}

/** *回复: dynamicID=动态id  covComNameID=被评论人id replyFirComID=没回复的评论id，如果为一级评论，传0 */
@property (copy, nonatomic) NSString    *dynamicID;
@property (copy, nonatomic) NSString    *covComNameID;
@property (copy, nonatomic) NSString    *replyFirComID;
@property (copy, nonatomic) NSString    *commentID;            //要删除的评论ID
@property (copy, nonatomic) NSString    *commentNameID;        //评论 covComNameID=被评论人id
@property (copy, nonatomic) NSString    *RefreashDate;
@property (copy, nonatomic) NSString    *itemSelect;           //解决提示框显示Bug,@"1"不显示
@property (copy, nonatomic) NSNumber    *redNum;                //红点数据
@property (copy, nonatomic) NSString    *cityname;              //当前城市名称
@property (copy, nonatomic) NSString    *reportType;            //举报类型
@property (copy, nonatomic) NSString    *reportState;            //举报类型
@property (copy, nonatomic) NSString    *reportRid;             //如果举报用户就是uid , 举报动态就是动态的 did, 举报 评论就是评论的cid

@property (copy, nonatomic) NSString    *player;            //打球记分人数
@property (copy, nonatomic) NSString    *isfinished;        //是否完成
@property (copy, nonatomic) NSString    *isvali;            //是否有效

@property (copy, nonatomic) NSString *appStoreURL;

@property (copy, nonatomic) NSString    *pastedStr;              //要复制的内容
@property (strong, nonatomic) NSMutableArray *collectionCaraDataArr;//滑动卡片数据
@property (strong, nonatomic) NSMutableArray *friendsterDataArr;//发布朋友圈的人的个人信息
@property (strong, nonatomic) NSMutableArray *tapFollowArr;
@property (strong, nonatomic) NSMutableArray *commentDataArr;
@property (strong, nonatomic) NSMutableArray *testDataArr;      //存放删除后的数据
@property (strong, nonatomic) NSMutableArray *layoutModelArr;
@property (strong, nonatomic) NSMutableArray *picsDataArr;//点赞数组

@property (assign, nonatomic) int page;//请求的页数
@property (assign, nonatomic) int lastPage;//总的页数
@property (assign, nonatomic) int currecPage;//请求的页数
//@property (assign, nonatomic) int totalNum;//collection刷新到最后一条数据的标识
@property (assign, nonatomic) int did;     //下拉加载的时候传did
@property (assign, nonatomic) int refreshdid;
@property (assign, nonatomic) int lasdid;                //最后一组的最后一个动态id
@property (assign, nonatomic) int clikcDID;              //评论点击的did


@property (nonatomic, assign) NSInteger lastPosition;//上次刷新的位置
@property (nonatomic, assign) NSInteger RepeatNum;//本地缓存
@property (nonatomic, assign) NSInteger didReadLocation;


@property (assign, nonatomic) CGFloat keyBoardHeight;//当前键盘的高度
@property (assign, nonatomic) BOOL    isEmojiBtn;


@property (strong, nonatomic) UITextView *inputTextView;//输入框*
@property (strong, nonatomic) UIButton   *KeybordEmojiIcon;//选择图标
@property (strong, nonatomic) UILabel    *commentPlaceLabel;//键盘等待文字
@property (strong, nonatomic) EmojiKeybordView    *emojiView;//表情键盘
@property (strong, nonatomic) UILabel    *limitLabel;//显示限制字数
@property (strong, nonatomic) UIView     *emojiKeybordView;//切换键盘按钮背景


@property (strong, nonatomic) UIView     *placeView;//等待View
@property (strong, nonatomic) UIView     *deleteGroundView;//删除的背景
@property (strong, nonatomic) UIView     *deleteView;//删除的view
@property (strong, nonatomic) UICollectionView    *collectionView;//滚动栏
@property (strong, nonatomic) UITableView         *tableview;//球友圈
@property (strong, nonatomic) DownLoadDataSource  *loadData;//请求数据工具类
@property (nonatomic, strong) CoreDataManager     *coreDataManager;//coreDataManager
@property (nonatomic, strong) GolvonAlertView     *checkAlertView;
@property (strong, nonatomic) BMKLocationService  *locationManager;//地图管理类
@property(nonatomic, assign) CLLocationDistance distanceFilter;//根据距离更新位置信息

@property (nonatomic, strong) NSMutableDictionary *coreDataDataDict;
@property (strong, nonatomic) UIActionSheet      *longpressActionSheet;
@property (strong, nonatomic) UIActionSheet      *reportSheet;

@property (strong, nonatomic) UIActionSheet      *reportActionSheet;

@property (assign, nonatomic) CGFloat tableViewKeyboardDelta;

@property (strong, nonatomic) UIView *noneDataView;

@end

@implementation HomePageViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        _coreDataManager = [CoreDataManager sharedCoreDataManager];
    }
    return self;
    
}
-(NSMutableArray *)picsDataArr{
    if (!_picsDataArr) {
        _picsDataArr = [[NSMutableArray alloc] init];
    }
    return _picsDataArr;
}
-(NSMutableArray *)testDataArr{
    if (!_testDataArr) {
        _testDataArr = [[NSMutableArray alloc] init];
    }
    return _testDataArr;
}
-(NSMutableArray *)commentDataArr{
    if (!_commentDataArr) {
        _commentDataArr = [[NSMutableArray alloc] init];
    }
    return _commentDataArr;
}

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableArray *)collectionCaraDataArr{
    if (!_collectionCaraDataArr) {
        _collectionCaraDataArr = [[NSMutableArray alloc]init];
    }
    return _collectionCaraDataArr;
}
-(NSMutableArray *)tapFollowArr{
    if (!_tapFollowArr) {
        _tapFollowArr = [NSMutableArray array];
    }
    return _tapFollowArr;
}
-(NSMutableArray *)friendsterDataArr{
    if (!_friendsterDataArr) {
        _friendsterDataArr = [[NSMutableArray alloc] init];
    }
    return _friendsterDataArr;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self createNav];

    NSInteger totalReaviewNum = [[userDefaults objectForKey:@"unreadAll"] integerValue];
    if (totalReaviewNum == 0) {
        
        redView.hidden = YES;
        
    }else{
        redView.hidden = NO;
        redView.text = [NSString stringWithFormat:@"%ld",(long)totalReaviewNum];
        redView.adjustsFontSizeToFitWidth = YES;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (_controllID == 2) {
        _controllID = 0;
        [self headerRefresh];
        _refreshdid = 2;
        [_tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (_controllID == 3){
        _controllID = 0;
        
        _emojiKeybordView.hidden = YES;
    }
    [self requestInformationData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_deleteGroundView removeFromSuperview];
    _emojiKeybordView.hidden = YES;
    [_inputTextView resignFirstResponder];
    [redView removeFromSuperview];    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _currecPage = 0;
    _controllID = 0;
    _page = 1;
    _oneDid = 0;
    _tableViewKeyboardDelta = 0;
    [userDefaults setValue:@"1" forKey:@"ReciveNotice"];

    [self loadEditData];//更新提示
    //获取附近位置信息
    [self createLocation];

    [self setApservice];
    [self requestDataWithCollectionCard];
    [self requestFriendsterData];
    [self createTextView];
    [self testNetState];

    [self requestNextVCData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUnreadData) name:@"ReloadSelfData" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestInformationData];
    
}
-(void)updataUnreadData{
    [self requestInformationData];
}
-(void)testNetState{
    
        __weak typeof(self) weakself = self;
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            AppDelegate *appdele = [UIApplication sharedApplication].delegate;
//            appdele.reachAbilety = status > 0;
            if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
                weakself.tableview.hidden = YES;
                [weakself createNoInternet];
            }else{
                
            }
        }];
        [manager.reachabilityManager startMonitoring];
}

#pragma mark ---- UI

-(void)createNoInternet{
    
    [_noneDataView removeFromSuperview];
    _noneDataView = [[UIView alloc] init];
    _noneDataView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64-49);
    _noneDataView.backgroundColor = GPColor(252, 252, 252);
    [self.view addSubview:_noneDataView];
    
    UIImageView *noInternetImage = [[UIImageView alloc] init];
    noInternetImage.image = [UIImage imageNamed:@"noInternetImage"];
    noInternetImage.frame = CGRectMake((ScreenWidth - kWvertical(149))/2, kHvertical(143), kWvertical(149), kHvertical(99));
    [_noneDataView addSubview:noInternetImage];
    
    
    UILabel *noInternetLabel = [[UILabel alloc] init];
    noInternetLabel.frame = CGRectMake(0, noInternetImage.bottom+kHvertical(10), ScreenWidth, kHvertical(17));
    noInternetLabel.text = @"网络出错啦，点击按钮重新加载";
    noInternetLabel.textAlignment = NSTextAlignmentCenter;
    noInternetLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    noInternetLabel.textColor = mostTintColor;
    [_noneDataView addSubview:noInternetLabel];
    
    UIButton *noInternetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noInternetBtn.frame = CGRectMake((ScreenWidth - kWvertical(131))/2, noInternetLabel.bottom + kHvertical(10), kWvertical(131), kHvertical(32));
    noInternetBtn.layer.borderColor = TINTLINCOLOR.CGColor;
    noInternetBtn.layer.masksToBounds = YES;
    noInternetBtn.layer.cornerRadius = 2;
    noInternetBtn.layer.borderWidth = 0.5;
    noInternetBtn.backgroundColor = WhiteColor;
    [noInternetBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    noInternetBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [noInternetBtn setTitleColor:GPColor(58, 60, 72) forState:UIControlStateNormal];
    [noInternetBtn addTarget:self action:@selector(headerRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_noneDataView addSubview:noInternetBtn];
    
}
-(void)createNav{
    

    UIImageView *logoImage  = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"打球去logo"];
    logoImage.frame = CGRectMake((ScreenWidth-kWvertical(60))/2, kHvertical(10), kWvertical(60), kHvertical(20));
    self.navigationItem.titleView = logoImage;
    
    //左边按钮
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(cilckToMessage)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"消息中心"]];
    
    
    UIBarButtonItem *seacherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSearch:)];
    seacherButton.tintColor = [UIColor blackColor];
    [seacherButton setImage:[UIImage imageNamed:@"首页搜索"]];
    
    self.navigationItem.leftBarButtonItems = @[leftBarbutton,seacherButton];
    
    //右边按钮
    UIBarButtonItem *RightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pushToRulesVC)];
    RightBarbutton .tintColor = [UIColor blackColor];
    [RightBarbutton setImage:[UIImage imageNamed:@"动态发布"]];
    self.navigationItem.rightBarButtonItem = RightBarbutton;
    
    
    
    //小红点
    redView                 = [[UILabel alloc]init];
    redView.hidden          = YES;
    redView.backgroundColor = [UIColor redColor];
    redView.textColor       = [UIColor whiteColor];
    redView.font            = [UIFont systemFontOfSize:kHorizontal(10)];
    redView.textAlignment   = NSTextAlignmentCenter;
    redView.frame = CGRectMake(kWvertical(36), kHvertical(3), kWvertical(15), kWvertical(15));
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = kWvertical(15)/2;
    [self.navigationController.navigationBar addSubview:redView];

    
    //取消键盘第一响应者
    [resignFirstResponder removeFromSuperview];
    resignFirstResponder                 = [UIButton buttonWithType:UIButtonTypeCustom];
    resignFirstResponder.hidden          = YES;
    resignFirstResponder.backgroundColor = [UIColor clearColor];
    resignFirstResponder.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [resignFirstResponder addTarget:self action:@selector(clickResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignFirstResponder];
    
}

// collectionView && tableView
-(void)createView{
    
    CollectionViewFlowLayout *cardlayout = [[CollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(284)) collectionViewLayout:cardlayout];
    _collectionView.backgroundColor = GPColor(234, 234, 234);
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    _collectionView.scrollsToTop = NO;
    _collectionView.decelerationRate = 0.3;
    
    [_collectionView registerClass:[HomePageCollectionViewCell class] forCellWithReuseIdentifier:identifierCollection];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableview.backgroundColor = GPColor(234, 234, 234);
    //    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.separatorStyle  = NO;
    _tableview.tableHeaderView = _collectionView;
    _tableview.delegate        = self;
    _tableview.dataSource      = self;
    _tableview.backgroundColor = WhiteColor;
    _tableview.sectionHeaderHeight = CGFLOAT_MIN;
    _tableview.sectionFooterHeight = CGFLOAT_MIN;
    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableview registerClass:[FriendsterTableViewCell class] forCellReuseIdentifier:identifierTableview];
    [_tableview registerClass:[FriendsImageTableViewCell class] forCellReuseIdentifier:FriendsImageTableViewCellIdentifier];
    [_tableview setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableview.scrollsToTop =YES;
    
    
    [self.view addSubview:_tableview];
    
    [self createRefresh];
    
    
}
//删除
-(void)deleteDynamic:(DynamicMessageModel *)model{
     
    _commentID = model.cid;
    
    _deleteGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _deleteGroundView.hidden = NO;
    _deleteGroundView.backgroundColor = GPRGBAColor(.2, .2, .2, .3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHidden)];
    [_deleteGroundView addGestureRecognizer:tap];
    [self.view addSubview:_deleteGroundView];
    
    _deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, HScale(14.8))];
    _deleteView.hidden = NO;
    _deleteView.backgroundColor = GPColor(245, 245, 245);
    [_deleteGroundView addSubview:_deleteView];
    [[[UIApplication sharedApplication] .windows firstObject] addSubview:_deleteGroundView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToDelet) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"删除" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [_deleteView addSubview:confirmBtn];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    [cancel addTarget:self action:@selector(clickToHidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    
    [_deleteView addSubview:cancel];
    
    [UIView animateWithDuration:0.4 animations:^{
        _deleteView.frame = CGRectMake(0, ScreenHeight - HScale(14.8), ScreenWidth, HScale(14.8));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        confirmBtn.frame = CGRectMake(0, 0, ScreenWidth, HScale(6.9));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        cancel.frame = CGRectMake(0, HScale(7.9), ScreenWidth, HScale(6.9));
    }];
 
    
}


// 创建键盘
-(void)createTextView{
    
    _emojiKeybordView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(44) + kHvertical(216)+kHvertical(49))];
    _emojiKeybordView.backgroundColor = GPColor(243, 245, 249);
    _inputTextView = [[UITextView alloc]init];
    _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
    _inputTextView.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.scrollsToTop = NO;
    [_emojiKeybordView addSubview:_inputTextView];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:_emojiKeybordView];
    
    
    _commentPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(12), HScale(1.1), WScale(70), HScale(2.7))];
    _commentPlaceLabel.text = @"评论";
    _commentPlaceLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _commentPlaceLabel.textColor = [UIColor lightGrayColor];
    [_inputTextView addSubview:_commentPlaceLabel];
    
    
    _emojiView = [[EmojiKeybordView alloc] initWithFrame:CGRectMake(0, _inputTextView.bottom + HScale(1.1), ScreenWidth, kHvertical(216))];
    __weak __typeof(self)weakSelf = self;
    _emojiView.selectEmoji = ^(id select){
        [weakSelf textViewChange:select];
    };
    [_emojiKeybordView addSubview:_emojiView];
    _KeybordEmojiIcon = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kHvertical(44))];
    [_KeybordEmojiIcon addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [_KeybordEmojiIcon setImage:[UIImage imageNamed:@"EmojiKeybord"] forState:UIControlStateNormal];
    [_KeybordEmojiIcon setImage:[UIImage imageNamed:@"KeybordEmojiIcon"] forState:UIControlStateSelected];
    
    _KeybordEmojiIcon.imageEdgeInsets = UIEdgeInsetsMake(kWvertical(10), kHvertical(10), kWvertical(10), kHvertical(10));
    _KeybordEmojiIcon.selected  = NO;
    [_emojiKeybordView addSubview:_KeybordEmojiIcon];
    
    [_emojiView.sendBtn addTarget:self action:@selector(writhComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kWvertical(44));
    _limitLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _limitLabel.hidden = YES;
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    _limitLabel.textColor = [UIColor lightGrayColor];
    [_emojiKeybordView addSubview:_limitLabel];
    
}

//提示界面
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)alertSuccessShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"成功" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}

-(void)createAlertView:(CollectionCardModel *)model{
    _checkAlertView = [[GolvonAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:@"记分已完成" leftBtn:@"查看记分卡" right:@"取消"];
    __weak __typeof(self)weakSelf = self;
    [_checkAlertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        if ([weakSelf.player isEqualToString:@"1"]) {
            NewStatisticsViewController *VC = [[NewStatisticsViewController alloc] init];
            VC.loginNameId = userDefaultId;
            VC.nameUid = model.name_id;
            VC.groupId = model.group_id;
            VC.isLoadDta = YES;
            VC.status = 1;
            VC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else{
            GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
            group.loginNameId = userDefaultId;
            group.nameUid = model.name_id;
            group.groupId = model.group_id;
            group.isLoadDta = YES;
            group.status = 1;
            group.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:group animated:YES];
        }
        [weakSelf.checkAlertView removeFromSuperview];
    }];
    
    [_checkAlertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakSelf headerRefresh];
        [weakSelf.checkAlertView removeFromSuperview];
    }];
    [self.view addSubview:_checkAlertView];
}
//提示更新
-(void)loadEditData{
    NSString *editionText = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"Edition":editionText,
                           @"device":@"0"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/GetEdition",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dataDict = data;
            NSString *statr = [dataDict objectForKey:@"statr"];
            NSString *AppUpdateContent = [dataDict objectForKey:@"AppUpdateContent"];
            self.appStoreURL = [dataDict objectForKey:@"UpdateUrl"];
            
            if ([statr isEqualToString:@"0"]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打球去"
                                                              message:AppUpdateContent
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"立即更新", nil];
                [alert show];
            }
        }
    }];
    
};

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self openUpdateUrl:self.appStoreURL];
            break;
            
        default:
            break;
    }
}


//删除评论
-(void)clickToDelet{
    __weak typeof(self) weakself = self;
    NSDictionary *pamarters = @{@"cid":_commentID,
                                @"name_id":userDefaultId};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dyndelcommit",apiHeader120] parameters:pamarters complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                FriendsterModel *tempModel = self.friendsterDataArr[_sectionIndex-1];
                [tempModel.commets removeObjectAtIndex:_operateIndex-1];
            }else{
                
                NSLog(@"删除失败");
            }
            
            [weakself clickToHidden];
            [weakself.tableview reloadData];
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }

    }];
}
//请求卡片数据
-(void)requestDataWithCollectionCard{
    if (_currecPage >= 5) {
        return;
    }
    NSDictionary *parameters = @{
                                 @"page":@(_currecPage),
                                 @"name_id":userDefaultId,
                                 };
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=mainrecommend",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            
            _RepeatNum = 0;
            /**
             *  访问量
             */
            _viewString = [data[@"data"][1][@"access_amount"] integerValue];
            NSMutableArray *dataArr = data[@"data"];
            if (_currecPage == 0) {
                _collectionView.contentOffset = CGPointMake(kWvertical(35)+kWvertical(197)/2, 0);
 
            }
            for (NSDictionary *temp in dataArr) {
                
                CollectionCardModel *model = [CollectionCardModel initWithDictionary:temp];
                [weakself.collectionCaraDataArr addObject:model];
                
            }
            

            [_collectionView reloadData];
            
        }else{
//            [weakself alertShowView:@"网络错误"];
        }
        [weakself.tableview.mj_header endRefreshing];
    }];
}

//轮播图刷新
-(void)reloaNewData{
    _lastPosition = 0;
    _currecPage = 0;
    [self requestDataWithCollectionCard];
}
-(void)createProgress{
    
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
    [self.view addSubview:_placeView];
    
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
    
}
-(void)requestFriendsterData{
    
    if (_friendsterDataArr.count > 0) {
        _HUD = nil;
        [_placeView removeFromSuperview];
        
    }else{
        
        [self createProgress];
        
    }
    
    if (_refreshdid == 2) {
        _oneDid = 0;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"lastdid":@(0)
                                 };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getdyn",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        _HUD = nil;
        [_placeView removeFromSuperview];
        if (success) {
            
            NSArray *timeLineArr = data[@"data"];
            
            for (int i = 0; i<timeLineArr.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineArr[i][@"pics"]];
                
            }
            
            _layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }
            
            self.lastPage = [data[@"allpage"]intValue];
            if (_page == 0) {
                [weakself.friendsterDataArr removeAllObjects];
            }
            for (NSDictionary *timeLineDict in timeLineArr) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];
                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
            }
            
            FriendsterModel *model = [_friendsterDataArr lastObject];
            _oneDid = [model.did intValue];
            _lasdid = [model.did intValue];
            
            _did = [model.did intValue];
            _lastPage = [data[@"pages"] intValue];
            
            [weakself.tableview reloadData];
            
        }else{
            
//            [weakself alertShowView:@"网络错误"];
            
        }
    }];
}
-(void)createRefresh{
    
    //    头部刷新
    refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    //    立即刷新
    self.tableview.mj_header = refreshHeader;
    
    //    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableview.mj_footer = refreshFooter;
}

-(void)startHeaderRefresh{
    
    [refreshHeader beginRefreshing];
    
}
-(void)headerRefresh{
    _page = 0;
    [self requestInformationData];
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"lastdid":@(0)
                                 };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getdyn",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_header endRefreshing];
        if (success) {
            _noneDataView.hidden = YES;
            
            NSArray *timeLineArr = data[@"data"];
            
            [weakself.collectionCaraDataArr removeAllObjects];
            [weakself.friendsterDataArr removeAllObjects];
            [weakself.picsDataArr removeAllObjects];
            [weakself.layoutModelArr removeAllObjects];
            [weakself reloaNewData];
            
            for (int i = 0; i<timeLineArr.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineArr[i][@"pics"]];
                
            }
            
            weakself.layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
            }
            
            weakself.lastPage = [data[@"allpage"]intValue];
            for (NSDictionary *timeLineDict in timeLineArr) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];

                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
            }
            FriendsterModel *model = [weakself.friendsterDataArr lastObject];
            weakself.oneDid = [model.did intValue];
            weakself.lastPage = [data[@"pages"] intValue];
            weakself.tableview.hidden = NO;
            [weakself.tableview reloadData];
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
}

-(void)footerRefresh{
    _page++;
    if (_page > _lastPage) {
        _page--;
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"lastdid":@(_oneDid)
                                 };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getdyn",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_footer endRefreshing];
        if (success) {
            
            NSArray *timeLineDicts = data[@"data"];
            for (int i = 0; i<timeLineDicts.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineDicts[i][@"pics"]];
                
            }
            
            weakself.layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }
            
            weakself.lastPage = [data[@"allpage"]intValue];
            for (NSDictionary *timeLineDict in timeLineDicts) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];
                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
            }
            FriendsterModel *model = [_friendsterDataArr lastObject];
            weakself.oneDid = [model.did intValue];
            weakself.lasdid = _oneDid;
            weakself.lastPage = [data[@"pages"] intValue];
            [weakself.tableview reloadData];
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
    
}

// 请求未读消息数据
-(void)requestInformationData{
    NSDictionary *parameter = @{@"name_id":userDefaultId};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=unreadinfo",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            int num = [data[@"all"]intValue];
            NSString *focus = [NSString stringWithFormat:@"%@",data[@"focus"]];
            NSString *msgs = [NSString stringWithFormat:@"%@",data[@"msgs"]];
            int allnum = num - [focus intValue] - [msgs intValue];
            if (allnum == 0) {
                
                redView.hidden = YES;
                
            }else{
                redView.hidden = NO;
                redView.text = [NSString stringWithFormat:@"%d",allnum];
                redView.adjustsFontSizeToFitWidth = YES;
            }
            
            [userDefaults setValue:[NSString stringWithFormat:@"%d",allnum] forKey:@"unreadAll"];
        }
    }];
}
//搜索界面的数据
-(void)requestNextVCData{
    
    __weak typeof(self) weakself = self;
    self.hotDataArr = [[NSMutableArray alloc] init];
    NSDictionary *parameter = @{
                                @"nameID":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/FriendsRecommend",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dict = data[@"FriendsReco"];
            
            for (NSDictionary *temp in dict) {
                RecommendModel *model = [RecommendModel initWithFromDictionary:temp];
                [weakself.hotDataArr addObject:model];
            }
            
        }else{
        }
        
    }];
}

//设置浏览记录
-(void)setReviewList:(CollectionCardModel *)model{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSString *selectId = model.name_id;
    NSDictionary *dict = @{
                           @"click_name_id":userDefaultId,
                           @"coverclick_name_id":selectId
                           };
    
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_user_click_user",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
        }else{
            
        }
    }];
    
}


//设置用户alias

-(void)setApservice{
    NSString *alia = [NSString stringWithFormat:@"%@",userDefaultId];
    NSSet *set = [NSSet setWithObject:@"golvon"];
    [JPUSHService setTags:set alias:alia fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        //        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
}

-(void)reportData{
    
    //     report_type=举报内容，1为举报动态，2为举报评论，3为举报用户
    //    report_state=举报类型，1=色情信息,2=广告欺诈,3=不当发言,4=虚假消息
    
    WeakSelfType blockself = self;
    
    NSDictionary *parameters = @{@"name_id":userDefaultId,
                                 @"rid":_reportRid,
                                 @"content":_reportState,
                                 @"type":_reportType};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynreport",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        NSString *code = data[@"code"];
        if ([code isEqualToString:@"1"]) {
            [blockself alertSuccessShowView:@"提交成功"];
        }else{
            [blockself alertShowView:@"提交失败"];
        }
    }];
}


/**
 *  URLEncode
 */
- (NSString *)URLEncodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

#pragma mark ---- UICollection代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _collectionCaraDataArr.count;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(HScale(2.2), kWvertical(14), HScale(2.3), 0);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollection forIndexPath:indexPath];
    if (_collectionCaraDataArr.count>0) {
        [cell relayoutWithModel:_collectionCaraDataArr[indexPath.row]];
    }
    if (_collectionCaraDataArr.count != 0) {
        
        if (indexPath.row == self.collectionCaraDataArr.count - 8) {
            _currecPage++;
            [self requestDataWithCollectionCard];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    cell.LoadingBlock = ^(CollectionCardModel *model){
        
        [weakSelf clickToScord:model];
        
    };
    
    return cell;
}


// 预加载
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableview) {
        
        CGFloat offsetY = _tableview.contentOffset.y;
        
        if (offsetY >10) {
            
        }
        
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _itemSelect = @"1";
    
    CollectionCardModel *model = _collectionCaraDataArr[indexPath.row];
    __weak typeof(self) weakself = self;
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/updata_user_access",urlHeader120] parameters:@{@"name_id":model.name_id} complicate:^(BOOL success, id data) {
        if (success) {
            
            [weakself.collectionView reloadData];
        }
    } ];
    
    if (collectionView == _collectionView) {
        NewDetailViewController *VC = [[NewDetailViewController alloc] init];
        VC.nameID = model.name_id;
        VC.statue = model.interview_state;
        VC.index = indexPath.row;
//        VC.isFollow = model.follow_state
        VC.hidesBottomBarWhenPushed = YES;
        
        [VC setBlock:^(BOOL isback) {
            _viewString=[model.access_amount integerValue];
            _viewString++;
            model.access_amount=[NSString stringWithFormat:@"%ld",(long)_viewString];
            [weakself.collectionView reloadData];
        }];
        _needRefresh = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前显示的cell的下标
    //    NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    //
    //    if ([_itemSelect isEqualToString:@"1"]) {
    //        return;
    //    }
    //
    //    if (firstIndexPath.row == _collectionCaraDataArr.count-1) {
    ////        if (_totalNum==100) {
    //            if (_collectionCaraDataArr.count==indexPath.row+2) {
    //                [self alertShowView:@"已加载所有"];
    //            }
    ////        }
    //    }
    
}

#pragma mark ---- UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    friendsterModelmdoel = _friendsterDataArr[section-1];
    
    return friendsterModelmdoel.commets.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kHvertical(32);
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0;
    }
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:FriendsImageTableViewCellIdentifier configuration:^(id cell) {
            
            FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
            tempCell.fd_enforceFrameLayout = true;
            
            FriendsterModel *model = _friendsterDataArr[indexPath.section - 1];
            PhotoBrowerLayoutModel *layoutModel = self.layoutModelArr[indexPath.section - 1];
            
            [tempCell setModel:model];
            [tempCell setLayoutModel:layoutModel];
            
        }];
        
    }
    
    FriendsterModel *friendsterModel = _friendsterDataArr[indexPath.section-1];
    DynamicMessageModel *model = friendsterModel.commets[indexPath.row-1];
    if ([model.type isEqualToString:@"0"]) {
        //评论的时的高度
        if (Device >=9.0) {
            
            CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
        }else{
            CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
        }
        
        
    }
    else{
        //        回复的时候的高度
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = model.covnickname;
        [test sizeToFit];
        if (Device >= 9.0) {
            NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.covnickname,model.content];
            CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
            
        }
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.covnickname,model.content];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
            return kWvertical(55);
            
        }else{
            return TitleSize.height + kWvertical(23)+kHvertical(10);
        }
    }
    
//    return [tableView fd_heightForCellWithIdentifier:identifierTableview cacheByKey:[NSString stringWithFormat:@"ROWCACHE_%ld_%ld",(long)indexPath.section, (long)indexPath.row] configuration:^(id cell) {
//        FriendsterTableViewCell *tempCell = (FriendsterTableViewCell*)cell;
//        
//        tempCell.fd_enforceFrameLayout = true;
//        [tempCell relayoutWithModel:model];
//        
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _friendsterDataArr.count + 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
        [tempCell setDataWithModel:_friendsterDataArr[indexPath.section-1]];
        [tempCell setLayoutModel:self.layoutModelArr[indexPath.section-1]];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        FriendsImageTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: FriendsImageTableViewCellIdentifier forIndexPath:indexPath];
        FriendsterModel *model = _friendsterDataArr[indexPath.section-1];
        if ([model.uid isEqualToString:userDefaultUid]) {
            
            tempCell.followBtn.hidden = YES;
        }else{
            
            tempCell.followBtn.hidden = NO;
            
        }
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        tempCell.longpressHeader = ^(FriendsterModel *model){
            [weakSelf longpressHeader:model];
        };
        
        tempCell.commentBlock = ^(FriendsterModel *model){
            
            _sectionIndex = indexPath.section;
            [weakSelf clickToComment:model];
        };
        
        tempCell.likeBlock = ^(FriendsterModel *model){
            _sectionIndex = indexPath.section;
            [weakSelf clickToLike:model];
        };
        
        tempCell.clickHeaderIconBlock = ^(FriendsterModel *model){
            [weakSelf clickToHeaderIconBtn:model];
        };
        tempCell.longpressHeaderImageBlock = ^(FriendsterModel *model){
            
            [weakSelf longpressHeaderImage:model];
        };
        
        tempCell.followBlock = ^(FriendsterModel *model){
            
            [weakSelf setFollowBtn:model];
            
        };

        
        if (indexPath.section == 1) {
            tempCell.line.frame = CGRectMake(0, 0, ScreenWidth,0.5);
        }else{
            tempCell.line.frame = CGRectMake(0, 0, ScreenWidth,5);
        }
        
        return tempCell;
        
    }
    
    FriendsterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTableview];
    FriendsterModel *model = _friendsterDataArr[indexPath.section-1];
    _commentDataArr = model.commets;
    [cell relayoutWithModel:_commentDataArr[indexPath.row-1]];
    
    
    [cell.headerBtn addTarget:self action:@selector(clickToOwnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentNickname addTarget:self action:@selector(clickToOwnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyNickname addTarget:self action:@selector(clickToReplyDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak typeof(self) weakSelf = self;
    cell.longpressBlock = ^(DynamicMessageModel *model){
        
        [weakSelf longpressComment:model];
        
    };
        cell.pressHeaderBlock = ^(DynamicMessageModel *model){
        
        [weakSelf pressCellHeader:model];
        
    };
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UIImageView *hotImage = [[UIImageView alloc]init];
        hotImage.image = [UIImage imageNamed:@"热门推荐"];
        hotImage.frame = CGRectMake(kWvertical(12), kHvertical(12), kWvertical(10), kWvertical(10));
        [header addSubview:hotImage];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = @"球友圈动态";
        title.frame = CGRectMake(hotImage.right + kWvertical(4), kHvertical(7), kWvertical(60), kHvertical(18));
        if (Device >=9.0) {
            title.font = [UIFont fontWithName:Light size:kHorizontal(12)];
        }else{
            title.font = [UIFont systemFontOfSize:kHorizontal(12)];
        }
        title.textColor = GPColor(63, 63, 63);
        
        [header addSubview:title];
        return header;
    }
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *dynamicID=动态id  covComNameID=被评论人id replyFirComID=没回复的评论id，如果为一级评论，传0
     */
    
    
    [self.tableview deselectRowAtIndexPath:[_tableview indexPathForSelectedRow] animated:YES];
    if (indexPath.row > 0 ) {
        
        
        FriendsterModel *model = _friendsterDataArr[indexPath.section-1];
        DynamicMessageModel *model1 = model.commets[indexPath.row-1];
        _covComNameID = model1.covuid;
        _replyFirComID = model1.cid;
        _dynamicID = model.did;
        _sectionIndex = indexPath.section;
        _operateIndex = indexPath.row;

        
        if ([model1.comuid isEqualToString:userDefaultUid]) {
            [self deleteDynamic:model1];
        }else{
            _clikcDID = [model.did intValue];
            _currentInadexpath = indexPath;
            [self adjustTableViewToFitKeybord];
            
            _KeybordEmojiIcon.selected = NO;
            _emojiKeybordView.hidden = NO;
            _commentPlaceLabel.text = [NSString stringWithFormat:@"回复：%@",model1.nickname];
            resignFirstResponder.hidden = NO;
            [self.inputTextView becomeFirstResponder];
        }
        
    }else{
        return;
    }
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (scrollView == _tableview) {
        [self headerRefresh];
    }
}

#pragma mark ---- 代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == _longpressActionSheet) {
        switch (buttonIndex) {
                
            case 0:
                [self createPastedboard];
                break;
            case 1:
                [self createReportView];
                break;
                
            default:
                break;
        }
    }else if (actionSheet == _reportSheet){
        switch (buttonIndex) {
            case 0:
                
                [self createReportView];
                
                break;
                
            default:
                break;
        }
        
    }else{
        switch (buttonIndex) {
            case 0:
                _reportState = @"1";
                [self reportData];
                break;
            case 1:
                
                _reportState = @"2";
                [self reportData];
                break;
            case 2:
                
                _reportState = @"3";
                [self reportData];
                break;
            case 3:
                
                _reportState = @"4";
                [self reportData];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark ---- 点击事件
-(void)createReportView{
    _reportActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情信息",@"广告欺诈",@"不当发言",@"虚假信息", nil];
    
    _reportActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createPastedboard{
    
    [UIPasteboard generalPasteboard].string = _pastedStr;
    [self alertSuccessShowView:@"复制成功"];
}
-(void)longpressGestureRecognizer{
    
    _longpressActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制",@"举报", nil];
    _longpressActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_longpressActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createActionSheet{
    
    _reportSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    _reportSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
//长按评论
-(void)longpressComment:(DynamicMessageModel *)model{
    
    _reportRid = model.cid;
    _reportType = @"2";
    _pastedStr = model.content;
    
    [self longpressGestureRecognizer];
}
//长按动态
-(void)longpressHeader:(FriendsterModel *)model{
    
    _reportRid = model.did;
    _reportType = @"1";
    _pastedStr = model.content;
    if ([model.content isEqualToString:@""]) {
        [self createActionSheet];
        
    }else{
        
        [self longpressGestureRecognizer];
    }
}
//长按头像
-(void)longpressHeaderImage:(FriendsterModel *)model{
    
    _reportRid = model.uid;
    _reportType = @"3";
    [self createActionSheet];
}

-(void)pressCellHeader:(DynamicMessageModel *)model{
    
    _reportRid = model.covuid;
    _reportType = @"3";
    
    [self createActionSheet];
}
//消息发布
-(void)pushToRulesVC{
    PublishPhotoViewController *vc = [[PublishPhotoViewController alloc] init];
    [userDefaults removeObjectForKey:@"PublishPhotosArray"];
    [userDefaults setValue:@"2" forKey:@"PublishLogInType"];
    vc.hidesBottomBarWhenPushed = YES;
    _needRefresh = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消响应
-(void)clickResignFirstResponder{
    
    resignFirstResponder.hidden = YES;
    _isEmojiBtn = NO;
    _emojiKeybordView.hidden = YES;
    [_inputTextView resignFirstResponder];
    
}
//跳转到搜索界面
-(void)clickToSearch:(UIButton *)btn{
    
    SeachViewController *search = [[SeachViewController alloc]init];
    search.hotDataArr = self.hotDataArr;
    _emojiKeybordView.hidden = YES;
    search.hidesBottomBarWhenPushed = YES;
    _needRefresh = YES;
    [self.navigationController pushViewController:search animated:YES];
    
}


-(void)clickToScord:(CollectionCardModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *paramters = @{@"name_id":userDefaultId,
                                @"gid":model.group_id};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=checkgroup",apiHeader120] parameters:paramters complicate:^(BOOL success, id data) {
       
        if (success) {
            // 1是结束和有效
            NSDictionary *ginfo = data[@"ginfo"];
            weakself.isfinished = ginfo[@"isfinished"]; //是否结束
            weakself.isvali = ginfo[@"isvali"];         //是否有效
            weakself.player = ginfo[@"players"];       //组队人数
            if ([weakself.isfinished isEqualToString:@"1"] && [weakself.isvali isEqualToString:@"1"]) {
                
                [weakself createAlertView:model];
                return;
                
            }else if ([self.isfinished isEqualToString:@"1"] && [self.isvali isEqualToString:@"0"]){
                
                [self alertShowView:@"记分成绩无效"];
                return;
                
            }else{
                
                if ([weakself.player isEqualToString:@"0"]) {
                    
                    [weakself alertShowView:@"记分已删除"];
                    return;
                    
                }else if ([weakself.player isEqualToString:@"1"]) {
                    
                    NewStatisticsViewController *VC = [[NewStatisticsViewController alloc] init];
                    VC.loginNameId = userDefaultId;
                    VC.nameUid = model.name_id;
                    VC.groupId = model.group_id;
                    VC.isLoadDta = YES;
                    VC.status = 1;
                    VC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:VC animated:YES];
                    
                }else{
                    
                    GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
                    group.loginNameId = userDefaultId;
                    group.nameUid = model.name_id;
                    group.groupId = model.group_id;
                    group.isLoadDta = YES;
                    group.status = 1;
                    group.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:group animated:YES];
                    
                }
            }
            
        }
    }];
    
}
// 加关注
-(void)setFollowBtn:(FriendsterModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":model.uid
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *strCode = data[@"data"][0][@"code"];
            
            if ([strCode isEqualToString:@"1"]) {
                if (model.isfocused == YES) {
                    model.isfocused = NO;
                }else{
                    model.isfocused = YES;
                }
            }
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
        [self requestFriendsterData];
        [_tableview reloadData];
    }];
}
//点赞
-(void)clickToLike:(FriendsterModel *)model{
    NSDictionary *parameters = @{@"did":model.did,
                                 @"name_id":userDefaultId};
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=click",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = data[@"code"];
            NSString *isdel = data[@"isdel"];
            NSArray *arr = data[@"clicks"];
            if ([code isEqualToString:@"1"]) {
                if ([isdel isEqualToString:@"0"]) {
                    
                    FriendsterModel *friendModel = _friendsterDataArr[self.sectionIndex - 1];
                    NSDictionary *dic = arr.firstObject;
                    LikeUsersModel   *tempMode = [LikeUsersModel modelWithDictionary:dic];
                    [friendModel.clicks appendObject:tempMode];
                    model.isclicked = true;
                    [weakself.tableview reloadData];
                    
                }else{
                    
                    __block NSInteger deleteIndex = 0;
                    
                    [model.clicks enumerateObjectsUsingBlock:^(LikeUsersModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.cuid isEqualToString:userDefaultUid]) {
                            deleteIndex = idx;
                            *stop = true;
                        }
                    }];
                    
                    [model.clicks removeObjectAtIndex:deleteIndex];
                    model.isclicked = NO;
                    [weakself.tableview reloadData];
                }
                
                
            }else{
                
                NSLog(@"点赞失败");
            }
            
        }else{
            
//            [weakself alertShowView:@"网络错误"];
        }
    }];
}
//点击评论
-(void)clickToComment:(FriendsterModel *)model{
    
    _clikcDID = [model.did intValue];
    _commentNameID = model.uid;
    _dynamicID = model.did;
    resignFirstResponder.hidden = NO;
    _commentPlaceLabel.text = @"评论";
    _KeybordEmojiIcon.selected = NO;
    _inputTextView.inputView = nil;
    _emojiKeybordView.hidden = NO;
    [_inputTextView becomeFirstResponder];
    
    _row = 0;
    _section = 0;
    for (int i = 0; i<_friendsterDataArr.count; i++) {
        FriendsterModel *model = _friendsterDataArr[i];
        
        if ([model.did isEqualToString:_dynamicID]) {
            
            _section = i;
        }
    }
    
    for (int i = 0; i< model.commets.count; i++) {
        DynamicMessageModel *dyModel = model.commets[i];
        if ([dyModel.cid isEqualToString:_reportRid]) {
            _row = i;
        }
    }
    _cellHeght = kHvertical(50)*model.commets.count;
    _currentInadexpath = [NSIndexPath indexPathForRow:_row inSection:_section];
    [self adjuestTableviewHeaderToTop];
    
    
}

//点击头像
-(void)clickToHeaderIconBtn:(FriendsterModel *)model{
    NewDetailViewController *VC = [[NewDetailViewController alloc]init];
    VC.nameID = model.uid;
    VC.hidesBottomBarWhenPushed = YES;
    [VC setBlock:^(BOOL isback) {
        
    }];
    _needRefresh = YES;
    [self.navigationController pushViewController:VC animated:YES];
}



//跳转到评论人的个人中心
-(void)clickToOwnDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
    FriendsterModel *model = _friendsterDataArr[indexPath.section-1];
    DynamicMessageModel *dyModel = model.commets[indexPath.row-1];
    NSString *covNameID = dyModel.comuid;
    if (![covNameID isEqualToString:userDefaultUid]) {
        
        NewDetailViewController *VC = [[NewDetailViewController alloc]init];
        VC.nameID = covNameID;
        VC.hidesBottomBarWhenPushed = YES;
        [VC setBlock:^(BOOL isback) {
            
        }];
        _needRefresh = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

// 跳转到被回复人的个人中心
-(void)clickToReplyDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
    FriendsterModel *model = _friendsterDataArr[indexPath.section-1];
    DynamicMessageModel *dyModel = model.commets[indexPath.row-1];
    NSString *mesNameID = dyModel.covuid;
    if (![mesNameID isEqualToString:userDefaultUid]) {
        
        NewDetailViewController *VC = [[NewDetailViewController alloc]init];
        VC.nameID = mesNameID;
        VC.hidesBottomBarWhenPushed = YES;
        [VC setBlock:^(BOOL isback) {
            
        }];
        _needRefresh =YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)cilckToMessage{
    
    Follow_ViewController *follow = [[Follow_ViewController alloc]init];
    follow.hidesBottomBarWhenPushed = YES;
    _needRefresh =YES;
    [self.navigationController pushViewController:follow animated:YES];
    
}

-(void)clickToHidden{
    [_deleteView removeFromSuperview];
    [_deleteGroundView removeFromSuperview];
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




#pragma mark ---- 键盘通知
// 接收弹出键盘通知
-(void)keyboardShow:(NSNotification *)notification{
    NSString *textViewStr = _inputTextView.text;
    if (textViewStr.length==0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    
    
    NSDictionary *dic = notification.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    _KeybordEmojiIcon.selected = NO;
    _emojiView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _emojiKeybordView.frame = CGRectMake(0, ScreenHeight - kHvertical(44) - _keyBoardHeight, ScreenWidth, kHvertical(44)+kHvertical(216));
        _KeybordEmojiIcon.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.height-kHvertical(216) - kWvertical(44), kWvertical(44), kWvertical(44));
    }];
    
}
// 接收隐藏键盘的通知
-(void)keyboardHide:(NSNotification *)notification{
    
    if (self.isEmojiBtn == YES) {
        _emojiKeybordView.hidden = NO;
        _isEmojiBtn = NO;
    }else{
        _emojiKeybordView.hidden = YES;
    }
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.23 animations:^{
        
        weakself.emojiKeybordView.frame = CGRectMake(0, ScreenHeight-kHvertical(44)-kHvertical(216), ScreenWidth, kHvertical(44)+kHvertical(216)+kHvertical(49));
        
        weakself.inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
        weakself.KeybordEmojiIcon.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44)-kHvertical(216) - kHvertical(49), kWvertical(44), kHvertical(44));
        
        weakself.limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.top, kWvertical(44), kWvertical(44));
    }];
    
    if (_clikcDID == _lasdid) {
        
        CGPoint offset = self.tableview.contentOffset;
        offset.y -= _tableViewKeyboardDelta-kHvertical(50);
        [self.tableview setContentOffset:CGPointMake(0, offset.y) animated:YES];
    }
    
}
//键盘切换
-(void)changeKeyboard:(UIButton *)btn{
    _isEmojiBtn = YES;
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        _emojiView.hidden = NO;
        [_inputTextView resignFirstResponder];
    }else{
        
        [_inputTextView becomeFirstResponder];
    }
}

//跳转至AppStore
-(void)openUpdateUrl:(NSString *)url{
    
    NSString *str = [NSString stringWithFormat:@"%@",url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

#pragma mark ---- textView代理
//提交评论及回复
-(void)writhComment{
    NSString *commentDesc = [NSMutableString stringWithFormat:@"%@",_inputTextView.text];
    NSMutableString *commentTest = [NSMutableString stringWithString:commentDesc];
    NSString *str2 = [commentTest stringByReplacingOccurrencesOfString:@" " withString:@""];
    __weak typeof(self) weakself = self;
    if (str2.length<1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提交内容不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }else{
        if ([_commentPlaceLabel.text isEqualToString:@"评论"]) {
            NSDictionary *parameters = @{
                                         @"name_id":userDefaultId,    //评论人id
                                         @"did":_dynamicID,
                                         @"content":commentDesc
                                         };
            resignFirstResponder.hidden = YES;
            [_inputTextView resignFirstResponder];
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    NSString *code = data[@"code"];
                    NSArray *commets = data[@"commets"];
                    _inputTextView.text = @"";
                    if ([code isEqualToString:@"1"]) {
                        
                        FriendsterModel *model = _friendsterDataArr[self.sectionIndex-1];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableview reloadData];
                        
                    }else{
                        [weakself alertShowView:@"提交失败"];
                    }
                    
                }
            }];
        }else{
            NSDictionary *parameters = @{
                                         @"name_id":userDefaultId,
                                         @"did":_dynamicID,
                                         @"content":commentDesc,
                                         @"replycid":_replyFirComID,
                                         };
            resignFirstResponder.hidden = YES;
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [_inputTextView resignFirstResponder];
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    
                    _inputTextView.text = @"";
                    NSString *code = data[@"code"];
                    NSArray *commets = data[@"commets"];
                    if ([code isEqualToString:@"1"]) {
                        
                        FriendsterModel *model = weakself.friendsterDataArr[self.sectionIndex-1];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableview reloadData];
                        
                    }else{
                        [weakself alertShowView:@"提交失败"];
                    }
                }else{
//                    [weakself alertShowView:@"网络错误"];
                }
            }];
            
        }
    }
}
//textView改变
-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.inputTextView.text.length];
    int a = 200 - [len intValue];
    //    NSLog(@"%d",a);
    if (a<=0) {
        NSString *str = [textView.text substringToIndex:200];
        _inputTextView.text = str;
        a =0;
        /**超过200字符不能输入
         */
        [_alertView removeFromSuperview];
        [_alertView.contentLabel removeFromSuperview];
        
        _alertView = [[NewAlertView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - kHvertical(32), ScreenWidth, kHvertical(64))];
        _alertView.contentLabel.textColor = [UIColor whiteColor];
        [_alertView setContentWith:@"😅最多输入200字符"];
        [self.view addSubview:_alertView];
        [self.view addSubview:_alertView.contentLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView removeFromSuperview];
            [_alertView.contentLabel removeFromSuperview];
        });
        
    }
    if(a <=50){
        _limitLabel.hidden = YES;
        _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _inputTextView.top, kWvertical(44), kWvertical(44));
        _limitLabel.text = [NSString stringWithFormat:@"%d",a];
    }
    
    if (textView.text.length == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    //    if (textView.contentSize.height>HScale(3.9)) {
    //
    //        if (textView.contentSize.height>HScale( 16.2)) {
    //
    //            _emojiKeybordView.frame = CGRectMake(0, HScale(97.9) - _keyBoardHeight - HScale(16.2), ScreenWidth,  HScale(16.2)+HScale(2.1)+kHvertical(216));
    //            _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(16.2));
    //        }else{
    //            _emojiKeybordView.frame = CGRectMake(0, HScale(97.9) - _keyBoardHeight - textView.contentSize.height, ScreenWidth,  textView.contentSize.height+HScale(2.1)+kHvertical(216));
    //            _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), textView.contentSize.height);
    //
    //        }
    //    }
    //
    //    _KeybordEmojiIcon.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44), kWvertical(44), kHvertical(44));
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputTextView resignFirstResponder];
    
    _isEmojiBtn = NO;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self writhComment];
        
    }
    return YES;
}
//表情键盘操作
-(void)textViewChange:(NSString *)emojiStr{
    
    NSString *mStr = _inputTextView.text;
    if (mStr == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    BOOL isEmoji = NO;
    
    if ([emojiStr isEqualToString:@"EmojiDeleat"]) {
        if ([mStr length]==0) {
            return;
        }
        if ([mStr length]>=2) {
            NSString *mStr1 = [mStr substringWithRange:NSMakeRange(mStr.length-2, 2)];
            isEmoji = [self isEmoji:mStr1];
        }
        
        mStr = [mStr substringToIndex:mStr.length-1];
        if (isEmoji) {
            mStr = [mStr substringToIndex:mStr.length-1];
        }
        
    }else{
        mStr = [NSMutableString stringWithFormat:@"%@%@", _inputTextView.text,emojiStr];
    }
    _inputTextView.text = mStr;
    
    
    [self textViewDidChange:_inputTextView];
    
}

#pragma mark - 百度地图定位信息
-(void)createLocation{
    
    self.locationManager = [[BMKLocationService alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager startUserLocationService];
    self.locationManager.distanceFilter = 5.0f;

}


#pragma mark - BMKUserLocation Delegate


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CGFloat latitude  = userLocation.location.coordinate.latitude;
    CGFloat longitude = userLocation.location.coordinate.longitude;
    NSString *lat = [NSString stringWithFormat:@"%0.14f",latitude];
    NSString *lon = [NSString stringWithFormat:@"%0.14f",longitude];
    [userDefaults setValue:lat forKey:@"latitude"];
    [userDefaults setValue:lon forKey:@"longitude"];
    
    NSLog(@"%@",lat);

    [self.locationManager stopUserLocationService];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager startUserLocationService];
    });
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    __weak __typeof(self)weakSelf = self;
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks) {
            weakSelf.cityname = placemark.locality;
            [userDefaults setValue:weakSelf.cityname forKey:@"locationCity"];
            //                        if (province.length == 0) {
            //                            province = placemark.locality;
            //                            cityname = placemark.subLocality;//区
            //                            NSLog(@"cityname %@",cityname);
            //                            NSLog(@"province %@ ++",province);
            //                        }else {
            //                            //获取街道地址
            //                            citystr = placemark.thoroughfare;
            //                            //获取城市名
            //                            cityname = placemark.locality;
            //                            province = placemark.administrativeArea;
            //                            nslog(@"city %@",citystr);//获取街道地址
            //                            nslog(@"cityname %@",cityname);//获取城市名
            //                            nslog(@"province %@",province);
            //                        }114.79142,34.545529
            break;
        }
    }];
    
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    
}


#pragma mark ==== 评论或者回复的时候，让键盘往上移动
-(void)adjuestTableviewHeaderToTop{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //UITableViewHeaderFooterView *header = [_tableview headerViewForSection:_section+1];
    
    UITableViewCell *header = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_section+1]];
    //    NSLog(@"第%d段",_page);
    CGRect cellFrame = CGRectMake(header.origin.x, header.origin.y, header.width, header.height + _cellHeght+kHvertical(49));
    CGRect rect = [header.superview convertRect:cellFrame toView:window];
    [self adjustTableViewToFitKeybordWithRect:rect];
    
}
-(void)adjustTableViewToFitKeybord{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:_currentInadexpath];
    CGRect cellFrame = CGRectMake(cell.origin.x, cell.origin.y, cell.width, cell.height +kHvertical(49));
    CGRect rect = [cell.superview convertRect:cellFrame toView:window];
    [self adjustTableViewToFitKeybordWithRect:rect];
}

-(void)adjustTableViewToFitKeybordWithRect:(CGRect)rect{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat keyboardHeight;
    if (_keyBoardHeight == 0) {
        
        if (self.view.frame.size.height <= 568)
        {
            keyboardHeight = 251.5;
            
        }else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667){
            
            keyboardHeight = 258;
        }else{
            
            keyboardHeight = 292;
            
        }
    }else{
        
        keyboardHeight = _keyBoardHeight;
    }
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - keyboardHeight);
    
    CGPoint offset = self.tableview.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableview setContentOffset:CGPointMake(0, offset.y) animated:YES];
    _tableViewKeyboardDelta = delta;
}

@end
