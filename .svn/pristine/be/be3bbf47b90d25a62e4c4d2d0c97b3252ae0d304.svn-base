//
//  Self_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/2.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_ViewController.h"
#import "RegistViewController.h"
#import "PhotoViewController.h"
#import "PhotoModel.h"
#import "AddSelfPhotosViewController.h"
#import "JZAlbumViewController.h"
#import "UserDetailViewController.h"
#import "AboutViewController.h"
#import "Self_GuanZhuViewController.h"
#import "DownLoadDataSource.h"
#import "PhotoViewController.h"

#import "JPUSHService.h"
#import "Self_Zhuan_TableViewCell.h"
#import "Self_Photo_TableViewCell.h"
#import "NewZhuanFangViewController.h"
#import "Self_P_ViewController.h"
#import "Self_Fans_ViewController.h"
#import "Self_LY_ViewController.h"
#import "Edit_ViewController.h"

@interface Self_ViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UILabel *_DescLabel;
}


@property(nonatomic,strong)NSMutableArray *PhotoArr;
@property(nonatomic,strong)NSMutableArray *AllPhotoArr;
@property(nonatomic,strong)NSMutableArray *PhotoDesc;
@property(nonatomic,strong)NSMutableArray *PhotoDate;
@property(nonatomic,strong)NSMutableArray *PhotoId;

/**
 *  个人属性背景图片
 */
@property (strong, nonatomic)UIImageView *backGroundImageOne;
@property (strong, nonatomic)UIImageView *backGroundImageTow;
@property (strong, nonatomic)UIImageView *backGroundImageThree;
@property (strong, nonatomic)UIImageView *backGroundImageFour;
@property (strong, nonatomic)UIImageView *backGroundImageFive;

@property (strong, nonatomic)UIButton *aboutBtn;


@property (strong, nonatomic)NSMutableArray *dataDict;
@property (strong, nonatomic)NSArray *guanNum;

@property(nonatomic,strong)UIImageView *markViewFri;
@property(nonatomic,strong)UIImageView *markViewSec;
@property(nonatomic,strong)UIImageView *markViewThr;
@property(nonatomic,strong)UIImageView *markViewFou;
@property(nonatomic,strong)UIImageView *markViewFif;
@property(nonatomic,strong)UIImageView *markViewSix;


@property(nonatomic,strong)UILabel *markLabelFri;
@property(nonatomic,strong)UILabel *markLabelSec;
@property(nonatomic,strong)UILabel *markLabelThr;
@property(nonatomic,strong)UILabel *markLabelFou;
@property(nonatomic,strong)UILabel *markLabelFif;
@property(nonatomic,strong)UILabel *markLabelSix;


@property(nonatomic,strong)UIImageView *markViewFri1;
@property(nonatomic,strong)UIImageView *markViewSec1;
@property(nonatomic,strong)UIImageView *markViewThr1;
@property(nonatomic,strong)UIImageView *markViewFou1;
@property(nonatomic,strong)UIImageView *markViewFif1;
@property(nonatomic,strong)UIImageView *markViewSix1;

@property(nonatomic,strong)UIImageView *markViewFri2;
@property(nonatomic,strong)UIImageView *markViewSec2;
@property(nonatomic,strong)UIImageView *markViewThr2;
@property(nonatomic,strong)UIImageView *markViewFou2;
@property(nonatomic,strong)UIImageView *markViewFif2;
@property(nonatomic,strong)UIImageView *markViewSix2;

@property(nonatomic,strong)UIImageView *markViewFri3;
@property(nonatomic,strong)UIImageView *markViewSec3;
@property(nonatomic,strong)UIImageView *markViewThr3;
@property(nonatomic,strong)UIImageView *markViewFou3;
@property(nonatomic,strong)UIImageView *markViewFif3;
@property(nonatomic,strong)UIImageView *markViewSix3;

@property(nonatomic,copy)UILabel *readNum;
@property(nonatomic,copy)UIImageView *viewImage;

@property(nonatomic,copy)UIImageView *cheakStyle;

@end

static NSString *zhuanfang = @"zhuanfang";
static NSString *photo = @"photo";
@implementation Self_ViewController

-(NSMutableArray *)dataDict{
    if (!_dataDict) {
        _dataDict = [[NSMutableArray alloc] init];
    }
    return _dataDict;
}

-(NSMutableArray *)PhotoDate{
    if (_PhotoDate == nil) {
        _PhotoDate = [NSMutableArray array];
    }
    return _PhotoDate;
}

-(NSMutableArray *)PhotoId{
    if (_PhotoId == nil) {
        _PhotoId = [NSMutableArray array];
    }
    return _PhotoId;
}

-(NSMutableArray *)PhotoDesc{
    if (_PhotoDesc == nil) {
        _PhotoDesc = [NSMutableArray array];
    }
    return _PhotoDesc;
}

-(NSMutableArray *)AllPhotoArr{
    if (_AllPhotoArr == nil) {
        _AllPhotoArr = [NSMutableArray array];
    }
    return _AllPhotoArr;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self createUI];
    [self createAboutBtn];
    [self guanZhuNum];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
    [self setViewData];
    self.navigationController.navigationBarHidden = YES;
    return;
}
#pragma mark ----- 创建关于按钮
-(void)createAboutBtn{
    _aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_aboutBtn addTarget:self action:@selector(persentToAbout) forControlEvents:UIControlEventTouchUpInside];
    [_aboutBtn setImage:[UIImage imageNamed:@"我的关于"] forState:UIControlStateNormal];
    _aboutBtn.frame = CGRectMake(WScale(90.1), HScale(2.8), ScreenWidth * 0.089, ScreenHeight * 0.05);
    [self.view addSubview:_aboutBtn];
}
#pragma mark ----- 跳转到关于界面
-(void)persentToAbout{

    
        AboutViewController *about = [[AboutViewController alloc]init];
        [self presentViewController:about animated:YES completion:nil];
}



#pragma mark - 获取数据

-(void)loadData{
    DownLoadDataSource *loadDataManager = [[DownLoadDataSource alloc] init];
    NSDictionary *userDic = @{
                              @"name_id":userDefaultId                              };
    [loadDataManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_picture_all_user",urlHeader120]parameters:userDic complicate:^(BOOL success, id data) {
        if (success) {
        self.PhotoArr = [NSMutableArray array];
        self.PhotoDesc = [NSMutableArray array];
        self.PhotoId = [NSMutableArray array];
        self.PhotoDate = [NSMutableArray array];
        NSArray *dataArry = [data objectForKey:@"data"];
        
        _AllPhotoArr = [NSMutableArray array];
            
        for (NSDictionary *dataDic in dataArry) {
            [_AllPhotoArr addObject:dataDic];
            [self.PhotoArr insertObject:[dataDic objectForKey:@"picture_url"] atIndex:0];
            [self.PhotoDesc insertObject:[dataDic objectForKey:@"picture_name"]atIndex:0];
            [self.PhotoId insertObject:[dataDic objectForKey:@"picture_id"] atIndex:0];
            [self.PhotoDate insertObject:[dataDic objectForKey:@"upload_tiem"] atIndex:0];
        }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }else{
//         dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark ---- 创建UI
-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight-29 ) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.bounces = NO;
    _tableView.sectionFooterHeight = 0;
    
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    NSLog(@"%@",[userDefaults objectForKey:@"picture_url"]);

    [_backImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"picture_url"]] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    [self.view addSubview:_backImage];
    _coverView = [[UIImageView alloc]initWithFrame:_backImage.frame];
    _coverView.image = [UIImage imageNamed:@"我的遮盖"];
    [_backImage addSubview:_coverView];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenWidth)];
    [_scrollView setDelegate:self];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_coverView addSubview:_scrollView];
    [self createView];
    
    _page = [[UIPageControl alloc]init];
    _page.frame = CGRectMake(ScreenWidth/2 - 30 , ScreenWidth - 30, 30, 30);
    _page.numberOfPages = 2;
    [_backImage addSubview:_page];
    
    [_page addTarget:self action:@selector(pressPage:) forControlEvents:UIControlEventValueChanged];
    [_page addTarget:self action:@selector(downPage:) forControlEvents:UIControlEventTouchDown];
    
    // 这个必须设置 UIImageView默认是不接受用户点击的
    [_coverView  setUserInteractionEnabled:YES];
    [_backImage  setUserInteractionEnabled:YES];
    _tableView.tableHeaderView = _backImage;

    
    
    
}
- (void)downPage:(UIPageControl *)page
{
    if (page.currentPage == 1) {
        [_scrollView setContentOffset:CGPointMake(2 * ScreenWidth, 0) animated:YES];
    }
}

- (void)pressPage:(UIPageControl *)page
{
    float offX = page.currentPage * ScreenWidth;
    
    [_scrollView setContentOffset:CGPointMake(offX, 0) animated:YES];
}

-(void)createView{
    UIView *first = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    /**
     背景图片
     */
    _backGroundImageOne = [[UIImageView alloc]init];
    _backGroundImageOne.image = [UIImage imageNamed:@"个人属性背景"];
    _backGroundImageOne.backgroundColor = [UIColor clearColor];
    _backGroundImageOne.layer.cornerRadius = 3;
    
    _backGroundImageOne.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _backGroundImageOne.layer.borderWidth = 0.5;
    
    _backGroundImageOne.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    [first addSubview:_backGroundImageOne];
    
    _backGroundImageTow = [[UIImageView alloc]init];
    _backGroundImageTow.image = [UIImage imageNamed:@"个人属性背景"];
    _backGroundImageTow.backgroundColor = [UIColor clearColor];
    _backGroundImageTow.layer.cornerRadius = 3;
    
    _backGroundImageTow.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _backGroundImageTow.layer.borderWidth = 0.5;
    
    _backGroundImageTow.layer.borderColor = [[UIColor whiteColor] CGColor];

    [first addSubview:_backGroundImageTow];
    
    _backGroundImageThree = [[UIImageView alloc]init];
    _backGroundImageThree.image = [UIImage imageNamed:@"个人属性背景"];
    _backGroundImageThree.backgroundColor = [UIColor clearColor];
    _backGroundImageThree.layer.cornerRadius = 3;
    
    _backGroundImageThree.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _backGroundImageThree.layer.borderWidth = 0.5;
    
    _backGroundImageThree.layer.borderColor = [[UIColor whiteColor] CGColor];

    [first addSubview:_backGroundImageThree];
    
   
    
    
    
    _backGroundImageFour = [[UIImageView alloc]init];
    _backGroundImageFour.image = [UIImage imageNamed:@"个人属性背景"];
    _backGroundImageFour.backgroundColor = [UIColor clearColor];
    _backGroundImageFour.layer.cornerRadius = 3;
    
    _backGroundImageFour.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _backGroundImageFour.layer.borderWidth = 0.5;
    
    _backGroundImageFour.layer.borderColor = [[UIColor whiteColor] CGColor];

    
    
    
    [first addSubview:_backGroundImageFour];
    
    _backGroundImageFive = [[UIImageView alloc]init];
    _backGroundImageFive.image = [UIImage imageNamed:@"个人属性背景"];
    
    _backGroundImageFive.backgroundColor = [UIColor clearColor];
    _backGroundImageFive.layer.cornerRadius = 3;
    
    _backGroundImageFive.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _backGroundImageFive.layer.borderWidth = 0.5;
    
    _backGroundImageFive.layer.borderColor = [[UIColor whiteColor] CGColor];

    
    [first addSubview:_backGroundImageFive];
    
    _cheakStyle = [[UIImageView alloc] init];
    
    [first addSubview:_cheakStyle];
    
    
    
    
//    昵称
    
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake(WScale(2.9), HScale(36.7), ScreenWidth * 0.531, ScreenHeight * 0.067)];
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.text = [userDefaults objectForKey:@"nickname"];
    [first addSubview:_nickName];
    
    
    _viewImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(2.9), HScale(43.9), ScreenWidth * 0.045, ScreenHeight * 0.015)];
    _viewImage.image = [UIImage imageNamed:@"iconfont-yanjing"];
    [first addSubview:_viewImage];
    /**
     访问量
     */
//    _viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(7.7), HScale(35.2), ScreenWidth * 0.09, ScreenHeight * 0.025)];
    
    _readNum = [[UILabel alloc] init];
    _readNum.frame = CGRectMake(WScale(7.7), HScale(43.4), WScale(30), HScale(2.5));
    _readNum.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _readNum.textColor = [UIColor whiteColor];
    _readNum.text = [NSString stringWithFormat:@" %@",[userDefaults objectForKey:@"access_amount"]];
    [first addSubview:_readNum];
    
    
//    性别
    _sexLabel = [[UILabel alloc]init];

    [first addSubview:_sexLabel];
    
//    年龄
    _ageLabel = [[UILabel alloc]init];

    [first addSubview:_ageLabel];
    
    
    
//    杆数
    _numGan = [[UILabel alloc]init];

    [first addSubview:_numGan];
    
//    地址
    _address = [[UILabel alloc]init];

    [first addSubview:_address];
//    工作
    _persion = [[UILabel alloc]init];

    [first addSubview:_persion];

    
    _guanZhu = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guanZhu setImage:[UIImage imageNamed:@"编辑资料@2x"] forState:UIControlStateNormal];
    [_guanZhu addTarget:self action:@selector(pressesEdit) forControlEvents:UIControlEventTouchUpInside];
    _guanZhu.frame = CGRectMake(WScale(70.4), HScale(47), ScreenWidth * 0.267, ScreenWidth * 0.085);
    [first addSubview:_guanZhu];
    
    [_scrollView addSubview:first];
    
    UIView *second = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenWidth)];
    _DescLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _DescLabel.textAlignment = NSTextAlignmentCenter;
    _DescLabel.textColor = [UIColor whiteColor];
    [second addSubview:_DescLabel];
    [_scrollView addSubview:second];
    _scrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenWidth);
    
    
    _markViewFri = [[UIImageView alloc] init];
    
    _markViewSec = [[UIImageView alloc] init];
    
    _markViewThr = [[UIImageView alloc] init];
    
    _markViewFou = [[UIImageView alloc] init];
    
    _markViewFif = [[UIImageView alloc] init];
    
    _markViewSix = [[UIImageView alloc] init];
    
    
    [first addSubview:_markViewFri];
    [first addSubview:_markViewSec];
    [first addSubview:_markViewThr];
    [first addSubview:_markViewFou];
    [first addSubview:_markViewFif];
    [first addSubview:_markViewSix];
    
    
    _markLabelFri = [[UILabel alloc] init];
    _markLabelSec = [[UILabel alloc] init];
    _markLabelThr = [[UILabel alloc] init];
    _markLabelFou = [[UILabel alloc] init];
    _markLabelFif = [[UILabel alloc] init];
    _markLabelSix = [[UILabel alloc] init];
    
    
    [first addSubview:_markLabelFri];
    [first addSubview:_markLabelSec];
    [first addSubview:_markLabelThr];
    [first addSubview:_markLabelFou];
    [first addSubview:_markLabelFif];
    [first addSubview:_markLabelSix];
    
    
    
    _markViewFri1 = [[UIImageView alloc] init];
    
    _markViewSec1 = [[UIImageView alloc] init];
    
    _markViewThr1 = [[UIImageView alloc] init];
    
    _markViewFou1 = [[UIImageView alloc] init];
    
    _markViewFif1 = [[UIImageView alloc] init];
    
    _markViewSix1 = [[UIImageView alloc] init];
    
    
    [first addSubview:_markViewFri1];
    [first addSubview:_markViewSec1];
    [first addSubview:_markViewThr1];
    [first addSubview:_markViewFou1];
    [first addSubview:_markViewFif1];
    [first addSubview:_markViewSix1];
    
    _markViewFri2 = [[UIImageView alloc] init];
    
    _markViewSec2 = [[UIImageView alloc] init];
    
    _markViewThr2 = [[UIImageView alloc] init];
    
    _markViewFou2 = [[UIImageView alloc] init];
    
    _markViewFif2 = [[UIImageView alloc] init];
    
    _markViewSix2 = [[UIImageView alloc] init];
    
    [first addSubview:_markViewFri2];
    [first addSubview:_markViewSec2];
    [first addSubview:_markViewThr2];
    [first addSubview:_markViewFou2];
    [first addSubview:_markViewFif2];
    [first addSubview:_markViewSix2];
    
    _markViewFri3 = [[UIImageView alloc] init];
    _markViewSec3 = [[UIImageView alloc] init];
    _markViewThr3 = [[UIImageView alloc] init];
    _markViewFou3 = [[UIImageView alloc] init];
    _markViewFif3 = [[UIImageView alloc] init];
    _markViewSix3 = [[UIImageView alloc] init];
    
    [first addSubview:_markViewFri3];
    [first addSubview:_markViewSec3];
    [first addSubview:_markViewThr3];
    [first addSubview:_markViewFou3];
    [first addSubview:_markViewFif3];
    [first addSubview:_markViewSix3];

    
    [self loadSelfData];
}

-(void)loadSelfData{
    NSString *examine_state = [userDefaults objectForKey:@"examine_state"];
    switch ([examine_state integerValue]) {
        case 0:{
            _cheakStyle.frame = CGRectMake(WScale(2.7), HScale(4.5), WScale(26.1), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"资料审核中"];
        }break;
        case 1:{
            _cheakStyle.image = [UIImage imageNamed:@""];
        }break;
        case 2:{
            _cheakStyle.frame = CGRectMake(WScale(2.7), HScale(4.5), WScale(26.7), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"请更换封面"];
        }break;
        case 3:{
            _cheakStyle.frame = CGRectMake(WScale(2.7), HScale(4.5), WScale(26.7), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"封面不合法"];
        }break;
            
        default:
            break;
    }
    
    
    _readNum.text = [NSString stringWithFormat:@" %@",[userDefaults objectForKey:@"access_amount"]];
    
    _sexLabel.frame = CGRectMake(WScale(2.9) + ScreenWidth * 0.013, HScale(47.1), ScreenWidth * 0.03, ScreenHeight * 0.027);
    _sexLabel.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"gender"]];

    _sexLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _sexLabel.textColor = [UIColor whiteColor];
    [_sexLabel sizeToFit];
    _backGroundImageOne.frame = CGRectMake(WScale(2.9)  ,HScale(47.1)-ScreenHeight * 0.001, _sexLabel.frame.size.width + ScreenWidth * 0.013 * 2, _sexLabel.frame.size.height + ScreenHeight * 0.001 * 2);
    
    
    //CGRectMake(WScale(2.9) - ScreenWidth * 0.013, HScale(47.1) - ScreenHeight * 0.001, _sexLabel.frame.size.width + ScreenWidth * 0.013 * 2, _sexLabel.frame.size.height + ScreenHeight * 0.001 * 2);
    
    _ageLabel.frame = CGRectMake(_sexLabel.frame.origin.x + _sexLabel.frame.size.width + ScreenWidth * 0.029+ ScreenWidth * 0.024, HScale(47.1), ScreenWidth * 0.03, ScreenHeight * 0.027);
    _ageLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"year_label"]];
    _ageLabel.textColor = [UIColor whiteColor];
    _ageLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_ageLabel sizeToFit];
    _backGroundImageTow.frame = CGRectMake(_ageLabel.frame.origin.x - ScreenWidth * 0.013, HScale(47.1) - ScreenHeight * 0.001, _ageLabel.frame.size.width + ScreenWidth * 0.013 * 2, _ageLabel.frame.size.height + ScreenHeight * 0.001 * 2);

    _numGan.frame = CGRectMake(_ageLabel.frame.origin.x + _ageLabel.frame.size.width + ScreenWidth * 0.029+ ScreenWidth * 0.024, HScale(47.1), ScreenWidth * 0.03, ScreenHeight * 0.027);
    _numGan.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _numGan.textColor = [UIColor whiteColor];
    _numGan.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"pole_number"]];
    [_numGan sizeToFit];
    _backGroundImageThree.frame = CGRectMake(_numGan.frame.origin.x - ScreenWidth * 0.013, HScale(47.1) - ScreenHeight * 0.001, _numGan.frame.size.width + ScreenWidth * 0.013 * 2, _numGan.frame.size.height + ScreenHeight * 0.001 * 2);

    _address.frame = CGRectMake(WScale(2.9) + ScreenWidth * 0.013,HScale(50.7), ScreenWidth * 0.04, ScreenHeight * 0.024);
    _address.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _address.textColor = [UIColor whiteColor];
    
    if ([[userDefaults objectForKey:@"province"] isEqualToString:[userDefaults objectForKey:@"city"]]) {
         _address.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"city"]];
    }else{
         _address.text = [NSString stringWithFormat:@"%@ %@",[userDefaults objectForKey:@"province"],[userDefaults objectForKey:@"city"]];
    }
    [_address sizeToFit];
    _backGroundImageFour.frame = CGRectMake(WScale(2.9)  ,HScale(50.7)-ScreenHeight * 0.001, _address.frame.size.width + ScreenWidth * 0.013 * 2, _address.frame.size.height + ScreenHeight * 0.001 * 2);

    _persion.frame = CGRectMake(_address.frame.origin.x+_address.frame.size.width + ScreenWidth * 0.029+ ScreenWidth * 0.024, HScale(50.7), ScreenWidth * 0.04, ScreenHeight * 0.024);
    _persion.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"work_fu"]];
    _persion.textColor = [UIColor whiteColor];
    _persion.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_persion sizeToFit];
    _backGroundImageFive.frame = CGRectMake(_persion.frame.origin.x - ScreenWidth * 0.013, HScale(50.7) - ScreenHeight * 0.001, _persion.frame.size.width + ScreenWidth * 0.013 * 2, _persion.frame.size.height + ScreenHeight * 0.001 * 2);
    
    
    NSString *markStr1 = [NSString string];
    NSString *markStr3 = [NSString string];
    NSString *markStr2 = [NSString string];
    NSString *markStr4 = [NSString string];
    NSString *markStr5 = [NSString string];
    NSString *markStr6 = [NSString string];
    NSLog(@"%@",[userDefaults objectForKey:@"label"]);
    NSMutableArray *lableArry = [NSMutableArray array];
    if ([[userDefaults objectForKey:@"label"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *mark_dic in [userDefaults objectForKey:@"label"]) {
            NSString *mark_label = [mark_dic objectForKey:@"label_content"];
            [lableArry addObject:mark_label];
        }
    }
    _markViewFri.hidden = YES;
    _markViewSec.hidden = YES;
    _markViewThr.hidden = YES;
    _markViewFou.hidden = YES;
    _markViewFif.hidden = YES;
    _markViewSix.hidden = YES;
    
    _markViewFri1.hidden = YES;
    _markViewSec1.hidden = YES;
    _markViewThr1.hidden = YES;
    _markViewFou1.hidden = YES;
    _markViewFif1.hidden = YES;
    _markViewSix1.hidden = YES;
    
    _markViewFri2.hidden = YES;
    _markViewSec2.hidden = YES;
    _markViewThr2.hidden = YES;
    _markViewFou2.hidden = YES;
    _markViewFif2.hidden = YES;
    _markViewSix2.hidden = YES;
    
    _markViewFri3.hidden = YES;
    _markViewSec3.hidden = YES;
    _markViewThr3.hidden = YES;
    _markViewFou3.hidden = YES;
    _markViewFif3.hidden = YES;
    _markViewSix3.hidden = YES;
    
    
    switch (lableArry.count) {
        case 0:{
            
        }break;
        case 1:{
            markStr3 = lableArry[0];
            _markViewThr.hidden = NO;
            _markViewThr1.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewThr3.hidden = NO;
        }break;
        case 2:{
            markStr3 = lableArry[0];
            markStr2 = lableArry[1];
            _markViewSec.hidden = NO;
            _markViewThr.hidden = NO;
            
            _markViewSec1.hidden = NO;
            _markViewThr1.hidden = NO;
            
            _markViewSec2.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewThr3.hidden = NO;
            _markViewSec3.hidden = NO;
            
        }break;
        case 3:{
            markStr3 = lableArry[0];
            markStr2 = lableArry[1];
            markStr4 = lableArry[2];
            _markViewSec.hidden = NO;
            _markViewThr.hidden = NO;
            _markViewFou.hidden = NO;
            
            _markViewSec1.hidden = NO;
            _markViewThr1.hidden = NO;
            _markViewFou1.hidden = NO;
            
            _markViewSec2.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewFou2.hidden = NO;
            
            _markViewFou3.hidden = NO;
            _markViewSec3.hidden = NO;
            _markViewThr3.hidden = NO;
            
        }break;
        case 4:{
            markStr3 = lableArry[0];
            markStr2 = lableArry[1];
            markStr4 = lableArry[2];
            markStr1 = lableArry[3];
            _markViewFri.hidden = NO;
            _markViewSec.hidden = NO;
            _markViewThr.hidden = NO;
            _markViewFou.hidden = NO;
            
            _markViewFri1.hidden = NO;
            _markViewSec1.hidden = NO;
            _markViewThr1.hidden = NO;
            _markViewFou1.hidden = NO;
            _markViewFri2.hidden = NO;
            _markViewSec2.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewFou2.hidden = NO;
            
            _markViewFri3.hidden = NO;
            _markViewSec3.hidden = NO;
            _markViewThr3.hidden = NO;
            _markViewFou3.hidden = NO;

        }break;
            
        case 5:{
            markStr3 = lableArry[0];
            markStr2 = lableArry[1];
            markStr4 = lableArry[2];
            markStr1 = lableArry[3];
            markStr5 = lableArry[4];
            _markViewSec.hidden = NO;
            _markViewThr.hidden = NO;
            _markViewFou.hidden = NO;
            _markViewFri.hidden = NO;

            _markViewFri1.hidden = NO;
            _markViewSec1.hidden = NO;
            _markViewThr1.hidden = NO;
            _markViewFou1.hidden = NO;
            
            _markViewFri2.hidden = NO;
            _markViewSec2.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewFou2.hidden = NO;
            
            _markViewSix.hidden = NO;
            _markViewSix1.hidden = NO;
            _markViewSix2.hidden = NO;
            
            _markViewFri3.hidden = NO;
            _markViewSec3.hidden = NO;
            _markViewThr3.hidden = NO;
            _markViewFou3.hidden = NO;
            _markViewSix3.hidden = NO;
        }break;
        case 6:{
            markStr3 = lableArry[0];
            markStr2 = lableArry[1];
            markStr4 = lableArry[2];
            markStr1 = lableArry[3];
            markStr5 = lableArry[4];
            markStr6 = lableArry[5];
            _markViewSec.hidden = NO;
            _markViewThr.hidden = NO;
            _markViewFou.hidden = NO;
            _markViewFri.hidden = NO;
            _markViewFri1.hidden = NO;
            _markViewSec1.hidden = NO;
            _markViewThr1.hidden = NO;
            _markViewFou1.hidden = NO;
            _markViewFri2.hidden = NO;
            _markViewSec2.hidden = NO;
            _markViewThr2.hidden = NO;
            _markViewFou2.hidden = NO;
            
            _markViewFif.hidden = NO;
            _markViewFif1.hidden = NO;
            _markViewFif2.hidden = NO;
            _markViewSix.hidden = NO;
            _markViewSix1.hidden = NO;
            _markViewSix2.hidden = NO;
            
            _markViewFri3.hidden = NO;
            _markViewSec3.hidden = NO;
            _markViewThr3.hidden = NO;
            _markViewFou3.hidden = NO;
            _markViewFif3.hidden = NO;
            _markViewSix3.hidden = NO;
        }
            
        default:
            break;
    }
    
//  左边标签
    _markLabelFri.text = markStr1;
    _markLabelFri.frame = CGRectMake(WScale(7.7), HScale(19.6), 10, HScale(2.4));
    _markLabelFri.textColor = [UIColor whiteColor];
    _markLabelFri.backgroundColor = [UIColor clearColor];
    _markLabelFri.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    [_markLabelFri sizeToFit];
    _markViewFri.frame = CGRectMake(WScale(7.4), HScale(18.7), _markLabelFri.frame.size.width+WScale(3.2), HScale(4.2));
    _markViewFri.image = [UIImage imageNamed:@"标签1"];
    _markViewFri1.frame = CGRectMake(_markViewFri.frame.origin.x+_markViewFri.frame.size.width, HScale(18.7), WScale(5.1), HScale(4.2));
    _markViewFri1.image = [UIImage imageNamed:@"标签2"];
    _markViewFri2.frame = CGRectMake(_markViewFri1.frame.origin.x+_markViewFri1.frame.size.width + HScale(0.6), HScale(19.9), HScale(1.8), HScale(1.8));
    _markViewFri2.image = [UIImage imageNamed:@"标签3"];
    
    _markViewFri3.frame = CGRectMake(WScale(6.1), HScale(18.7), WScale(1.3), HScale(4.2));
    _markViewFri3.image = [UIImage imageNamed:@"标签1s"];
    
    
    _markLabelSec.text = markStr2;
    _markLabelSec.frame = CGRectMake(WScale(7.7), HScale(25.7), 10, HScale(2.4));
    _markLabelSec.textColor = [UIColor whiteColor];
    _markLabelSec.backgroundColor = [UIColor clearColor];
    _markLabelSec.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    [_markLabelSec sizeToFit];
    _markViewSec.frame = CGRectMake(WScale(7.4), HScale(24.8), _markLabelSec.frame.size.width+WScale(3.2), HScale(4.2));
    _markViewSec.image = [UIImage imageNamed:@"标签1"];
    
    UILabel *testLable = [[UILabel alloc] init];
    testLable.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    
    _markViewSec1.frame = CGRectMake(_markViewFri.frame.origin.x+_markViewSec.frame.size.width, HScale(24.8), WScale(5.1), HScale(4.2));
    
    _markViewSec1.image = [UIImage imageNamed:@"标签2"];
    
    _markViewSec2.frame = CGRectMake(_markViewSec1.frame.origin.x+_markViewSec1.frame.size.width + HScale(0.6), HScale(26), HScale(1.8), HScale(1.8));
    
    _markViewSec2.image = [UIImage imageNamed:@"标签3"];
    _markViewSec3.frame =  CGRectMake(WScale(6.1), HScale(24.8), WScale(1.3), HScale(4.2));
    _markViewSec3.image = [UIImage imageNamed:@"标签1s"];
    
    
    
    _markLabelFif.text = markStr6;
    _markLabelFif.frame = CGRectMake(WScale(7.7), HScale(31.8), 10, HScale(2.4));
    _markLabelFif.textColor = [UIColor whiteColor];
    _markLabelFif.backgroundColor = [UIColor clearColor];
    _markLabelFif.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    [_markLabelFif sizeToFit];
    _markViewFif.frame = CGRectMake(WScale(7.4), HScale(30.9), _markLabelFif.frame.size.width+WScale(3.2), HScale(4.2));
    _markViewFif.image = [UIImage imageNamed:@"标签1"];
    
    
    _markViewFif1.frame = CGRectMake(_markViewFif.frame.origin.x+_markViewFif.frame.size.width, HScale(30.9), WScale(5.1), HScale(4.2));
    
    _markViewFif1.image = [UIImage imageNamed:@"标签2"];
    
    
    _markViewFif2.frame = CGRectMake(_markViewFif1.frame.origin.x+_markViewFif1.frame.size.width + HScale(0.6), HScale(32.1), HScale(1.8), HScale(1.8));
    
    _markViewFif2.image = [UIImage imageNamed:@"标签3"];
    
    _markViewFif3.frame =  CGRectMake(WScale(6.1), HScale(30.9), WScale(1.3), HScale(4.2));
    _markViewFif3.image = [UIImage imageNamed:@"标签1s"];
    
    
    
    _markLabelThr.text = markStr3;
    testLable.text = _markLabelThr.text;
    [testLable sizeToFit];
    
//    右边标签
    _markLabelThr.frame = CGRectMake(WScale(93.9) - testLable.frame.size.width, HScale(13.5), testLable.frame.size.width, HScale(2.4));
    _markLabelThr.textColor = [UIColor whiteColor];
    _markLabelThr.backgroundColor = [UIColor clearColor];
    _markLabelThr.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    _markLabelThr.textAlignment = NSTextAlignmentRight;
    
    _markViewThr.frame = CGRectMake(WScale(93.9) - WScale(1.6)-testLable.frame.size.width, HScale(12.7), testLable.frame.size.width+WScale(1.9), HScale(4.2));
    _markViewThr.image = [UIImage imageNamed:@"标签1"];
    
    _markViewThr1.frame = CGRectMake(_markViewThr.frame.origin.x-WScale(5.1), HScale(12.7), WScale(5.1), HScale(4.2));
    
    _markViewThr1.image = [UIImage imageNamed:@"标签Left2"];
    
    _markViewThr2.frame = CGRectMake(_markViewThr1.frame.origin.x - HScale(1.8) - WScale(0.6), HScale(13.9),  HScale(1.8), HScale(1.8));
    
    _markViewThr2.image = [UIImage imageNamed:@"标签3"];
    
    _markViewThr3.frame =  CGRectMake(_markViewThr.frame.origin.x+_markViewThr.frame.size.width, HScale(12.7), WScale(1.3), HScale(4.2));
    _markViewThr3.image = [UIImage imageNamed:@"标签Left1s"];
    
    
    _markLabelFou.text = markStr4;
    testLable.text = _markLabelFou.text;
    [testLable sizeToFit];
    
    
    _markLabelFou.frame = CGRectMake(WScale(93.9) - testLable.frame.size.width, HScale(19.6), testLable.frame.size.width, HScale(2.4));
    _markLabelFou.textColor = [UIColor whiteColor];
    _markLabelFou.backgroundColor = [UIColor clearColor];
    _markLabelFou.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    _markLabelFou.textAlignment = NSTextAlignmentRight;
    
    _markViewFou.frame = CGRectMake(WScale(93.9) - WScale(1.6)-testLable.frame.size.width, HScale(18.7), testLable.frame.size.width+WScale(3.2), HScale(4.2));
    _markViewFou.image = [UIImage imageNamed:@"标签1"];
    
    
    _markViewFou1.frame = CGRectMake(_markViewFou.frame.origin.x - WScale(5.1), HScale(18.7), WScale(5.1), HScale(4.2));
    
    _markViewFou1.image = [UIImage imageNamed:@"标签Left2"];
    
    _markViewFou2.frame = CGRectMake(_markViewFou1.frame.origin.x - HScale(1.8) - WScale(0.6) , HScale(19.9),  HScale(1.8), HScale(1.8));
    
    _markViewFou2.image = [UIImage imageNamed:@"标签3"];
    
    _markViewFou3.frame =  CGRectMake(_markViewFou.frame.origin.x+_markViewFou.frame.size.width, HScale(18.7), WScale(1.3), HScale(4.2));
    _markViewFou3.image = [UIImage imageNamed:@"标签Left1s"];
    
    
    
    _markLabelSix.text = markStr5;
    testLable.text = _markLabelSix.text;
    [testLable sizeToFit];
    
    
    _markLabelSix.frame = CGRectMake(WScale(93.9) - testLable.frame.size.width, HScale(25.7), testLable.frame.size.width, HScale(2.4));
    _markLabelSix.textColor = [UIColor whiteColor];
    _markLabelSix.backgroundColor = [UIColor clearColor];
    _markLabelSix.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    _markLabelSix.textAlignment = NSTextAlignmentRight;
    
    _markViewSix.frame = CGRectMake(WScale(93.9) - WScale(1.6)-testLable.frame.size.width, HScale(24.7), testLable.frame.size.width+WScale(3.2), HScale(4.2));
    _markViewSix.image = [UIImage imageNamed:@"标签1"];
    
    
    _markViewSix1.frame = CGRectMake(_markViewSix.frame.origin.x - WScale(5.1), HScale(24.7), WScale(5.1), HScale(4.2));
    
    _markViewSix1.image = [UIImage imageNamed:@"标签Left2"];
    
    _markViewSix2.frame = CGRectMake(_markViewSix1.frame.origin.x - HScale(1.8) - WScale(0.6) , HScale(25.9),  HScale(1.8), HScale(1.8));
    _markViewSix2.image = [UIImage imageNamed:@"标签3"];
    
    _markViewSix3.frame =  CGRectMake(_markViewSix.frame.origin.x+_markViewSix.frame.size.width, HScale(24.7), WScale(1.3), HScale(4.2));
    _markViewSix3.image = [UIImage imageNamed:@"标签Left1s"];
}




#pragma mark - 获取个人信息
-(void)setViewData{
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];

    NSDictionary *dataDict =  @{
                                @"PoloNum":@"洞号",
                                @"Par":@"标准杆",
                                @"Players":@[
                                            @{
                                                @"nick_name":@"球员昵称",
                                                @"name_id":@"球员id",
                                                @"Num":@"杆数"
                                                },
                                            @{
                                                @"nick_name":@"球员昵称",
                                                @"name_id":@"球员id",
                                                @"Num":@"杆数"
                                                },
                                            ]
                                };
    
    

    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if ([jsonData length] > 0){
       jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
    }

    
    
    NSDictionary *dict = [NSDictionary new];
    dict = @{
             @"name_id":userDefaultId
             };
    
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_name_id",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            NSDictionary *dic = data;
            NSArray *FristinterviewArr = [NSArray array];
            FristinterviewArr = dic[@"data"];
            NSArray *dataArry = [NSArray array];
            dataArry = dic[@"label"];
            if (dataArry.count>0) {
                
                [userDefaults setValue:dataArry forKey:@"label"];
                
            }
            if (FristinterviewArr.count==0) {
                return ;
            }
            NSDictionary *temp = FristinterviewArr[0];
            id interViewArr = [temp objectForKey:@"interview"];
            
            if (![interViewArr isKindOfClass:[NSString class]]) {
                
            [userDefaults setValue:interViewArr[0] forKey:@"interviewDict"];
            NSLog(@"%@",[userDefaults objectForKey:@"interviewDict"]);
            }
            
            [userDefaults setValue:[temp objectForKey:@"access_amount"] forKey:@"access_amount"];
            [userDefaults setValue:[temp objectForKey:@"picture_id"] forKey:@"pictureid"];
            [userDefaults setValue:[temp objectForKey:@"gender"] forKey:@"gender"];
            
            [userDefaults setValue:[temp objectForKey:@"province"] forKey:@"province"];
            
            [userDefaults setValue:[temp objectForKey:@"label_content"] forKey:@"label_content"];
            
            
            [userDefaults setValue:[temp objectForKey:@"access_amount"] forKey:@"access_amount"];
            
            [userDefaults setValue:[temp objectForKey:@"picture_url"] forKey:@"picture_url"];
            
            [userDefaults setValue:[temp objectForKey:@"pole_number"] forKey:@"pole_number"];
            
            [userDefaults setValue:[temp objectForKey:@"follow_number"] forKey:@"follow_number"];
            [userDefaults setValue:[temp objectForKey:@"message_number"] forKey:@"message_number"];
            [userDefaults setValue:[temp objectForKey:@"attention_number"] forKey:@"attention_number"];
            [userDefaults setValue:[temp objectForKey:@"label_content"] forKey:@"year_label"];
           
            [userDefaults setValue:[temp objectForKey:@"city"] forKey:@"city"];
            
            [userDefaults setValue:[temp objectForKey:@"nickname"] forKey:@"nickname"];
            
            [userDefaults setValue:[temp objectForKey:@"work_content"] forKey:@"work_fu"];
            
            [userDefaults setValue:[temp objectForKey:@"siignature"] forKey:@"siignature"];
            NSLog(@"%@",[userDefaults objectForKey:@"year_label"]);
            
            
            [userDefaults setValue:[temp objectForKey:@"examine_state"] forKey:@"examine_state"];
            
            _nickName.text = [userDefaults objectForKey:@"nickname"];
            _address.text = [userDefaults objectForKey:@"city"];
            [_backImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"picture_url"]] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
            _DescLabel.text = [temp objectForKey:@"siignature"];
            _DescLabel.numberOfLines = 2;
            _address.text = [temp objectForKey:@"province"];
            _numGan.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"pole_number"]];
            
//            _pageView.text = [NSString stringWithFormat:@"访问量%@次",[temp objectForKey:@"access_amount"]];
            
            _address.text = [NSString stringWithFormat:@"%@ %@",[userDefaults objectForKey:@"province"],[userDefaults objectForKey:@"city"]];
            [_tableView reloadData];
            [self loadSelfData];
            [_sexLabel sizeToFit];
            [_ageLabel sizeToFit];
            [_persion sizeToFit];
            [_address sizeToFit];
            [_numGan sizeToFit];
            
        }
    }];


}



#pragma ----- UIScrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _coverView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:(scrollView.contentOffset.x / (scrollView.frame.size.width * 2))];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/ScreenWidth;
    if (page == 2) {
        _page.currentPage = 0;
        _scrollView.contentOffset = CGPointZero;
    }else{
        _page.currentPage = page;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/ScreenWidth;
    if (page == 2) {
        _page.currentPage = 0;
        _scrollView.contentOffset = CGPointZero;
    }
}
#pragma mark ---- UITableViewDataSource
//返回多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dataDic = [userDefaults objectForKey:@"interviewDict"];
//    id interview_state = [dataDic objectForKey:@"interview_state"];
    return 1;
//    if ([interview_state isEqualToString:@"1"]) {
//        return 1;
//    }else{
//        if (section == 0) {
//            return 0;
//        }else{
//        return 1;
//        }
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [userDefaults objectForKey:@"interviewDict"];

    if (indexPath.section == 0) {
        
        Self_Zhuan_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zhuanfang];
        if (cell == nil) {
            cell = [[Self_Zhuan_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhuanfang];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell relayOutDataAZhuanfangWithTitle:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"interview_title"]]];
        cell.zhaunfang.hidden = NO;
        cell.image.hidden = NO;
        if (![dataDic objectForKey:@"interview_title"]) {
            cell.zhaunfang.hidden = YES;
            cell.image.hidden = YES;
            [cell relayOutDataAZhuanfangWithTitle:@"快来成为达人吧!"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消cell的高亮状态
        
        return cell;
    }
    Self_Photo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photo];
    if (cell == nil) {
        cell = [[Self_Photo_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photo];
    }
    
    UICollectionView *collectionview = cell.imageCollection;
    collectionview.delegate = self;
    cell.PhotoArr =self.PhotoArr;
    [collectionview reloadData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消cell的高亮状态
    
    return cell;
    
}

#pragma mark ---- UITableViewDelegate
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return ScreenHeight * 0.072;
    }
    return ScreenHeight * 0.187;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = [userDefaults objectForKey:@"interviewDict"];
    if (indexPath.row == 0) {
        if (![dataDic objectForKey:@"interview_title"]) {
            UserDetailViewController *uvc = [[UserDetailViewController alloc] init];
        uvc.urlStr = @"https://mp.weixin.qq.com/s?__biz=MzIwMDA5MTQ2NA==&mid=404508847&idx=1&sn=b2314801cb73b4b55604096123536eeb&scene=1&srcid=0421EOqXwMNfdGdrpYhmvUVQ&key=b28b03434249256b19f3efca24c833481ab9e66d8e1e9a935fd9731a4eab1a54cf506b48e8c63dddf8f314d9f0dfaccd&ascene=0&uin=MTU2OTMwMzQ2MA%3D%3D&devicetype=iMac16%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=j8xY5wuBLTtUXqWdUm1INU0Ffa28jEYx2JdF1y5k6HIo45q4J3ewpH3mCg9NopHc";
        
        uvc.titleStr = @"快来成为高尔夫达人吧!";
            [self.navigationController pushViewController:uvc animated:YES];
        }else{
        NewZhuanFangViewController *zhuanfang = [[NewZhuanFangViewController alloc] init];
        NSLog(@"%@",userDefaultId);
        
        NSLog(@"%@",[userDefaults objectForKey:@"interviewDict"]);
        
        id dict = [userDefaults objectForKey:@"interviewDict"];
        
            zhuanfang.interviewerId = userDefaultId;
            zhuanfang.interviewerName = [userDefaults objectForKey:@"nickname"];
            zhuanfang.interviewId = [dict objectForKey:@"interview_id"];
            zhuanfang.hidesBottomBarWhenPushed = YES;
            [zhuanfang setBlock:^(BOOL isView) {
                
            }];
            [self.navigationController pushViewController:zhuanfang animated:YES];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
#pragma mark ---- 自定义段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.frame = CGRectMake(0, HScale(73), ScreenWidth, HScale(7));
    view.backgroundColor = GPColor(245, 245, 245);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(7), ScreenWidth, 1)];
    line.backgroundColor = GPColor(223, 224, 225);
    [view addSubview:line];
    
    
    if (section == 1) {
        
        NSArray *titleArr = @[@"相册",@"粉丝",@"关注",@"留言"];
        NSMutableArray *numArry = [NSMutableArray array];
        
        [numArry addObject:[NSString stringWithFormat:@"%lu",(unsigned long)_PhotoArr.count]];
        if ([userDefaults objectForKey:@"follow_number"]) {
            [numArry addObject:[userDefaults objectForKey:@"follow_number"]];
        }else{
            [numArry addObject:@"0"];

        }
        if ([userDefaults objectForKey:@"attention_number"]) {
            [numArry addObject:[userDefaults objectForKey:@"attention_number"]];
        }else{
            [numArry addObject:@"0"];
        }
        if ([userDefaults objectForKey:@"message_number"]) {
            [numArry addObject:[userDefaults objectForKey:@"message_number"]];
        }else{
            [numArry addObject:@"0"];


        }

            for (int i = 0; i<4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor whiteColor];
            btn.tag = 111*(i+1);
            [btn addTarget:self action:@selector(shlClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(ScreenWidth*i/4, 0, ScreenWidth, HScale(7));
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/4, HScale(3.7), ScreenWidth/4, HScale(3))];
            titleLabel.text = titleArr[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
            titleLabel.textColor = [UIColor colorWithRed:142/255.0f green:142/255.0f blue:142/255.0f alpha:1];
            
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/4, HScale(0.9), ScreenWidth/4, HScale(3))];
            numLabel.text = numArry[i];
            numLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(14)];
            numLabel.textAlignment = NSTextAlignmentCenter;
            
            
            [view addSubview:btn];
            [view addSubview:numLabel];
            [view addSubview:titleLabel];
        }


    }
    return view;
}

-(void)shlClick:(UIButton *)btn{
    switch (btn.tag) {
        case 111:{
            [self pressPhoto];
        }break;
        case 222:{
            [self pressFans];
        }break;
        case 333:{
            Self_GuanZhuViewController *svc = [[Self_GuanZhuViewController alloc] init];
            svc.name_id = userDefaultId;
            svc.login_state = 1;
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
            
        }break;
        case 444:{
            [self pressLiuyan];
        }break;
            
        default:
            break;
    }
    
}
-(void)guanZhuNum{
    DownLoadDataSource *load = [[DownLoadDataSource alloc]init];
    [load downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_number",urlHeader120] parameters:@{@"name_id":userDefaultId} complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data[@"data"][0];
            _guanNum = [dic objectForKey:@"count(1)"];
            [_tableView reloadData];
        }
    }];
}
-(void)pressPhoto{
    Self_P_ViewController *photo = [[Self_P_ViewController alloc]initWithNameID:userDefaultId];
    
    [self presentViewController:photo animated:NO completion:^{
        
    }];

}
-(void)pressFans{
    
    Self_Fans_ViewController *fans = [[Self_Fans_ViewController alloc]init];
    fans.hidesBottomBarWhenPushed = YES;
    fans.login_Id = @"1";
    fans.name_id = userDefaultId;

    [self.navigationController pushViewController:fans animated:YES];
}

-(void)pressLiuyan{
    Self_LY_ViewController *liuyan = [[Self_LY_ViewController alloc]init];
    liuyan.nickName = [userDefaults objectForKey:@"nickname"];
    liuyan.nameID = userDefaultId;
    liuyan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liuyan animated:YES];
}
#pragma mark - 修改个人资料
-(void)pressesEdit{
    
    Edit_ViewController *edit = [[Edit_ViewController alloc]init];
    edit.logIntype = @"1";
    edit.nameid = userDefaultId;
    edit.phoneNumber = [userDefaults objectForKey:@"phone"];
    [self presentViewController:edit animated:YES completion:nil];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return ScreenHeight * 0.084;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return HScale(1.5);
        //ScreenHeight - ScreenWidth - HScale(6.4) - HScale(7.2) - HScale(18.7) - 44;
    } else {
        return 0;
    }

}
#pragma mark - 上传图片界面跳转

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        AddSelfPhotosViewController *avc = [[AddSelfPhotosViewController alloc] init];
        avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:avc animated:YES];
    }else{
        NSMutableArray *dataArry = [NSMutableArray array];
 
        [dataArry insertObject:_AllPhotoArr[indexPath.row-1] atIndex:0];

        JZAlbumViewController *jvc = [[JZAlbumViewController alloc] init];
        jvc.currentIndex =0;//这个参数表示当前图片的index，默认是0
        jvc.dateArr = self.PhotoDate;
        jvc.imgId = self.PhotoId;
        jvc.descArr = self.PhotoDesc;
        jvc.imgArr = self.PhotoArr;//图片数组，可以是url，也可以是UIImage
        jvc.currentIndex = indexPath.row-1;
        jvc.nameId = userDefaultId;
        [self presentViewController:jvc animated:YES completion:nil];
    }
    
}

@end
