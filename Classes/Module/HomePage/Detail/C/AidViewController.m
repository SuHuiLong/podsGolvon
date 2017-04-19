//
//  AidViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "AidViewController.h"
#import "NewDetailCell.h"
#import "NewDetailPhotoAblumCell.h"
#import "DetailHeaderModel.h"
#import "Self_Fans_ViewController.h"
#import "Self_GuanZhuViewController.h"
#import "Self_P_ViewController.h"
#import "Self_LY_ViewController.h"
#import "MarkItem.h"
#import "UIView+Size.h"
#import "ChangeHeaderImageViewController.h"


@interface AidViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) DownLoadDataSource    *loadData;          //工具类
@property (strong, nonatomic) NSMutableArray        *liuyanData;        //留言数据
@property (strong, nonatomic) NSMutableArray        *photoAblumArr;     //相册数据
@property (strong, nonatomic) NSMutableArray        *headerViewDataArr; //段头数据
/**
 *  相册个数
 */
@property (strong, nonatomic) NSMutableArray        *photoNum;
@property (strong, nonatomic) UITableView           *tableView;         //表
@property (strong ,nonatomic) UIImageView           *backGroundImage;   //封面图片
@property (strong ,nonatomic) UIImageView           *headerImage;       //头像
@property (strong ,nonatomic) UIImageView           *sexImage;       //头像

@property (strong, nonatomic) UIButton              *fansBtn;           //粉丝
@property (strong, nonatomic) UIButton              *followBtn;         //关注
@property (strong, nonatomic) UIButton              *setFollowBtn;      //添加关注按钮
@property (strong ,nonatomic) UILabel               *nickName;          //昵称
@property (strong ,nonatomic) UILabel               *signature;         //签名
@property (strong ,nonatomic) NSString               *sex;               //性别
@property (strong, nonatomic) NSString   *messageStr;
@property (strong, nonatomic) NSMutableArray        *photoArr;


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
@property (strong, nonatomic) MBProgressHUD   *HUD;             //菊花

@property (nonatomic,copy)    NSMutableArray        *markArry;              //存放标签的数据
@property (nonatomic, copy) NSArray<MarkItem *> *markItemsArray; ///< 标签工具集合
@property (nonatomic, copy) NSMutableArray  *cellArr;

/**
 *  背景view
 */
@property (strong, nonatomic) UIView      *backGroundView;

/** 访问量*/
@property (strong, nonatomic) UIImageView     *pageViewImage;
@property (strong, nonatomic) UILabel         *pageViewLabel;


@end


static NSString *identtifier = @"NewDetailCell";
static NSString *photoAblumCell = @"NewDetailPhotoAblumCell";
@implementation AidViewController

-(NSMutableArray *)liuyanData{
    if (!_liuyanData) {
        _liuyanData = [[NSMutableArray alloc]init];
    }
    return _liuyanData;
}


-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
/**相册dataArr*/
-(NSMutableArray *)photoAblumArr{
    if (!_photoAblumArr) {
        _photoAblumArr = [[NSMutableArray alloc]init];
    }
    return _photoAblumArr;
}
/**标签*/
-(NSMutableArray *)markArry{
    
    if (!_markArry) {
        
        _markArry = [[NSMutableArray alloc]init];
    }
    return _markArry;
}
/**照片数*/
-(NSMutableArray *)photoNum{
    if (!_photoNum) {
        _photoNum = [[NSMutableArray alloc]init];
    }
    return _photoNum;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _block(YES);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currenPage = 0;
    [self createUI];
    [self downLoadLiuYanData];
    [self downLoadHeaderData];
    [self createBackButton];
//    [self downLoadPhotoAblumData];
//    [self downGuanzhuData];
}
#pragma mark ---- 返回按钮
-(void)createBackButton{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(24.7)+HScale(29.8))];
    _backGroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backGroundView];
    
    //    创建表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    CGFloat rowHight = (ScreenHeight - HScale(66.4))/3;
    _tableView.rowHeight = rowHight;
    [_tableView registerClass:[NewDetailCell class] forCellReuseIdentifier:identtifier];
    [_tableView registerClass:[NewDetailPhotoAblumCell class] forCellReuseIdentifier:photoAblumCell];
    [self.view addSubview:_tableView];
    
    
    /**背景图*/
    _backGroundImage = [[UIImageView alloc]init];
    _backGroundImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(24.7));
    _backGroundImage.clipsToBounds = YES;
    _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [_tableView addSubview:_backGroundImage];
    
    _tableView.tableHeaderView = _backGroundView;
    
    
    
    UIImageView *maskBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, HScale(15.6) , ScreenWidth, HScale(9.1))];
    maskBottom.image = [UIImage imageNamed:@"蒙板移动_下"];
    [_backGroundView addSubview:maskBottom];
    
    
    /**头像*/
    UILabel *groundLabel = [[UILabel alloc]init];
    groundLabel.frame = CGRectMake(WScale(39.75), HScale(19.35) , WScale(20.5), HScale(11.7));
    groundLabel.backgroundColor = [UIColor whiteColor];
    groundLabel.layer.masksToBounds = YES;
    groundLabel.layer.cornerRadius = HScale(11.7)/2;
    [_backGroundView addSubview:groundLabel];
    
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(40), HScale(19.6) , WScale(20), HScale(11.2))];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = HScale(11.2)/2;
    _headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChangeHeaderImage)];
    [_headerImage addGestureRecognizer:tap];
    [_backGroundView addSubview:_headerImage];
    
    /**昵称*/
    _nickName = [[UILabel alloc]init];
    _nickName.frame = CGRectMake((ScreenWidth - WScale(28)) /2, HScale(31.9) , WScale(28), HScale(3.3));
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(18)];
    _nickName.textColor = GPColor(49, 47, 47);
    [_backGroundView addSubview:_nickName];
    
    _sexImage = [[UIImageView alloc]init];
    [_backGroundView addSubview:_sexImage];
    
    /**粉丝，关注*/
    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_fansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",@"0"] forState:UIControlStateNormal];
    [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",@"0"] forState:UIControlStateNormal];

    
    [_fansBtn addTarget:self action:@selector(clickToFans) forControlEvents:UIControlEventTouchUpInside];
    [_followBtn addTarget:self action:@selector(clickToFollow) forControlEvents:UIControlEventTouchUpInside];
    
    [_fansBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    [_followBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = GPColor(66, 66, 66);
    [_backGroundView addSubview:_line];
    
    [_backGroundView addSubview:_fansBtn];
    [_backGroundView addSubview:_followBtn];
    
    
    /**签名*/
    _signature = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(74.8))/2, HScale(42.9) , WScale(74.8), HScale(2.4))];
    _signature.textColor = GPColor(125, 122, 136);
    _signature.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_backGroundView addSubview:_signature];
    
    
    //    添加关注按钮
    _setFollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setFollowBtn setBackgroundImage:[UIImage imageNamed:@"addFollow(personal center)"] forState:UIControlStateNormal];
    [_setFollowBtn setBackgroundImage:[UIImage imageNamed:@"alreadyFollow(personal center)"] forState:UIControlStateSelected];
    [_setFollowBtn addTarget:self action:@selector(addFollow:) forControlEvents:UIControlEventTouchUpInside];
    _setFollowBtn.frame = CGRectMake((ScreenWidth-WScale(23.7))/2, HScale(47.5) , WScale(23.7), HScale(3.7));
    [_backGroundView addSubview:_setFollowBtn];
    
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
#pragma mark ---- 跳转到更换头像界面
-(void)clickToChangeHeaderImage{
    
    ChangeHeaderImageViewController *change = [[ChangeHeaderImageViewController alloc]init];
    change.hidesBottomBarWhenPushed = YES;
    change.controlID = 1;
    change.pictureUrl = _picture_url;
    change.avatarView = _headerImage;
    [self.navigationController pushViewController:change animated:NO];
}
#pragma mark ---- 下载数据
-(void)downLoadHeaderData{
    NSDictionary *dict = @{
                           @"name_id":@"usergolvon"
                           };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_name_id",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            _headerViewDataArr = [NSMutableArray array];
            NSDictionary *dic = data;
            
            _markArry = [NSMutableArray array];
            for (NSDictionary *mark_dic in dic[@"label"]) {
                
                NSString *mark_label = [mark_dic objectForKey:@"label_content"];
                
                
                [_markArry addObject:mark_label];
            }
            
            for (NSDictionary *temp in dic[@"data"]) {
                
//                DetailHeaderModel *model = [DetailHeaderModel pareFrom:temp];
//                _sex = model.gender;
//                _messageStr = model.messageNum;
//                _picture_url = model.picture_url;
                id interViewStyle = temp[@"interview"];
                if ([interViewStyle isKindOfClass:[NSArray class]]) {
                    NSDictionary *interViewDict = interViewStyle[0];
                    _interviewid = [interViewDict objectForKey:@"interview_id"];
                }
                
//                [self.headerViewDataArr addObject:model];
                
                NSLog(@"用户、、、ID%@",temp[@"name_id"]);
//                [self setUpModel:model];
            }
            //            [self downLoadZhuanFangTitle];
            self.view.backgroundColor = [UIColor colorWithRed:245.0f/256.0f green:245.0f/256.0f blue:245.0f/256.0f alpha:1];
            [_tableView reloadData];
            
        }
    }];
}
#pragma mark —— 获取关注状态
//-(void)downGuanzhuData{
//    
//    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
//    
//    NSDictionary *dict = @{
//                           @"follow_name_id":userDefaultId,
//                           @"cov_follow_nameid":@"usergolvon"
//                           };
//    
//    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_nameid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
//        if (success) {
//            _followState = data[@"data"][0][@"code"];
//            NSLog(@"%@", _followState);
//            self.setFollowBtn.selected = [_followState intValue] == 0 ? NO : YES;
//        }
//    }];
//}



#pragma mark ---- 添加关注
-(void)addFollow:(UIButton*)button{
    
    /**
     *  follow_name 关注人
     cofollow_name 被关注的人
     */
    NSDictionary *insterParamters = @{
                                      @"follow_name_id":userDefaultId,
                                      @"cof_name_id":@"usergolvon"
                                      };
    NSDictionary *deleteParamters = @{
                                      @"follow_user_id":userDefaultId,
                                      @"name_id":@"usergolvon"
                                      };
    NSString *insertUrlStr = [NSString stringWithFormat:@"%@Golvon/insert_follow",urlHeader120];
    NSString *deleteUrlStr = [NSString stringWithFormat:@"%@Golvon/delete_follow",urlHeader120];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.alpha = 0.5;
    NSLog(@"%@", _followState);
    if ([_followState isEqualToString:@"0"]) {
        
        [self.loadData downloadWithUrl:insertUrlStr parameters:insterParamters complicate:^(BOOL success, id data) {
            if (success) {
                _HUD.hidden = YES;
                _HUD = nil;
                button.selected = YES;
//                [self DownloadCellData];
                _followState = @"1";
            }
        }];
    }else{
        [self.loadData downloadWithUrl:deleteUrlStr parameters:deleteParamters complicate:^(BOOL success, id data) {
            if (success) {
                _HUD.hidden = YES;
                _HUD = nil;
                button.selected = NO;
                _followState = @"0";
                
            }
        }];
    }
}


//- (void)setUpModel:(DetailHeaderModel *)model{
//    //    封面图
//    [_backGroundImage sd_setImageWithURL:[NSURL URLWithString:model.groundImage] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
//    
//    //    头像
//    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
//    
//    //    签名
//    UILabel *test = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(28))/2, HScale(31.9) , WScale(28), HScale(3.3))];
//    test.text = model.nickname;
//    test.textAlignment = NSTextAlignmentCenter;
//    [test sizeToFit];
//    
//    _nickName.frame = CGRectMake((ScreenWidth - test.width)/2, test.y, test.width, test.height);
//    _nickName.textAlignment = NSTextAlignmentCenter;
//    _nickName.text =test.text;
//    [_nickName sizeToFit];
//    
//    _sexImage.frame = CGRectMake(_nickName.x+_nickName.width+3, _nickName.top+3, 15, 15);
//    if ([_sex isEqualToString:@"女"]) {
//        _sexImage.image = [UIImage imageNamed:@"女"];
//    }else{
//        _sexImage.image = [UIImage imageNamed:@"男"];
//    }
//    
//    
//    _signature.text = model.siignature;
//    _signature.textAlignment = NSTextAlignmentCenter;
//    
//    //    粉丝，关注
//    
//    _line.frame = CGRectMake((ScreenWidth - 1)/2, HScale(38)  , 0.8, HScale(1.8));
//    
//    UILabel *fansTest = [[UILabel alloc]init];
//    UILabel *followTest = [[UILabel alloc]init];
//    
//    fansTest.frame = CGRectMake(_line.x - WScale(3) - WScale(25), HScale(36.7) , WScale(25), HScale(2.7));
//    followTest.frame = CGRectMake(_line.right + WScale(3), HScale(36.7) , WScale(25), HScale(2.7));
//    
//    fansTest.text = [NSString stringWithFormat:@"%@粉丝",model.fansNum];
//    followTest.text = [NSString stringWithFormat:@"%@关注",model.followNum];
//    
//    fansTest.font = [UIFont systemFontOfSize:kHorizontal(13)];
//    followTest.font = [UIFont systemFontOfSize:kHorizontal(13)];
//    
//    fansTest.textAlignment = NSTextAlignmentCenter;
//    followTest.textAlignment = NSTextAlignmentCenter;
//    
//    [fansTest sizeToFit];
//    [followTest sizeToFit];
//    
//    
//    [_fansBtn setTitle:fansTest.text forState:UIControlStateNormal];
//    [_followBtn setTitle:followTest.text forState:UIControlStateNormal];
//    
//    _fansBtn.frame = CGRectMake(_line.x - fansTest.width - WScale(3), fansTest.y, fansTest.width, HScale(2.7));
//    _followBtn.frame = CGRectMake(followTest.x,followTest.y, followTest.width, HScale(2.7));
//    
//    _fansBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//    _followBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//
//    [_fansBtn sizeToFit];
//    [_followBtn sizeToFit];
//    
//    UILabel *test1 = [[UILabel alloc]init];
//    test1.backgroundColor = [UIColor redColor];
//    test1.text = model.access_amount;
//    test1.frame = CGRectMake(_pageViewImage.right + WScale(1), _pageViewImage.y-3, 80, _pageViewImage.height);
//    test1.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    [test1 sizeToFit];
//    
//    _pageViewLabel.text = test1.text;
//    _pageViewLabel.frame = test1.frame;
//    _pageViewLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    _pageViewLabel.textAlignment = NSTextAlignmentCenter;
//    _pageViewLabel.shadowColor = GPColor(26, 26, 26);
//    _pageViewLabel.textColor = [UIColor whiteColor];
//    _pageViewLabel.shadowOffset = CGSizeMake(0, 1);
//    [_pageViewLabel sizeToFit];
//    
//    
//    //    标签
//    NSString *markStr1 = [NSString string];
//    NSString *markStr3 = [NSString string];
//    NSString *markStr2 = [NSString string];
//    NSString *markStr4 = [NSString string];
//    NSString *markStr5 = [NSString string];
//    NSString *markStr6 = [NSString string];
//    
//    _markHeaderImage1.hidden = YES;
//    _markHeaderImage2.hidden = YES;
//    _markHeaderImage3.hidden = YES;
//    _markHeaderImage4.hidden = YES;
//    _markHeaderImage5.hidden = YES;
//    _markHeaderImage6.hidden = YES;
//    
//    
//    _markGroundImage1.hidden = YES;
//    _markGroundImage2.hidden = YES;
//    _markGroundImage3.hidden = YES;
//    _markGroundImage4.hidden = YES;
//    _markGroundImage5.hidden = YES;
//    _markGroundImage6.hidden = YES;
//    
//    
//    switch (_markArry.count) {
//            
//            
//            
//        case 0:{
//            
//        }break;
//        case 1:{
//            markStr3 = _markArry[0];
//            _markHeaderImage3.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            
//        }break;
//        case 2:{
//            markStr3 = _markArry[0];
//            markStr2 = _markArry[1];
//            
//            _markHeaderImage2.hidden = NO;
//            _markHeaderImage3.hidden = NO;
//            
//            _markGroundImage2.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            
//            
//        }break;
//        case 3:{
//            
//            markStr2 = _markArry[1];
//            markStr3 = _markArry[0];
//            markStr4 = _markArry[2];
//            
//            _markHeaderImage2.hidden = NO;
//            _markHeaderImage3.hidden = NO;
//            _markHeaderImage4.hidden = NO;
//            
//            _markGroundImage2.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            _markGroundImage4.hidden = NO;
//            
//        }break;
//        case 4:{
//            
//            markStr1 = _markArry[3];
//            markStr2 = _markArry[1];
//            markStr3 = _markArry[0];
//            markStr4 = _markArry[2];
//            
//            _markHeaderImage1.hidden = NO;
//            _markHeaderImage2.hidden = NO;
//            _markHeaderImage3.hidden = NO;
//            _markHeaderImage4.hidden = NO;
//            
//            _markGroundImage1.hidden = NO;
//            _markGroundImage2.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            _markGroundImage4.hidden = NO;
//            
//        }break;
//            
//        case 5:{
//            
//            markStr3 = _markArry[0];
//            markStr2 = _markArry[1];
//            markStr4 = _markArry[2];
//            markStr1 = _markArry[3];
//            markStr5 = _markArry[4];
//            
//            _markHeaderImage2.hidden = NO;
//            _markHeaderImage3.hidden = NO;
//            _markHeaderImage4.hidden = NO;
//            _markHeaderImage1.hidden = NO;
//            _markHeaderImage6.hidden = NO;
//            
//            _markGroundImage1.hidden = NO;
//            _markGroundImage2.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            _markGroundImage4.hidden = NO;
//            _markGroundImage6.hidden = NO;
//            
//        }break;
//        case 6:{
//            markStr3 = _markArry[0];
//            markStr2 = _markArry[1];
//            markStr4 = _markArry[2];
//            markStr1 = _markArry[3];
//            markStr5 = _markArry[4];
//            markStr6 = _markArry[5];
//            
//            _markHeaderImage2.hidden = NO;
//            _markHeaderImage3.hidden = NO;
//            _markHeaderImage4.hidden = NO;
//            _markHeaderImage1.hidden = NO;
//            _markHeaderImage5.hidden = NO;
//            _markHeaderImage6.hidden = NO;
//            
//            _markGroundImage1.hidden = NO;
//            _markGroundImage2.hidden = NO;
//            _markGroundImage3.hidden = NO;
//            _markGroundImage4.hidden = NO;
//            _markGroundImage5.hidden = NO;
//            _markGroundImage6.hidden = NO;
//            
//        }
//        default:
//            break;
//    }
//    
//#pragma mark ---- 左边第1个标签
//    _markLabel1.text = markStr1;
//    _markLabel1.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
//    _markLabel1.textColor = [UIColor whiteColor];
//    _markLabel1.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    [_markLabel1 sizeToFit];
//    _markGroundImage1.frame = CGRectMake(0, 0, _markLabel1.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage1.image = [UIImage imageNamed:@"标签_内容背景"];
//    _markHeaderImage1.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage1.frame.size.width, 0, WScale(7.5), HScale(4.6));
//    _markHeaderImage1.image = [UIImage imageNamed:@"标签头__左"];
//    _markView1.frame = CGRectMake(0 - _markGroundImage1.frame.size.width-WScale(7.5), 0, _markGroundImage1.frame.size.width +WScale(7.5), HScale(4.6));
//    
//#pragma mark ---- 左边第2个标签
//    _markLabel2.text = markStr2;
//    _markLabel2.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
//    _markLabel2.textColor = [UIColor whiteColor];
//    _markLabel2.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
//    [_markLabel2 sizeToFit];
//    _markGroundImage2.frame = CGRectMake(0, 0, _markLabel2.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage2.image = [UIImage imageNamed:@"标签_内容背景"];
//    
//    UILabel *testLable = [[UILabel alloc] init];
//    testLable.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    
//    _markHeaderImage2.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage2.frame.size.width, 0, WScale(7.5), HScale(4.6));
//    
//    _markHeaderImage2.image = [UIImage imageNamed:@"标签头__左"];
//    
//    _markView2.frame = CGRectMake(0 - _markGroundImage2.frame.size.width - WScale(7.5), _markView1.bottom + HScale(2.2), _markGroundImage2.frame.size.width + WScale(7.5), HScale(4.6));
//    
//#pragma mark ---- 左边第3个标签
//    _markLabel5.text = markStr6;
//    _markLabel5.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
//    _markLabel5.textColor = [UIColor whiteColor];
//    _markLabel5.backgroundColor = [UIColor clearColor];
//    _markLabel5.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    [_markLabel5 sizeToFit];
//    _markGroundImage5.frame = CGRectMake(0, 0, _markLabel5.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage5.image = [UIImage imageNamed:@"标签_内容背景"];
//    
//    _markHeaderImage5.frame = CGRectMake(_markGroundImage5.frame.origin.x+_markGroundImage5.frame.size.width, 0,WScale(7.5), HScale(4.6));
//    _markHeaderImage5.image = [UIImage imageNamed:@"标签头__左"];
//    _markView5.frame = CGRectMake(0 - _markGroundImage5.frame.size.width - WScale(7.5), _markView2.bottom+HScale(2.2), _markGroundImage5.frame.size.width + WScale(7.5), HScale(4.6));
//    
//#pragma mark ---- 右边第1个标签
//    _markLabel3.text = markStr3;
//    testLable.text = _markLabel3.text;
//    [testLable sizeToFit];
//    _markLabel3.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
//    _markLabel3.textColor = [UIColor whiteColor];
//    _markLabel3.backgroundColor = [UIColor clearColor];
//    _markLabel3.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    _markLabel3.textAlignment = NSTextAlignmentRight;
//    
//    _markGroundImage3.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage3.image = [UIImage imageNamed:@"标签_内容背景"];
//    
//    _markHeaderImage3.frame = CGRectMake(_markGroundImage3.x-WScale(7.5), 0, WScale(7.5), HScale(4.6));
//    _markHeaderImage3.image = [UIImage imageNamed:@"标签头__右"];
//    _markView3.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView1.y, _markGroundImage3.width+ WScale(7.5), HScale(4.6));
//    
//#pragma mark ---- 右边第2个标签
//    _markLabel4.text = markStr4;
//    testLable.text = _markLabel4.text;
//    [testLable sizeToFit];
//    
//    
//    _markLabel4.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
//    _markLabel4.textColor = [UIColor whiteColor];
//    _markLabel4.backgroundColor = [UIColor clearColor];
//    _markLabel4.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    _markLabel4.textAlignment = NSTextAlignmentRight;
//    
//    _markGroundImage4.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage4.image = [UIImage imageNamed:@"标签_内容背景"];
//    
//    
//    _markHeaderImage4.frame = CGRectMake(_markGroundImage4.frame.origin.x - WScale(7.5), 0,WScale(7.5), HScale(4.6));
//    
//    _markHeaderImage4.image = [UIImage imageNamed:@"标签头__右"];
//    _markView4.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView2.y, _markGroundImage4.frame.size.width + WScale(7.5), HScale(4.6));
//    
//    
//#pragma mark ---- 右边第3个标签
//    _markLabel6.text = markStr5;
//    testLable.text = _markLabel6.text;
//    [testLable sizeToFit];
//    
//    _markLabel6.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
//    _markLabel6.textColor = [UIColor whiteColor];
//    _markLabel6.backgroundColor = [UIColor clearColor];
//    _markLabel6.font = [UIFont systemFontOfSize:kHorizontal(12)];
//    _markLabel6.textAlignment = NSTextAlignmentRight;
//    
//    _markGroundImage6.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
//    _markGroundImage6.image = [UIImage imageNamed:@"标签_内容背景"];
//    _markHeaderImage6.frame = CGRectMake(_markGroundImage6.frame.origin.x - WScale(7.5), 0, WScale(7.5), HScale(4.6));
//    _markHeaderImage6.image = [UIImage imageNamed:@"标签头__右"];
//    _markView6.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView5.y, _markGroundImage6.frame.size.width + WScale(7.5), HScale(4.6));
//
//    // 标签工具1
//    CGPoint centerEnd1 = CGPointMake(_markView1.width/2, _markView1.y+_markView1.height/2);
//    MarkItem *item1 = [MarkItem itemWithView:_markView1 centerStart:_markView1.center centerEnd:centerEnd1];
//    // 标签工具2
//    CGPoint centerEnd2 = CGPointMake(_markView2.width/2, _markView2.y+_markView2.height/2);
//    MarkItem *item2 = [MarkItem itemWithView:_markView2 centerStart:_markView2.center centerEnd:centerEnd2];
//    // 标签工具5
//    CGPoint centerEnd5 = CGPointMake(_markView5.width/2, _markView5.y+_markView5.height/2);
//    MarkItem *item5 = [MarkItem itemWithView:_markView5 centerStart:_markView5.center centerEnd:centerEnd5];
//    
//    // 标签工具3
//    CGPoint centerEnd3 = CGPointMake(_tableView.tableHeaderView.right-_markView3.width/2+WScale(7.5), _markView1.y+_markView3.height/2);
//    MarkItem *item3 = [MarkItem itemWithView:_markView3 centerStart:_markView3.center centerEnd:centerEnd3];
//    // 标签工具4
//    CGPoint centerEnd4 = CGPointMake(_tableView.tableHeaderView.right-_markView4.width/2+WScale(7.5), _markView2.y+_markView4.height/2);
//    MarkItem *item4 = [MarkItem itemWithView:_markView4 centerStart:_markView4.center centerEnd:centerEnd4];
//    // 标签工具6
//    CGPoint centerEnd6 = CGPointMake(_tableView.tableHeaderView.right-_markView6.width/2+WScale(7.5), _markView5.y+_markView6.height/2);
//    MarkItem *item6 = [MarkItem itemWithView:_markView6 centerStart:_markView6.center centerEnd:centerEnd6];
//    
//    _markItemsArray = @[item1, item2, item3, item4, item5, item6];
//
//    
//}
#pragma mark ---- 下载留言数据
-(void)downLoadLiuYanData{
    NSDictionary *dict = @{
                           @"name_id": @"usergolvon",
                           @"start_number":@(_currenPage)
                           };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_message_name_id",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
//                LiuYanModel *model = [LiuYanModel pareFromWithDictionary:temp];
//                [self.liuyanData addObject:model];
            }
            
        }else{
            
            SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: @"网络错误"];
            [self.view addSubview:sView];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sView.hidden = YES;
            });
        
        }
        
        [self.tableView reloadData];
    }];
    
    
}
#pragma mark ---- 请求相册数据
//-(void)downLoadPhotoAblumData{
//    NSDictionary *dict = @{
//                           @"name_id":@"usergolvon",
//                           };
//    
//    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_picture_all_user",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
//        
//        if (success) {
//            
//            _photoArr = [[NSMutableArray alloc]init];
//            NSLog(@"照片 %@",data[@"data"]);
//            
//            for (NSDictionary *temp in data[@"data"]) {
//                
////                PhotoModel *model = [PhotoModel pareFromDictionary:temp];
////                [self.photoAblumArr addObject:model];
//            }
//            NSInteger count = _photoAblumArr.count;
//            if (_photoAblumArr.count == 1) {
//                
////                PhotoModel *model = _photoAblumArr[0];
////                [_photoArr addObject:model];
//                _photoImage = model.photoName;
//                
//            }else if (_photoAblumArr.count == 2){
//                
//                PhotoModel *model = _photoAblumArr[0];
//                PhotoModel *model_1 = _photoAblumArr[1];
//                [_photoArr addObject:model];
//                [_photoArr addObject:model_1];
//                _photoImage = model.photoName;
//                _photoImageO = model_1.photoName;
//                
//            }else if (_photoAblumArr.count >= 3){
//                
//                for (NSInteger i = 0; i<3; i++) {
//                    
//                    PhotoModel *model = _photoAblumArr[count - i - 1];
//                    [_photoArr addObject:model];
//                }
//                
//                PhotoModel *model = _photoArr[0];
//                PhotoModel *model1 = _photoArr[1];
//                PhotoModel *model2 = _photoArr[2];
//                _photoImageT = model.photoName;
//                _photoImageO = model1.photoName;
//                _photoImage = model2.photoName;
//                
//            }
//            
//            [_tableView reloadData];
//        }
//    }];
//}
#pragma mark ---- 跳转到关注的界面
-(void)clickToFollow{
    Self_GuanZhuViewController *follow = [[Self_GuanZhuViewController alloc]init];
    follow.name_id = @"usergolvon";
    [self.navigationController pushViewController:follow animated:YES];
}
#pragma mark ---- 跳转到粉丝的界面
-(void)clickToFans{
    Self_Fans_ViewController *fans = [[Self_Fans_ViewController alloc]init];
    fans.name_id = @"usergolvon";
    [self.navigationController pushViewController:fans animated:YES];
}

#pragma mark ----- 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_photoAblumArr || !_liuyanData) {
        return 1;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NewDetailPhotoAblumCell *cell = [tableView dequeueReusableCellWithIdentifier:photoAblumCell];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.photoNum.text = [NSString stringWithFormat:@"%ld",(long)_photoAblumArr.count];
        
        [cell.photoImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImage]] placeholderImage:[UIImage imageNamed:@"照片加载图"]];
        [cell.photoImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImageO]] placeholderImage:[UIImage imageNamed:@"照片加载图"]];
        [cell.photoImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photoImageT]] placeholderImage:[UIImage imageNamed:@"照片加载图"]];
        
        return cell;
    }
    NewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identtifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = [NSString stringWithFormat:@"留言(%@)",_messageStr];
//    [cell relayOutWithLiuYanModel:_liuyanData[0]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        Self_P_ViewController *photo = [[Self_P_ViewController alloc]init];
        photo.nameID = @"usergolvon";
        [self.navigationController pushViewController:photo animated:YES];
    }else{
        Self_LY_ViewController *message = [[Self_LY_ViewController alloc]init];
        message.nameID = @"usergolvon";
        message.nickName = @"打球去小助手";
        [self.navigationController pushViewController:message animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offY = scrollView.contentOffset.y+20;
    CGFloat maxOffsetY = -100; //< 计算比率的最大偏移量
    
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
@end
