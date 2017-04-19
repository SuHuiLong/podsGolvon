//
//  GroupStatisticsViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/10/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "GroupStatisticsViewController.h"
#import "DrawRectLineView.h"
#import "WXApi.h"
#import "ImageTool.h"
#import "WeiboSDK.h"
#import "ScorRecordViewController.h"
#import "PublishPhotoViewController.h"
#import <Photos/Photos.h>
#import<AssetsLibrary/AssetsLibrary.h>

@interface GroupStatisticsViewController ()<UIAlertViewDelegate>{
    /*暂时显示距标准杆和总杆;
        0 默认，
        1 显示正常
        2 显示距标准杆
     */
    NSInteger _grossViewClick;
    /*
     0 默认不显示
     1 周最佳
     2 月最佳
     3 年最佳
     */
    NSInteger _alertBestScoreView;
}
@property(nonatomic,copy)UIScrollView  *mainScrollView;
//球员选T背景
@property(nonatomic,copy)UIView  *slectPlayerView;
//选T按钮
@property(nonatomic,strong)UIButton *SlectTBtn;
//选T背景
@property(nonatomic,copy)UIView  *grayBackView;
//分享背景
@property(nonatomic,copy)UIView  *shareButtonView;
//选T选中球员tag值
@property(nonatomic,assign)NSInteger  selectTag;
//球员T
@property(nonatomic,strong)NSMutableArray  *playerTArray;
//分享按钮背景
@property(nonatomic,copy)UIView *shareOtherView;
//分享图片背景
@property(nonatomic,copy)UIView  *shareBackView;
//慈善金额数组
@property(nonatomic,copy)NSArray  *moneyArray;
//确认成绩提交
@property(nonatomic,copy)GolvonAlertView *alertView;
//加载提示
@property(nonatomic,copy)MBProgressHUD *HUD;
//用户头像
@property(nonatomic,copy)UIImage *headerImage;
//时间选择器
@property(nonatomic,strong)UIDatePicker *datePicker;
//比赛开始时间
@property(nonatomic,copy)NSString *startTime;
//确认成绩&&本地保存
@property(nonatomic,copy)UIBarButtonItem *rightBarbutton;
@end

@implementation GroupStatisticsViewController

-(NSDictionary *)dataDict{
    if (_dataDict==nil) {
        _dataDict = [NSDictionary dictionary];
    }
    return _dataDict;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_status==1) {
        [self insertJustGroup];
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self resevNotic];

    // Do any additional setup after loading the view.
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_status == 1) {
        [self quietJustGroup];
    }
}

#pragma mark- 接收自定义推送消息
-(void)resevNotic{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)networkDidReceiveMessage:(NSNotification *)noti{
    NSLog(@"%@",noti);
    id dict = noti.userInfo;
    NSDictionary *extras = [dict objectForKey:@"extras"];
    NSString *PushToStat = [extras objectForKey:@"JPushCode"];
    if ([PushToStat isEqualToString:@"17"]) {
        if (_status!=0) {
            [self reloadTotalData];
        }
    }
    if ([PushToStat isEqualToString:@"6"]) {
        if (_status!=0) {
            [self reloadTotalData];
        }
    }
    
}


#pragma mark - createView
-(void)createView{
    _selectTag = 100;
    [self createNavagationView];
//    [self createContentView];
}


//创建navagation
-(void)createNavagationView{
    
    
    
    self.navigationItem.title = @"记分卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    _rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"确认成绩" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    
    _rightBarbutton.tintColor = localColor;
    if (_status == 0) {
        self.navigationItem.rightBarButtonItem = _rightBarbutton;
    }
}
//加载提示
-(void)createHUD{
    if (_HUD) {
        _HUD.hidden = NO;
    }else{
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HUD.alpha = 0.8;
        _HUD.mode = MBProgressHUDModeIndeterminate;
    }
}

-(void)createContentView{
    //数据 85，162，252
    NSArray *showViewColorArray = @[rgba(252,206,47,1),rgba(252,206,47,1),rgba(237,117,76,1),rgba(85,162,252,1),rgba(245,245,245,1),rgba(245,245,245,1)];
    NSArray *showLabelTextArray = @[@"信天翁",@"老鹰球",@"小鸟球",@"标准杆",@"柏忌",@"双柏忌"];
    NSArray *topArray = @[@"平均推杆",@"标ON",@"标ON率"];
    NSArray *colorName = @[@"黑T",@"金T",@"蓝T",@"白T",@"红T"];
    NSString *isSelect = [_dataDict objectForKey:@"isSelectKey"];
    
    if (_grossViewClick==2) {
        isSelect = @"1";
    }else if(_grossViewClick==1){
        isSelect = @"0";
    }

    NSMutableArray *playerNameArray = [NSMutableArray array];
    NSMutableArray *playerImageArray = [NSMutableArray array];
    NSMutableArray *playerTcolorArray = [NSMutableArray array];
    NSMutableArray *playerNameIdArray = [NSMutableArray array];

    NSArray *playerArray = [_dataDict objectForKey:@"playerArrayKey"];//球员数组
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];
    NSInteger playerSelectIndex = 0;//当前用户所在位置
    for (int i = 0; i<playerArray.count; i++) {
        NSDictionary *playerDict = playerArray[i];
        NSString *nickname = [playerDict objectForKey:@"nickname"];
        NSString *pic = [playerDict objectForKey:@"pic"];
        NSString *nameId = [playerDict objectForKey:@"nameId"];
        NSString *Tcolor = [playerDict objectForKey:@"tcolor"];

        if ([nameId isEqualToString:_nameUid]) {
            playerSelectIndex = i;
        }
        [playerNameArray addObject:nickname];
        [playerImageArray addObject:pic];
        [playerTcolorArray addObject:Tcolor];
        [playerNameIdArray addObject:nameId];
    }
    _playerTArray = playerTcolorArray;
    NSInteger playerNum = playerNameArray.count;

    
    NSMutableArray *PARStandardData = [NSMutableArray arrayWithArray: @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"OUT",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"IN"]];
    NSMutableArray *PARData  =  [NSMutableArray array];
    NSMutableArray *GrossArray = [NSMutableArray array];
    NSMutableArray *PuttersArray = [NSMutableArray array];
    NSMutableArray *DiffrendsArray = [NSMutableArray arrayWithArray:@[@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10"],@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10"],@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10"],@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10"]]];
    
    NSArray *poleNameArray = [_dataDict objectForKey:@"poleOrderArray"];
    
    
    for (int i = 0; i<playerNum; i++) {
        NSMutableArray *oneGrossArray = [NSMutableArray array];
        NSMutableArray *onePuttersArray = [NSMutableArray array];
        for (int j = 0; j<18; j++) {
            
            NSDictionary *poleDict = [_dataDict objectForKey:[NSString stringWithFormat:@"pole%d",j+1]];
            NSString *par = [poleDict objectForKey:@"par"];
            if (i==0) {
                [PARData addObject:par];
            }
            
            NSArray *pArray = [poleDict objectForKey:@"p"];
            NSDictionary *playerDataDict = pArray[i];
            NSString *Gross = [playerDataDict objectForKey:@"r"];
            NSString *Putters = [playerDataDict objectForKey:@"pr"];
            if ([selectArray containsObject:[NSString stringWithFormat:@"%d",j+1]]) {
                [oneGrossArray addObject:Gross];
                [onePuttersArray addObject:Putters];
            }else{
            
                [oneGrossArray addObject:@""];
                [onePuttersArray addObject:@""];
            }
        }
        [GrossArray addObject:oneGrossArray];
        [PuttersArray addObject:onePuttersArray];
    }
    
    NSMutableArray *mTopDataArray = [NSMutableArray array];
    BOOL HOLE_IN_ONE = NO;
    
    for (NSInteger m = 0; m<playerNum; m++) {
        NSMutableArray *palyerGrossArray = [NSMutableArray arrayWithArray:GrossArray[m]];
        NSMutableArray *palyerPuttersArray = [NSMutableArray arrayWithArray:PuttersArray[m]];
        NSMutableArray *palyerDiffrendsArray = [NSMutableArray arrayWithArray:DiffrendsArray[m]];
        NSInteger OUT = 0;
        NSInteger IN = 0;
        NSInteger GrossOUT = 0;
        NSInteger GrossIN = 0;
        NSInteger PuttersOUT = 0;
        NSInteger PuttersIN = 0;
        for (int i = 0; i<9; i++) {
            NSInteger PARDataOUT = [PARData[i] integerValue];
            NSInteger GrossArrayOUT = [palyerGrossArray[i] integerValue];
            NSInteger PuttersArrayOUT = [palyerPuttersArray[i] integerValue];
            
            
            
            NSInteger PARDataIN = [PARData[i+9] integerValue];
            NSInteger GrossArrayIN = [palyerGrossArray[i+9] integerValue];
            NSInteger PuttersArrayIN = [palyerPuttersArray[i+9] integerValue];
            
            NSString *DiffrendsArrayOUT = [NSString stringWithFormat:@"%ld",(long)([palyerGrossArray[i] integerValue] - [PARData[i] integerValue])];
            NSString *DiffrendsArrayIN = [NSString stringWithFormat:@"%ld",(long)([palyerGrossArray[i+9] integerValue] - [PARData[i+9] integerValue])];
            OUT = OUT + PARDataOUT;
            GrossOUT = GrossOUT + GrossArrayOUT;
            if (PuttersArrayOUT>0) {
                PuttersOUT = PuttersOUT + PuttersArrayOUT;
            }

            IN = IN + PARDataIN;
            GrossIN = GrossIN + GrossArrayIN;
            if (PuttersArrayIN>0) {
                PuttersIN = PuttersIN + PuttersArrayIN;
            }
            if (PuttersArrayOUT<0) {
                PuttersArrayOUT = 0;
            }
            if (PuttersArrayIN<0) {
                PuttersArrayIN = 0;
            }

            [palyerDiffrendsArray replaceObjectAtIndex:i withObject:DiffrendsArrayOUT];
            [palyerDiffrendsArray replaceObjectAtIndex:i+10 withObject:DiffrendsArrayIN];
            
            if (GrossArrayIN==1||GrossArrayOUT==1) {
                HOLE_IN_ONE = YES;
            }
            
        }
        
        NSInteger averagePutters = 0;
        NSInteger markerNO = 0;
        NSInteger totalUnNo = 0;
        
        for (int i = 0; i<18; i++) {
            
            averagePutters  =  averagePutters +[palyerPuttersArray[i] integerValue];
            NSInteger puttersDifference = [GrossArray[m][i] integerValue] - [PuttersArray[m][i] integerValue];//总杆与推杆的差
            NSInteger parDifference = [PARData[i] integerValue]-2;//标准杆减2
            //        if ([PuttersArray[i] integerValue]<=2) {
            if ([PuttersArray[m][i] integerValue]<=0) {
                totalUnNo++;
            }
            NSLog(@"%ld====%ld",puttersDifference,parDifference);
            if (puttersDifference<=parDifference) {
                markerNO = markerNO + 1;
            }
        }
        
        CGFloat averagePuttersFloat = [[NSString stringWithFormat:@"%ld",averagePutters] floatValue]/18;
        NSString *averagePuttersStr =[NSString stringWithFormat:@"%.2f",averagePuttersFloat];
        NSString *markerNOStr = [NSString stringWithFormat:@"%ld",(long)markerNO];
        CGFloat markNOFloat = [markerNOStr floatValue]/18;
        NSString   *markNOPercentage = [self Rounding:markNOFloat afterPoint:2];
        
        markNOPercentage = [NSString stringWithFormat:@"%0.0f%@",[markNOPercentage floatValue]*100,@"%"];
        
        
        NSString *nameId = playerNameIdArray[m];
        NSArray *topDataArray = [NSArray arrayWithObjects:averagePuttersStr,markerNOStr,markNOPercentage,nameId, nil];
        if (totalUnNo>2) {
            topDataArray = [NSArray array];
        }
        
        if (m==playerNum-1) {
            [PARData insertObject:[NSString stringWithFormat:@"%ld",OUT] atIndex:9];
            [PARData insertObject:[NSString stringWithFormat:@"%ld",IN] atIndex:19];
        }
        [palyerGrossArray insertObject:[NSString stringWithFormat:@"%ld",GrossOUT] atIndex:9];
        [palyerGrossArray insertObject:[NSString stringWithFormat:@"%ld",GrossIN] atIndex:19];
        [palyerGrossArray insertObject:[NSString stringWithFormat:@"%ld",GrossOUT+GrossIN] atIndex:20];
        
        [palyerPuttersArray insertObject:[NSString stringWithFormat:@"%ld",PuttersOUT] atIndex:9];
        [palyerPuttersArray insertObject:[NSString stringWithFormat:@"%ld",PuttersIN] atIndex:19];
        [palyerPuttersArray insertObject:[NSString stringWithFormat:@"%ld",PuttersOUT+PuttersIN] atIndex:20];

        //        }
        [PuttersArray replaceObjectAtIndex:m withObject:palyerPuttersArray];
        [GrossArray replaceObjectAtIndex:m withObject:palyerGrossArray];
        [DiffrendsArray replaceObjectAtIndex:m withObject:palyerDiffrendsArray];
        if (topDataArray.count==4) {
            
            [mTopDataArray addObject:topDataArray];
        }
    }
    
    NSMutableArray *showLabelArray = [NSMutableArray array];
    NSInteger showLabelArray0 = 0;
    NSInteger showLabelArray1 = 0;
    NSInteger showLabelArray2 = 0;
    NSInteger showLabelArray3 = 0;
    NSInteger showLabelArray4 = 0;
    NSInteger showLabelArray5 = 0;
    for (int i = 0; i<20; i++) {
        if (i==9||i==19) {
            continue;
        }else{
            int j = i;
            if (i>9) {
                j=i-1;
            }
            if ([selectArray containsObject:[NSString stringWithFormat:@"%d",j+1]]) {
                NSString *showLabelStr = DiffrendsArray[playerSelectIndex][i];
                NSInteger showStrIntger = [showLabelStr integerValue];
                if (showStrIntger<=-3) {
                    showLabelArray0++;
                }else if (showStrIntger==-2){
                    showLabelArray1++;
                }else if (showStrIntger==-1){
                    showLabelArray2++;
                }else if (showStrIntger==0){
                    showLabelArray3++;
                }else if (showStrIntger==1){
                    showLabelArray4++;
                }else if (showStrIntger>=2){
                    showLabelArray5++;
                }
            }
        }
    }
    if (showLabelArray0>0) {
        [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray0]];
    }else{
        NSMutableArray *mShowViewColorArray = [NSMutableArray arrayWithArray:showViewColorArray];
        [mShowViewColorArray removeFirstObject];
        showViewColorArray = [NSArray arrayWithArray:mShowViewColorArray];
        
        NSMutableArray *mShowLabelTextArray = [NSMutableArray arrayWithArray:showLabelTextArray];
        [mShowLabelTextArray removeFirstObject];
        showLabelTextArray = [NSArray arrayWithArray:mShowLabelTextArray];
        
    }
    [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray1]];
    [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray2]];
    [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray3]];
    [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray4]];
    [showLabelArray addObject:[NSString stringWithFormat:@"%ld",showLabelArray5]];
    
    NSDictionary *parkDict= [_dataDict objectForKey:@"qinfo"];
    NSString *ParkName = [parkDict objectForKey:@"qname"];
    for (int i = 0 ; i<poleNameArray.count; i++) {
        if (i==0) {
            ParkName = [NSString stringWithFormat:@"%@(%@)",ParkName,poleNameArray[i]];
        }else if (i==1){
            ParkName = [NSString stringWithFormat:@"%@(%@/%@)",[parkDict objectForKey:@"qname"],poleNameArray[0],poleNameArray[1]];
        }
    }
    NSString *dataStr = [self TimeStamp:[_dataDict objectForKey:@"begainTime"]];
    NSString *totalTime = [_dataDict objectForKey:@"gameduration"];
    if ([totalTime isEqualToString:@"-1"]) {
        totalTime = @"";
    }
    totalTime = [self getMMSSFromSS:totalTime];
    NSString *timeText = [NSString stringWithFormat:@"%@ ",dataStr];
    if (totalTime.length>1) {
        timeText = [NSString stringWithFormat:@"%@   %@",dataStr,[NSString stringWithFormat:@"本场用时：%@", totalTime]];
    }
    //头部视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [mainScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight*2)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    CGFloat ParkLabelWidth = ScreenWidth - kWvertical(13) - kHvertical(67) - kWvertical(13);

    
    UILabel *ParkLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(13),kHvertical(12), ParkLabelWidth, kHvertical(40)) textColor:BlackColor fontSize:kHvertical(13) Title:ParkName];
    ParkLabel.numberOfLines = 0;

    ParkLabel.numberOfLines = 0;
    
    UILabel *timeLabel = [Factory createLabelWithFrame:CGRectMake(ParkLabel.x, ParkLabel.y_height + kHvertical(3), ParkLabelWidth, kHvertical(17)) textColor:rgba(128,128,128,1) fontSize:kHorizontal(12) Title:timeText];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(timeLabel.x, ParkLabel.y_height + kHvertical(3), timeLabel.width, kHvertical(17));
    UITapGestureRecognizer *timeSelectTgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGameBeganView)];
    
    UIView *timeSelectView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(timeLabel.x, timeLabel.y-kHvertical(15), timeLabel.width, kHvertical(40))];
    timeSelectView.userInteractionEnabled = NO;
    [timeSelectView addGestureRecognizer:timeSelectTgp];
    
    UILabel *TEE = [Factory createLabelWithFrame:CGRectMake( kWvertical(12), kHvertical(3), kWvertical(30), timeLabel.height) textColor:BlackColor fontSize:kHorizontal(12) Title:@"TEE"];
    [TEE sizeToFit];
    TEE.frame = CGRectMake(TEE.x, kHvertical(3), TEE.width, timeLabel.height);
    UIImageView *colorArrow = [Factory createImageViewWithFrame:CGRectMake(TEE.x_width+ kWvertical(1),  kHvertical(10), kWvertical(8), kHvertical(5)) Image:[UIImage imageNamed:@"scoring向下角标"]];
    
    _SlectTBtn = [Factory createButtonWithFrame:CGRectMake(timeLabel.x_width, ParkLabel.y_height, TEE.x_width + kWvertical(10), timeLabel.height+kHvertical(6)) target:self selector:@selector(SelectT:) Title:nil];
    
    [_SlectTBtn addSubview:colorArrow];
    [_SlectTBtn addSubview:TEE];
    
    EAFeatureItem *left;
    EAFeatureItem *right;
    
    left = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(timeLabel.x, timeLabel.y+64, timeLabel.width, timeLabel.height) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    left.imageFrame = CGRectMake(kWvertical(47), timeLabel.y+64-8-kWvertical(23), kWvertical(23), kWvertical(23));
    left.indicatorImageName = @"bottom_icon";
    left.labelFrame = CGRectMake(kWvertical(6), timeLabel.y+64-46-kWvertical(23), kWvertical(120), kHvertical(35));
    left.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    left.introduce = @"更改开场日期";
    
    right = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(_SlectTBtn.x+5, _SlectTBtn.y+64, _SlectTBtn.width, _SlectTBtn.height) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    right.imageFrame = CGRectMake(_SlectTBtn.x+8, kHvertical(142), kWvertical(23), kWvertical(23));
    right.indicatorImageName = @"top_short";
    right.labelFrame = CGRectMake(_SlectTBtn.x-40, kHvertical(174), kWvertical(114), kHvertical(35));
    right.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    right.introduce = @"选择发球台";
    
    if (_status==0) {
        [self.navigationController.view showWithFeatureItems:@[left,right] saveKeyName:@"group" inVersion:nil];

        NSString *jluid = [_dataDict objectForKey:@"jluid"];
        if ([jluid isEqualToString:_nameUid]) {
            timeSelectView.userInteractionEnabled = YES;
            [mainScrollView addSubview:_SlectTBtn];
        }
    }
    
    UIView *totalView = [Factory createViewWithBackgroundColor:rgba(85,162,252,1) frame:CGRectMake(ScreenWidth - kWvertical(13) - kHvertical(67), kHvertical(10), kHvertical(67), kHvertical(67))];
    totalView.userInteractionEnabled = YES;
    __weak typeof(self) weakself = self;

    UITapGestureRecognizer *totalViewGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_grossViewClick == 0) {
            _grossViewClick = 2;
            if ([isSelect isEqualToString:@"1"]) {
                _grossViewClick = 1;
            }
        }else if (_grossViewClick<2) {
            _grossViewClick = 2;
        }else{
            _grossViewClick = 1;
        }
        [weakself.mainScrollView removeAllSubviews];
        [weakself.mainScrollView removeFromSuperview];
        [weakself createContentView];
        if (_status==3&&[_nameUid isEqualToString:userDefaultUid]) {
            if (_grossViewClick>0) {
                [self createShareView];
            }
        }
    }];
    [totalView addGestureRecognizer:totalViewGesture];
    
    UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(7), totalView.width, kHvertical(17)) textColor:WhiteColor fontSize:kHorizontal(12) Title:@"总杆"];
    [Gross setTextAlignment:NSTextAlignmentCenter];

    UILabel *GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(23), totalView.width, kHvertical(37)) textColor:WhiteColor fontSize:kHorizontal(26) Title:GrossArray[playerSelectIndex][20]];
    
    [GrossLabel setTextAlignment:NSTextAlignmentCenter];
    [GrossLabel sizeToFit];
    GrossLabel.frame = CGRectMake(totalView.width/2 - GrossLabel.width/2 - kWvertical(4), kHvertical(23), GrossLabel.width, kHvertical(37));
    
    UILabel *PuttersLabel = [Factory createLabelWithFrame:CGRectMake(GrossLabel.x_width , kHvertical(25), kWvertical(20), kHvertical(14)) textColor:WhiteColor fontSize:kHorizontal(10) Title:PuttersArray[playerSelectIndex][20]];
    [PuttersLabel sizeToFit];
    

    
    GrossLabel.frame = CGRectMake(totalView.width/2 - GrossLabel.width/2 - PuttersLabel.width/2, kHvertical(23), GrossLabel.width, kHvertical(37));
    PuttersLabel.frame = CGRectMake(GrossLabel.x_width , kHvertical(25), PuttersLabel.width, kHvertical(14));
    
    [totalView addSubview:Gross];
    [totalView addSubview:GrossLabel];
    [totalView addSubview:PuttersLabel];
    
//    if (_status==3) {
//        PuttersLabel.text = @"0";
//    }

    
    [mainScrollView addSubview:ParkLabel];
    [mainScrollView addSubview:timeLabel];
    [mainScrollView addSubview:totalView];
    [mainScrollView addSubview:timeSelectView];
    //表格
    UIView *markBakcView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, totalView.y_height + kHvertical(14), ScreenWidth, kHvertical(28)*playerNum+ kHvertical(4))];
    if (_status == 3) {
        [mainScrollView addSubview:markBakcView];
    }
    
    DrawRectLineView *Rectangle = [[DrawRectLineView alloc] init];
    Rectangle.backgroundColor = [UIColor whiteColor];
    Rectangle.frame = CGRectMake(timeLabel.x, 0, ScreenWidth - kWvertical(24), kHvertical(23));
    Rectangle.lineWidth = 0.5;
    Rectangle.begainRect = CGPointMake(-1, 0);
    Rectangle.endRect = CGPointMake(Rectangle.width+1, Rectangle.height-1);
    Rectangle.lineColorArray = @[@"129",@"152",@"173",@"1"];
    Rectangle.contentColor = rgba(230,237,243,1);
    Rectangle.DrawRectLineViewStyle = DrawRectLineViewStyleRectangle;
    [markBakcView addSubview:Rectangle];
    
    
    DrawRectLineView *slashView = [[DrawRectLineView alloc] init];
    slashView.backgroundColor = [UIColor clearColor];
    slashView.frame = CGRectMake(0 ,0 , (ScreenWidth - kWvertical(24))/4, kHvertical(23));
    slashView.lineWidth = 0.5;
    slashView.begainRect = CGPointMake(0, 0);
    slashView.endRect = CGPointMake(slashView.width, slashView.height);
    slashView.lineColorArray = @[@"129",@"152",@"173",@"1"];
    slashView.DrawRectLineViewStyle = DrawRectLineViewStyleLine;
    [Rectangle addSubview:slashView];
    
    for (int i = 0; i<5; i++) {
        UIView *backView = [Factory createViewWithBackgroundColor:rgba(129,152,173,1) frame:CGRectMake(Rectangle.x +slashView.width*i , Rectangle.y, 0.5f, kHvertical(23)*(mTopDataArray.count + 1))];
        [markBakcView addSubview:backView];
    }
    
    for (int i = 0; i<mTopDataArray.count; i++) {
        UIView *backView = [Factory createViewWithBackgroundColor:rgba(129,152,173,1) frame:CGRectMake(Rectangle.x, Rectangle.y_height + kHvertical(23)*(i+1), Rectangle.width,0.5)];
        [markBakcView addSubview:backView];
        
    }
    
    UILabel *BallFriendLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(8), kHvertical(8), kWvertical(25), kHvertical(13)) textColor:rgba(128, 146, 160, 1) fontSize:kHorizontal(8) Title:@"球友"];
    
    UILabel *DataLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(2), slashView.width - kWvertical(8), kHvertical(13)) textColor:rgba(128, 146, 160, 1) fontSize:kHorizontal(8) Title:@"数据"];
    [DataLabel setTextAlignment:NSTextAlignmentRight];
    [Rectangle addSubview:BallFriendLabel];
    [Rectangle addSubview:DataLabel];
    BOOL isViewTotalPutter = NO;

    if (mTopDataArray.count>0) {
    
        NSMutableArray *formTotalArray = [NSMutableArray array];
            NSMutableArray *formNameIdArray = [NSMutableArray array];
        [formTotalArray addObject:@"0"];
        [formTotalArray addObjectsFromArray:topArray];
        for (int i = 0; i<mTopDataArray.count; i++) {
            [formTotalArray addObject:playerNameArray[i]];
            [formTotalArray addObject:mTopDataArray[i][0]];
            [formTotalArray addObject:mTopDataArray[i][1]];
            [formTotalArray addObject:mTopDataArray[i][2]];
            [formNameIdArray addObject:mTopDataArray[i][3]];
            
        }
        for (NSInteger i = 0; i<mTopDataArray.count+1; i++) {
            for (NSInteger j =0; j<4; j++) {
                UILabel *contentLabel = [Factory createLabelWithFrame:CGRectMake(Rectangle.x + kWvertical(8) + slashView.width*j,Rectangle.y + kHvertical(23)*i, slashView.width - kWvertical(16), slashView.height) textColor:BlackColor fontSize:kHorizontal(12) Title:formTotalArray[4*i+j]];
                [contentLabel setTextAlignment:NSTextAlignmentLeft];
                if (j>0) {
                    [contentLabel setTextAlignment:NSTextAlignmentCenter];
                }
                if (i>0) {
                    NSString *selectNameID = formNameIdArray[i-1];
                    if ([selectNameID isEqualToString:_nameUid]) {
                        [contentLabel setTextColor:localColor];
                        isViewTotalPutter = YES;
                    }
                }
                if (i==0) {
                    [contentLabel setFont:[UIFont systemFontOfSize:kHorizontal(11)]];
                }
                
                if (!(i==0&&j==0)) {
                    [markBakcView addSubview:contentLabel];
                }
            }
        }
    }
    //一杆进洞
    CGFloat showY = 0;
    CGFloat markBakcViewy_height = markBakcView.y_height;
    
    if (_status!=3||mTopDataArray.count==0) {
        [markBakcView removeAllSubviews];
        markBakcViewy_height = totalView.y_height;

    }
    
    if (!isViewTotalPutter) {
        if (_status==3) {
            PuttersLabel.text = @"0";
        }
    }

    NSInteger showLabelArrayCount = showLabelArray.count;

    for (int j =0 ; j<showLabelArrayCount; j++) {
        UIImageView *trophyView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(17), markBakcViewy_height +kHvertical(17), kWvertical(34), kHvertical(36)) Image:[UIImage imageNamed:@"scoring一杆进洞"]];
        UILabel *HOLE_IN_ONELabel = [Factory createLabelWithFrame:CGRectMake(0, trophyView.y_height + kHvertical(4), ScreenWidth, kHvertical(14)) textColor:BlackColor fontSize:kHorizontal(10.0f) Title:@"一杆进洞"];
        [HOLE_IN_ONELabel setTextAlignment:NSTextAlignmentCenter];
        if (HOLE_IN_ONE) {
            if (j==0) {
                [mainScrollView addSubview:trophyView];
                [mainScrollView addSubview:HOLE_IN_ONELabel];
            }
            showY = kHvertical(77);
        }
        CGFloat showlabelWidth = ScreenWidth - kWvertical(28);
        //杆数标记
        UILabel *showlabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(14) + showlabelWidth/showLabelArrayCount*j ,  markBakcViewy_height  + kHvertical(17) + showY, showlabelWidth/showLabelArrayCount, kWvertical(24)) textColor:WhiteColor fontSize:kHvertical(13) Title:showLabelArray[j]];
        //showLabelArray[j]
        [showlabel setTextAlignment:NSTextAlignmentCenter];
        
        UIView *showView = [Factory createViewWithBackgroundColor:showViewColorArray[j] frame:CGRectMake(showlabel.x + (showlabel.width - kWvertical(24))/2, showlabel.y,  kWvertical(24), kWvertical(24))];
        showView.layer.masksToBounds = YES;
        showView.layer.cornerRadius = kWvertical(12);
        if (j> showLabelTextArray.count-3) {
            [showlabel setTextColor:rgba(95,95,95,1)];
        }
        UILabel *showName = [Factory createLabelWithFrame:CGRectMake(showlabel.x, showView.y_height + kHvertical(10), showlabel.width, kHvertical(14)) textColor:rgba(67,67,67,1) fontSize:kHorizontal(10) Title:showLabelTextArray[j]];
        [showName setTextAlignment:NSTextAlignmentCenter];
        
        
        
        [mainScrollView addSubview:showView];
        [mainScrollView addSubview:showlabel];
        [mainScrollView addSubview:showName];
        
    }
    
    UIView *line = [Factory createViewWithBackgroundColor:rgba(239,239,239,1) frame:CGRectMake(kWvertical(13), markBakcViewy_height+showY+kHvertical(17)+kWvertical(24) + kHvertical(20) +kHvertical(10), ScreenWidth - kWvertical(26), 0.5)];
    [mainScrollView addSubview:line];
    
    //前后9洞数据是否需要颠倒
    NSString *islast9 = [_dataDict objectForKey:@"islast9"];
    BOOL begainPOle = false;
    if ([islast9 isEqualToString:@"1"]) {
        begainPOle = true;
    }
    
    
    if (begainPOle) {
        NSArray *testPARData = PARData;
        PARData = [NSMutableArray array];
        for (int i = 1; i>-1; i--) {
            for (int j = 0; j<10; j++) {
                [PARData addObject:testPARData[10*i+j]];
            }
        }
    }

    if (begainPOle) {
        NSArray *testGrossArray = GrossArray;
        NSArray *testPuttersArray = PuttersArray;
        NSArray *testDiffrendsArray = DiffrendsArray;
        
        GrossArray = [NSMutableArray array];
        PuttersArray = [NSMutableArray array];
        DiffrendsArray = [NSMutableArray array];
        for (int k = 0; k<playerNum; k++) {
            NSMutableArray *playerGrossArray = [NSMutableArray array];
            NSMutableArray *playerPuttersArray = [NSMutableArray array];
            NSMutableArray *playerDiffrendsArray = [NSMutableArray array];
            
            for (int i = 1; i>-1; i--) {
                for (int j = 0; j<10; j++) {
                    [playerGrossArray addObject:testGrossArray[k][10*i+j]];
                    [playerPuttersArray addObject:testPuttersArray[k][10*i+j]];
                    if (10*i+j<20) {
                        [playerDiffrendsArray addObject:testDiffrendsArray[k][10*i+j]];
                    }
                    if (10*i+j == 9) {
                        [playerGrossArray addObject:testGrossArray[k][20]];
                        [playerPuttersArray addObject:testPuttersArray[k][20]];
                    }
                }
            }
            [GrossArray addObject:playerGrossArray];
            [PuttersArray addObject:playerPuttersArray];
            [DiffrendsArray addObject:playerDiffrendsArray];
        }
    }


    // HOLE PAR
    
    NSArray *holeParArray = [NSArray arrayWithObjects:@"HOLE",@"PAR", nil];
    for (int i = 0; i<2 ; i++) {
        UILabel *HolePar = [Factory createLabelWithFrame:CGRectMake(kWvertical(11)+ kWvertical(40)*i, line.y_height + kHvertical(9),kWvertical(40), kHvertical(28)) textColor:rgba(20,20,20,1) fontSize:kHorizontal(10) Title:holeParArray[i]];
        [HolePar setTextAlignment:NSTextAlignmentCenter];
        [mainScrollView addSubview:HolePar];
    }
    
    NSMutableArray *contenParArray = [NSMutableArray array];
    [contenParArray addObject:PARStandardData];
    [contenParArray addObject:PARData];
    
    //洞号 标准杆
    for (int i = 0; i<20; i++) {
        for (int j =0; j<2; j++) {
            UILabel *contentLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(11) + kWvertical(40)*j ,line.y_height + kHvertical(123) + kHvertical(30)*i, kWvertical(40), kHvertical(30)) textColor:rgba(150,150,150,1) fontSize:kHorizontal(12) Title:contenParArray[j][i]];
            
            if (i>9) {
                contentLabel.frame = CGRectMake(kWvertical(11) + kWvertical(40)*j , line.y_height + kHvertical(123) + kHvertical(30)*i + kHvertical(5), kWvertical(40), kHvertical(30));
            }
            
            [contentLabel setTextAlignment:NSTextAlignmentCenter];
            [mainScrollView addSubview:contentLabel];
        }
    }
    
    //竖直线
    UIView *verticalView = [Factory  createViewWithBackgroundColor:rgba(244,244,244,1) frame:CGRectMake(kWvertical(113), line.y_height + kHvertical(130), 0.5, kHvertical(30)*9 - kHvertical(7)*2)];
    [mainScrollView addSubview:verticalView];
    
    for (int i = 0; i<playerNum; i++) {
        UIView *backView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(verticalView.x + (ScreenWidth-verticalView.x)/playerNum*i, line.y_height + kHvertical(9),(ScreenWidth-verticalView.x)/playerNum, kHvertical(30)*20)];
        [mainScrollView addSubview:backView];
        
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((backView.width - kHvertical(28))/2, 0, kHvertical(28), kHvertical(28))];
        UIView *pushToselectView = [Factory createViewWithBackgroundColor:ClearColor frame:headerImageView.frame];

        headerImageView.layer.masksToBounds = YES;
        headerImageView.layer.cornerRadius = kHvertical(14);
        [headerImageView sd_setImageWithURL:playerImageArray[i]];
        
        pushToselectView.userInteractionEnabled = YES;
        __weak typeof(self) weakself = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakself pushToDetail:playerNameIdArray[i]];
        }];
        [pushToselectView addGestureRecognizer:tap];
        
        [backView addSubview:headerImageView];
        [backView addSubview:pushToselectView];
        
        UILabel *playerNameLabel = [Factory createLabelWithFrame:CGRectMake(0, headerImageView.y_height + kHvertical(4), backView.width, kHvertical(16)) textColor:rgba(0,0,0,1) fontSize:kHorizontal(11) Title:playerNameArray[i]];
        [playerNameLabel sizeToFit];
        
        if (playerNameLabel.width>=backView.width) {
            playerNameLabel.frame = CGRectMake(0, playerNameLabel.y , backView.width, kHvertical(16));
        }else{
            playerNameLabel.frame = CGRectMake(0, headerImageView.y_height + kHvertical(4), backView.width, kHvertical(16));
            
            [playerNameLabel setTextAlignment:NSTextAlignmentCenter];
        }
        [backView addSubview:playerNameLabel];
        //T展示
        NSString *TStr = colorName[[playerTcolorArray[i] integerValue]];
        UILabel *TLabel = [Factory createLabelWithFrame:CGRectMake(0, playerNameLabel.y_height + kHvertical(6), backView.width, kHvertical(28)) textColor:WhiteColor fontSize:kHorizontal(10) Title:TStr];
        [TLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIView *colorView = [Factory createViewWithBackgroundColor:rgba(68,68,68,1) frame:CGRectMake((backView.width - kHvertical(28))/2, TLabel.y, kHvertical(28), kHvertical(28))];
        colorView.userInteractionEnabled = YES;
        __weak __typeof(self)weakSelf = self;
        NSString *jluid = [_dataDict objectForKey:@"jluid"];
        
        if ([jluid isEqualToString:_nameUid]) {

        UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (_status == 0) {
                [weakSelf SelectT:[NSString stringWithFormat:@"%d",i]];
            }
        }];
        [colorView addGestureRecognizer:tpg];
        }
        colorView.layer.masksToBounds = YES;
        colorView.layer.cornerRadius = kHorizontal(14);
        if ([TStr isEqualToString:@"白T"]) {
            [TLabel setTextColor:BlackColor];
            [colorView setBackgroundColor:rgba(249,249,249,1)];
            colorView.layer.borderColor = rgba(217,217,217,1).CGColor;
            colorView.layer.borderWidth = 0.5;
        }else if ([TStr isEqualToString:@"金T"]){
            [colorView setBackgroundColor:rgba(255,200,74,1)];
        }else if ([TStr isEqualToString:@"蓝T"]){
            [colorView setBackgroundColor:rgba(1,144,255,1)];
        }else if ([TStr isEqualToString:@"红T"]){
            [colorView setBackgroundColor:rgba(237,87,55,1)];
        }
        
        [backView addSubview:colorView];
        [backView addSubview:TLabel];
        NSString *grossStr = GrossArray[i][20];
        if (!grossStr) {
            grossStr = @"";
        }
        
        UILabel *totalLabel = [Factory createLabelWithFrame:CGRectMake(0, colorView.y_height + kHvertical(6), backView.width, kHvertical(20)) textColor:rgba(0,0,0,1) fontSize:kHorizontal(14) Title:grossStr];
        [backView addSubview:totalLabel];

//        [totalLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        NSInteger OUTNum = 0;
        NSInteger INNum = 0;
        
        
        
        for (int j = 0; j<20; j++) {
            
            UIView *circleView = [Factory createViewWithBackgroundColor:rgba(245,245,245,1) frame:CGRectMake((backView.width - kHvertical(25))/2 ,kHvertical(116) + kHvertical(30)*j,kHvertical(25),kHvertical(25))];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = kHvertical(12.5);
            
            NSString *Difference = [[NSString alloc] initWithFormat:@"%@",DiffrendsArray[i][j]];

            NSString *poleStr = GrossArray[i][j];
            NSString *parStr = PARData[j];
            
            
            if ([isSelect isEqualToString:@"1"]&&[poleStr integerValue]>0){
                if(j!=9&&j!=19) {
                    poleStr = [NSString stringWithFormat:@"%ld",[poleStr integerValue] - [parStr integerValue]];
                    if (j<9) {
                        OUTNum = OUTNum + [poleStr integerValue];
                    }else if (j>10&&j<19){
                        INNum = INNum + [poleStr integerValue];
                    }
                    if ([poleStr integerValue]>0) {
                        poleStr = [NSString stringWithFormat:@"+%@",poleStr];
                    }
                }else if (j==9) {
                    poleStr = [NSString stringWithFormat:@"%ld",OUTNum];
                    if (OUTNum>0) {
                        poleStr = [NSString stringWithFormat:@"+%@",poleStr];
                    }
                }else if (j==19) {
                    poleStr = [NSString stringWithFormat:@"%ld",INNum];
                    if (INNum>0) {
                        poleStr = [NSString stringWithFormat:@"+%@",poleStr];
                    }
                }
                NSInteger totalNum = OUTNum + INNum;
                grossStr = [NSString stringWithFormat:@"%ld",totalNum];
                if (totalNum > 0) {
                    grossStr = [NSString stringWithFormat:@"+%@",grossStr];
                }
            }
            
            UILabel *poleNumber = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(120) + kHvertical(30)*j, backView.width, kHvertical(18)) textColor:BlackColor fontSize:kHorizontal(13) Title:poleStr];

            if (j>9) {
                poleNumber.frame = CGRectMake(0, kHvertical(120) + kHvertical(30)*j + kHvertical(5), backView.width, kHvertical(18));
                circleView.frame = CGRectMake((backView.width - kHvertical(25))/2 ,kHvertical(116) + kHvertical(30)*j + kHvertical(5),kHvertical(25),kHvertical(25));
            }
            CGFloat poleNumberY = poleNumber.y;

            [poleNumber sizeToFit];
            poleNumber.frame = CGRectMake(backView.width/2 - poleNumber.width/2, poleNumberY, poleNumber.width, kHvertical(18));
            
            NSString *puttersTitle = PuttersArray[i][j];
            if ([puttersTitle isEqualToString:@"-1"]) {
                puttersTitle = @"0";
            }
            
            UILabel *Putters = [Factory createLabelWithFrame:CGRectMake(poleNumber.x_width, poleNumber.y, kWvertical(20), kHvertical(11)) fontSize:kHvertical(8) Title:[NSString stringWithFormat:@"%@",puttersTitle]];

            NSInteger diffrent = [Difference integerValue];
            NSInteger totalColor = showViewColorArray.count;
            if (diffrent<=0) {
                poleNumber.textColor = WhiteColor;
                Putters.textColor = WhiteColor;
                circleView.backgroundColor = showViewColorArray[totalColor-3];
                if (diffrent<=-1){
                    circleView.backgroundColor = showViewColorArray[totalColor-4];
                    if (diffrent<-1){
                        circleView.backgroundColor = showViewColorArray[totalColor-5];
                    }
                }
            }

            if ([GrossArray[i][j] isEqualToString:@""]) {
                circleView.backgroundColor = ClearColor;
                poleNumber.textColor = BlackColor;
                Putters.textColor = BlackColor;
            }
            
            if ([GrossArray[i][j] isEqualToString:@"0"]) {
                circleView.backgroundColor = ClearColor;
                poleNumber.textColor = ClearColor;
                Putters.textColor = ClearColor;
            }
            
            if (j==9||j==19) {
                circleView = nil;
            }
            
            [poleNumber setTextAlignment:NSTextAlignmentCenter];
            [backView addSubview:circleView];
            [backView addSubview:poleNumber];
            [backView addSubview:Putters];
    
            if (j==19) {
                backView.frame = CGRectMake(backView.x, backView.y, backView.width, poleNumber.y_height + kHvertical(44));
                [mainScrollView setContentSize:CGSizeMake(ScreenWidth, backView.y_height)];
            }
        }
        totalLabel.text = grossStr;
        
        [totalLabel sizeToFit];
        totalLabel.x = backView.width/2 - totalLabel.width/2;
        
        
        NSString *totalPuttersStr = [NSString stringWithFormat:@"%ld",[PuttersArray[i][9] integerValue]+[PuttersArray[i][19] integerValue]];
        
        UILabel *totalPutterLabel = [Factory createLabelWithFrame:CGRectMake(totalLabel.x_width, totalLabel.y, kWvertical(20), kHvertical(11)) fontSize:kHvertical(8) Title:[NSString stringWithFormat:@"%@",totalPuttersStr]];
        
        [backView addSubview:totalPutterLabel];

    }
    
    
    
    [self.view addSubview:mainScrollView];
    _mainScrollView = mainScrollView;
//    _mainScrollView.height = _mainScrollView.height - kHvertical(65);
}

-(void)createShareView{
    [_shareOtherView removeFromSuperview];
    NSArray *shareIcon = @[@"scoring-groundIcon",@"scoring-wxfriends",@"scoring-Friendster",@"scoing-weibo"];
    NSArray *shareTitle = @[@"球友圈",@"微信好友",@"朋友圈",@"微博"];
    NSArray *shareIconEdg = @[@"22",@"28",@"22",@"29"];
    _shareOtherView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(65))];
    if (_status==3&&[_nameUid isEqualToString:userDefaultUid]) {
        _mainScrollView.height = _mainScrollView.height - kHvertical(65);
        for (int i = 0; i<4; i++) {
            CGFloat Swidth = (ScreenWidth-kWvertical(30))/4;
            
            int xX = [shareIconEdg[i] intValue];
            UIButton *sharBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(15) + Swidth*i, 0, Swidth, kHvertical(65)) image:[UIImage imageNamed:shareIcon[i]] target:self selector:@selector(shareClick:) Title:nil];
            
            sharBtn.tag = 200+i;
            //            [sharBtn setBackgroundColor:RandomColor];
            UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(41), Swidth, kHvertical(14)) textColor:BlackColor fontSize:kHorizontal(10) Title:shareTitle[i]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [sharBtn addSubview:titleLabel];
            
            [sharBtn setImageEdgeInsets:UIEdgeInsetsMake(kHvertical(11), (Swidth - xX)/2,  kHvertical(54)-23, (Swidth - xX)/2 )];
            
            [_shareOtherView addSubview:sharBtn];
        }
    }
    if (_grossViewClick>0) {
        _shareOtherView.frame = CGRectMake(0, ScreenHeight - kHvertical(65), ScreenWidth, kHvertical(65));
    }else{
        [UIView animateWithDuration:1.0f animations:^{
            _shareOtherView.frame = CGRectMake(0, ScreenHeight - kHvertical(65), ScreenWidth, kHvertical(65));
        }];
    }
    [self.view addSubview:_shareOtherView];

    
}

//创建分享界面
-(void)createShareOtherView{
    
    _shareBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth+kWvertical(46), 10)];
    
    UIView *shareBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(23), 0, ScreenWidth, _shareBackView.height)];

    UIImageView *headerView = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth - kHvertical(56))/2, kHvertical(32), kHvertical(56), kHvertical(56)) Image:nil];
    if (_headerImage) {
        headerView.image = _headerImage;
    }else{
        return;
    }
    
//    [headerView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"加载结束");
//    }];
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = kHvertical(28);
    
    
    
    UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(0, headerView.y_height+kHvertical(7), shareBackView.width, kHvertical(22)) textColor:rgba(38,36,36,1) fontSize:0 Title:[userDefaults objectForKey:@"nickname"]];
    nameLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(16.0f)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    
    [shareBackView addSubview:headerView];
    [shareBackView addSubview:nameLabel];
    
    _mainScrollView.y = nameLabel.y_height + kHvertical(31);
    _mainScrollView.height = _mainScrollView.contentSize.height;
    
    NSArray *money = _moneyArray;
    
    UIView *imageView = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth-kWvertical(56))/2, _mainScrollView.y_height + kHvertical(32), kWvertical(56), kWvertical(56)) Image:[UIImage imageNamed:@"scoing-downloadicon"]];
    UIImageView *golvonText = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth-kWvertical(56))/2, imageView.y_height+kHvertical(10), kWvertical(56), kHvertical(21)) Image:[UIImage imageNamed:@"scoring-golvonText"]];
    
    UILabel *publichBenifit = [Factory createLabelWithFrame:CGRectMake(0, golvonText.y_height + kHvertical(19), ScreenWidth, kHvertical(24)) textColor:rgba(34,34,34,1) fontSize:kHorizontal(17) Title:@"打球记分也能做公益"];
    [publichBenifit setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *indexLabel = [Factory createLabelWithFrame:CGRectMake(0, publichBenifit.y_height + kHvertical(12), ScreenWidth, kHvertical(19)) textColor:rgba(103,103,103,1) fontSize:kHorizontal(13.5) Title:[NSString stringWithFormat:@"本场捐出：%@元",money[0]]];
    [indexLabel setTextAlignment:NSTextAlignmentCenter];
    indexLabel = [self AttributedStringLabel:indexLabel rang:NSMakeRange(5, indexLabel.text.length-6) changeColor:localColor];
    
    
    
    UILabel *totalLabel = [Factory createLabelWithFrame:CGRectMake(0, indexLabel.y_height, ScreenWidth, kHvertical(19)) textColor:rgba(103,103,103,1) fontSize:kHorizontal(13.5) Title:[NSString stringWithFormat:@"累计捐助：%@元",money[1]]];
    [totalLabel setTextAlignment:NSTextAlignmentCenter];
    totalLabel = [self AttributedStringLabel:totalLabel rang:NSMakeRange(5, totalLabel.text.length-6) changeColor:localColor];

    [shareBackView addSubview:imageView];
    [shareBackView addSubview:golvonText];
    [shareBackView addSubview:publichBenifit];
    [shareBackView addSubview:indexLabel];
    [shareBackView addSubview:totalLabel];
    [shareBackView addSubview:_mainScrollView];

    shareBackView.height = totalLabel.y_height + kHvertical(32);
    _shareBackView.height = shareBackView.y_height ;

    [_shareBackView addSubview:shareBackView];
}
//时间选择界面

-(void)createGameBeganView{
    UIView *grayBackView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.4) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [self.view addSubview:grayBackView];
    
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(278))];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backView.y = ScreenHeight - kHvertical(278);
    } completion:^(BOOL finished) {
        
    }];
    [grayBackView addSubview:backView];
    
    UIButton *titleBtn = [Factory createButtonWithFrame:CGRectMake(0, kHvertical(10), ScreenWidth, kHvertical(40)) titleFont:kHorizontal(15) textColor:rgba(58,60,72,1) backgroundColor:ClearColor target:self selector:@selector(timeTitleClick:) Title:@"下场日期"];
    
    [titleBtn setTitleColor:localColor forState:UIControlStateSelected];
    UIView *bottomLine = [Factory createViewWithBackgroundColor:localColor frame:CGRectMake(0, titleBtn.height-4, ScreenWidth, 1)];
    [titleBtn addSubview:bottomLine];
    [backView addSubview:titleBtn];
    
    UIView *bottomView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, kHvertical(230), ScreenWidth, kHvertical(48))];
    
    [backView addSubview:bottomView];
    
    UIButton *cancelBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(60), kHvertical(48)) titleFont:kHorizontal(15) textColor:rgba(91,91,91,1) backgroundColor:ClearColor target:self selector:@selector(timeSelectCancel:) Title:@"取消"];
    [bottomView addSubview:cancelBtn];
    
    UIButton *sureBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(76), kHvertical(11), kWvertical(63), kHvertical(26)) titleFont:kHorizontal(15) textColor:WhiteColor backgroundColor:localColor target:self selector:@selector(timeSelectSure:) Title:@"确认"] ;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 3.0f;
    [bottomView addSubview:cancelBtn];
    [bottomView addSubview:sureBtn];
    
    
    __weak typeof(self) weakself = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself timeSelectCancel:cancelBtn];
    }];
    grayBackView.userInteractionEnabled = YES;
    [grayBackView addGestureRecognizer:tap];
    
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kHvertical(42), ScreenWidth, kHvertical(186))];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSString *begainTime = [_dataDict objectForKey:@"begainTime"];
    NSTimeInterval time=[begainTime doubleValue];//
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"2000-01-01 00:00:00"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *minDate = [dateFormatter dateFromString:strDate];
    NSLog(@"%@", minDate);

    _datePicker.maximumDate = [NSDate date];
    _datePicker.minimumDate = minDate;
    _datePicker.date = detaildate;
    _startTime =begainTime;
    [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    [backView addSubview:_datePicker];
}
//创建 周、月、年最佳
-(void)createALertBestView{
    if (_alertBestScoreView==0) {
        return;
    }
    NSString *imageStr = [NSString string];
    NSString *descStr = [NSString string];
    switch (_alertBestScoreView) {
        case 1:
            imageStr = @"scoring-weekBest";
            descStr = @"本周最佳成绩";
            break;
        case 2:
            imageStr = @"scoring-monthBest";
            descStr = @"本月最佳成绩";
            break;
        case 3:
            imageStr = @"scoring-yearBest";
            descStr = @"年度最佳成绩";
            break;
            
        default:
            break;
    }
    _alertBestScoreView=0;
    NSString *begainTime = [_dataDict objectForKey:@"begainTime"];
    NSTimeInterval time=[begainTime doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    begainTime = currentDateStr;
    
    GolvonAlertView *alert = [[GolvonAlertView alloc] initWithBestScoreAlertFrame:self.view.bounds time:begainTime desc:descStr image:imageStr];
    [self.view addSubview:alert];
    alert.userInteractionEnabled = YES;
    [alert addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [alert removeFromSuperview];
    }]];
}


#pragma mark - loadData
-(void)initViewData{
    if (!_isLoadDta) {
        NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
        
        NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
        if ([diskCache containsObjectForKey:disckCacheKey]) {
            _dataDict = (NSDictionary *)[diskCache objectForKey:disckCacheKey];
        }
        [self createContentView];
    }else{
        [self reloadTotalData];
        
    }
}
//点击用户头像跳转
-(void)pushToDetail:(NSString *)nameId{
    if ([nameId integerValue]<0) {
        return;
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"checkuid":nameId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=isvailduid",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = [data objectForKey:@"code"];
            NSString *isadd = [data objectForKey:@"isadd"];
            
            if ([code isEqualToString:@"1"]||[isadd isEqualToString:@"0"]) {
                NewDetailViewController *VC = [[NewDetailViewController alloc] init];
                VC.nameID = nameId;
                [VC setBlock:^(BOOL isback) {
                }];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
    }];
}



//加入临时分组
-(void)insertJustGroup{

    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"groupID":_groupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@/Golvon/InsertBrowseGroup",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
        }
    }];
    
}
//退出分组
-(void)quietJustGroup{

    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"groupID":_groupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteBrowseGroup",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        
    }];
}

//数据更新
-(void)reloadTotalData{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_nameUid,
                           @"gid":_groupId
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
                
                NSString *charity    = [data objectForKey:@"charity"];//本场慈善金额
                NSString *charityall = [data objectForKey:@"charityall"];//累计金额
                //
                _moneyArray = @[charity, charityall];
                
                NSMutableArray *orderArray = [NSMutableArray array];
                for (int i = 0; i<order.count; i++) {
                    for (int j = 1; j<10; j++) {
                        [orderArray addObject:[NSString stringWithFormat:@"%@%d",order[i],j]];
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
                NSString *islast9 = [data objectForKey:@"islast9"];
                
                [mDict setValue:islast9 forKey:@"islast9"];
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
                            requestDict = @{
                                            @"pr":[poleIndexDict objectForKey:@"pushrod"],
                                            @"r":[poleIndexDict objectForKey:@"score"],
                                            @"uid":[poleIndexDict objectForKey:@"uid"]
                                            };
                            
                        }else{
                            requestDict = @{
                                            @"pr":@"0",
                                            @"r" :@"0",
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
                if (vcStatus==1&&[jluid isEqualToString:userDefaultUid]) {
                    vcStatus = 0;
                }
                if (vcStatus!=_status) {
                    _needPopHome = YES;
                }
                _status = vcStatus;
                _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
                
            if (_status == 3&&[_nameUid isEqualToString:userDefaultUid]){
                self.navigationItem.rightBarButtonItem = _rightBarbutton;
                [_rightBarbutton setTitle:@"本地保存"];

            }
                if (!_mainScrollView) {
                    [self createContentView];
                }else{

                    [self.mainScrollView removeAllSubviews];
                    [self.mainScrollView removeFromSuperview];
                    
                    [self createContentView];
                }
                if (self.status==3&&[_nameUid isEqualToString:userDefaultUid]) {
                    [self createShareView];
                    [self createALertBestView];

                }

            }
        }
    }];
}

//更新打球时间
-(void)changeStartTime{
    [self createHUD];
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"startts":_startTime,
                           @"name_id":userDefaultId,
                           @"gid":_groupId
                           };
    NSString *urlStr = [NSString stringWithFormat:@"%@scoreapi.php?func=setgametime",apiHeader120];
    [manager downloadWithUrl:urlStr parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                NSLog(@"%@",code);
                if ([code isEqualToString:@"0"]) {
                    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_dataDict];
                    [mDict setValue:_startTime forKey:@"begainTime"];
                    [self saveData:mDict];
                    [self.mainScrollView removeAllSubviews];
                    [self.mainScrollView removeFromSuperview];
                    [self createContentView];
                }
            }
        }
        _HUD.hidden = YES;
    }];
}

//选T提交
-(void)selectTsend{
    
    
    NSMutableArray *playerNameIdArray = [NSMutableArray array];
    NSArray *playerArray = [_dataDict objectForKey:@"playerArrayKey"];//球员数组
    NSMutableArray *mPlayerArray = [NSMutableArray array];
    for (int i = 0; i<playerArray.count; i++) {
        NSMutableDictionary *playerDict = [NSMutableDictionary dictionaryWithDictionary:playerArray[i]];
        NSString *nameId = [playerDict objectForKey:@"nameId"];
        [playerNameIdArray addObject:nameId];
        [playerDict setValue:_playerTArray[i] forKey:@"tcolor"];
        [mPlayerArray addObject:playerDict];
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_dataDict];
    
    
    [mDict setValue:mPlayerArray forKey:@"playerArrayKey"];
    
    [self saveData:mDict];
    
//    _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
//    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
//    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
//    [diskCache setObject:_dataDict forKey:disckCacheKey];
    
    NSString *selectId = [NSString stringWithFormat:@"%@:%@",playerNameIdArray[0],_playerTArray[0]];

    for (int i = 1 ;i<playerNameIdArray.count ;i++ ) {
        selectId = [NSString stringWithFormat:@"%@,%@:%@",selectId,playerNameIdArray[i],_playerTArray[i]];
    }
    
    
    if (!_mainScrollView) {
        [self createContentView];
    }else{
        
        [_mainScrollView removeAllSubviews];
        [_mainScrollView removeFromSuperview];
        
        [self createContentView];
    }

    //    t  uid:t值列表，用逗号分隔，比如:  5:0,9:2,15:4
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"gid":_groupId,
                           @"t":selectId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=updatetcolor",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
//            NSString *code = [data objectForKey:@"code"];
//            if ([code isEqualToString:@"0"]) {
//                [self reloadTotalData];
//            }
        }
    }];
}



//18洞数据提交
-(void)clickPresShare{

    NSString *isSelect = [_dataDict objectForKey:@"isSelectKey"];
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];
    
    NSMutableArray *scoreArray = [NSMutableArray array];
    for (NSInteger i = 1; i<19; i++) {
        NSDictionary *indexPoleDict = [_dataDict objectForKey:[NSString stringWithFormat:@"pole%ld",i]];
        if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",i]]) {
            [scoreArray addObject:indexPoleDict];
        }
    }
    if (scoreArray.count==0) {
        return;
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
                           @"gid":_groupId,
                           @"isftp":isSelect,
                           @"scores":jsonString
                           };
    __weak typeof(self) weakself = self;
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=score",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        NSLog(@"%@",data);
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                if ([code isEqualToString:@"0"]) {
                    [weakself sureAchievement];
                }
            }

        }else{
            [_HUD removeFromSuperview];
        
        }
    }];
}

//确认成绩点击
-(void)sureAchievement{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"gid":_groupId
                           };
    __weak typeof(self) weakself = self;
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=endofgame",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        [_HUD removeFromSuperview];
        if (success) {
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *iscomplete = [data objectForKey:@"iscomplete"];
                if ([iscomplete isEqualToString:@"1"]) {
                    NSArray *pbscores = [data objectForKey:@"pbscores"];
                    for (NSDictionary *dataDict in pbscores) {
                        NSString *puid = dataDict[@"puid"];
                        if ([puid isEqualToString:userDefaultUid]) {
                            NSString *bestofweek = dataDict[@"bestofweek"];
                            NSString *bestofmonth = dataDict[@"bestofmonth"];
                            NSString *bestofyear = dataDict[@"bestofyear"];
                            if ([bestofweek isEqualToString:@"1"]) {
                                _alertBestScoreView = 1;
                            }
                            if ([bestofmonth isEqualToString:@"1"]) {
                                _alertBestScoreView = 2;
                            }
                            if ([bestofyear isEqualToString:@"1"]) {
                                _alertBestScoreView = 3;
                            }
                        }
                    }
                    
                    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
                    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
                    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
                    
                    NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
                    [gidArray removeObject:_groupId];
                    [diskCache setObject:gidArray forKey:userGidKey];
                    [diskCache removeObjectForKey:disckCacheKey];
                    _grossViewClick = 0;
                    [weakself reloadTotalData];
                    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
                    
                    weakself.navigationItem.rightBarButtonItem = rightBarbutton;
                    
                }
            }
        }
    }];
}




#pragma mark - Action
//选T
-(void)SelectT:(id)sender{
    
    NSInteger selectPlayerIndex = 0;
    if (![sender isKindOfClass:[UIButton class]]) {
        selectPlayerIndex = [sender integerValue];
    }
    

    NSMutableArray *playerArray = [NSMutableArray array];
    NSMutableArray *playerImageArray = [NSMutableArray array];
    NSMutableArray *playerTColor = [NSMutableArray array];
    NSMutableArray *playerNameIdArray = [NSMutableArray array];
    
    NSArray *PlayerArray = [_dataDict objectForKey:@"playerArrayKey"];//球员数组

    for (int i = 0; i<PlayerArray.count; i++) {
        NSDictionary *playerDict = PlayerArray[i];
        NSString *nickname = [playerDict objectForKey:@"nickname"];
        NSString *pic = [playerDict objectForKey:@"pic"];
        NSString *nameId = [playerDict objectForKey:@"nameId"];
        NSString *Tcolor = [playerDict objectForKey:@"tcolor"];
        
        [playerNameIdArray addObject:nameId];
        [playerArray addObject:nickname];
        [playerImageArray addObject:pic];
        [playerTColor addObject:Tcolor];
    }
    UIView *grayBackView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.4) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [self.view addSubview:grayBackView];
    
    
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight - kHvertical(280), ScreenWidth, kHvertical(280))];
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(213,213,213,1) frame:CGRectMake(ScreenWidth/2 - kWvertical(89), kHvertical(32), kWvertical(178), 1)];
    
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(50), kHvertical(24), kWvertical(100), kHvertical(18)) textColor:rgba(155,155,155,1) fontSize:kHorizontal(13) Title:@"选择T的颜色"];
    [titleLabel setBackgroundColor:WhiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSArray *colorArray = @[rgba(68,68,68,1),rgba(255,200,74,1),rgba(1,144,255,1),rgba(249,249,249,1),rgba(237,87,55,1)];
    NSMutableArray *playerColorArray = [NSMutableArray array];
    for (int i = 0; i<playerArray.count; i++) {
        if ([playerTColor[i] isEqualToString:@"0"]) {
            [playerColorArray addObject:rgba(68,68,68,1)];
        }else if ([playerTColor[i] isEqualToString:@"1"]){
            [playerColorArray addObject:rgba(255,200,74,1)];
        }else if ([playerTColor[i] isEqualToString:@"2"]){
            [playerColorArray addObject:rgba(1,144,255,1)];
        }else if ([playerTColor[i] isEqualToString:@"3"]){
            [playerColorArray addObject:rgba(249,249,249,1)];
        }else if ([playerTColor[i] isEqualToString:@"4"]){
            [playerColorArray addObject:rgba(237,87,55,1)];
        }
    }
    
    NSArray *colorName = @[@"黑T",@"金T",@"蓝T",@"白T",@"红T"];
    
    _slectPlayerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, kHvertical(50), ScreenWidth, kHvertical(30))];
    for (int i = 0; i<playerArray.count; i++) {
        UIButton *playerBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/playerArray.count*i, 0, ScreenWidth/playerArray.count, kHvertical(30)) target:self selector:@selector(playerTClick:) Title:nil];
        playerBtn.tag = 100+i;
        
        UIView *circleView = [Factory createViewWithBackgroundColor:playerColorArray[i] frame:CGRectMake(0, 0, kHvertical(10), kHvertical(10))];
        
        UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(circleView.x_width + kWvertical(4), kHvertical(10), 20, kHvertical(20)) textColor:rgba(68,68,68,1) fontSize:kHorizontal(14) Title:playerArray[i]];
        [nameLabel sizeToFit];
        if (nameLabel.width > ScreenWidth/playerArray.count - kWvertical(10)- kWvertical(4) - kWvertical(20)) {
            nameLabel.width = ScreenWidth/playerArray.count - kWvertical(10)- kWvertical(4) - kWvertical(20);
        }
        
        circleView.frame = CGRectMake((ScreenWidth/playerArray.count - nameLabel.width - kHvertical(10) - kWvertical(4))/2, kHvertical(15), kHvertical(10), kHvertical(10));
        circleView.layer.masksToBounds = YES;
        circleView.layer.cornerRadius = kHvertical(5);
        
        if ([circleView.backgroundColor isEqual:rgba(249,249,249,1)]) {            
            circleView.layer.borderColor = rgba(217,217,217,1).CGColor;
            circleView.layer.borderWidth = 0.5;
        }
        
        nameLabel.frame = CGRectMake(circleView.x_width + kWvertical(4), kHvertical(10), nameLabel.width, kHvertical(20));

        UIView *lineView = [Factory createViewWithBackgroundColor:rgba(53,141,227,3) frame:CGRectMake( kWvertical(20),nameLabel.y_height + kHvertical(5), ScreenWidth/playerArray.count - kWvertical(40), 2)];
        lineView.hidden = YES;
        if (playerBtn.tag == _selectTag) {
            
            lineView.hidden = NO;
            lineView.backgroundColor = circleView.backgroundColor;
        }
        [playerBtn addSubview:circleView];
        [playerBtn addSubview:nameLabel];
        [playerBtn addSubview:lineView];
        [_slectPlayerView addSubview:playerBtn];
    }
    [backView addSubview:_slectPlayerView];
    
    for (int i = 0; i<5; i++) {
        UIButton *btn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/5 * i, kHvertical(102), ScreenWidth/5, kHvertical(100)) target:self selector:@selector(selectTClick:) Title:nil];
        btn.backgroundColor = ClearColor;
        UIView *cirlcleView = [Factory createViewWithBackgroundColor:colorArray[i] frame:CGRectMake(ScreenWidth/10 - kHvertical(18), kHvertical(20), kHvertical(36), kHvertical(36))];
        cirlcleView.layer.masksToBounds = YES;
        cirlcleView.layer.cornerRadius = kHvertical(18);
        UILabel *Tlabel = [Factory createLabelWithFrame:cirlcleView.frame textColor:WhiteColor fontSize:kHorizontal(19) Title:@"T"];
        [Tlabel setTextAlignment:NSTextAlignmentCenter];
        Tlabel.hidden = YES;
        
        UILabel *coloName = [Factory createLabelWithFrame:CGRectMake(0, cirlcleView.y_height + kHvertical(12), btn.width, kHvertical(18)) textColor:rgba(136,136,136,1) fontSize:kHorizontal(13) Title:colorName[i]];
        [coloName setTextAlignment:NSTextAlignmentCenter];
        if (i == 3) {
            cirlcleView.layer.borderWidth = 1.0f;
            cirlcleView.layer.borderColor = rgba(217,217,217,1).CGColor;
            Tlabel.textColor = BlackColor;
        }

        cirlcleView.userInteractionEnabled = NO;

        if ([cirlcleView.backgroundColor isEqual:playerColorArray[_selectTag - 100]]) {
            Tlabel.hidden = NO;
        }
        [btn addSubview:cirlcleView];
        [btn addSubview:Tlabel];
        [btn addSubview:coloName];
        [backView addSubview:btn];
    }
    
    UIView *bottomLine = [Factory createViewWithBackgroundColor:rgba(207,207,207,1) frame:CGRectMake(0, kHvertical(231), ScreenWidth, 1)];
    UIButton *cancelBtn = [Factory createButtonWithFrame:CGRectMake(0, kHvertical(231), kWvertical(60), kHvertical(48)) titleFont:kHvertical(15) textColor:rgba(91,91,91,1) backgroundColor:ClearColor target:self selector:@selector(searchBarCancelButtonClicked:) Title:@"取消"];
    UIButton *sureBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(74),cancelBtn.y + kHvertical(11), kWvertical(63), kHvertical(26)) titleFont:kHorizontal(15) textColor:rgba(255,255,255,1) backgroundColor:rgba(53,141,227,1) target:self selector:@selector(sureBtnClick) Title:@"确认"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = kHvertical(3);
    __weak __typeof(self)weakSelf = self;
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf sureBtnClick];
    }];
    grayBackView.userInteractionEnabled = YES;
    [grayBackView addGestureRecognizer:tgp];
    _grayBackView = grayBackView;
    [backView addSubview:lineView];
    [backView addSubview:titleLabel];
    [backView addSubview:cancelBtn];
    [backView addSubview:sureBtn];
    [backView addSubview:bottomLine];
    
    [grayBackView addSubview:backView];
    
    
    UIButton *playerSelectButton = (UIButton *)[self.view viewWithTag:100+selectPlayerIndex];
    [self playerTClick:playerSelectButton];
}


//返回
-(void)leftBtnClick{
    if (_needPopHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        if (_status == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            BOOL isPush = false;
            for(UIViewController *controller in self.navigationController.viewControllers) {
                NSString *className =NSStringFromClass([controller class]);
                NSLog(@"--className--%@",className);
                if([controller isKindOfClass:[ScorRecordViewController class]]){
                    ScorRecordViewController *viewCon = (ScorRecordViewController *)controller;
                    [self.navigationController popToViewController:viewCon animated:YES];
                    isPush = true;
                }
            }
            if (!isPush) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }

}

//确认
-(void)rightBtnClick{
    
    if (_status == 3&&[_nameUid isEqualToString:userDefaultUid]){
        
        UIImageView *testImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, kHvertical(56), kHvertical(56)) Image:nil];
        
        if (_headerImage) {
            [_HUD removeFromSuperview];
            [self saveProgressPhoto];
        }else{
            
            [testImageView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _headerImage = testImageView.image;
                
                [_HUD removeFromSuperview];
                [self saveProgressPhoto];
            }];
            
        }

    }else{
        [self showAlertView];
    }
    
}
//本地成绩照片保存
-(void)saveProgressPhoto{
    
    [self createShareOtherView];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_shareBackView.bounds.size.width-2,_shareBackView.bounds.size.height), YES, 2);
    [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    _mainScrollView.y = 64;
    _mainScrollView.height = ScreenHeight - 64- kHvertical(65);
    [self.view addSubview:_mainScrollView];

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest creationRequestForAssetFromImage:img];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            });
        }else{
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            
            if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                
                //无权限
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开iPhone中的\n设置-隐私-照片\n选项中，允许打球去访问你的手机相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                    [alertView show];
                });
                
            }
        }
    }];
}


//确认提示
-(void)showAlertView{

    __weak typeof(self) weakself = self;
    
    NSArray *playerArray = [_dataDict objectForKey:@"playerArrayKey"];//球员数组
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];
    NSArray *poleName    = [_dataDict objectForKey:@"poleNameKey"];
    NSInteger playerNum = playerArray.count;
    
    //    NSMutableArray *puttersArray = [NSMutableArray array];
    NSMutableArray *poleNameUnWrite   = [NSMutableArray array];
    NSMutableArray *poleNumUnWrite   = [NSMutableArray array];
    BOOL puttersCan = false;
    BOOL grossCan = false;
    for (int i = 0; i<playerNum; i++) {
        NSMutableArray *onePoleNameUnWrite   = [NSMutableArray array];
        NSMutableArray *onePoleNumUnWrite   = [NSMutableArray array];
        NSInteger putterZerow = 0;
        NSInteger grossNum = 0;
        NSMutableArray *oneGrossArray = [NSMutableArray array];
        NSMutableArray *onePuttersArray = [NSMutableArray array];
        for (int j = 0; j<18; j++) {
            
            NSDictionary *poleDict = [_dataDict objectForKey:[NSString stringWithFormat:@"pole%d",j+1]];
            //            NSString *par = [poleDict objectForKey:@"par"];
            NSArray *pArray = [poleDict objectForKey:@"p"];
            NSDictionary *playerDataDict = pArray[i];
            NSString *Gross = [playerDataDict objectForKey:@"r"];
            NSString *Putters = [playerDataDict objectForKey:@"pr"];
            if ([selectArray containsObject:[NSString stringWithFormat:@"%d",j+1]]) {
                [oneGrossArray addObject:Gross];
                [onePuttersArray addObject:Putters];
                if ([Putters isEqualToString:@"0"]) {
                    putterZerow++;
                    [onePoleNameUnWrite addObject:poleName[j]];
                    [onePoleNumUnWrite addObject:[NSString stringWithFormat:@"%d",j]];
                }
                grossNum = grossNum + [Gross integerValue];
            }
            
        }
        if (putterZerow<3&&putterZerow>0) {
            puttersCan = true;
            [poleNameUnWrite addObject:onePoleNameUnWrite];
            [poleNumUnWrite addObject:onePoleNumUnWrite];
        }
        if (grossNum<58) {
            grossCan = true;
        }
    }
    
    if (selectArray.count<18) {
        _alertView = [[GolvonAlertView alloc] initSureWithFrame:self.view.bounds title:@"您尚未完成所有记分，现在就确认成绩吗？" leftBtn:@"确定提交" right:@"暂不提交"];
        [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakself.alertView removeFromSuperview];
            
        }];
        
        
    }else if (grossCan) {
        _alertView = [[GolvonAlertView alloc] initSureWithFrame:self.view.bounds title:@"哇噻，你的成绩已创造高坛奇迹，也突破了平台极限，我们无法保存你的这次成绩！" leftBtn:@"确定提交" right:@"暂不提交"];
        [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakself.alertView removeFromSuperview];
            
        }];
        
        
    }else if (puttersCan){
        NSString *desc = [NSString string];
        
        for (NSArray *onePoleName in poleNameUnWrite) {
            
            for (int i = 0; i<onePoleName.count; i++) {
                if (desc.length>0) {
                    
                    desc = [NSString stringWithFormat:@"%@、%@",desc,onePoleName[1]];
                }else{
                    desc = [NSString stringWithFormat:@"%@",onePoleName[0]];
                }
            }
            break;
        }
        NSString *title = [NSString stringWithFormat:@"您有球洞未记录推杆!"];
        desc = [NSString stringWithFormat:@"（ %@ ）",desc];
        _alertView = [[GolvonAlertView alloc] initSureWithFrame:self.view.bounds title:title desc:desc leftBtn:@"确认成绩" right:@"返回修改"];
        [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakself.alertView removeFromSuperview];
            
            if (weakself.movetoPole != nil) {
                weakself.movetoPole(poleNumUnWrite[0][0]);
            }
            
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        _alertView = [[GolvonAlertView alloc] initSureWithFrame:self.view.bounds title:@"您已完成所有记分，现在确认成绩吗" leftBtn:@"确定" right:@"取消"];
        [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakself.alertView removeFromSuperview];
            
        }];
        
        
    }
    
    //确认成绩
    
    [_alertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakself.alertView removeFromSuperview];
        [weakself createHUD];
        [weakself clickPresShare];
        [userDefaults removeObjectForKey:@"moveToPoleNum"];
        
    }];
    
    [self.view addSubview:_alertView];

}
//继续推杆block
-(void)setBlock:(movetoPole)block{
    self.movetoPole = block;
}


//球员点击
-(void)playerTClick:(UIButton *)sender{
    _selectTag = sender.tag;
    for (int i = 0; i<_slectPlayerView.subviews.count; i++) {
        UIButton *backBtn = (UIButton *)[_slectPlayerView.subviews objectAtIndex:i];
        UIView *lineView = [backBtn.subviews objectAtIndex:3];
        lineView.hidden = YES;
    }
    UIView *circleView = [sender.subviews objectAtIndex:1];
    UIView *lineView = [sender.subviews objectAtIndex:3];
    lineView.backgroundColor = circleView.backgroundColor;
    lineView.hidden = NO;
    
    
    UIView *btnSuperView = sender.superview;
    UIView *alertView = btnSuperView.superview;
    for (int i = 0; i<5; i++) {
        UIButton *Btn = (UIButton *)[alertView.subviews objectAtIndex:i+1];
        UILabel *TLabel = (UILabel *)[Btn.subviews objectAtIndex:2];
        UIView *selecCircleView = [Btn.subviews objectAtIndex:1];
        TLabel.hidden = YES;
        if ([selecCircleView.backgroundColor isEqual:circleView.backgroundColor]) {
            TLabel.hidden = NO;
        }
    }
}

//选T点击
-(void)selectTClick:(UIButton *)btn{
    UIView *btnSuperView = btn.superview;
    for (int i = 0; i<5; i++) {
        UIButton *Btn = (UIButton *)[btnSuperView.subviews objectAtIndex:i+1];
        UILabel *TLabel = (UILabel *)[Btn.subviews objectAtIndex:2];
        TLabel.hidden = YES;
    }
    
    UIView *circleView = [btn.subviews objectAtIndex:1];
    UILabel *TLabel = (UILabel *)[btn.subviews objectAtIndex:2];
    UILabel *colorNamelabel = (UILabel *)[btn.subviews objectAtIndex:3];
    TLabel.hidden = NO;
    
    NSString *TStr = colorNamelabel.text;
    NSString *colorStr = @"0";

    if ([TStr isEqualToString:@"白T"]) {
        [TLabel setTextColor:BlackColor];
        [circleView setBackgroundColor:rgba(249,249,249,1)];
        
        colorStr = @"3";
    }else if ([TStr isEqualToString:@"金T"]){
        [circleView setBackgroundColor:rgba(255,200,74,1)];
        colorStr = @"1";
    }else if ([TStr isEqualToString:@"蓝T"]){
        [circleView setBackgroundColor:rgba(1,144,255,1)];
        colorStr = @"2";
    }else if ([TStr isEqualToString:@"红T"]){
        [circleView setBackgroundColor:rgba(237,87,55,1)];
        colorStr = @"4";
    }
    
    
    UIButton *backBtn = (UIButton *)[_slectPlayerView.subviews objectAtIndex:_selectTag - 100];
    UIView *titleCircleView = [backBtn.subviews objectAtIndex:1];
//    UILabel *nameLabel = [backBtn.subviews objectAtIndex:2];
    UIView *lineView = [backBtn.subviews objectAtIndex:3];
    

    [_playerTArray replaceObjectAtIndex:_selectTag-100 withObject:colorStr];
    titleCircleView.backgroundColor = circleView.backgroundColor;
    lineView.backgroundColor = circleView.backgroundColor;
    
}

//分享
-(void)shareClick:(UIButton *)sender{
    NSInteger Tag = sender.tag;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.alpha = 0.5;
    HUD.mode = MBProgressHUDModeIndeterminate;

    
    UIImageView *testImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, kHvertical(56), kHvertical(56)) Image:nil];

    if (_headerImage) {
        [HUD removeFromSuperview];
        [self imageLoadEnd:Tag];
    }else{
        [testImageView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]]];
        
        _headerImage = testImageView.image;
        
            [HUD removeFromSuperview];
            [self imageLoadEnd:Tag];
    }
}

-(void)imageLoadEnd:(NSInteger)Tag{
    
    [self createShareOtherView];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_shareBackView.bounds.size.width-2,_shareBackView.bounds.size.height), YES, 2);
    [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    _mainScrollView.y = 64;
    _mainScrollView.height = ScreenHeight - 64- kHvertical(65);
    [self.view addSubview:_mainScrollView];

    switch (Tag) {
        case 200:{
            PublishPhotoViewController *vc = [[PublishPhotoViewController alloc] init];

            NSMutableArray *imageIds = [NSMutableArray array];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //写入图片到相册
                PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:img];
                //记录本地标识，等待完成后取到相册中的图片对象
                [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
                
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                NSLog(@"success = %d, error = %@", success, error);
                
                if (success)
                {
                    //成功后取相册中的图片对象
                    __block PHAsset *imageAsset = nil;
                    __weak typeof(self) weakself = self;

                    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        imageAsset = obj;
                        *stop = YES;
                        
                    }];
                    
                    if (imageAsset)
                    {
                        UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(240, 420) sizeOfImage:img];
                        
                        NSData *iconData =  UIImageJPEGRepresentation(sharImage,0.9);
                        
                        UIImage *iconImage = [UIImage imageWithData:iconData];
                        vc.dataArry = [NSMutableArray arrayWithObjects:iconImage,@"PublishAdd", nil];
                        vc.photoImageArray = [NSMutableArray arrayWithObjects:imageAsset, nil];
                        vc.popStaticsView = true;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself.navigationController pushViewController:vc animated:YES];
                        });

                    }
                }else{
                    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                    
                    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                        
                        //无权限
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开iPhone中的\n设置-隐私-照片\n选项中，允许打球去访问你的手机相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            [alertView show];
                        });
                        
                    }
                }
            }];
            
        }break;
        case 201:{
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *ext = [WXImageObject object];
            
            ext.imageData =  UIImageJPEGRepresentation(img,0.8);
            message.mediaObject = ext;
            
            UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700*img.size.width/img.size.height, 700) sizeOfImage:img];
            message.thumbData =  UIImageJPEGRepresentation(sharImage,0.1);
            GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
            resp.message = message;
            resp.bText = NO;
            [WXApi sendResp:resp];
        }break;
        case 202:{
            
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *ext = [WXImageObject object];
            
            ext.imageData =  UIImageJPEGRepresentation(img,0.8);
            message.mediaObject = ext;
            UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700*img.size.width/img.size.height, 700) sizeOfImage:img];
            message.thumbData =  UIImageJPEGRepresentation(sharImage,0.1);
            sendReq.message = message;
            sendReq.bText = NO;
            [WXApi sendReq:sendReq];
        }break;
        case 203:{
            if (![WeiboSDK isWeiboAppInstalled]) {
                //                [self showLoadSinaWeiboClient];
            }else {
                WBMessageObject *message = [WBMessageObject message];
                message.text = @"";
                // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
                WBImageObject *imageObject = [WBImageObject object];
                imageObject.imageData = UIImageJPEGRepresentation(img, 1.0);
                message.imageObject = imageObject;
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                [WeiboSDK sendRequest:request];
            }
            
            
        }break;

        default:
            break;
    }
}



//选T背景隐藏
-(void)searchBarCancelButtonClicked:(UIButton *)btn{
    [_grayBackView removeFromSuperview];
}

//确认修改
-(void)sureBtnClick{
    
    [self selectTsend];
    [_grayBackView removeFromSuperview];

    
}
//时间选择器选择
-(void)timeTitleClick:(UIButton *)btn{
    NSTimeInterval time=[_startTime doubleValue];//
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    _datePicker.maximumDate = [NSDate date];
    _datePicker.date = detaildate;
    
}

//时间选择取消
-(void)timeSelectCancel:(UIButton *)btn{
    UIView *btnSuperView = btn.superview.superview.superview;
    _startTime = [NSString string];
    [btnSuperView removeFromSuperview];
}

//时间选择确定
-(void)timeSelectSure:(UIButton *)btn{
    UIView *btnSuperView = btn.superview.superview.superview;
    
    [btnSuperView removeFromSuperview];
    if (!_startTime) {
        NSString *timeSp = [NSString stringWithFormat:@"%@", [_dataDict objectForKey:@"time"]];
        _startTime =timeSp;
    }
    
    [self changeStartTime];
}

//时间选择器数据变化
-(void)datePickerChange:(id)sender{
    UIDatePicker * control = (UIDatePicker *)sender;
    NSDate *date=[control date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    _startTime = timeSp;
}








#pragma mark - 数据本地保存

-(void)saveData:(NSMutableDictionary *)mDict{

    _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
    [diskCache setObject:_dataDict forKey:disckCacheKey];

}

#pragma mark - Other
//格式化时间
-(NSString *)TimeStamp:(NSString *)strTime{
    

    
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
//秒转时间
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@小时%@分钟",str_hour,str_minute];
    
    if ([str_hour integerValue]>11||[str_hour integerValue]<1) {
        format_time = @"";
    }
    
    //    if ([str_hour isEqualToString:@"00"]) {
    //        format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
    //        if ([str_minute isEqualToString:@"00"]){
    //            format_time = [NSString stringWithFormat:@"%@秒",str_second];
    //            if ([str_second isEqualToString:@"00"]){
    //                format_time = @"";
    //            }
    //        }
    //    }
    return format_time;
    
}
//富文本操作
-(UILabel *)AttributedStringLabel:(UILabel *)putLabel rang:(NSRange )changeRang changeColor:(UIColor *)changeColor{
    UILabel *testLabel = putLabel;
    

    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:testLabel.text];
    
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:changeColor
     
                          range:changeRang];
    
    testLabel.attributedText = AttributedStr;
    
    return testLabel;
}
//四舍五入
-(NSString *)Rounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
//跳转至系统
-(void)pushToSystem{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
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
