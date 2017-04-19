//
//  ScoreCardViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ScoreCardViewController.h"
#import "RulesTableViewCell.h"
#import "DownLoadDataSource.h"
#import "RulesModel.h"
#import "UIImageView+WebCache.h"
#import "MoreFriendViewController.h"
#import "NoneFriendViewController.h"
#import "UIView+Size.h"
#import "RulesModel.h"
#import "SupportViewController.h"
#import "SimpleInterest.h"
#import "RecommendModel.h"
#import "RankSelfHeader.h"
#import "PopoverView.h"
//#import "APService.h"
@interface ScoreCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView                  *navi;
    UIView *headerView;
    CGFloat headerY;
    UIButton *rightBtn;
    UILabel *title;
    /**灰色背景*/
    UIView *_greyGroundView;
    UIView *_whiteView;
    UIImageView *_rulePicture;
    UIButton *_knowBtn;
    UIButton *_gotoDetail;//跳转自己的个人主页
    MBProgressHUD *_HUD;
    CGFloat _lastOffY; ///< tableView滑动时最后的偏移量, 用于判断tableView的滑动方向
    UIButton *chooseBtn;
}
@property (strong, nonatomic) UITableView    *tableView;
/**
 *  封面图片
 */
@property (strong, nonatomic) UIImageView    *coverImage;
/***  工具类*/
@property (strong, nonatomic) DownLoadDataSource    *loadData;
/***  自己的排行*/
@property (strong, nonatomic) NSMutableArray    *selfRankArr;
/***  好友的排行*/
@property (strong, nonatomic) NSMutableArray    *friendRankArr;
/***  全部的排行*/
@property (strong, nonatomic) NSMutableArray    *allRankArr;
/***  关注状态*/
@property (strong, nonatomic) NSNumber    *likeState;


/***  第一名的头像*/
@property (strong, nonatomic) UIImageView    *firstHeaderImage;
/***  第一名的昵称*/
@property (strong, nonatomic) UILabel    *firstNickname;
/***  第一名封面*/
@property (strong, nonatomic) NSString     *coverURL;
/***  第一名头像*/
@property (strong, nonatomic) NSString     *headerURL;
/***  第一名昵称*/
@property (strong, nonatomic) NSString     *nickName;
/***  第一名的nameid*/
@property (strong, nonatomic) NSString    *firstNameID;


/***  label*/
@property (strong, nonatomic) UILabel    *label;
/***  zhuangtai*/
@property (strong, nonatomic) NSString    *state;

@property (strong ,nonatomic) RulesModel *selfModel;

/***  有没有关注好友*/
@property (strong, nonatomic) NSString    *FriendsRankingStatr;
/***  封面蒙版*/
@property (strong, nonatomic) UIImageView       *maskImage;

/***  等待View*/
@property (strong, nonatomic) UIView    *placeView;
@property (strong, nonatomic) UIView *noneDataView;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSArray   *selecedArr;
@property (copy, nonatomic) NSString *selectedStr;

@end

static NSString *identifier = @"RulesTableViewCell";
static NSString *headerID = @"RankSelfHeader";

@implementation ScoreCardViewController
-(NSArray *)selecedArr{
    if (!_selecedArr) {
        _selecedArr = [NSMutableArray array];
    }
    return _selecedArr;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _coreDataManager = [CoreDataManager sharedCoreDataManager];
    }
    return self;
    
}

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableArray *)selfRankArr{
    if (!_selfRankArr) {
        _selfRankArr = [[NSMutableArray alloc]init];
    }
    return _selfRankArr;
}
-(NSMutableArray *)friendRankArr{
    if (!_friendRankArr) {
        _friendRankArr = [[NSMutableArray alloc]init];
    }
    return _friendRankArr;
}
-(NSMutableArray *)allRankArr{
    if (!_allRankArr) {
        _allRankArr = [[NSMutableArray alloc]init];
    }
    return _allRankArr;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGFloat offsetY = _tableView.contentOffset.y;
    if (offsetY>kHvertical(64)) {
        //黑色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        //白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    [_firstHeaderImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"firstImage"]] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    if (self.popID == 2) {
        [self headerRefresh];
    }
    
    if (_dataArr.count>1) {
        [self scrollToIndex];
    }
    if (!_selectedStr) {
        
        [self requestDataWithString:@"2017"];
    }else{
        
        [self requestDataWithString:_selectedStr];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_greyGroundView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.view.backgroundColor = TINTLINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _nickName = @"";
    _popID = 0;
    [self createNav];
    [self createHeaderView];
    self.selecedArr = @[@"全部",@"2016年",@"2017年"];
    _selectedIndex = 2;
    [self testNetState];
}

-(void)testNetState{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == AFNetworkReachabilityStatusNotReachable) {
            _tableView.hidden = YES;
            [self createNoInternet];
        }else{
            [self headerRefresh];
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}
#pragma mark ---- 创建UI
//显示黑色电池栏
-(void)ViewBlackBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


-(void)createNav{
    
    navi                 = [[UIView alloc]init];
    navi.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:navi];
    [navi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kHvertical(0));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, kHvertical(64)));
    }];
    
    title  = [[UILabel alloc]init];
    title.textColor = [UIColor whiteColor];
    title.text      = @"铁人榜";
    title.font      = [UIFont systemFontOfSize:kHorizontal(18)];
    title.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:title];
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navi).with.offset(kHvertical(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, kHvertical(44)));
    }];
    [title sizeToFit];
    
    
    //右边按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, kHvertical(20), kWvertical(44), kWvertical(44));
    [rightBtn setTitle:@"规则" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [rightBtn addTarget:self action:@selector(clictRulesButton) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [navi addSubview:rightBtn];
    
    chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(ScreenWidth - kWvertical(44), kHvertical(20), kWvertical(44), kWvertical(44));
    [chooseBtn setImage:[UIImage imageNamed:@"scordRighticon"] forState:UIControlStateNormal];
    [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [chooseBtn addTarget:self action:@selector(clickChooseYear:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:chooseBtn];
}

-(void)createUI{
    //封面照片
    UIView *View = [[UIView alloc] init];
    View.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(181));
    View.backgroundColor = [UIColor whiteColor];
    
    _coverImage = [[UIImageView alloc]init];
    _coverImage.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(181));
    _coverImage.clipsToBounds = YES;
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToFirstDetailVC)];
    [_coverImage addGestureRecognizer:tap];
    [View addSubview:_coverImage];
    _maskImage = [[UIImageView alloc]init];
    _maskImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(11.5));
    _maskImage.image = [UIImage imageNamed:@"1封面蒙板"];
    [_coverImage addSubview:_maskImage];
    
    //第一名的头像
    _firstHeaderImage = [[UIImageView alloc]init];
    [_coverImage addSubview:_firstHeaderImage];
    //第一名的昵称
    _firstNickname = [[UILabel alloc]init];
    _firstNickname.text = @"";
    [_coverImage addSubview:_firstNickname];
    
    [_tableView removeAllSubviews];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[RulesTableViewCell class] forCellReuseIdentifier:identifier];
    [_tableView registerClass:[RankSelfHeader class] forHeaderFooterViewReuseIdentifier:headerID];
    _tableView.tableHeaderView = View;
    _tableView.separatorColor = GPColor(244, 244, 244);
    _tableView.sectionHeaderHeight = 6;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self createRefresh];
}
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

-(void)createHeaderView{
    UIImageView *groundImage = [[UIImageView alloc]init];
    groundImage.frame = CGRectMake(ScreenWidth - kWvertical(107), kHvertical(183)  - kHvertical(28), kWvertical(107), kHvertical(28));
    groundImage.image = [UIImage imageNamed:@"异形"];
    [self.view addSubview:groundImage];
    
    UILabel *chang = [[UILabel alloc]init];
    chang.frame = CGRectMake(kWvertical(31), kHvertical(6), kWvertical(24), kHvertical(17));
    chang.text = @"场次";
    chang.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [chang sizeToFit];
    [groundImage addSubview:chang];
    
    UILabel *like = [[UILabel alloc]init];
    like.frame = CGRectMake(kWvertical(68), kHvertical(6), kWvertical(24), kHvertical(17));
    like.text = @"点赞";
    like.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [like sizeToFit];
    [groundImage addSubview:like];
    groundImage.userInteractionEnabled = NO;
    headerView = groundImage;
    headerView.userInteractionEnabled = NO;
    
}

-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}

//榜单规则
-(void)clictRulesButton{
    _greyGroundView = [UIView new];
    _greyGroundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [_greyGroundView addSubview:backgroundView];
    
    [[[UIApplication sharedApplication].windows firstObject] addSubview:_greyGroundView];
    
    _rulePicture = [UIImageView new];
    _rulePicture.userInteractionEnabled = YES;
    _rulePicture.frame = CGRectMake((ScreenWidth - WScale(74.7))/2, (ScreenHeight - HScale(62.2))/2,  WScale(74.7), HScale(62.2));
    _rulePicture.image = [UIImage imageNamed:@"『铁人榜』排名规则"];
    [_greyGroundView addSubview:_rulePicture];
    
    
    _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _knowBtn.frame = CGRectMake(0, kHvertical(352), _rulePicture.width, kHvertical(65));
    _knowBtn.backgroundColor = [UIColor clearColor];
    [_knowBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_rulePicture addSubview:_knowBtn];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(_rulePicture.width - kWvertical(22), -kHvertical(5), kWvertical(24), kWvertical(24));
    image.image = [UIImage imageNamed:@"选择关闭"];
    [_rulePicture addSubview:image];
    
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    [butn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    butn.frame = CGRectMake(_rulePicture.width - kWvertical(50), -kHvertical(26), kWvertical(80), kWvertical(80));
    [_rulePicture addSubview:butn];
}

#pragma mark ---- button的点击事件

-(void)clickCancelBtn{
    _greyGroundView.hidden = YES;
    _whiteView.hidden = YES;
    
}
-(void)clickChooseYear:(UIButton *)sender{
    
    PopoverView *popoverView = [PopoverView popoverView];
    [popoverView showToPoint:CGPointMake(CGRectGetWidth(self.view.bounds) - 28, 60) withTitles:self.selecedArr selectedIndex:_selectedIndex handler:^(NSUInteger selectedIndex){
        _selectedIndex = selectedIndex;
        if (selectedIndex == 0) {
            [self requestDataWithString:@"all"];
        }else if (selectedIndex == 1){
            [self requestDataWithString:@"2016"];
        }else{
            [self requestDataWithString:@"2017"];
        }
    }];
}
//跳转到自己的个人主页
-(void)clickGoToDetailVC{
    
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    detail.nameID = userDefaultId;
    [detail setBlock:^(BOOL isback) {
        
    }];
    detail.hidesBottomBarWhenPushed = YES;
    [self ViewBlackBar];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}
//自己点赞界面
-(void)selfLickButton{
    
    SupportViewController *VC = [[SupportViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.nameid = _nameID;
    [self ViewBlackBar];
    
    [self.navigationController pushViewController:VC animated:YES];
}
//更多好友
-(void)createMoreFriend{
    
    MoreFriendViewController *VC = [[MoreFriendViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self ViewBlackBar];
    
    [self.navigationController pushViewController:VC animated:YES];
}
// 推荐好友
-(void)createNoneFriend{
    
    NoneFriendViewController *VC = [[NoneFriendViewController alloc]init];
    
    VC.dataArr = self.dataArr;
    VC.hidesBottomBarWhenPushed = YES;
    [self ViewBlackBar];
    
    [self.navigationController pushViewController:VC animated:YES];
}
//点击封面跳转第一名头像
-(void)clickToFirstDetailVC{
    
    
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    detail.nameID = _firstNameID;
    [detail setBlock:^(BOOL isback) {
        
    }];
    detail.hidesBottomBarWhenPushed = YES;
    [self ViewBlackBar];
    
    [self.navigationController pushViewController:detail animated:YES];
}
// 点赞
-(void)clickLikeBtn:(RulesModel *)model{
    __weak typeof(self) weakself = self;
    if ([model.name_id isEqualToString:userDefaultId]) {
        
        SupportViewController *support = [[SupportViewController alloc]init];
        support.hidesBottomBarWhenPushed = YES;
        [self ViewBlackBar];
        
        [self.navigationController pushViewController:support animated:YES];
        
    }else{
        
        NSDictionary *parameter = @{
                                    @"nameID":userDefaultId,
                                    @"rankNameID":model.name_id
                                    };
        [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertRankClick",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
            if (success) {
                
                NSNumberFormatter *num = [[NSNumberFormatter alloc]init];
                weakself.likeState = data[@"data"][0][@"code"];
                NSString *str = [num stringFromNumber:_likeState];
                
                if ([str isEqualToString:@"1"]) {
                    
                }
                
                [weakself requestDataWithString:_selectedStr];
                
            }else{
//                [weakself alertShowView:@"网络错误"];
            }
        }];
        
    }
    
}

#pragma mark ---- 请求数据
-(void)initWithHistoryData{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要抓取哪种类型的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViewHistoryData" inManagedObjectContext:self.coreDataManager.managedObjContext];
    // 设置抓取实体
    [request setEntity:entity];
    NSError *error = nil;
    // 执行抓取数据的请求，返回符合条件的数据
    NSArray *eventArray = [[self.coreDataManager.managedObjContext
                            executeFetchRequest:request error:&error] mutableCopy];
    if (eventArray.count>0) {
    ViewHistoryData *test = [eventArray objectAtIndex:0];
    id data = test.rankTableview;
    _state = data[@"UserRank"][@"zongChangCi"];
    if (_state) {
        _selfModel = [RulesModel relayoutWithModel:data[@"UserRank"]];
    }
    
    [self.allRankArr removeAllObjects];
    for (NSDictionary *all_temp in data[@"Ranking"]) {
        RulesModel *model = [RulesModel relayoutWithModel:all_temp];
        _coverURL = data[@"Ranking"][0][@"touxiang_url"];
        _headerURL = data[@"Ranking"][0][@"picture_url"];
        _nickName = data[@"Ranking"][0][@"nickname"];
        _firstNameID = data[@"Ranking"][0][@"name_id"];
        [self.allRankArr addObject:model];
        
    }
    
    [_coverImage setFindImageStr:_coverURL];
    
    SimpleInterest *manager = [SimpleInterest sharedSingle];
    if (manager.isFromA == YES) {
        manager.isFromA = NO;
        _nameID = manager.supportNameID;
        int row = 0;
        for (int i = 0; i<_allRankArr.count; i++) {
            RulesModel *model1 = _allRankArr[i];
            if ([model1.name_id isEqualToString:_nameID]) {
                row = i;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *targetIndexpath = [NSIndexPath indexPathForRow:row inSection:1];
            [self.tableView selectRowAtIndexPath:targetIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self requestWithBadgeValue];
        });
        
    }
    
    _FriendsRankingStatr = data[@"FriendsRankingStatr"];
    if ([_FriendsRankingStatr isEqualToString:@"1"]) {
        [self.friendRankArr removeAllObjects];
        
        for (NSDictionary *friend_temp in data[@"FriendsRanking"]) {
            RulesModel *model = [RulesModel relayoutWithModel:friend_temp];
            [self.friendRankArr addObject:model];
        }
    }
    [self setModel];
    [_tableView reloadData];
        
    }

    
}

//已有数据跳转
-(void)scrollToIndex{
    SimpleInterest *manager = [SimpleInterest sharedSingle];
    if (manager.isFromA == YES) {
        manager.isFromA = NO;
        _nameID = manager.supportNameID;
        int row = 0;
        for (int i = 0; i<_allRankArr.count; i++) {
            RulesModel *model1 = _allRankArr[i];
            if ([model1.name_id isEqualToString:_nameID]) {
                row = i;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *targetIndexpath = [NSIndexPath indexPathForRow:row inSection:1];
            [self.tableView selectRowAtIndexPath:targetIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self requestWithBadgeValue];
        });
        
    }

}
-(void)createProgress{
    
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_placeView];
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
}
-(void)requestDataWithString:(NSString *)year{
    _selectedStr = year;
    if (_allRankArr > 0) {
        [_placeView removeFromSuperview];
        _HUD = nil;
    }else{
        [self createProgress];
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"nameID":userDefaultId,
                                @"year":year};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRanking",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        
        [_placeView removeFromSuperview];
        _HUD = nil;
        if (success) {
            
            [self.allRankArr removeAllObjects];
            [self.friendRankArr removeAllObjects];
            [self.selfRankArr removeAllObjects];
            self.state = data[@"UserRank"][@"zongChangCi"];
            if ([weakself.state intValue]>0) {
                weakself.selfModel = [RulesModel relayoutWithModel:data[@"UserRank"]];
                [self.selfRankArr addObject:self.selfModel];
            }
            
            [self.allRankArr removeAllObjects];
            for (NSDictionary *all_temp in data[@"Ranking"]) {
                RulesModel *model = [RulesModel relayoutWithModel:all_temp];
                weakself.coverURL = data[@"Ranking"][0][@"touxiang_url"];
                weakself.headerURL = data[@"Ranking"][0][@"picture_url"];
                weakself.nickName = data[@"Ranking"][0][@"nickname"];
                weakself.firstNameID = data[@"Ranking"][0][@"name_id"];
                [weakself.allRankArr addObject:model];
                
            }
            
            [weakself.coverImage setFindImageStr:weakself.coverURL];
            
            SimpleInterest *manager = [SimpleInterest sharedSingle];
            if (manager.isFromA == YES) {
                manager.isFromA = NO;
                weakself.nameID = manager.supportNameID;
                int row = -1;
                
                for (int i = 0; i<_allRankArr.count; i++) {
                    RulesModel *model1 = weakself.allRankArr[i];
                    if ([model1.name_id isEqualToString:weakself.nameID]) {
                        row = i;
                    }
                }
                if (row>-1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSIndexPath *targetIndexpath = [NSIndexPath indexPathForRow:row inSection:1];
                    [weakself.tableView selectRowAtIndexPath:targetIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    [weakself requestWithBadgeValue];
                });
                }
            }
            
            weakself.FriendsRankingStatr = data[@"FriendsRankingStatr"];
            if ([weakself.FriendsRankingStatr isEqualToString:@"1"]) {
                [weakself.friendRankArr removeAllObjects];
                
                for (NSDictionary *friend_temp in data[@"FriendsRanking"]) {
                    RulesModel *model = [RulesModel relayoutWithModel:friend_temp];
                    [weakself.friendRankArr addObject:model];
                }
            }
            
            [weakself.coverImage sd_setImageWithURL:[NSURL URLWithString:weakself.coverURL] placeholderImage:[UIImage imageNamed:@"动态等待图"]];
            [userDefaults setObject:weakself.headerURL forKey:@"firstImage"];
            [weakself setModel];
            
            
//            NSFetchRequest *request = [[NSFetchRequest alloc] init];
//            // 设置要抓取哪种类型的实体
//            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViewHistoryData" inManagedObjectContext:self.coreDataManager.managedObjContext];
//            // 设置抓取实体
//            [request setEntity:entity];
//            [request setEntity:[NSEntityDescription entityForName:@"ViewHistoryData" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext]];
//            NSError *error = nil;
//            NSArray *result = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//            
//            for (int i = 0; i<result.count; i++) {
//                ViewHistoryData *test = [result objectAtIndex:i];
//                
//                test.rankTableview = data;
//            }
//            //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
//            BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
//            if (!isSaveSuccess) {
////                NSLog(@"Error: %@,%@",error,[error userInfo]);
//            }else
//            {
////                NSLog(@"Save successFull");
//            }
            [_tableView reloadData];
        }else{
            [weakself alertShowView:@"网络错误"];
        }
        
    }];
    
}

-(void)createRefresh{
    
    //    头部刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_header = refreshHeader;
}

-(void)headerRefresh{
    __weak typeof(self) weakself = self;
    [self.tableView.mj_footer resetNoMoreData];
    NSDictionary *parameter = @{@"nameID":userDefaultId,
                                @"year":_selectedStr};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRanking",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            _noneDataView.hidden = YES;
            
            [self.allRankArr removeAllObjects];
            [self.friendRankArr removeAllObjects];
            [self.selfRankArr removeAllObjects];
            weakself.state = data[@"UserRank"][@"zongChangCi"];
            if (weakself.state) {
                weakself.selfModel = [RulesModel relayoutWithModel:data[@"UserRank"]];
                [self.selfRankArr addObject:self.selfModel];
            }
            
            [weakself.allRankArr removeAllObjects];
            for (NSDictionary *all_temp in data[@"Ranking"]) {
                RulesModel *model = [RulesModel relayoutWithModel:all_temp];
                weakself.coverURL = data[@"Ranking"][0][@"touxiang_url"];
                weakself.headerURL = data[@"Ranking"][0][@"picture_url"];
                weakself.nickName = data[@"Ranking"][0][@"nickname"];
                weakself.firstNameID = data[@"Ranking"][0][@"name_id"];
                [weakself.allRankArr addObject:model];
                
            }
            [weakself.friendRankArr removeAllObjects];
            weakself.FriendsRankingStatr = data[@"FriendsRankingStatr"];
            if ([weakself.FriendsRankingStatr isEqualToString:@"1"]) {
                [weakself.friendRankArr removeAllObjects];
                
                for (NSDictionary *friend_temp in data[@"FriendsRanking"]) {
                    RulesModel *model = [RulesModel relayoutWithModel:friend_temp];
                    [weakself.friendRankArr addObject:model];
                }
            }
            weakself.tableView.hidden = NO;
            [weakself setModel];
            [weakself.tableView reloadData];
            
        }
        
    }];
    
}

//下个界面请求数据
-(void)requestLoadData{
    __weak typeof(self) weakself = self;
    self.dataArr = [NSMutableArray array];
    NSDictionary *parameter = @{@"nameID":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/FriendsRecommend",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *dict = data[@"FriendsReco"];
            for (NSDictionary *temp in dict) {
                RecommendModel *model = [RecommendModel initWithFromDictionary:temp];
                [weakself.dataArr addObject:model];
            }
            [weakself.tableView reloadData];
            
        }else{
//            NSLog(@"网络错误");
        }
        
    }];
}


//其他数据
-(void)setModel{
    
    //第一名的昵称
    UILabel *test = [[UILabel alloc]init];
    test.frame = CGRectMake((ScreenWidth - 200)/2, kHvertical(96), 200, kHvertical(17));
    test.font = [UIFont systemFontOfSize:kHorizontal(14)];
    test.textAlignment = NSTextAlignmentCenter;
    test.text = [NSString stringWithFormat:@"  %@占领了封面",_nickName];
    [test sizeToFit];
    
    _firstNickname.text = test.text;
    _firstNickname.frame = CGRectMake((ScreenWidth - test.width)/2+kWvertical(19), test.top, test.width, test.height);
    
    _firstNickname.textColor = [UIColor whiteColor];
    _firstNickname.layer.shadowColor = GPColor(26, 26, 26).CGColor;
    _firstNickname.layer.shadowOffset = CGSizeMake(0, 2);
    _firstNickname.layer.shadowOpacity = 0.5;
    _firstNickname.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _firstNickname.textAlignment = NSTextAlignmentCenter;
    [_firstNickname sizeToFit];
    
    //第一名的头像
    [_firstHeaderImage sd_setImageWithURL:[NSURL URLWithString:_headerURL] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    _firstHeaderImage.frame = CGRectMake(_firstNickname.left - kWvertical(38), kHvertical(85), kWvertical(38), kWvertical(38));
    _firstHeaderImage.clipsToBounds = YES;
    _firstHeaderImage.layer.cornerRadius = kWvertical(38)/2;
    
    _label.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(28));
    _label.textAlignment = NSTextAlignmentCenter;
    [_label sizeToFit];
    
}

#pragma mark ---- UITableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(57);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        
        if ([_FriendsRankingStatr isEqualToString:@"0"]) {
            return 0;
        }else{
            if (_friendRankArr.count > 2) {
                return 2;
                
            } else {
                
                return _friendRankArr.count;
            }
        }
        
    }else{
        return _allRankArr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return kHvertical(57);
    }else{
        return kHvertical(4.5);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        if ([_FriendsRankingStatr isEqualToString:@"0"] || _friendRankArr.count>2) {
            return kHvertical(33);
        }else{
            return CGFLOAT_MIN;
        }
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        RankSelfHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
        if (_state) {
            
            view.noneRank.hidden = YES;
            
            view.nickName.hidden = false;
            view.headerImage.hidden = false;
            view.Vimage.hidden = false;
            view.rankLabel.hidden = false;
            view.changCiLabel.hidden = false;
            view.likeNum.hidden = false;
            view.likeImage.hidden = false;
            
            [view relayoutWithModel:self.selfRankArr[0]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(selfLickButton) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(ScreenWidth-kWvertical(52), 0, kWvertical(52), kHvertical(52));
            [view addSubview:button];
            
        }else{
            view.nickName.hidden = YES;
            view.headerImage.hidden = YES;
            view.Vimage.hidden = YES;
            view.rankLabel.hidden = YES;
            view.changCiLabel.hidden = YES;
            view.likeNum.hidden = YES;
            view.likeImage.hidden = YES;
            
            view.noneRank.hidden = NO;
        }
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(kWvertical(12), kHvertical(7), kWvertical(200), kHvertical(17));
        label.font = [UIFont systemFontOfSize:kHorizontal(12)];
        label.textColor = localColor;
        [view addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(kWvertical(355), kHvertical(9), kWvertical(8), kHvertical(14));
        [view addSubview:image];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(33));
        button.backgroundColor = [UIColor clearColor];
        [view addSubview:button];
        if ([_FriendsRankingStatr isEqualToString:@"0"]) {
            label.text = @"为您推荐的球友";
            image.image = [UIImage imageNamed:@"RightSelected"];
            [button addTarget:self action:@selector(createNoneFriend) forControlEvents:UIControlEventTouchUpInside];
        }else if (_friendRankArr.count >2) {
            label.text = @"查看更多关注球友";
            image.image = [UIImage imageNamed:@"RightSelected"];
            [button addTarget:self action:@selector(createMoreFriend) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = GPColor(246, 246, 246);
    
    if (indexPath.section == 0) {
        cell.rankImage.hidden = YES;
        cell.allRankLabel.hidden = YES;
        cell.rankLabel.hidden = NO;
        cell.nickName.frame = CGRectMake(cell.headerImage.x + cell.headerImage.width + kWvertical(8), kHvertical(8), kWvertical(150), kHvertical(20));
        
        __weak typeof(self) weakself = self;
        cell.lickBtnBlock = ^(RulesModel *model){
            
            [weakself clickLikeBtn:model];
            
        };
        [cell relayoutWithModel:_friendRankArr[indexPath.row]];
        
    }else if(indexPath.section == 1){
        
        CGFloat Y = (kHvertical(55)-kHvertical(20))/2;
        cell.nickName.frame = CGRectMake(kWvertical(82), Y, kWvertical(150), kHvertical(20));
        if (indexPath.row<3) {
            
            cell.rankImage.hidden=NO;
            cell.allRankLabel.hidden = YES;
            cell.rankLabel.hidden = YES;
            NSArray *imageName = @[@"榜单第一",@"榜单第二",@"榜单第三"];
            cell.rankImage.image = [UIImage imageNamed:imageName[indexPath.row]];
        }else{
            
            cell.rankImage.hidden=YES;
            cell.allRankLabel.hidden = NO;
            cell.rankLabel.hidden = YES;
            cell.allRankLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        }
        [cell relayoutWithModel:_allRankArr[indexPath.row]];

        __weak typeof(self) weakself = self;
        cell.lickBtnBlock = ^(RulesModel *model){
            
            [weakself clickLikeBtn:model];
            
        };
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
        if (_friendRankArr != nil) {
            RulesModel *model = _friendRankArr[indexPath.row];
            if ([model.name_id isEqualToString:@"usergolvon"]) {
                [aid setBlock:^(BOOL isView) {
                }];
                aid.hidesBottomBarWhenPushed = YES;
                [self ViewBlackBar];
                
                [self.navigationController pushViewController:aid animated:YES];
            }else if ([model.name_id isEqualToString:userDefaultId]){
                
                
                detail.nameID = userDefaultId;
                [detail setBlock:^(BOOL isback) {
                    
                }];
                detail.hidesBottomBarWhenPushed = YES;
                [self ViewBlackBar];
                
                [self.navigationController pushViewController:detail animated:YES];
                
            } else{
                
                detail.nameID = model.name_id;
                [detail setBlock:^(BOOL isback) {
                    
                }];
                detail.hidesBottomBarWhenPushed = YES;
                [self ViewBlackBar];
                
                [self.navigationController pushViewController:detail animated:YES];
            }
            
        }
        
        
    }else{
        
        RulesModel *model1 = _allRankArr[indexPath.row];
        if ([model1.name_id isEqualToString:@"usergolvon"]) {
            [aid setBlock:^(BOOL isView) {
                
            }];
            aid.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];
            
            [self.navigationController pushViewController:aid animated:YES];
            
        }else{
            detail.nameID = model1.name_id;
            [detail setBlock:^(BOOL isback) {
                
            }];
            detail.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];
            
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    
}
-(void)requestWithBadgeValue{
    
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=unreadinfo",apiHeader120] parameters:@{@"name_id":userDefaultId} complicate:^(BOOL success, id data) {
        if (success) {
            
           
            UITabBarController *tabVC = (UITabBarController *)self.view.window.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[4];
            NSString *redNum = [NSString stringWithFormat:@"%@",data[@"all"]];
            if ([redNum isEqualToString:@"0"]) {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[redNum integerValue]];
                //                [APService setBadge:[redNum integerValue]];
                
                pushClassStance.tabBarItem.badgeValue = nil;
                return;
            }
            pushClassStance.tabBarItem.badgeValue = redNum;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[redNum integerValue]];
//                        [APService setBadge:[redNum integerValue]];
        }
    }];
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        [self headerRefresh];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>(kHvertical(182)-kHvertical(64))) {
        headerView.y =  kHvertical(64)  - kHvertical(28);
    }else{
        headerView.y =  kHvertical(182)  - kHvertical(28)-offsetY;
    }
    
    //获取偏移量
    
    navi.backgroundColor = [UIColor colorWithWhite:1 alpha:self.tableView.contentOffset.y/100];
    if (self.tableView.contentOffset.y>kHvertical(64)) {
        
        title.textColor = BlackColor;
        [rightBtn setTitleColor:BlackColor forState:UIControlStateNormal];
    }else{
        title.textColor = [UIColor colorWithWhite:1 alpha:1];
        [rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    }
    
    if (offsetY > kHvertical(120)) {
        chooseBtn.hidden = true;
    }else{
        chooseBtn.hidden = false;

    }

    if (offsetY>kHvertical(64)) {
        //黑色
        return [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        //白色
        return [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    }


@end
