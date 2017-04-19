//
//  ViewController.m
//  Jifenka
//
//  Created by shiyingdong on 16/6/1.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "SelectMethodMViewController.h"

#import "CodeViewController.h"
#import "SingleScoringViewController.h"
#import "StartScoringViewController.h"
#import "SaveScoreView.h"
#import "ScoringViewController.h"
#import "StatisticsViewController.h"
#import "DownLoadDataSource.h"
#import "CharityViewController.h"
#import "OwnShareCharityModel.h"
#import "WXApi.h"
#import "ScorViewCell.h"
#import "JPUSHService.h"
#import "MarkAlertView.h"

#import "NewStartScoringViewController.h"

static NSString *identifier = @"ScorViewCell";


@interface SelectMethodMViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *sharBackView;
    UIView *shareView;
    UIImageView *bottom;
    UIImageView *shareImageView;    //分享出去的背景图
    UIImageView *NewBottomView;
    
}
@property (strong, nonatomic) UIScrollView      *scrollView;  //滚动
@property (strong, nonatomic) UIButton          *bezelButton;  //外圈
@property (strong, nonatomic) UILabel           *bezelLabel;  //标题
@property (assign, nonatomic) CGRect             bezelRect;
@property (assign, nonatomic) BOOL               isAnim;

@property (nonatomic, strong)UITableView        *pushView;
@property (nonatomic, strong)UILabel            *pushLabel;
@property (nonatomic, assign) CGFloat            bezelBtnOriginalY; ///< 打球记分按钮原Y轴数值
@property(nonatomic,strong)NSString             *GroupId;

@property(nonatomic , strong) ScorModel        *dataIng;//正在进行
@property(nonatomic , strong) ScorModel        *dataHistory;//最近一次
@property(nonatomic,strong)NSString             *DoneNum;//已完成的洞数



@property (strong, nonatomic) UIView             *shareview;
/**
 *  分享的view
 */
@property (strong, nonatomic) UIImageView       *shareImage;
/**
 *  本次捐赠场次
 */
@property (strong, nonatomic) UILabel           *changThis;
/**
 *  本次捐赠金额
 */
@property (strong, nonatomic) UILabel           *moneyThis;
/**
 *  累计金额
 */
@property (strong, nonatomic) UILabel      *allMoney;
/**
 *  累计场次
 */
@property (strong, nonatomic) UILabel      *allChang;
/**
 *  头像
 */
@property (strong, nonatomic) UIImageView  *headerImage;


@property (nonatomic, strong)NSMutableArray *userArry;

@property (nonatomic, strong)NSMutableArray *userIdArry;

@property(nonatomic,strong)NSString         *chengjiID;//成绩id;

@property(nonatomic,copy)NSString  *jilu_user;//记录人id
/**
 *  分享带数据的view
 */
@property (strong, nonatomic) UIView      *shareDataView;

@property(nonatomic,strong)NSString         *startClick;//点击开始记分时请求数据判断是否有正在进行,默认@"0",点击开始记分为@"1";


@property(nonatomic,strong)NSString         *ingParkName;//球场名称

@end

@implementation SelectMethodMViewController

-(NSMutableArray *)userArry{
    if (_userArry==nil) {
        _userArry = [NSMutableArray array];
    }
    return _userArry;
}

-(NSMutableArray *)userIdArry{
    if (_userIdArry==nil) {
        _userIdArry = [NSMutableArray array];
    }
    return _userIdArry;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _startClick = @"0";
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;

    
    _dataIng = nil;
    _dataHistory = nil;
    
    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    
    if (!PlayerDict) {
        _bezelButton.userInteractionEnabled = NO;
        [_bezelButton setTitle:@"开始记分" forState:UIControlStateNormal];
        [self loadData];
    }else{
        [_bezelButton setTitle:@"继续记分" forState:UIControlStateNormal];
        [self loadData];
    }
    NSString *showCharityView = [userDefaults objectForKey:@"showCharityView"];
    if (!showCharityView) {
        [userDefaults setValue:@"0" forKey:@"showCharityView"];
    }
    if ([showCharityView isEqualToString:@"1"]) {
        [self createShareView];
        [userDefaults setValue:@"0" forKey:@"showCharityView"];
    }
    [_pushView reloadData];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [userDefaults removeObjectForKey:@"ViewMatchDict"];
    
    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    
    if (MatchDict) {
        _pushLabel.hidden = YES;
        NSDictionary *PlaceDict = [MatchDict objectForKey:@"PlaceDict"];
        if (!PlaceDict) {
            return;
        }
        _ballPark.text = [PlaceDict objectForKey:@"qiuchang_name"];
        NSMutableString *time = [NSMutableString stringWithFormat:@"%@",[PlaceDict objectForKey:@"chuangjian_time"]];
        [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
        [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
        [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
        [time deleteCharactersInRange:NSMakeRange(0, 5)];
        [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
        
        NSArray *dongIngNum = [MatchDict objectForKey:@"第1位已完成洞号"];
        if (!dongIngNum) {
            dongIngNum = @[];
        }
        _timeLabel.text = [NSString stringWithFormat:@"%@  完成%lu/18洞",time,(unsigned long)dongIngNum.count];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resevNotic];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MarkAlertView *view = (MarkAlertView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
}

//显示黑色电池栏
-(void)ViewBlackBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)resevNotic{
#pragma mark- 接收自定义推送消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)networkDidReceiveMessage:(NSNotification *)noti{
    NSLog(@"%@",noti);
    id dict = noti.userInfo;
    NSDictionary *extras = [dict objectForKey:@"extras"];
    NSString *UpdateChengJi = [extras objectForKey:@"PushToStat"];
    NSString *JPushCode = [extras objectForKey:@"JPushCode"];

    if ([UpdateChengJi isEqualToString:@"7"]||[JPushCode isEqualToString:@"9"]||[JPushCode isEqualToString:@"10"]||[UpdateChengJi isEqualToString:@"8"]||[JPushCode isEqualToString:@"6"]) {
        [self loadData];
    }
}

#pragma mark - 创建View
-(void)createUI{
    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    NSDictionary *ViewMatchDict = [userDefaults objectForKey:@"ViewMatchDict"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
    _scrollView.backgroundColor = GPColor(32, 190, 189);
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(48.1))];
    image.image = [UIImage imageNamed:@"绿色底"];
    [_scrollView addSubview:image];
    
    // 打球记分按钮
    _bezelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bezelBtnOriginalY = HScale(13.8);
    _bezelButton.frame = CGRectMake((ScreenWidth-WScale(45.9))/2, _bezelBtnOriginalY, WScale(45.9), HScale(25.8));
    _bezelRect = _bezelButton.frame;
    _bezelButton.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(22)];
    [_bezelButton setTitleColor:GPColor(32, 190, 189) forState:UIControlStateNormal];
    [_bezelButton setTitle:@"开始记分" forState:UIControlStateNormal];
    [_bezelButton setBackgroundImage:[UIImage imageNamed:@"打球记分按钮"] forState:UIControlStateNormal];
    _bezelButton.userInteractionEnabled = YES;
    [_bezelButton addTarget:self action:@selector(cilckToSrcol) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_bezelButton];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(3.7), 35, WScale(5.1), HScale(3))];
    leftView.image = [UIImage imageNamed:@"历史记录"];
    
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0,0, 35, HScale(9));
    [leftBtn addTarget:self action:@selector(leftBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBtn addSubview:leftView];
    [self.view addSubview:leftBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    label.text = @"记分卡";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    if (self.view.frame.size.height <= 568)
    {
        label.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
        
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
    {
        
        label.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    }else{
        
        label.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
        
    }
    [self.view addSubview:label];
    
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(5.7), 35, WScale(5.1), HScale(3))];
    rightView.image = [UIImage imageNamed:@"我的二维码"];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(WScale(85), HScale(0), WScale(15), HScale(9));
    [rightBtn addTarget:self action:@selector(rightBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addSubview:rightView];
    [self.view addSubview:rightBtn];
    
    
    UIView *image2 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(48.1), ScreenWidth, ScreenHeight)];
    image2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:image2];
    UIView *image1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    image1.backgroundColor = [UIColor whiteColor];
    [image2 addSubview:image1];
    
    
    _pushLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(10.7), ScreenWidth, HScale(3.3))];
    _pushLabel.text = @"让记分成为一种习惯";
    _pushLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _pushLabel.textAlignment = NSTextAlignmentCenter;
    _pushLabel.textColor = [UIColor blackColor];
    
    [image1 addSubview:_pushLabel];
    
    [image1 addSubview:_pushView];
    
    
    UIButton *gongyi_dianji = [[UIButton alloc] initWithFrame:CGRectMake(WScale(33.05), HScale(25), WScale(33.9), HScale(13))];
//        gongyi_dianji.backgroundColor = [UIColor redColor];
    
    UIImageView *descLabel = [[UIImageView alloc] init];
    descLabel.frame = CGRectMake(0, HScale(9.2), WScale(33.9), HScale(2.1));
    
    [descLabel setImage:[UIImage imageNamed:@"公益口号"]];
    
    
    UIImageView *gongyi = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(12.55), HScale(3.6), WScale(8.8), HScale(3.9))];
    gongyi.image = [UIImage imageNamed:@"公益"];
    
    
    [gongyi_dianji addTarget:self action:@selector(joinNowClick) forControlEvents:UIControlEventTouchUpInside];
    
    [gongyi_dianji addSubview:descLabel];
    [gongyi_dianji addSubview:gongyi];
    [image1 addSubview:gongyi_dianji];
    
    //    [image1 addSubview:gongyi];
    
    _pushLabel.hidden = NO;
    if (MatchDict&&ViewMatchDict) {
        [_bezelButton setTitle:@"继续记分" forState:UIControlStateNormal];
        
        _pushLabel.hidden = YES;
        _pushLabel = nil;
    }
}

//创建tableView
-(void)createTableView{
    
    _pushView = [[UITableView alloc] initWithFrame:CGRectMake(0, HScale(9), ScreenWidth, HScale(11.8))];
    _pushView.delegate = self;
    _pushView.dataSource = self;
    [_pushView registerClass:[ScorViewCell class] forCellReuseIdentifier:identifier];
    _pushView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pushView.scrollEnabled = NO;
    
    
    UILongPressGestureRecognizer *tpg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [_pushView addGestureRecognizer:tpg];
    
}
-(void)createShareView{
    
    /**灰色蒙版*/
    _groundView = [[UIView alloc]init];
    _groundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _groundView.backgroundColor = [UIColor blackColor];
    _groundView.alpha = 0.5;
    _groundView.hidden = NO;
    _groundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBack)];
    [self.view addSubview:_groundView];
    [_groundView addGestureRecognizer:tap];
    /**背景图片*/
    _viewGroundView = [[UIImageView alloc]init];
    _viewGroundView.frame = CGRectMake((ScreenWidth - WScale(76.5))/2, HScale(12.7), WScale(76.5), HScale(74.7));
    [_viewGroundView setImage:[UIImage imageNamed:@"底板"]];
    _viewGroundView.layer.cornerRadius = 8;
    _viewGroundView.hidden = NO;
    _viewGroundView.backgroundColor = [UIColor whiteColor];
    _viewGroundView.userInteractionEnabled = YES;
    [self.view addSubview:_viewGroundView];
    
    /**口号*/
    UIImageView *slogan = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(33.6))/2, HScale(55.3), WScale(33.6), HScale(2.2))];
    slogan.image = [UIImage imageNamed:@"打球公益口号"];
    [_viewGroundView addSubview:slogan];
    
    UIImageView *sloganImage = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(31.2))/2, HScale(58.9), WScale(31.2), HScale(2.8))];
    sloganImage.image = [UIImage imageNamed:@"打球去和大城小爱"];
    [_viewGroundView addSubview:sloganImage];
    
    
    /**Friendster朋友圈*/
    UIButton *friendster = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendster setBackgroundImage:[UIImage imageNamed:@"微信朋友圈"] forState:UIControlStateNormal];
    friendster.frame = CGRectMake(WScale(14.1), HScale(67), WScale(13.3), HScale(6.4));
    [friendster addTarget:self action:@selector(clickToPengYouQuan) forControlEvents:UIControlEventTouchUpInside];
    [_viewGroundView addSubview:friendster];
    
    /**Friendster好友*/
    UIButton *friend = [UIButton buttonWithType:UIButtonTypeCustom];
    [friend setBackgroundImage:[UIImage imageNamed:@"微信好友"] forState:UIControlStateNormal];
    friend.frame = CGRectMake(WScale(76.5) - WScale(17.9) - WScale(10.7), HScale(67), WScale(10.7), HScale(6.3));
    [friend addTarget:self action:@selector(clickToHaoYou) forControlEvents:UIControlEventTouchUpInside];
    [_viewGroundView addSubview:friend];
    
    
    /**分享图片*/
    //    sharBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WScale(76.5), HScale(51.5))];
    //    sharBackView.backgroundColor = [UIColor clearColor];
    //    [_shareview addSubview:sharBackView];
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WScale(76.5), HScale(51.1))];
    shareImage.image = [UIImage imageNamed:@"分享上_底色"];
    [_viewGroundView addSubview:shareImage];
    
    _shareViewBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, HScale(50), WScale(76.5), HScale(23.5))];
    _shareViewBottom.image = [UIImage imageNamed:@"分享下_"];
    
    
    
    /**头像*/
    UILabel *groundLabel = [[UILabel alloc]init];
    groundLabel.frame = CGRectMake((WScale(76.5) - WScale(14.4))/ 2, HScale(2.5), WScale(14.4), HScale(8.19));
    groundLabel.backgroundColor = [UIColor whiteColor];
    groundLabel.layer.masksToBounds = YES;
    groundLabel.layer.cornerRadius = HScale(8.19)/2;
    [_viewGroundView addSubview:groundLabel];
    //
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(((WScale(76.5) - WScale(14.4))/ 2)+2, HScale(2.5)+2, WScale(14.4)-4, HScale(8.19)-4)];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = (HScale(8.19)-4)/2;
    
    [_viewGroundView addSubview:_headerImage];
    
    /**
     场次等数据界面
     */
    _dataView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScale(76.5), HScale(50))];
    _dataView.backgroundColor = [UIColor clearColor];
    
    /**捐助场次*/
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(24.7), WScale(76.5), HScale(2.7))];
    label.text = @"本次成绩";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = GPColor(178, 176, 176);
    label.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_dataView addSubview:label];
    
    
    _changThis = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(28), WScale(76.5), HScale(6.7))];
    _changThis.textAlignment = NSTextAlignmentCenter;
    _changThis.textColor = GPColor(217, 69, 54);
    _changThis.font = [UIFont systemFontOfSize:kHorizontal(32)];
    [_dataView addSubview:_changThis];
    
    
    
    /**累计金额  场次*/
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(WScale(16.3), HScale(43.3), WScale(13.9), HScale(2.7))];
    label1.text = @"累计金额";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = GPColor(64, 64, 64);
    label1.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_dataView addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(WScale(76.5)-WScale(16.3)- WScale(13.9), HScale(43.3), WScale(13.9), HScale(2.7))];
    label2.text = @"累计场次";
    label2.textColor = GPColor(64, 64, 64);
    label2.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_dataView addSubview:label2];
    /**本次金额*/
    
    UILabel *donateLabel = [[UILabel alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(56))/2, HScale(36.1), WScale(56), HScale(3))];
    donateLabel.textAlignment = NSTextAlignmentCenter;
    [_dataView addSubview:donateLabel];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WScale(24), HScale(3))];
    logoImage.image = [UIImage imageNamed:@"携手打球去"];
    [donateLabel addSubview:logoImage];
    
    UILabel *donate = [[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.origin.x+logoImage.frame.size.width+3, 3, WScale(24), HScale(3))];
    donate.text = @"打球去捐出";
    donate.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [donate sizeToFit];
    [donateLabel addSubview:donate];
    
    _moneyThis = [[UILabel alloc]initWithFrame:CGRectMake(donate.frame.origin.x + donate.frame.size.width+3, 3, WScale(12), HScale(3))];
    _moneyThis.textAlignment = NSTextAlignmentCenter;
    _moneyThis.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _moneyThis.textColor = GPColor(238, 108, 33);
    
    [donateLabel sizeToFit];
    [donateLabel addSubview:_moneyThis];
    
    /**总金额*/
    _allMoney = [[UILabel alloc]initWithFrame:CGRectMake(WScale(10.3), HScale(47.2), WScale(25.9), HScale(3))];
    _allMoney.textAlignment = NSTextAlignmentCenter;
    _allMoney.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _allMoney.textColor = GPColor(238, 108, 33);
    [_dataView addSubview:_allMoney];
    
    /**总场次*/
    _allChang = [[UILabel alloc]initWithFrame:CGRectMake(WScale(76.5)-WScale(16.3)- WScale(13.9), HScale(47.2), WScale(13.9), HScale(3))];
    _allChang.textAlignment = NSTextAlignmentCenter;
    _allChang.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _allChang.textColor = GPColor(238, 108, 33);
    
    [_dataView addSubview:_allChang];
    
    [_viewGroundView addSubview:_dataView];
    
}

-(void)createShareOtherView{
    
    _shareView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - WScale(76.5))/2, HScale(12.7), WScale(76.5), HScale(74.7))];
    
    _shareView.backgroundColor = [UIColor whiteColor];
    _shareView.image = [UIImage imageNamed:@"分享底板"];
    
    [_shareView addSubview:_headerImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(12.1), WScale(76.5), HScale(3.6))];
    nameLabel.text = [userDefaults objectForKey:@"nickname"];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_shareView addSubview:nameLabel];
    
    UIImageView *thanksLabel = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(8.8), HScale(17.1), WScale(58.9), HScale(2.8))];
    
    thanksLabel.image = [UIImage imageNamed:@"分享_感谢话语"];
    
    
    
    //
    [_shareView addSubview:thanksLabel];
    
    
    
    
    UIImageView *QRView = [[UIImageView alloc] initWithFrame:CGRectMake((WScale(76.5)-HScale(8))/2, HScale(54.5), HScale(8), HScale(8))];
    
    QRView.image = [UIImage imageNamed:@"分享二维码"];
    
    [_shareView addSubview:QRView];
    
    UIImageView *slogan = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(33.6))/2, HScale(64.5), WScale(33.6), HScale(2.2))];
    slogan.image = [UIImage imageNamed:@"打球公益口号"];
    [_shareView addSubview:slogan];
    
    UIImageView *sloganImage = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(31.2))/2, HScale(68.1), WScale(31.2), HScale(2.8))];
    sloganImage.image = [UIImage imageNamed:@"打球去和大城小爱"];
    [_shareView addSubview:sloganImage];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(74.7)-1, WScale(76.5), 1)];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    [_shareView addSubview:topView];
    
    //创建浅色边框
    for (NSInteger i = 0; i<2; i++) {
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake((WScale(76.5)-1)*i, HScale(20), 1, HScale(54.4))];
        
        leftView.backgroundColor = [UIColor whiteColor];
        [_shareView addSubview:leftView];
    }
    [self loadData];
}

-(void)createAlertMark{
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    testLabel.text = @"长按或左滑可退出记分";
    [testLabel sizeToFit];

    CGFloat x = ScreenWidth - testLabel.frame.size.width - kWvertical(30);
    
    
    MarkAlertView *alert = [[MarkAlertView alloc] initWithFrame:CGRectMake(x, HScale(68), 10, kHvertical(33))];
    alert.mode = MarkAlertViewModeLeftTop;
    alert.tag = 101;
    [alert createWithContent:@"长按或左滑可退出记分"];
    
    [_scrollView addSubview:alert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            alert.alpha = 0;
        } completion:^(BOOL finished) {
            [alert removeFromView];
        }];
    });
}

#pragma mark - 保存本地
-(void)savePoto{
    
    
    shareView = [[UIView alloc]init];
    shareView.frame = CGRectMake((ScreenWidth - WScale(76.5))/2, HScale(12.7), WScale(76.5), HScale(65.5));
    [shareView addSubview:shareImageView];
    
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, YES, 2);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(img, self,  @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    //    [self.view addSubview:sharBackView];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];

            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

-(void)clickToBack{
    _groundView.hidden = YES;
    _viewGroundView.hidden = YES;
    _groundView = nil;
    _viewGroundView = nil;
}

#pragma mark - 分享好友
-(void)clickToHaoYou{
    [self createShareOtherView];
    [self clickToBack];
    [_shareView addSubview:_dataView];
    UIGraphicsBeginImageContextWithOptions(_shareView.bounds.size, YES, 2);
    [_shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData =  UIImageJPEGRepresentation(img,1.2);
    message.mediaObject = ext;
    
    //    UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700, 400) sizeOfImage:img];
    
    message.thumbData =  UIImageJPEGRepresentation(img,0.1);
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
    
    
}
#pragma mark - 分享朋友圈

-(void)clickToPengYouQuan{
    
    [self createShareOtherView];
    [self clickToBack];
    [_shareView addSubview:_dataView];
    UIGraphicsBeginImageContextWithOptions(_shareView.bounds.size, YES, 2);
    [_shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    [self.view addSubview:SecBackView];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData =  UIImageJPEGRepresentation(img,1.2);
    message.mediaObject = ext;
    
    message.thumbData =  UIImageJPEGRepresentation(img,0.1);
    sendReq.message = message;
    sendReq.bText = NO;
    [WXApi sendReq:sendReq];
    
}

#pragma mark - 点击响应(Action)

-(void)joinNowClick{
    
    CharityViewController *charity = [[CharityViewController alloc]init];
    charity.hidesBottomBarWhenPushed = YES;
    [self ViewBlackBar];
    [self.navigationController pushViewController:charity animated:YES];
}



//开始打球
-(void)cilckToSrcol{
    NSString *BtnTitle =  _bezelButton.titleLabel.text;
    if ([BtnTitle isEqualToString:@"准备记分"]) {
        return;
    }
    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    NSLog(@"%@",MatchDict);
    //    NSDictionary *ViewMatchDict = [userDefaults objectForKey:@"ViewMatchDict"];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    if ([_ingParkName isEqualToString:@"0"]) {
        StartScoringViewController *vc = [[StartScoringViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        
        if ([_bezelButton.titleLabel.text isEqualToString:@"继续记分"]) {
            vc.groupID = _GroupId;
        }
        [self ViewBlackBar];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
    if (PlayerDict) {
        NSString *Num = [PlayerDict objectForKey:@"playerNum"];
        if ([Num isEqualToString:@"1"]) {
            SingleScoringViewController *vc = [[SingleScoringViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];

            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ScoringViewController *vc =[[ScoringViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];

            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (_dataIng){
        [self downloadData];
    }else{
        _startClick = @"1";
        [self loadData];
        
        }
    }
}

// 打球记录
-(void)leftBtnClike{
    NSLog(@"打球记录");
    SaveScoreView *vc = [[SaveScoreView alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.name_id = userDefaultId;
    [self ViewBlackBar];

    [self.navigationController pushViewController:vc animated:YES];
};
// 我的二维码
-(void)rightBtnClike{
//    NSLog(@"二维码");
//    CodeViewController *vc =[[CodeViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self ViewBlackBar];
//
//    [self.navigationController pushViewController:vc animated:YES];

    NewStartScoringViewController *vc = [[NewStartScoringViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)clickHidden{
    _groundView.hidden = YES;
    _shareview.hidden = YES;
    _shareImage.hidden = YES;
}
//长按
-(void)longPress{
    NSString *content;

    __weak __typeof(self)weakSelf = self;
    ScorModel *model = _dataIng;
    if (_dataHistory) {
        model = _dataHistory;
        _chengjiID = model.group_chengji_id;
    }
    
    if ([model.zongganshu isEqualToString:@"0"]) {
            content = @"删除记分";
        }else if (_dataIng){
            if ([weakSelf.jilu_user isEqualToString:userDefaultId]) {
                content = @"删除记分";
            }else{
                content = @"退出记分";
            }
        }else{
                content = @"点击分享";
        }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        if([content isEqualToString:@"点击分享"]) {
            [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf createShareView];
                [weakSelf requestWithShareData];
            }]];
        }else{
        [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if ([content isEqualToString:@"退出记分"]) {
                [weakSelf exitGroup];
            } else if([content isEqualToString:@"删除记分"]) {
                [weakSelf clickToDelegate];
            }
        }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


#pragma mark - 请求数据
-(void)loadData{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    _dataIng = nil;
    _dataHistory = nil;
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"code":@"1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_group_ing",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            _bezelButton.userInteractionEnabled = YES;
            [_bezelButton setTitle:@"开始记分" forState:UIControlStateNormal];
            
            NSDictionary *dataDict = [data objectForKey:@"data"][0];
            NSLog(@"%@",dataDict);
            NSArray *dataAll = [dataDict objectForKey:@"data_all"];
            NSString *code = [dataDict objectForKey:@"code"];
            NSInteger codeInt = [code integerValue];
            if (codeInt == 3) {
                _pushLabel.hidden = NO;
                _pushView.hidden = YES;
                
                if ([_startClick isEqualToString:@"1"]) {
                    if (!_dataIng) {
                        StartScoringViewController *vc = [[StartScoringViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
//                        
//                        CATransition *animation = [CATransition animation];
//                        [animation setDuration:0.3f];
//                        [animation setTimingFunction:[CAMediaTimingFunction
//                                                      functionWithName:kCAMediaTimingFunctionEaseOut]];
//                        [animation setType:kCATransitionPush];
//                        [animation setSubtype: kCATransitionFromRight];
//                        [self.view.layer addAnimation:animation forKey:@"Reveal"];
//                        [self.navigationController.view.layer addAnimation:animation forKey:nil];
                        if ([_bezelButton.titleLabel.text isEqualToString:@"继续记分"]) {
                            vc.groupID = _GroupId;
                        }
                        [self ViewBlackBar];

                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    _startClick = @"0";
                }
                
            }else{
                _pushLabel.hidden = YES;
                _pushView.hidden = NO;
            }
            
            for (NSDictionary *dict in dataAll) {
                _pushLabel.hidden = YES;
                
                _GroupId = [dict objectForKey:@"group_id"];
                _ballPark.text = [dict objectForKey:@"qiuchang_name"];
                
                _userArry = [NSMutableArray array];
                _userIdArry = [NSMutableArray array];
                if (_userArry.count==0) {
                    for (NSDictionary *userDict in [dict objectForKey:@"group_user"]) {
                        [_userArry addObject:[userDict objectForKey:@"nickname"]];
                        [_userIdArry addObject:[userDict objectForKey:@"name_id"]];
                    }
                }
                
                NSMutableString *time = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"chuangjian_time"]];
                [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
                [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
                
                [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
                
                [time deleteCharactersInRange:NSMakeRange(0, 5)];
                [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
                
                NSString *dongIngNum = [dict objectForKey:@"dongIngNum"];
                if (!dongIngNum) {
                    dongIngNum = @"0";
                }
                NSString *groupStatr = [dict objectForKey:@"groupStatr"];
                if (!groupStatr) {
                    groupStatr = [NSString string];
                }
                NSString *ingStr;
//                NSString *ingStr = [NSString string];
                if (![groupStatr isEqualToString:@"1"]) {
                    ingStr = [NSString stringWithFormat:@"%@  未完成",time];
                }else{
                    ingStr = [NSString stringWithFormat:@"正在进行 完成%@/18洞",dongIngNum];
                }
                NSString *qiuchang_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"qiuchang_name"]];
                _jilu_user = [dict objectForKey:@"jilu_user"];
                NSDictionary *ingDict = @{
                                          @"ingStr":ingStr,
                                          @"qiuchang_name":qiuchang_name,
                                          @"groupStatr":groupStatr,
                                          };
                if (codeInt==1) {
                    NSArray *Players = [dict objectForKey:@"group_user"];
                    NSString *jilu_user = [dict objectForKey:@"jilu_user"];
                    
                    _ingParkName = qiuchang_name;
                    
                    [_bezelButton setTitle:@"查看记分" forState:UIControlStateNormal];
                    
                    if ([jilu_user isEqualToString:userDefaultId]) {
                        [_bezelButton setTitle:@"继续记分" forState:UIControlStateNormal];
                    }else if ([_ingParkName isEqualToString:@"0"]){
                        [_bezelButton setTitle:@"准备记分" forState:UIControlStateNormal];
                    }
                    
                    _dataIng = [ScorModel pareFromWithDictionary:ingDict];
                    _chengjiID = [dict objectForKey:@"group_chengji_id"];
                    [_pushView reloadData];
                    [self viewMarkAlertView];
                    NSLog(@"%@",[userDefaults objectForKey:@"MatchDict"]);
                    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
                    if (MatchDict) {
                        NSDictionary *playerDict = [MatchDict objectForKey:@"PlayerDict"];
                        NSString *playerNum = [playerDict objectForKey:@"playerNum"];
                        if ([playerNum integerValue]!=Players.count) {
                            [userDefaults removeObjectForKey:@"MatchDict"];
                        }
                    }
                    
                }else{
                    _dataHistory = [ScorModel pareFromWithDictionary:dict];
                    _ingParkName = [NSString string];
                    [_pushView reloadData];
                }
                
                
                [self requestWithShareData];
                [_pushView reloadData];
                
                if ([_startClick isEqualToString:@"1"]) {
                    if (!_dataIng) {
                        StartScoringViewController *vc = [[StartScoringViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
//                        CATransition *animation = [CATransition animation];
//                        [animation setDuration:0.3f];
//                        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//                        [animation setType:kCATransitionPush];
//                        [animation setSubtype: kCATransitionFromRight];
//                        [self.view.layer addAnimation:animation forKey:@"Reveal"];
//                        [self.navigationController.view.layer addAnimation:animation forKey:nil];
                        if ([_bezelButton.titleLabel.text isEqualToString:@"继续记分"]) {
                            vc.groupID = _GroupId;
                        }
                        [self ViewBlackBar];

                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    _startClick = @"0";
                }
            }

        
        
        }else{
            SucessView *sView = [SucessView new];
            sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
            sView.imageName = @"失败";
            sView.descStr = @"网络错误";
            [sView didFaild];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sView.hidden = YES;
            });
        
        }
    }];
}



// 前往统计界面

-(void)downloadData{
    
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"group_id":_GroupId,
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_achievement_groupid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        _pushView.userInteractionEnabled = YES;
        
        if (success) {
            NSArray *placeArry = [data objectForKey:@"qiuchang"];
            if (placeArry.count ==0) {
                return ;
            }
            NSMutableDictionary *placeData = [[NSMutableDictionary alloc] initWithDictionary:[data objectForKey:@"qiuchang"][0]];
            
            NSArray *dataArr = [data objectForKey:@"data"];
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
            NSMutableDictionary *PlayerDict = [NSMutableDictionary dictionary];
            
            [placeData setValue:_GroupId forKey:@"group_id"];
            
            [userDefaults setValue:dataDict forKey:@"ViewMatchDict"];
            
            [dataDict setValue:placeData forKey:@"PlaceDict"];
            
            NSString *FinleStr = [data objectForKey:@"lastDong"];
            
            if (!FinleStr) {
                FinleStr = @"1";
            }
            [dataDict setValue:FinleStr forKey:@"退出时记分位置"];
            
            NSArray *UserDong = [data objectForKey:@"UserDong"];
            
            
            for (int i = 0; i<UserDong.count; i++) {
                NSArray *NumArry = UserDong[i];
                [dataDict setValue:NumArry forKey:[NSString stringWithFormat:@"第%d位已完成洞号",i+1]];
            }
            
            for (int i = 0; i<dataArr.count; i++) {
                NSMutableDictionary *singlePoloData = [[NSMutableDictionary alloc] initWithDictionary:dataArr[i]];
                singlePoloData = dataArr[i];
                NSString *Par = [singlePoloData objectForKey:@"Par"];
                NSString *PoloNum = [singlePoloData objectForKey:@"PoloNum"];
                
                [dataDict setValue:Par forKey:[NSString stringWithFormat:@"第%@洞标准杆",PoloNum]];
                
                NSArray *pesonArry = [singlePoloData objectForKey:@"Players"];
                NSInteger dataInter =pesonArry.count;
                if (dataInter == 0) {
                    dataInter = _userArry.count;
                }
                
                for (int x = 0; x<dataInter; x++) {
                    NSString *Num = [pesonArry[x] objectForKey:@"Num"];
//                    NSString *Name = [pesonArry[x] objectForKey:@"nick_name"];
                    NSString *name_id = [pesonArry[x] objectForKey:@"name_id"];
//                    NSLog(@"第%@洞%@",PoloNum,name_id);
                    [dataDict setValue:Num forKey:[NSString stringWithFormat:@"第%@洞%@",PoloNum,name_id]];
//                    [PlayerDict setValue:name_id forKey:[NSString stringWithFormat:@"第%d位id",x+1]];
//                    [PlayerDict setValue:Name forKey:[NSString stringWithFormat:@"第%d位名字",x+1]];
                }
                [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_userArry.count] forKey:@"playerNum"];
            }
            if ([data objectForKey:@"groupUser"]) {
                _userArry = [NSMutableArray array];
                _userIdArry = [NSMutableArray array];
                for (NSDictionary *userDict in [data objectForKey:@"groupUser"]) {
                    NSString *userName  =       [userDict objectForKey:@"nickname"];
                    NSString *userDongNumber =  [userDict objectForKey:@"userDongNumber"];
//                    NSString *name_id =         [userDict objectForKey:@"name_id"];

                    NSMutableArray *DoneNUm = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0 ; i<[userDongNumber integerValue]; i++) {
                        [DoneNUm addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    
                    [_userArry addObject:userName];
                    [_userIdArry addObject:[userDict objectForKey:@"name_id"]];
                }
                
                for (int i = 0; i<_userIdArry.count; i++) {
                    NSString *Num = [NSString stringWithFormat:@"%ld",(unsigned long)_userIdArry.count];
                    [PlayerDict setValue:Num forKey:@"playerNum"];
                    NSString *Name = _userArry[i];
                    NSString *name_id = _userIdArry[i];
                    [PlayerDict setValue:name_id forKey:[NSString stringWithFormat:@"第%d位id",i+1]];
                    [PlayerDict setValue:Name forKey:[NSString stringWithFormat:@"第%d位名字",i+1]];
                }
            }
            
            
            NSMutableArray *dataNumArr = [NSMutableArray array];
            for (NSDictionary *dataNumDic in dataArr) {
                NSString *PoloNum = [dataNumDic objectForKey:@"PoloNum"];
                [dataNumArr addObject:PoloNum];
            }
            [dataDict setValue:dataNumArr forKey:@"已操作洞号"];
            
            
            
            [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_userArry.count] forKey:@"playerNum"];
            [PlayerDict setValue:_GroupId forKey:@"group_id"];
            [dataDict setValue:PlayerDict forKey:@"PlayerDict"];
            NSLog(@"%@",[userDefaults objectForKey:@"ViewMatchDict"]);
            NSLog(@"%@",dataDict);
            NSString *jilu_user = [placeArry[0] objectForKey:@"jilu_user"];
            
            if ([jilu_user isEqualToString:userDefaultId]&&_dataIng) {
                [userDefaults setValue:dataDict forKey:@"MatchDict"];
                NSString *numberStr = [PlayerDict objectForKey:@"playerNum"];
                if ([numberStr isEqualToString:@"1"]) {
                    SingleScoringViewController *vc = [[SingleScoringViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self ViewBlackBar];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ScoringViewController *vc =[[ScoringViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self ViewBlackBar];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else{
                
                [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_userArry.count] forKey:@"playerNum"];
                [userDefaults setObject:dataDict forKey:@"ViewMatchDict"];
//                NSMutableArray *nameIdArry = [NSMutableArray array];
//
//                for (int i = 0; i<_userArry.count; i++) {
//                    NSString *name_id = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",i+1]];
//                    [nameIdArry addObject:name_id];
//                }
                
                NSString *jilu_user =  [placeArry[0] objectForKey:@"jilu_user"];
                StatisticsViewController *vc = [[StatisticsViewController alloc] init];
                vc.nameArry = _userArry;
                vc.logInNumber =1;
                vc.nameIdArry = _userIdArry;
                vc.userNameId = userDefaultId;
                [userDefaults setValue:userDefaultId forKey:@"StatisticsNameId"];

                if (_dataIng&&![jilu_user isEqualToString:userDefaultId]) {
                    vc.logInNumber =2;
                }
                [self ViewBlackBar];

                [self presentViewController:vc animated:YES completion:nil];
            }
            
            
            
        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误,请检查网络后重试" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                
//                [self presentViewController:alertController animated:YES completion:nil];
//            });

            SucessView *sView = [SucessView new];
            sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
            sView.imageName = @"失败";
            sView.descStr = @"网络错误";
            [sView didFaild];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sView.hidden = YES;
            });
        
        }
    }];
}

//分享数据
-(void)requestWithShareData{
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc]init];
    NSDictionary *dic = @{
                          @"name_id":userDefaultId,
                          @"group_id":_GroupId
                          };
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_gerencishan",urlHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            OwnShareCharityModel *model = [[OwnShareCharityModel alloc]init];
            model.charity = data[@"data"][0][@"charity"];
            model.picture_url = [userDefaults objectForKey:@"pic"];
            model.zongganshu = data[@"data"][0][@"zongganshu"];
            model.cishan_jiner = data[@"data"][0][@"cishan_jiner"];
            model.zongchangshu = data[@"data"][0][@"zongchangshu"];
            [self setModelWith:model];
            sharBackView.hidden = NO;
        }
    }];
}

-(void)viewMarkAlertView{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"windowID":@"SelectMethodIng"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertWindowBrows",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
        NSDictionary *dataDict = [data objectForKey:@"data"];
        NSInteger longInNum = 0;
        if (dataDict) {
            NSString *code = [dataDict objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {
                NSArray *windowBrows = [dataDict objectForKey:@"windowBrows"];
                for (NSDictionary *windowDict in windowBrows) {
                    NSString *windowID = [windowDict objectForKey:@"windowID"];
                    if ([windowID isEqualToString:@"SelectMethodIng"]) {
                        NSString *browsNumber = [windowDict objectForKey:@"browsNumber"];
                        longInNum = longInNum + [browsNumber integerValue];
                    }
                    
                }
            }
            if (longInNum<3) {
                [self createAlertMark];
            }
            }
        }

    }];

}

#pragma mark - 加载数据(loadData)

-(void)setModelWith:(OwnShareCharityModel *)model{
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url]];
    
    _changThis.text = [NSString stringWithFormat:@"%@",model.zongganshu];
    
    _moneyThis.text = model.charity;
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.charity,@"元"];
    NSMutableAttributedString *attributed2 = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed2.length-1, 1)];
    _moneyThis.attributedText = attributed2;
    [_moneyThis sizeToFit];
    
    
    _allMoney.text = model.cishan_jiner;
    NSString *allMoney = [NSString stringWithFormat:@"%@ %@",model.cishan_jiner,@"元"];
    NSMutableAttributedString *attributedAllMoney = [[NSMutableAttributedString alloc]initWithString:allMoney];
    [attributedAllMoney addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributedAllMoney.length-1, 1)];
    _allMoney.attributedText = attributedAllMoney;
    
    
    _allChang.text = model.zongchangshu;
    NSString *allChang = [NSString stringWithFormat:@"%@ %@",model.zongchangshu,@"场"];
    NSMutableAttributedString *attributedAllChang = [[NSMutableAttributedString alloc]initWithString:allChang];
    [attributedAllChang addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributedAllChang.length-1, 1)];
    _allChang.attributedText = attributedAllChang;
    
}
#pragma mark - Delegate
//scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect frame = _bezelButton.frame;
    if (offsetY < 0) { // scrollView往下移动则增大宽和高
        float contrast    = fabs(offsetY)/4;///< 差距
        frame.size.width  = _bezelRect.size.width + contrast;
        frame.size.height = _bezelRect.size.height + contrast;
        frame.origin.x    = (ScreenWidth - frame.size.width)/2;
        
        CGFloat fontNum   = frame.size.width*22/190;
        _bezelButton.titleLabel.font = [UIFont systemFontOfSize:MAX(kHorizontal(22), fontNum)];
    }
    frame.origin.y = _bezelBtnOriginalY+offsetY; // 无论scrollView是往上移动还是往下移动都保持按钮的Y轴不变.
    _bezelButton.frame = frame;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HScale(11.8);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataIng||_dataHistory) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.playImage.hidden = YES;
    cell.circle.hidden = YES;
    cell.underway.hidden = YES;
    cell.scoreImage.hidden = YES;
    cell.money.hidden = YES;
    cell.poleNum.hidden = YES;
    cell.moneyImage.hidden = YES;
    cell.line.hidden = YES;
    if (_dataHistory) {
        [cell relayoutWithDictionary:_dataHistory];
        
    }
    if (indexPath.row == 0) {
        if (_dataIng) {
            cell.playImage.hidden = NO;
            cell.circle.hidden = NO;
            cell.underway.hidden = NO;
            [cell.underway addTarget:self action:@selector(longPress) forControlEvents:UIControlEventTouchUpInside];
            [cell relayoutWithLoadingDictionary:_dataIng];
            
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *BtnTitle =  _bezelButton.titleLabel.text;
    if ([BtnTitle isEqualToString:@"准备记分"]) {
        return;
    }
    if ([_ingParkName isEqualToString:@"0"]) {
        StartScoringViewController *vc = [[StartScoringViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        
        
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.3f];
//        [animation setTimingFunction:[CAMediaTimingFunction
//                                      functionWithName:kCAMediaTimingFunctionEaseOut]];
//        [animation setType:kCATransitionPush];
//        [animation setSubtype: kCATransitionFromRight];
//        [self.view.layer addAnimation:animation forKey:@"Reveal"];
//        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        if ([_bezelButton.titleLabel.text isEqualToString:@"继续记分"]) {
            vc.groupID = _GroupId;
        }
        [self ViewBlackBar];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    if (PlayerDict) {
        NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
        NSString *Num = [PlayerDict objectForKey:@"playerNum"];
        if ([Num isEqualToString:@"1"]) {
            SingleScoringViewController *vc = [[SingleScoringViewController alloc] init];
            //            _isConfirm = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            ScoringViewController *vc =[[ScoringViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self ViewBlackBar];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {

        _pushView.userInteractionEnabled = NO;
        [self downloadData];
        }
    }
    
}

#pragma mark - 左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataIng) {
//        if (![_jilu_user isEqualToString:userDefaultId]) {
//            return FALSE;
//        }
    }
    return TRUE;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    ScorModel *model = _dataIng;
    if (_dataHistory) {
        model = _dataHistory;
        _chengjiID = model.group_chengji_id;
    }
    
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView setEditing:NO animated:YES];
        
        if ([model.zongganshu isEqualToString:@"0"]) {
            [weakSelf clickToDelegate];
        }else if (_dataIng){
            if ([weakSelf.jilu_user isEqualToString:userDefaultId]) {
                [weakSelf clickToDelegate];
            }else{
                [weakSelf exitGroup];
            }
        }else{
            [weakSelf createShareView];
            [weakSelf requestWithShareData];
        }
        
    }];
    
    layTopRowAction1.backgroundColor =localColor;
    if(_dataIng){
        
        [layTopRowAction1 setTitle:@"删除"];
        layTopRowAction1.backgroundColor = [UIColor redColor];
        if (![_jilu_user isEqualToString:userDefaultId]) {
            [layTopRowAction1 setTitle:@"退出"];
        }
        
    }
    if ([model.zongganshu isEqualToString:@"0"]) {
        
        [layTopRowAction1 setTitle:@"删除"];
        layTopRowAction1.backgroundColor = [UIColor redColor];
    }
    
    NSArray *arr = @[layTopRowAction1];
    
    return arr;
}


-(void)clickToDelegate{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    
    NSDictionary *dict = @{
                           @"groupChengJiId":_chengjiID,
                           @"groupId":_GroupId
                           };
    
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/UpdataGroupDeleStatr",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            [userDefaults removeObjectForKey:@"MatchDict"];
            [userDefaults removeObjectForKey:@"ViewMatchDict"];
            if (_dataIng) {
                [_bezelButton setTitle:@"开始记分" forState:UIControlStateNormal];
                
            }
            [self loadData];
        }
    }];
    
}

-(void)exitGroup{
    NSLog(@"退出");
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupNameID":userDefaultId,
                           @"groupID":_GroupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteGroupUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        NSLog(@"%@",data);
        if (success) {
            NSString *code = [data objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {
                if (_dataIng) {
                    [_bezelButton setTitle:@"开始记分" forState:UIControlStateNormal];
                    
                }
                
                [self loadData];
            }

        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

@end





