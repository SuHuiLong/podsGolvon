//
//  NewDetailViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/1.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "NewDetailViewController.h"
#import "NewDetailCell.h"
#import "DetailHeaderModel.h"
#import "DownLoadDataSource.h"
#import "UIImageView+WebCache.h"
#import "NewDetailPhotoAblumCell.h"
#import "UIView+Size.h"
//#import "FansModel.h"
#import "Self_Fans_ViewController.h"
#import "Self_LY_ViewController.h"
#import "Self_P_ViewController.h"
#import "Self_GuanZhuViewController.h"
#import "ScorRecordViewController.h"
#import "MarkItem.h"
#import "ChangeHeaderImageViewController.h"
//#import "NewZhuanFangViewController.h"
#import "DynamicViewController.h"

#import "InterviewDetileViewController.h"


static NSString *identtifier = @"NewDetailCell";
static NSString *PhotoAblumCell = @"NewDetailPhotoAblumCell";

@interface NewDetailViewController()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,LikeDelegate>

/**
 *  性别
 */
@property (strong, nonatomic)UILabel *sexLabel;
/**
 *  age
 */
@property (strong, nonatomic)UILabel *ageLabel;

/**
 *  杆数
 */
@property (strong, nonatomic)UILabel *numGan;

/**
 *  地址
 */
@property (strong, nonatomic)UILabel *address;
/**
 *  职业
 */
@property (strong, nonatomic)UILabel *persion;
//专访id
@property (copy, nonatomic) NSString *interviewId;

@property (strong, nonatomic)UIButton *guanZhu;

@property (copy, nonatomic) NSString *photoImage;//照片
@property (copy, nonatomic) NSString *photoImageO;//照片
@property (copy, nonatomic) NSString *photoImageT;//照片
@property (assign, nonatomic) int groupNum;//总场数
@property (assign, nonatomic) NSUInteger playgolfState;
@property (copy, nonatomic) NSString *picture_url;//头像
@property (copy, nonatomic) NSString *dynum;

@property (strong, nonatomic) UIView   *line1;
@property (strong, nonatomic) UIView   *line2;
@property (strong, nonatomic) UIView   *noneDataView;


@property (strong, nonatomic) UITableView   *tableView;
@property (strong ,nonatomic) UIImageView   *backGroundImage;   //封面图片
@property (strong ,nonatomic) UIImageView   *headerImage;       //头像
@property (strong ,nonatomic) UIImageView   *sexImage;          //性别
@property (strong ,nonatomic) UILabel       *nickName;          //昵称
@property (strong ,nonatomic) UILabel       *ownMessage;        //资料
@property (strong ,nonatomic) UILabel       *label;             //标签
@property (strong ,nonatomic) UILabel       *signature;         //签名
@property (strong, nonatomic) UILabel       *changCi;           //场次
@property (strong, nonatomic) UILabel       *zhuaNiao;          //抓鸟
@property (strong, nonatomic) UILabel       *ciShan;            //慈善
@property (strong, nonatomic) UIButton      *fansBtn;           //粉丝按钮
@property (strong, nonatomic) UIButton      *liuyanBtn;         //留言按钮
@property (strong, nonatomic) UIButton      *followBtn;         //关注按钮
@property (strong ,nonatomic) UIButton      *setFollowBtn;      //添加关注按钮
@property (strong, nonatomic) MBProgressHUD   *HUD;             //菊花
@property (strong, nonatomic) MBProgressHUD   *HUD2;            //菊花2
/***  专访标志*/
@property (strong, nonatomic) UIImageView    *Vimage;


/**
 *  标签内容背景
 */
@property(nonatomic,strong)UIImageView *markGroundImage1;
@property(nonatomic,strong)UIImageView *markGroundImage2;
@property(nonatomic,strong)UIImageView *markGroundImage3;
@property(nonatomic,strong)UIImageView *markGroundImage4;
@property(nonatomic,strong)UIImageView *markGroundImage5;
@property(nonatomic,strong)UIImageView *markGroundImage6;

/**
 *  标签内容
 */
@property(nonatomic,strong)UILabel *markLabel1;
@property(nonatomic,strong)UILabel *markLabel2;
@property(nonatomic,strong)UILabel *markLabel3;
@property(nonatomic,strong)UILabel *markLabel4;
@property(nonatomic,strong)UILabel *markLabel5;
@property(nonatomic,strong)UILabel *markLabel6;

/**
 *  标签头
 */
@property(nonatomic,strong)UIImageView *markHeaderImage1;
@property(nonatomic,strong)UIImageView *markHeaderImage2;
@property(nonatomic,strong)UIImageView *markHeaderImage3;
@property(nonatomic,strong)UIImageView *markHeaderImage4;
@property(nonatomic,strong)UIImageView *markHeaderImage5;
@property(nonatomic,strong)UIImageView *markHeaderImage6;


/**
 *  存放标签的label
 */
@property (strong, nonatomic) UILabel                *markView1;
@property (strong, nonatomic) UILabel                *markView2;
@property (strong, nonatomic) UILabel                *markView3;
@property (strong, nonatomic) UILabel                *markView4;
@property (strong, nonatomic) UILabel                *markView5;
@property (strong, nonatomic) UILabel                *markView6;


@property (assign, nonatomic) CGFloat                markX1;
@property (assign, nonatomic) CGFloat                markX2;
@property (assign, nonatomic) CGFloat                markX3;
@property (assign, nonatomic) CGFloat                markX4;
@property (assign, nonatomic) CGFloat                markX5;
@property (assign, nonatomic) CGFloat                markX6;


@property (nonatomic,copy)    NSMutableArray        *markArry;              //存放标签的数据
@property (strong ,nonatomic) DownLoadDataSource    *loadData;
@property (strong ,nonatomic) NSMutableArray        *headerViewDataArr;     //段头
@property (strong ,nonatomic) NSMutableArray        *scoringArr;            //记分
@property (strong ,nonatomic) NSMutableArray        *interviewArr;          //专访
@property (strong, nonatomic) NSMutableArray        *fansArr;               //粉丝
@property (strong, nonatomic) NSMutableArray        *followArray;           //关注
@property (strong, nonatomic) NSMutableArray        *photoArr;

@property (strong, nonatomic) NSArray               *adjArray;              //粉丝，关注，留言
@property (nonatomic, copy) NSArray<MarkItem *> *markItemsArray; ///< 标签工具集合
@property (nonatomic, copy) NSMutableArray *cellArr;


/**
 *  uiview
 */
@property (strong, nonatomic) UIView      *backGroundView;

/** 访问量*/
@property (strong, nonatomic) UIImageView     *pageViewImage;
@property (strong, nonatomic) UILabel         *pageViewLabel;

/***  转圈的view*/
@property (strong, nonatomic) UIView    *placeView;

@end

@implementation NewDetailViewController
/**下载数据的工具类*/
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
/**存段头的数组*/
-(NSMutableArray *)headerViewDataArr{
    if (!_headerViewDataArr) {
        _headerViewDataArr = [[NSMutableArray alloc]init];
    }
    return _headerViewDataArr;
}
/**记分*/
-(NSMutableArray *)scoringArr{
    if (!_scoringArr) {
        _scoringArr = [[NSMutableArray alloc]init];
    }
    return _scoringArr;
}
/**专访*/
-(NSMutableArray *)interviewArr{
    if (!_interviewArr) {
        _interviewArr = [[NSMutableArray alloc]init];
    }
    return _interviewArr;
}
/**粉丝 关注*/
-(NSMutableArray *)fansArr{
    if (!_fansArr) {
        _fansArr = [[NSMutableArray alloc]init];
    }
    return _fansArr;
}

-(NSMutableArray *)followArray{
    if (!_followArray) {
        _followArray = [[NSMutableArray alloc]init];
    }
    return _followArray;
}
/**标签*/
-(NSMutableArray *)markArry{
    if (!_markArry) {
        _markArry = [[NSMutableArray alloc]init];
    }
    return _markArry;
}
-(NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [[NSMutableArray alloc]init];
    }
    return _cellArr;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    //    导航栏变为透明
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    //    让黑线消失的方法
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    _block(YES);
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = WhiteColor;
    [self downGuanzhuData];

}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUI];
    [self createBackButton];
    self.dynum = @"0";
    _playgolfState = 0;
    [self loadDataWithPersonMessage];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void)testNetState{
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            weakself.tableView.hidden = YES;
            [weakself createNoInternet];
        }else{
            [weakself loadDataWithPersonMessage];

        }
    }];
    
    [manager.reachabilityManager startMonitoring];
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
    [noInternetBtn addTarget:self action:@selector(loadDataWithPersonMessage) forControlEvents:UIControlEventTouchUpInside];
    [_noneDataView addSubview:noInternetBtn];
    
}
#pragma mark ---- 返回按钮
-(void)createBackButton{
    
    UIImageView *maskTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(9.1))];
    maskTop.image = [UIImage imageNamed:@"蒙板固定_上"];
    [self.view addSubview:maskTop];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, HScale(3), ScreenWidth * 0.091, ScreenHeight * 0.066);
    [back setImage:[UIImage imageNamed:@"白色统一返回"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}
#pragma mark ---- 返回按钮的点击事件
-(void)pressBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
-(void)createUI{
    
    /**段头*/
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(66.4))];
    _backGroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backGroundView];
    
    //    创建表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  )];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    CGFloat rowHight = (ScreenHeight - HScale(66.4))/3;
    _tableView.rowHeight = rowHight;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.hidden = YES;
    [_tableView registerClass:[NewDetailCell class] forCellReuseIdentifier:identtifier];
    [_tableView registerClass:[NewDetailPhotoAblumCell class] forCellReuseIdentifier:PhotoAblumCell];
    [self.view addSubview:_tableView];
    
    /**背景图*/
    _backGroundImage = [[UIImageView alloc]init];
    _backGroundImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(24.7));
    _backGroundImage.clipsToBounds = YES;
    _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [_tableView addSubview:_backGroundImage];
    
    _tableView.tableHeaderView = _backGroundView;
    
    
    UIImageView *maskBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, HScale(15.6)  , ScreenWidth, HScale(9.1))];
    maskBottom.image = [UIImage imageNamed:@"蒙板移动_下"];
    [_backGroundView addSubview:maskBottom];
    
    
    /**头像*/
    UILabel *groundLabel = [[UILabel alloc]init];
    groundLabel.frame = CGRectMake((ScreenWidth - WScale(20)-4)/2, HScale(19.6)  -2, WScale(20)+4, WScale(20)+4);
    groundLabel.backgroundColor = [UIColor whiteColor];
    groundLabel.layer.masksToBounds = YES;
    groundLabel.layer.cornerRadius = HScale(11.7)/2;
    [_backGroundView addSubview:groundLabel];
    
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(20))/2, HScale(19.6)  , WScale(20), WScale(20))];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = HScale(11.2)/2;
    _headerImage.userInteractionEnabled = YES;
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChangeHeaderImage)];
    [_headerImage addGestureRecognizer:tap];
    [_backGroundView addSubview:_headerImage];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.frame = CGRectMake(_headerImage.right-kWvertical(17), _headerImage.height-kWvertical(17)+ HScale(19.6), kWvertical(17), kWvertical(17));
    _Vimage.hidden = YES;
    [_backGroundView addSubview:_Vimage];
    
    /**昵称*/
    
    _nickName = [[UILabel alloc]init];
    [_backGroundView addSubview:_nickName];
    
    _sexImage = [[UIImageView alloc]init];
    [_backGroundView addSubview:_sexImage];
    
    
    /**个人资料*/
    _ownMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(36.3)  , ScreenWidth, HScale(2.4))];
    _ownMessage.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _ownMessage.textAlignment = NSTextAlignmentCenter;
    _ownMessage.textColor = GPColor(125, 122, 136);
    [_backGroundView addSubview:_ownMessage];
    /**签名*/
    _signature = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(74.8))/2, HScale(46.8)  , WScale(74.8), HScale(2.4))];
    _signature.textColor = GPColor(125, 122, 136);
    _signature.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _signature.textAlignment = NSTextAlignmentCenter;
    [_backGroundView addSubview:_signature];
    
    /**粉丝，关注，留言*/
    _adjArray = @[@"0",@"0",@"0"];
    _fansBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _line1 = [[UIView alloc]init];
    _followBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _line2 = [[UIView alloc]init];
    _liuyanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    
    [_fansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",_adjArray[0] ] forState:(UIControlStateNormal)];
    [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",_adjArray[1] ] forState:(UIControlStateNormal)];
    [_liuyanBtn setTitle:[NSString stringWithFormat:@"%@留言",_adjArray[2] ] forState:(UIControlStateNormal)];
    
    [_fansBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    [_followBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    [_liuyanBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    
    _line1.backgroundColor = GPColor(66, 66, 66);
    _line2.backgroundColor = GPColor(66, 66, 66);
    
    
    [_fansBtn addTarget:self action:@selector(clickToFans) forControlEvents:UIControlEventTouchUpInside];
    [_followBtn addTarget:self action:@selector(clickToFollow) forControlEvents:UIControlEventTouchUpInside];
    [_liuyanBtn addTarget:self action:@selector(clickToLiuyan) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_backGroundView addSubview:_fansBtn];
    [_backGroundView addSubview:_followBtn];
    [_backGroundView addSubview:_liuyanBtn];
    
    [_backGroundView addSubview:_line1];
    [_backGroundView addSubview:_line2];
    
    
    /**场次，抓鸟，慈善*/
    NSArray *titleArr = @[@"场次",@"抓鸟",@"慈善"];
    for (int i = 0; i<3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/3, HScale(57.4), ScreenWidth/3, HScale(2.4))];
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        titleLabel.textColor = GPColor(51, 51, 59);
        [_backGroundView addSubview:titleLabel];
        
    }
    _changCi = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(60.6)  , ScreenWidth / 3, HScale(4.5))];
    _changCi.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _changCi.textAlignment = NSTextAlignmentCenter;
    [_backGroundView addSubview:_changCi];
    
    _zhuaNiao = [[UILabel alloc]initWithFrame:CGRectMake(_changCi.frame.origin.x +_changCi.frame.size.width, HScale(60.6)  , ScreenWidth / 3, HScale(4.5))];
    _zhuaNiao.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _zhuaNiao.textAlignment = NSTextAlignmentCenter;
    [_backGroundView addSubview:_zhuaNiao];
    
    _ciShan = [[UILabel alloc]initWithFrame:CGRectMake(_zhuaNiao.frame.origin.x +_zhuaNiao.frame.size.width, HScale(60.6)  , ScreenWidth / 3, HScale(4.5))];
    _ciShan.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _ciShan.textAlignment = NSTextAlignmentCenter;
    [_backGroundView addSubview:_ciShan];
    
    
    
    //    添加关注按钮
    _setFollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setFollowBtn setImage:[UIImage imageNamed:@"addFollow(personal center)"] forState:UIControlStateNormal];
    [_setFollowBtn setImage:[UIImage imageNamed:@"alreadyFollow(personal center)"] forState:UIControlStateSelected];
    [_setFollowBtn addTarget:self action:@selector(addFollow:) forControlEvents:UIControlEventTouchUpInside];
    _setFollowBtn.frame = CGRectMake((ScreenWidth-WScale(23.7))/2, HScale(51)  , WScale(23.7), HScale(4.1));
    if ([_nameID isEqualToString:userDefaultId] || [_nameID isEqualToString:userDefaultUid]) {
                
    }else{
        [_backGroundView addSubview:_setFollowBtn];

    }
    
    //访问量
    _pageViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(3.9), HScale(19.9)+HScale(1.2), WScale(4.5), HScale(1.5))];
    _pageViewImage.image = [UIImage imageNamed:@"iconfont-yanjing"];
    [_backGroundView addSubview:_pageViewImage];
    
    _pageViewLabel = [[UILabel alloc]init];
    [_backGroundView addSubview:_pageViewLabel];
    
    
    
    /**
     存放标签的label
     */
    _markView1 = [[UILabel alloc]init];
    _markView2 = [[UILabel alloc]init];
    _markView3 = [[UILabel alloc]init];
    _markView4 = [[UILabel alloc]init];
    _markView5 = [[UILabel alloc]init];
    _markView6 = [[UILabel alloc]init];
    
    
    [_backGroundView addSubview:_markView1];
    [_backGroundView addSubview:_markView2];
    [_backGroundView addSubview:_markView3];
    [_backGroundView addSubview:_markView4];
    [_backGroundView addSubview:_markView5];
    [_backGroundView addSubview:_markView6];
    
    
    /**
     标签背景
     */
    _markGroundImage1 = [[UIImageView alloc] init];
    
    _markGroundImage2 = [[UIImageView alloc] init];
    
    _markGroundImage3 = [[UIImageView alloc] init];
    
    _markGroundImage4 = [[UIImageView alloc] init];
    
    _markGroundImage5 = [[UIImageView alloc] init];
    
    _markGroundImage6 = [[UIImageView alloc] init];
    
    
    [_markView1 addSubview:_markGroundImage1];
    [_markView2 addSubview:_markGroundImage2];
    [_markView3 addSubview:_markGroundImage3];
    [_markView4 addSubview:_markGroundImage4];
    [_markView5 addSubview:_markGroundImage5];
    [_markView6 addSubview:_markGroundImage6];
    
    /**
     标签内容
     */
    _markLabel1 = [[UILabel alloc] init];
    _markLabel2 = [[UILabel alloc] init];
    _markLabel3 = [[UILabel alloc] init];
    _markLabel4 = [[UILabel alloc] init];
    _markLabel5 = [[UILabel alloc] init];
    _markLabel6 = [[UILabel alloc] init];
    
    
    [_markView1 addSubview:_markLabel1];
    [_markView2 addSubview:_markLabel2];
    [_markView3 addSubview:_markLabel3];
    [_markView4 addSubview:_markLabel4];
    [_markView5 addSubview:_markLabel5];
    [_markView6 addSubview:_markLabel6];
    
    /**
     标签头
     */
    _markHeaderImage1 = [[UIImageView alloc] init];
    _markHeaderImage2 = [[UIImageView alloc] init];
    _markHeaderImage3 = [[UIImageView alloc] init];
    _markHeaderImage4 = [[UIImageView alloc] init];
    _markHeaderImage5 = [[UIImageView alloc] init];
    _markHeaderImage6 = [[UIImageView alloc] init];
    
    
    [_markView1 addSubview:_markHeaderImage1];
    [_markView2 addSubview:_markHeaderImage2];
    [_markView3 addSubview:_markHeaderImage3];
    [_markView4 addSubview:_markHeaderImage4];
    [_markView5 addSubview:_markHeaderImage5];
    [_markView6 addSubview:_markHeaderImage6];
    
}
//createHUD
-(void)createHUD{
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.alpha = 0.5;
}


#pragma mark ---- LoadData
-(void)loadDataWithPersonMessage{
    [self createHUD];
    NSDictionary *parameters = @{@"name_id":_nameID,
                                 @"uid":userDefaultUid};
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=getui",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        _HUD.hidden = YES;
        if (success) {
            _tableView.hidden = NO;
            NSDictionary *tempDic = data[@"ui"];
            DetailHeaderModel *headerModel = [DetailHeaderModel initWithDictionary:tempDic];
            [self.headerViewDataArr addObject:headerModel];
            weakself.picture_url = headerModel.avator;
            weakself.groupNum = [headerModel.completegames intValue];
            weakself.dynum = headerModel.dyns;
            int dynamicNum = [weakself.dynum intValue];
            if (dynamicNum >= 1) {
                [self downLoadPhotoAblumData];
            }
            
            
            NSMutableArray *labelArr = tempDic[@"labels"];
            if (labelArr.count>0) {
                
                [userDefaults setValue:labelArr forKey:@"labels"];
                
            }
            
            weakself.interviewId = headerModel.vid;
            
            if (![weakself.interviewId isEqualToString:@"0"]) {
                
                ZhuanFangModel *model = [ZhuanFangModel paresFromDictionary:tempDic[@"v"][0]];
                [self.interviewArr addObject:model];
                
            }
            NSArray *tempArr = tempDic[@"lastgame"];
            weakself.playgolfState = [tempArr count];

            if ([tempArr count] != 0) {
                
                ScoringModel *scorModel = [ScoringModel pareFromWith:tempDic[@"lastgame"]];
                NSMutableString *time = [NSMutableString stringWithFormat:@"%@",scorModel.timeLabel];
                [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
                [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
                [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
                [time deleteCharactersInRange:NSMakeRange(0, 5)];
                [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
                scorModel.timeLabel = time;
                [weakself.scoringArr addObject:scorModel];
                
            }

            weakself.tableView.hidden = NO;
            [weakself setUpModel:headerModel];
            [weakself.tableView reloadData];

        }
    }];
}

-(void)downLoadPhotoAblumData{
    
    __weak typeof(self) weakself = self;
    NSDictionary *userDic = @{
                              @"name_id":_nameID,
                              @"iscover":@"1"
                              };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=getpics",apiHeader120]parameters:userDic complicate:^(BOOL success, id data) {
        if (success) {
            self.photoArr = [NSMutableArray array];
            NSArray *tempArr = data[@"data"];
            if ([tempArr count] == 0) {
                return;
            }
            for (int i = 0; i<tempArr.count; i++) {
                [weakself.photoArr addObject:tempArr[i][@"url"]];
            }
            if (weakself.photoArr.count == 1) {
                weakself.photoImage = self.photoArr[0];
            }else if (self.photoArr.count == 2){
                weakself.photoImage = self.photoArr[0];
                weakself.photoImage = self.photoArr[1];
            }else{
                
                weakself.photoImageT = self.photoArr[0];
                weakself.photoImageO = self.photoArr[1];
                weakself.photoImage = self.photoArr[2];
            }
            [weakself.tableView reloadData];
        }
        
    }];
    
}
#pragma mark ---- 跳转到更换头像界面
-(void)clickToChangeHeaderImage{
    
    ChangeHeaderImageViewController *change = [[ChangeHeaderImageViewController alloc]init];
    change.hidesBottomBarWhenPushed = YES;
    change.nameid = self.nameID;
    change.controlID = 1;
    change.pictureUrl = _picture_url;
    change.avatarView = _headerImage;
    [self.navigationController pushViewController:change animated:NO];
}
//获取关注状态
-(void)downGuanzhuData{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    __weak typeof(self) weakself = self;
    NSDictionary *dict = @{
                           @"follow_name_id":userDefaultId,
                           @"cov_follow_nameid":self.nameID
                           };
    
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_nameid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            weakself.followState = data[@"data"][0][@"code"];
            weakself.setFollowBtn.selected = [weakself.followState intValue] == 0 ? NO : YES;
        }
    }];
}
// 添加关注
-(void)addFollow:(UIButton*)button{
    [self createHUD];
    /**
     *  follow_name 关注人
     cofollow_name 被关注的人
     */
    __weak typeof(self) weakself = self;
    NSDictionary *insterParamters = @{@"follow_name_id":userDefaultId,
                                      @"cof_name_id":self.nameID};
    NSDictionary *deleteParamters = @{@"follow_user_id":userDefaultId,
                                      @"name_id":self.nameID};
    NSString *insertUrlStr = [NSString stringWithFormat:@"%@Golvon/insert_follow",urlHeader120];
    NSString *deleteUrlStr = [NSString stringWithFormat:@"%@Golvon/delete_follow",urlHeader120];
    if ([_followState isEqualToString:@"0"]) {
        
        [self.loadData downloadWithUrl:insertUrlStr parameters:insterParamters complicate:^(BOOL success, id data) {
            if (success) {
                _HUD.hidden = YES;
                _HUD = nil;
                button.selected = YES;
                [weakself loadDataWithPersonMessage];

                weakself.followState = @"1";
            }
        }];
    }else{
        [self.loadData downloadWithUrl:deleteUrlStr parameters:deleteParamters complicate:^(BOOL success, id data) {
            if (success) {
                _HUD.hidden = YES;
                _HUD = nil;
                button.selected = NO;
                [weakself loadDataWithPersonMessage];

                weakself.followState = @"0";
                
            }
        }];
    }
}



- (void)setUpModel:(DetailHeaderModel *)model{
    
    if ([model.vid isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    [_backGroundImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    UILabel *test = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(28))/2, HScale(31.9)  , WScale(28), HScale(3.3))];
    test.text = model.nickname;
    test.font = [UIFont systemFontOfSize:kHorizontal(18)];
    test.textAlignment = NSTextAlignmentCenter;
    [test sizeToFit];
    
    _nickName.frame = CGRectMake((ScreenWidth - test.width)/2, test.y, test.width, test.height);
    _nickName.text = test.text;
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(18)];
    _nickName.textColor = GPColor(49, 47, 47);
    _nickName.textAlignment = NSTextAlignmentCenter;
    [_nickName sizeToFit];
    _sexImage.frame = CGRectMake(_nickName.x+_nickName.width+3, _nickName.top+3, kWvertical(14), kWvertical(14));
    _sexImage.layer.masksToBounds = YES;
    _sexImage.layer.cornerRadius = kWvertical(7);
    if ([model.gender isEqualToString:@"女"]) {
        _sexImage.image = [UIImage imageNamed:@"女（首页）"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"男（首页）"];
    }
    //    签名
    _signature.text = model.sign;
    _signature.textAlignment = NSTextAlignmentCenter;
    
    //    个人信息
    if ([model.province isEqualToString:model.city]) {
        
        _ownMessage.text = [NSString stringWithFormat:@"%@  %@  %@  %@",model.year_label,model.rodnum,model.province,model.work_content];
    }else{
        _ownMessage.text = [NSString stringWithFormat:@"%@  %@  %@  %@  %@",model.year_label,model.rodnum,model.province,model.city,model.work_content];
    }
    
    //    粉丝，关注，留言
    [_fansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",model.befocus] forState:UIControlStateNormal];
    [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",model.focus] forState:UIControlStateNormal];
    [_liuyanBtn setTitle:[NSString stringWithFormat:@"%@留言",model.msgs] forState:UIControlStateNormal];
    
    _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _followBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _liuyanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _fansBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _liuyanBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    
    [_fansBtn sizeToFit];
    [_followBtn sizeToFit];
    [_liuyanBtn sizeToFit];
    
    [_followBtn setOrigin:CGPointMake((ScreenWidth-_followBtn.width)/2, HScale(40.5)  )];
    
    CGFloat lineheight = HScale(1.8);
    CGFloat lineY = _followBtn.top+(_followBtn.height-lineheight)/2;
    
    _line1.frame = CGRectMake(_followBtn.left-WScale(3),lineY , 1, lineheight);
    _line2.frame = CGRectMake(_followBtn.right+WScale(3), lineY, 1 ,lineheight);
    
    
    
    [_fansBtn setOrigin:CGPointMake(_line1.left-WScale(3)-_fansBtn.width, _followBtn.top)];
    [_liuyanBtn setOrigin:CGPointMake(_line2.right + WScale(3), _followBtn.top)];
    
    //    场次
    _changCi.text = model.completegames;
    _zhuaNiao.text = model.bird;
    _ciShan.text = model.charity;
    NSString *str1 = [NSString stringWithFormat:@"%@%@",model.completegames,@"次"];
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute1.length-1, 1)];
    [attribute1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute1.length-1, 1)];
    _changCi.attributedText = attribute1;
    
    //    抓鸟
    NSString *str2 = [NSString stringWithFormat:@"%@%@",model.bird,@"次"];
    NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attribute2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute2.length-1, 1)];
    [attribute2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute2.length-1, 1)];
    _zhuaNiao.attributedText = attribute2;
    
    //    慈善
    NSString *str3 = [NSString stringWithFormat:@"%@%@",model.charity,@"元"];
    NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc]initWithString:str3];
    [attribute3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute3.length-1, 1)];
    [attribute3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute3.length-1, 1)];
    _ciShan.attributedText = attribute3;
    
    UILabel *test1 = [[UILabel alloc]init];
    test1.backgroundColor = [UIColor redColor];
    test1.text = model.visits;
    test1.frame = CGRectMake(_pageViewImage.right + WScale(1), _pageViewImage.y-3, 80, _pageViewImage.height);
    test1.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [test1 sizeToFit];
    
    _pageViewLabel.text = test1.text;
    _pageViewLabel.frame = test1.frame;
    _pageViewLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _pageViewLabel.textAlignment = NSTextAlignmentCenter;
    _pageViewLabel.shadowColor = GPColor(26, 26, 26);
    _pageViewLabel.textColor = [UIColor whiteColor];
    _pageViewLabel.shadowOffset = CGSizeMake(0, 1);
    [_pageViewLabel sizeToFit];

    
    
    //    标签
    NSString *markStr1 = [NSString string];
    NSString *markStr3 = [NSString string];
    NSString *markStr2 = [NSString string];
    NSString *markStr4 = [NSString string];
    NSString *markStr5 = [NSString string];
    NSString *markStr6 = [NSString string];
    
    _markHeaderImage1.hidden = YES;
    _markHeaderImage2.hidden = YES;
    _markHeaderImage3.hidden = YES;
    _markHeaderImage4.hidden = YES;
    _markHeaderImage5.hidden = YES;
    _markHeaderImage6.hidden = YES;
    
    
    _markGroundImage1.hidden = YES;
    _markGroundImage2.hidden = YES;
    _markGroundImage3.hidden = YES;
    _markGroundImage4.hidden = YES;
    _markGroundImage5.hidden = YES;
    _markGroundImage6.hidden = YES;
    
    
    switch (_markArry.count) {
            
            
            
        case 0:{
            
        }break;
        case 1:{
            markStr3 = _markArry[0];
            _markHeaderImage3.hidden = NO;
            _markGroundImage3.hidden = NO;
            
        }break;
        case 2:{
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            
            
        }break;
        case 3:{
            
            markStr2 = _markArry[1];
            markStr3 = _markArry[0];
            markStr4 = _markArry[2];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            
        }break;
        case 4:{
            
            markStr1 = _markArry[3];
            markStr2 = _markArry[1];
            markStr3 = _markArry[0];
            markStr4 = _markArry[2];
            
            _markHeaderImage1.hidden = NO;
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            
        }break;
            
        case 5:{
            
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            markStr4 = _markArry[2];
            markStr1 = _markArry[3];
            markStr5 = _markArry[4];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            _markHeaderImage1.hidden = NO;
            _markHeaderImage6.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            _markGroundImage6.hidden = NO;
            
        }break;
        case 6:{
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            markStr4 = _markArry[2];
            markStr1 = _markArry[3];
            markStr5 = _markArry[4];
            markStr6 = _markArry[5];
            
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            _markHeaderImage1.hidden = NO;
            _markHeaderImage5.hidden = NO;
            _markHeaderImage6.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            _markGroundImage5.hidden = NO;
            _markGroundImage6.hidden = NO;
            
        }
        default:
            break;
    }
    
#pragma mark ---- 左边第1个标签
    _markLabel1.text = markStr1;
    _markLabel1.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel1.textColor = [UIColor whiteColor];
    _markLabel1.backgroundColor = [UIColor clearColor];
    _markLabel1.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_markLabel1 sizeToFit];
    _markGroundImage1.frame = CGRectMake(0, 0, _markLabel1.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage1.image = [UIImage imageNamed:@"标签_内容背景"];
    _markHeaderImage1.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage1.frame.size.width, 0, WScale(7.5), HScale(4.6));
    _markHeaderImage1.image = [UIImage imageNamed:@"标签头__左"];
    
    _markView1.frame = CGRectMake(0 - _markGroundImage1.frame.size.width-WScale(7.5), 0, _markGroundImage1.frame.size.width +WScale(7.5), HScale(4.6));
    
#pragma mark ---- 左边第2个标签
    _markLabel2.text = markStr2;
    _markLabel2.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel2.textColor = [UIColor whiteColor];
    _markLabel2.backgroundColor = [UIColor clearColor];
    _markLabel2.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    [_markLabel2 sizeToFit];
    _markGroundImage2.frame = CGRectMake(0, 0, _markLabel2.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage2.image = [UIImage imageNamed:@"标签_内容背景"];
    
    UILabel *testLable = [[UILabel alloc] init];
    testLable.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    _markHeaderImage2.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage2.frame.size.width, 0, WScale(7.5), HScale(4.6));
    
    _markHeaderImage2.image = [UIImage imageNamed:@"标签头__左"];
    
    _markView2.frame = CGRectMake(0 - _markGroundImage2.frame.size.width - WScale(7.5), _markView1.bottom+HScale(2.2), _markGroundImage2.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 左边第3个标签
    _markLabel5.text = markStr6;
    _markLabel5.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel5.textColor = [UIColor whiteColor];
    _markLabel5.backgroundColor = [UIColor clearColor];
    _markLabel5.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_markLabel5 sizeToFit];
    _markGroundImage5.frame = CGRectMake(0, 0, _markLabel5.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage5.image = [UIImage imageNamed:@"标签_内容背景"];
    
    _markHeaderImage5.frame = CGRectMake(_markGroundImage5.frame.origin.x+_markGroundImage5.frame.size.width, 0,WScale(7.5), HScale(4.6));
    _markHeaderImage5.image = [UIImage imageNamed:@"标签头__左"];
    _markView5.frame = CGRectMake(0 - _markGroundImage5.frame.size.width - WScale(7.5), _markView2.bottom+HScale(2.2), _markGroundImage5.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 右边第1个标签
    _markLabel3.text = markStr3;
    testLable.text = _markLabel3.text;
    [testLable sizeToFit];
    _markLabel3.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel3.textColor = [UIColor whiteColor];
    _markLabel3.backgroundColor = [UIColor clearColor];
    _markLabel3.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel3.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage3.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage3.image = [UIImage imageNamed:@"标签_内容背景"];
    
    _markHeaderImage3.frame = CGRectMake(_markGroundImage3.x-WScale(7.5), 0, WScale(7.5), HScale(4.6));
    _markHeaderImage3.image = [UIImage imageNamed:@"标签头__右"];
    _markView3.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView1.y, _markGroundImage3.width+ WScale(7.5), HScale(4.6));
    
#pragma mark ---- 右边第2个标签
    _markLabel4.text = markStr4;
    testLable.text = _markLabel4.text;
    [testLable sizeToFit];
    
    
    _markLabel4.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel4.textColor = [UIColor whiteColor];
    _markLabel4.backgroundColor = [UIColor clearColor];
    _markLabel4.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel4.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage4.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage4.image = [UIImage imageNamed:@"标签_内容背景"];
    
    
    _markHeaderImage4.frame = CGRectMake(_markGroundImage4.frame.origin.x - WScale(7.5), 0,WScale(7.5), HScale(4.6));
    
    _markHeaderImage4.image = [UIImage imageNamed:@"标签头__右"];
    _markView4.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView2.y, _markGroundImage4.frame.size.width + WScale(7.5), HScale(4.6));
    
    
#pragma mark ---- 右边第3个标签
    _markLabel6.text = markStr5;
    testLable.text = _markLabel6.text;
    [testLable sizeToFit];
    
    _markLabel6.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel6.textColor = [UIColor whiteColor];
    _markLabel6.backgroundColor = [UIColor clearColor];
    _markLabel6.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel6.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage6.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage6.image = [UIImage imageNamed:@"标签_内容背景"];
    _markHeaderImage6.frame = CGRectMake(_markGroundImage6.frame.origin.x - WScale(7.5), 0, WScale(7.5), HScale(4.6));
    _markHeaderImage6.image = [UIImage imageNamed:@"标签头__右"];
    _markView6.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView5.y, _markGroundImage6.frame.size.width + WScale(7.5), HScale(4.6));
    
    
    // 标签工具1
    CGPoint centerEnd1 = CGPointMake(_markView1.width/2, _markView1.y+_markView1.height/2);
    MarkItem *item1 = [MarkItem itemWithView:_markView1 centerStart:_markView1.center centerEnd:centerEnd1];
    // 标签工具2
    CGPoint centerEnd2 = CGPointMake(_markView2.width/2, _markView2.y+_markView2.height/2);
    MarkItem *item2 = [MarkItem itemWithView:_markView2 centerStart:_markView2.center centerEnd:centerEnd2];
    // 标签工具5
    CGPoint centerEnd5 = CGPointMake(_markView5.width/2, _markView5.y+_markView5.height/2);
    MarkItem *item5 = [MarkItem itemWithView:_markView5 centerStart:_markView5.center centerEnd:centerEnd5];
    
    // 标签工具3
    CGPoint centerEnd3 = CGPointMake(_tableView.tableHeaderView.right-_markView3.width/2+WScale(7.5), _markView1.y+_markView3.height/2);
    MarkItem *item3 = [MarkItem itemWithView:_markView3 centerStart:_markView3.center centerEnd:centerEnd3];
    // 标签工具4
    CGPoint centerEnd4 = CGPointMake(_tableView.tableHeaderView.right-_markView4.width/2+WScale(7.5), _markView2.y+_markView4.height/2);
    MarkItem *item4 = [MarkItem itemWithView:_markView4 centerStart:_markView4.center centerEnd:centerEnd4];
    // 标签工具6
    CGPoint centerEnd6 = CGPointMake(_tableView.tableHeaderView.right-_markView6.width/2+WScale(7.5), _markView5.y+_markView6.height/2);
    MarkItem *item6 = [MarkItem itemWithView:_markView6 centerStart:_markView6.center centerEnd:centerEnd6];
    
    _markItemsArray = @[item1, item2, item3, item4, item5, item6];
}

#pragma mark ---- 跳转到关注的界面
-(void)clickToFollow{
    
    Self_GuanZhuViewController *follow = [[Self_GuanZhuViewController alloc]init];
    follow.name_id = _nameID;
    [self.navigationController pushViewController:follow animated:YES];
}
#pragma mark ---- 跳转到粉丝的界面
-(void)clickToFans{
    
    Self_Fans_ViewController *fans = [[Self_Fans_ViewController alloc]init];
    fans.name_id = _nameID;
    [self.navigationController pushViewController:fans animated:YES];
}
#pragma mark ---- 跳转到留言的界面
-(void)clickToLiuyan{
    Self_LY_ViewController *message = [[Self_LY_ViewController alloc]init];
    message.nameID = _nameID;
    message.nickName = _nickName.text;
    [self.navigationController pushViewController:message animated:YES];
}
#pragma mark ---- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return 1 + ((_playgolfState == 0)?0:1) + ((![_interviewId isEqualToString:@"0"])?1:0);

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        
        NewDetailPhotoAblumCell *cell = [tableView dequeueReusableCellWithIdentifier:PhotoAblumCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.photoNum.text = [NSString stringWithFormat:@"%@",_dynum];
        cell.photoNum.font = [UIFont systemFontOfSize:kHorizontal(22)];
        [cell.photoNum sizeToFit];
        
        if (_photoArr.count == 0) {
            cell.photoImage1.image = [UIImage imageNamed:@"相册默认图"];
        }else{
            if (_photoImage) {
                [cell.photoImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImage]] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
                cell.photoImage1.clipsToBounds = YES;
                cell.photoImage1.contentMode = UIViewContentModeScaleAspectFill;
            }
            if (_photoImageO) {
                [cell.photoImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImageO]] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
                cell.photoImage2.clipsToBounds = YES;
                cell.photoImage2.contentMode = UIViewContentModeScaleAspectFill;
            }
            if (_photoImageT) {
                [cell.photoImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImageT]] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
                cell.photoImage3.clipsToBounds = YES;
                cell.photoImage3.contentMode = UIViewContentModeScaleAspectFill;
            }

        }
        
        return cell;
    }
    NewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identtifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        
        if (_playgolfState != 0) {
            cell.title.text = [NSString stringWithFormat:@"记分(%d)",_groupNum];
            if (_scoringArr.count != 0) {
                [cell relayOutWithScoringModel:_scoringArr[0]];

            }
            
        }else{
            if (_interviewArr.count != 0) {
                [cell relayoutWithDictionary:_interviewArr[0]];

            }
        }
        
    }else if(indexPath.row == 2){
        if (![_interviewId isEqualToString:@"0"]) {
            
            [cell relayoutWithDictionary:_interviewArr[0]];

        }
        
    }
    
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailHeaderModel *model = self.headerViewDataArr.firstObject;
    ZhuanFangModel *interViewModel = _interviewArr[0];
//    ScoringModel *scorModel = _scoringArr[0];
    if (indexPath.row == 0) {
        DynamicViewController *photo = [[DynamicViewController alloc]init];
        photo.nameid = _nameID;
        [self.navigationController pushViewController:photo animated:YES];
    }
    
    if (indexPath.row == 1) {
        
        if (_playgolfState == 0) {
            
            InterviewDetileViewController *zhuanfang = [[InterviewDetileViewController alloc]init];
            
            zhuanfang.ID = model.vid;
            zhuanfang.type = @"2";
            zhuanfang.addTimeStr = interViewModel.time;
            zhuanfang.titleStr = interViewModel.title;
            zhuanfang.htmlStr = interViewModel.url;
            zhuanfang.readStr = interViewModel.readnum;
            zhuanfang.likeStr = interViewModel.clicks;
            zhuanfang.likeDelegate = self;
            zhuanfang.isLike = interViewModel.liked;
            zhuanfang.isFollow = _followState;
            zhuanfang.name_id = _nameID;

            
            [zhuanfang setBlock:^(BOOL isView) {
                
            }];
            [self.navigationController pushViewController:zhuanfang animated:YES];
            
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/updata_interview_rednumber",urlHeader120] parameters:@{@"interview_id":model.vid} complicate:^(BOOL success, id data) {
                if (success) {
                    
                    [self.tableView reloadData];
                }
            } ];

            
        }else{
            
            ScorRecordViewController *save = [[ScorRecordViewController alloc]init];
            save.logInNameId = userDefaultId;
            save.nameUid = _nameID;
            if ([_nameID isEqualToString:userDefaultId]) {
                save.nameUid = userDefaultUid;
            }
            
            [self.navigationController pushViewController:save animated:YES];

        }
    }
    if (indexPath.row == 2) {
        if ([_interviewId isEqualToString:@"0"]) {
            return;
        }
        InterviewDetileViewController *zhuanfang = [[InterviewDetileViewController alloc]init];
        
        DetailHeaderModel *model = self.headerViewDataArr.firstObject;
        
        zhuanfang.ID = model.vid;
        zhuanfang.type = @"2";
        zhuanfang.addTimeStr = interViewModel.time;
        zhuanfang.titleStr = interViewModel.title;
        zhuanfang.htmlStr = interViewModel.url;
        zhuanfang.likeDelegate = self;
        zhuanfang.isLike = interViewModel.liked;
        zhuanfang.readStr = interViewModel.readnum;
        zhuanfang.likeStr = interViewModel.clicks;
        zhuanfang.isFollow = _followState;
        zhuanfang.name_id = _nameID;
        [zhuanfang setBlock:^(BOOL isView) {
            
        }];
        [self.navigationController pushViewController:zhuanfang animated:YES];
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offY = scrollView.contentOffset.y+20;
    CGFloat maxOffsetY = -100; ///< 计算比率的最大偏移量
    
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY >= HScale(24.7)) {
        _backGroundImage.height = 0;
        
    }else{
        _backGroundImage.height = HScale(24.7)-offSetY;
    }
    _backGroundImage.top = offSetY;
    
    if (offY <= 0) {
        
        if (offY == 0) {
            for (MarkItem *markItem in _markItemsArray) {
                [markItem updateViewPositionWithRatio:0];
            }
        } else if (offY >= maxOffsetY) {
            for (MarkItem *markItem in _markItemsArray) {
                [markItem updateViewPositionWithRatio:fabs(offY)/fabs(maxOffsetY)];
            }
        } else {
            for (MarkItem *markItem in _markItemsArray) {
                [markItem updateViewPositionWithRatio:1];
            }
        }
    }
    
}
-(void)likeBtnSelected:(BOOL)isSelected withLikeNum:(NSString *)likenum{
    ZhuanFangModel *interViewModel = _interviewArr[0];
    interViewModel.liked = isSelected;
    interViewModel.clicks = likenum;
}
@end