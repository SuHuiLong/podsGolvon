//
//  NewStatisticsViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewStatisticsViewController.h"
#import "GroupStatisticsViewController.h"
#import "WXApi.h"
#import "ImageTool.h"
#import "WeiboSDK.h"
#import "ScorRecordViewController.h"
#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"
#import <Photos/Photos.h>
#import<AssetsLibrary/AssetsLibrary.h>

#import "PublishPhotoViewController.h"

@interface NewStatisticsViewController (){
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
//总推杆
@property(nonatomic, copy)UILabel *totalPutterLabel;
//头部图
@property(nonatomic, copy)UIView *headerBackView;
//数据展示图
@property(nonatomic, copy)UIView  *DataShowView;
//选T按钮
@property(nonatomic, strong)UIButton *SlectTBtn;
//选T背景
@property(nonatomic, copy)UIView  *grayBackView;
//分享背景（只处理不展示）
@property(nonatomic, copy)UIView  *shareBackView;
//分享按钮背景（从下弹出）
@property(nonatomic, copy)UIView  *shareButtonBackView;
//慈善金额数组
@property(nonatomic,copy)NSArray  *moneyArray;
//确认成绩提交
@property(nonatomic,copy)GolvonAlertView *alertView;
//加载提示
@property(nonatomic,copy)MBProgressHUD *HUD;
//时间选择器
@property(nonatomic,strong)UIDatePicker *datePicker;
//比赛开始时间
@property(nonatomic,copy)NSString *startTime;
//确认成绩&&本地保存
@property(nonatomic,copy)UIBarButtonItem *rightBarbutton;

@end

@implementation NewStatisticsViewController

-(NSDictionary *)dataDict{
    if (_dataDict==nil) {
        _dataDict = [NSDictionary dictionary];
    }
    return _dataDict;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_status==1) {
        [self insertJustGroup];
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self resevNotic];
    [self createNavagationView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - createView
-(void)CreateView{
    
    [self createContentViewHeader];
    [self createContentView];
    
    //    [self createShareView];
    
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

//创建头部内容
-(void)createContentViewHeader{
    
    NSArray *colorArray = @[rgba(68,68,68,1),rgba(255,200,74,1),rgba(1,144,255,1),rgba(249,249,249,1),rgba(237,87,55,1)];
    NSArray *colorName = @[@"黑",@"金",@"蓝",@"白",@"红"];
    
    NSDictionary *parkData = [_dataDict objectForKey:@"qinfo"];
    NSDictionary *playerDict = [_dataDict objectForKey:@"playerArrayKey"][0];
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];//已选择洞号
    NSArray *poleNameArray = [_dataDict objectForKey:@"poleOrderArray"];//球洞号
    NSString *isSelect = [_dataDict objectForKey:@"isSelectKey"];//是否选择距标准杆
    
    NSString *nickname = [playerDict objectForKey:@"nickname"];
    NSString *pic = [playerDict objectForKey:@"pic"];
    NSString *parkName = [parkData objectForKey:@"qname"];
    for (int i = 0 ; i<poleNameArray.count; i++) {
        if (i==0) {
            parkName = [NSString stringWithFormat:@"%@(%@)",parkName,poleNameArray[i]];
        }else if (i==1){
            parkName = [NSString stringWithFormat:@"%@(%@/%@)",[parkData objectForKey:@"qname"],poleNameArray[0],poleNameArray[1]];
        }
    }
    
    NSString *Tcolor = [playerDict objectForKey:@"tcolor"];
    
    NSString *dataStr = [self TimeStamp:[_dataDict objectForKey:@"begainTime"]];//开始时间
    NSString *totalTime = [_dataDict objectForKey:@"gameduration"];
    if ([totalTime isEqualToString:@"-1"]) {
        totalTime = @"";
    }
    totalTime = [self getMMSSFromSS:totalTime];//比赛时间
    
    
    NSInteger totalGross = 0;
    NSInteger totalPutters = 0;
    for (int i = 1; i<19; i++) {
        NSDictionary *poleDict = [_dataDict objectForKey:[NSString stringWithFormat:@"pole%d",i]];
        NSArray *pArray = [poleDict objectForKey:@"p"];
        NSDictionary *playerDataDict = pArray[0];
        NSString *Gross = @"0";
        NSString *putters = [playerDataDict objectForKey:@"pr"];
        
        if ([selectArray containsObject:[NSString stringWithFormat:@"%d",i]]) {
            Gross = [playerDataDict objectForKey:@"r"];
        }
        if ([putters integerValue]>0) {
            totalPutters = totalPutters + [putters integerValue];
        }
        totalGross = totalGross+ [Gross integerValue];
    }
    
    UIImageView *headerImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(14), kHvertical(10), kHvertical(25), kHvertical(25)) Image:nil];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:pic]];
    [headerImageView setBackgroundColor:ClearColor];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = kHvertical(12.5);
    
    
    UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(headerImageView.x_width+kWvertical(5), kHvertical(13), kWvertical(10), kHvertical(18)) textColor:BlackColor fontSize:kHorizontal(13) Title:nickname];
    [nameLabel sizeToFit];
    
    UIView *colorView = [Factory createViewWithBackgroundColor:colorArray[[Tcolor integerValue]] frame:CGRectMake( kWvertical(16), kHvertical(17), kHvertical(12), kHvertical(12))];
    
    colorView.layer.borderColor = rgba(217,217,217,1).CGColor;
    colorView.layer.borderWidth = 0.5;
    colorView.layer.masksToBounds = YES;
    colorView.layer.cornerRadius = kHvertical(6);
    
    
    UILabel *colorLabel = [Factory createLabelWithFrame:CGRectMake(colorView.x_width+kWvertical(4), kHvertical(14.5), kWvertical(27), kHvertical(20)) textColor:BlackColor fontSize:kHorizontal(13) Title:[NSString stringWithFormat:@"%@T",colorName[[Tcolor integerValue]]]];
    [colorLabel sizeToFit];
    
    UIImageView *colorArrow = [Factory createImageViewWithFrame:CGRectMake(colorLabel.x_width+ kWvertical(2), kHvertical(21), kWvertical(8), kHvertical(5)) Image:[UIImage imageNamed:@"scoring向下角标"]];
    
    _SlectTBtn = [Factory createButtonWithFrame:CGRectMake(nameLabel.x_width, 0, colorArrow.x_width + kHvertical(3), kHvertical(50)) target:self selector:@selector(SelectT:) Title:nil];
    
    
    [_SlectTBtn addSubview:colorView];
    _SlectTBtn.userInteractionEnabled = NO;
    [_SlectTBtn addSubview:colorLabel];
    
    
    
    UIView *totalView = [Factory createViewWithBackgroundColor:rgba(85,162,252,1) frame:CGRectMake(ScreenWidth - kWvertical(13) - kHvertical(67), kHvertical(10), kHvertical(67), kHvertical(67))];
    
    totalView.userInteractionEnabled = YES;
    __weak typeof(self) weakself = self;
    
    UITapGestureRecognizer *totalViewGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_grossViewClick == 0) {
            _grossViewClick = 2;
            if ([isSelect isEqualToString:@"1"]) {
                _grossViewClick = 1;
            }
        } else if (_grossViewClick<2) {
            _grossViewClick = 2;
        }else{
            _grossViewClick = 1;
        }
        
        
        
        
        //        [weakself.mainScrollView removeAllSubviews];
        //        [weakself.mainScrollView removeFromSuperview];
        //        [weakself createContentView];
        
        [weakself.DataShowView removeAllSubviews];
        [weakself.headerBackView removeAllSubviews];
        [weakself.DataShowView removeFromSuperview];
        [weakself.headerBackView removeFromSuperview];
        [weakself createContentViewHeader];
        [weakself createContentView];
        
        
        //        if (_status==3&&[_nameUid isEqualToString:userDefaultUid]) {
        //            if (_grossViewClick>0) {
        //                [self createShareView];
        //            }
        //        }
    }];
    [totalView addGestureRecognizer:totalViewGesture];
    
    UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(7), totalView.width, kHvertical(17)) textColor:WhiteColor fontSize:kHorizontal(12) Title:@"总杆"];
    [Gross setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(23), totalView.width, kHvertical(37)) textColor:WhiteColor fontSize:kHorizontal(26) Title:[NSString stringWithFormat:@"%ld",totalGross]];
    [GrossLabel setTextAlignment:NSTextAlignmentCenter];
    [GrossLabel sizeToFit];
    GrossLabel.frame = CGRectMake(totalView.width/2 - GrossLabel.width/2 - kWvertical(4), kHvertical(23), GrossLabel.width, kHvertical(37));
    
    UILabel *PuttersLabel = [Factory createLabelWithFrame:CGRectMake(GrossLabel.x_width , kHvertical(25), kWvertical(20), kHvertical(14)) textColor:WhiteColor fontSize:kHorizontal(10) Title:[NSString stringWithFormat:@"%ld",totalPutters]];
    [PuttersLabel sizeToFit];
    
    GrossLabel.frame = CGRectMake(totalView.width/2 - GrossLabel.width/2 - PuttersLabel.width/2, kHvertical(23), GrossLabel.width, kHvertical(37));
    PuttersLabel.frame = CGRectMake(GrossLabel.x_width , kHvertical(25), PuttersLabel.width, kHvertical(14));
    
    [totalView addSubview:Gross];
    [totalView addSubview:GrossLabel];
    [totalView addSubview:PuttersLabel];
    
    _totalPutterLabel = PuttersLabel;
    
    UILabel *ParkLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(16),headerImageView.y_height + kHvertical(4), totalView.x - kWvertical(40), kHvertical(36)) textColor:BlackColor fontSize:kHvertical(13) Title:parkName];
    ParkLabel.numberOfLines = 0;
    
    UILabel *timeLabel = [Factory createLabelWithFrame:CGRectMake(_SlectTBtn.x_width, kHvertical(13), kWvertical(90), kHvertical(18)) textColor:rgba(128,128,128,1) fontSize:kHorizontal(13) Title:dataStr];
    [timeLabel sizeToFit];
    timeLabel.height = kHvertical(20);
    
    UILabel *totalLabel = [Factory createLabelWithFrame:CGRectMake(ParkLabel.x, ParkLabel.y_height+kHvertical(3), kWvertical(200), kHvertical(18)) textColor:rgba(128,128,128,1) fontSize:kHorizontal(13) Title:[NSString stringWithFormat:@"本场用时：%@", totalTime]];
    if ([totalTime isEqualToString:@""]) {
        totalLabel.text = @"";
    }
    
    UITapGestureRecognizer *timeSelectTgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGameBeganView)];
    
    UIView *timeSelectView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(timeLabel.x, 0, timeLabel.width, kHvertical(40))];
    timeSelectView.userInteractionEnabled = NO;
    [timeSelectView addGestureRecognizer:timeSelectTgp];
    
    UIView *line = [Factory createViewWithBackgroundColor:rgba(225,225,225,1) frame:CGRectMake(0,totalLabel.y_height + kHvertical(11), ScreenWidth, 0.5)];
    _headerBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 64, ScreenWidth, line.y_height+1)];
    
    EAFeatureItem *top;
    EAFeatureItem *bottom;
    
    top = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(_SlectTBtn.x, _SlectTBtn.y+64, _SlectTBtn.width, _SlectTBtn.height) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    top.imageFrame = CGRectMake(_SlectTBtn.x+20, _SlectTBtn.bottom+8+64, kWvertical(23), kWvertical(23));
    top.indicatorImageName = @"top_short";
    top.labelFrame = CGRectMake(_SlectTBtn.x-20, _SlectTBtn.bottom+40+64, kWvertical(108), kHvertical(35));
    top.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    top.introduce = @"选择发球台";
    
    
    bottom = [[EAFeatureItem alloc] initWithFocusRect:CGRectMake(timeLabel.x, timeLabel.y+64, timeLabel.width, timeLabel.height) focusCornerRadius:3 focusInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    bottom.imageFrame = CGRectMake(timeLabel.x+45,timeLabel.bottom+64+8, kWvertical(23), kWvertical(23));
    bottom.indicatorImageName = @"top_short";
    bottom.labelFrame = CGRectMake(timeLabel.x+20, timeLabel.bottom+64+40, kWvertical(120), kHvertical(35));
    bottom.introduceFont = [UIFont systemFontOfSize:kHorizontal(15)];
    bottom.introduce = @"更改开场日期";
    
    
    if (_status == 0) {
        _SlectTBtn.userInteractionEnabled = YES;
        [_SlectTBtn addSubview:colorArrow];
        timeSelectView.userInteractionEnabled = YES;
        
        [self.navigationController.view showWithFeatureItems:@[top,bottom] saveKeyName:@"sta" inVersion:nil];
    }
    
    [self.view addSubview:_headerBackView];
    [_headerBackView addSubview:headerImageView];
    [_headerBackView addSubview:nameLabel];
    [_headerBackView addSubview:_SlectTBtn];
    
    [_headerBackView addSubview:timeLabel];
    [_headerBackView addSubview:totalView];
    [_headerBackView addSubview:ParkLabel];
    [_headerBackView addSubview:totalLabel];
    [_headerBackView addSubview:timeSelectView];
    
    
}

//数据展示
-(void)createContentView{
    NSArray *showViewColorArray = @[rgba(252,206,47,1),rgba(252,206,47,1),rgba(237,117,76,1),rgba(85,162,252,1),rgba(245,245,245,1),rgba(245,245,245,1)];
    NSArray *showLabelTextArray = @[@"信天翁",@"老鹰球",@"小鸟球",@"标准杆",@"柏忌",@"双柏忌"];
    
    _DataShowView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, _headerBackView.y_height, ScreenWidth, ScreenHeight - _headerBackView.y_height)];
    NSInteger DataShowViewHeight = 0;
    NSMutableArray *PARStandardData = [NSMutableArray arrayWithArray: @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"]];
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];//已选择洞号
    NSString *isSelect = [_dataDict objectForKey:@"isSelectKey"];//是否选择距标准杆
    if (_grossViewClick==2) {
        isSelect = @"1";
    }else if(_grossViewClick==1){
        isSelect = @"0";
    }
    
    NSMutableArray *PARData  =  [NSMutableArray array];
    //总杆
    NSMutableArray *GrossArray = [NSMutableArray array];
    //推杆
    NSMutableArray *PuttersArray = [NSMutableArray array];
    
    NSMutableArray *DiffrendsArray = [NSMutableArray arrayWithArray:@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10"]];
    
    for (int i = 1; i<19; i++) {
        NSDictionary *poleDict = [_dataDict objectForKey:[NSString stringWithFormat:@"pole%d",i]];
        NSString *par = [poleDict objectForKey:@"par"];
        NSArray *pArray = [poleDict objectForKey:@"p"];
        NSDictionary *playerDataDict = pArray[0];
        NSString *Gross = [playerDataDict objectForKey:@"r"];
        NSString *Putters = [playerDataDict objectForKey:@"pr"];
        [PARData addObject:par];
        if ([selectArray containsObject:[NSString stringWithFormat:@"%d",i]]) {
            [GrossArray addObject:Gross];
            [PuttersArray addObject:Putters];
        }else{
            [GrossArray addObject:@""];
            [PuttersArray addObject:@""];
        }
    }
    BOOL HOLE_IN_ONE = NO;
    
    NSInteger OUT = 0;
    NSInteger IN = 0;
    NSInteger GrossOUT = 0;
    NSInteger GrossIN = 0;
    NSInteger PuttersOUT = 0;
    NSInteger PuttersIN = 0;
    
    for (int i = 0; i<9; i++) {
        NSInteger PARDataOUT = [PARData[i] integerValue];
        NSInteger GrossArrayOUT = [GrossArray[i] integerValue];
        NSInteger PuttersArrayOUT = [PuttersArray[i] integerValue];
        
        NSInteger PARDataIN = [PARData[i+9] integerValue];
        NSInteger GrossArrayIN = [GrossArray[i+9] integerValue];
        NSInteger PuttersArrayIN = [PuttersArray[i+9] integerValue];
        
        NSString *DiffrendsArrayOUT = [NSString stringWithFormat:@"%ld",(long)([GrossArray[i] integerValue] - [PARData[i] integerValue])];
        NSString *DiffrendsArrayIN = [NSString stringWithFormat:@"%ld",(long)([GrossArray[i+9] integerValue] - [PARData[i+9] integerValue])];
        
        
        
        OUT = OUT + PARDataOUT;
        GrossOUT = GrossOUT + GrossArrayOUT;
        PuttersOUT = PuttersOUT + PuttersArrayOUT;
        
        IN = IN + PARDataIN;
        GrossIN = GrossIN + GrossArrayIN;
        PuttersIN = PuttersIN + PuttersArrayIN;
        
        [DiffrendsArray replaceObjectAtIndex:i withObject:DiffrendsArrayOUT];
        [DiffrendsArray replaceObjectAtIndex:i+10 withObject:DiffrendsArrayIN];
        
        
        if (GrossArrayIN==1||GrossArrayOUT==1) {
            HOLE_IN_ONE = YES;
        }
        
    }
    
    NSArray *topArray = @[@"平均推杆：",@"标ON：",@"标ON率："];
    NSArray *topDataArray = [NSArray array];
    NSInteger averagePutters = 0;
    NSInteger markerNO = 0;
    NSInteger totalUnNo = 0;
    for (int i = 0; i<18; i++) {
        averagePutters  =  averagePutters +[PuttersArray[i] integerValue];
        
        
        NSInteger puttersDifference = [GrossArray[i] integerValue] - [PuttersArray[i] integerValue];//总杆与推杆的差
        NSInteger parDifference = [PARData[i] integerValue]-2;//标准杆减2
        
        //        if ([PuttersArray[i] integerValue]<=2) {
        if ([PuttersArray[i] integerValue]<=0) {
            totalUnNo++;
        }
        
        //        NSLog(@"%ld====%ld",puttersDifference,parDifference);
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
    
    
    
    
    
    topDataArray = [NSArray arrayWithObjects:averagePuttersStr,markerNOStr,markNOPercentage, nil];
    if (totalUnNo>2) {
        topDataArray = [NSArray array];
    }
    
    
    [PARStandardData insertObject:@"OUT" atIndex:9];
    [PARStandardData insertObject:@"IN" atIndex:19];
    
    [PARData insertObject:[NSString stringWithFormat:@"%ld",OUT] atIndex:9];
    [PARData insertObject:[NSString stringWithFormat:@"%ld",IN] atIndex:19];
    
    [GrossArray insertObject:[NSString stringWithFormat:@"%ld",GrossOUT] atIndex:9];
    [GrossArray insertObject:[NSString stringWithFormat:@"%ld",GrossIN] atIndex:19];
    
    [PuttersArray insertObject:[NSString stringWithFormat:@"%ld",PuttersOUT] atIndex:9];
    [PuttersArray insertObject:[NSString stringWithFormat:@"%ld",PuttersIN] atIndex:19];
    
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
                NSString *showLabelStr = DiffrendsArray[i];
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
    
    
    
    UIView *topLine = [Factory createViewWithBackgroundColor:rgba(226,226,226,1) frame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_DataShowView addSubview:topLine];
    
    
    for (int i = 0; i<3; i++) {
        if (topDataArray.count>0) {
            UILabel *topLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i + kWvertical(10), kHvertical(19), ScreenWidth/3 - kWvertical(20), kHvertical(18)) textColor:BlackColor fontSize:kHorizontal(13) Title:[NSString stringWithFormat:@"%@%@",topArray[i],topDataArray[i]]];
            [topLabel setTextAlignment:NSTextAlignmentCenter];
            if (_status == 3) {
                [_DataShowView addSubview:topLabel];
            }
            
            if (i>0) {
                UIView *linView = [Factory createViewWithBackgroundColor:rgba(226,226,226,1) frame:CGRectMake(ScreenWidth/3*i - 0.5, kHvertical(23), 1, kHvertical(11))];
                if (_status == 3) {
                    [_DataShowView addSubview:linView];
                }
            }
        }else{
            if (_status==3) {
                _totalPutterLabel.text = @"0";
            }
        }
    }
    //前后9洞数据是否需要颠倒
    NSString *islast9 = [_dataDict objectForKey:@"islast9"];
    BOOL begainPOle = false;
    if ([islast9 isEqualToString:@"1"]) {
        begainPOle = true;
    }
    if (begainPOle) {
        NSArray *testPARData = PARData;
        NSArray *testGrossArray = GrossArray;
        NSArray *testPuttersArray = PuttersArray;
        NSArray *testDiffrendsArray = DiffrendsArray;
        
        PARData = [NSMutableArray array];
        GrossArray = [NSMutableArray array];
        PuttersArray = [NSMutableArray array];
        DiffrendsArray = [NSMutableArray array];
        
        for (int i = 1; i>-1; i--) {
            for (int j = 0; j<10; j++) {
                [PARData addObject:testPARData[10*i+j]];
                [GrossArray addObject:testGrossArray[10*i+j]];
                [PuttersArray addObject:testPuttersArray[10*i+j]];
                [DiffrendsArray addObject:testDiffrendsArray[10*i+j]];
            }
        }
    }
    
    for (int i = 0; i<2; i++) {
        NSInteger TotalNum = 0;
        
        
        UIView *BlueBackView = [Factory createViewWithBackgroundColor:rgba(53,141,227,0.12)frame:CGRectMake(kWvertical(14), kHvertical(55) + (kHvertical(96) +kWvertical(27))*i, ScreenWidth - kWvertical(28), kHvertical(58))];
        [_DataShowView addSubview:BlueBackView];
        
        for (int j = 0; j<10; j++) {
            UILabel *PAR = [Factory createLabelWithFrame:CGRectMake(kWvertical(14) + BlueBackView.width/10*j, BlueBackView.y, BlueBackView.width/10, kHvertical(29)) textColor:rgba(54,54,54,1) fontSize:kHorizontal(13) Title:PARStandardData[j + 10*i]];
            [PAR setTextAlignment:NSTextAlignmentCenter];
            
            NSString *parStr = PARData[j + 10*i];
            UILabel *UserPAR = [Factory createLabelWithFrame:CGRectMake(kWvertical(14) + BlueBackView.width/10*j, PAR.y_height, BlueBackView.width/10, kHvertical(29)) textColor:rgba(154,154,154,1) fontSize:kHorizontal(13) Title:parStr];
            [UserPAR setTextAlignment:NSTextAlignmentCenter];
            
            
            UIView *circleView = [Factory createViewWithBackgroundColor:showViewColorArray[4] frame:CGRectMake(BlueBackView.x + kWvertical(4) + UserPAR.width*j ,BlueBackView.y_height + kHvertical(8),UserPAR.width - kWvertical(8),  UserPAR.width - kWvertical(8))];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = (UserPAR.width - kWvertical(8))/2;
            
            
            //当前球洞的数据
            NSString *poleStr =  [[NSString alloc] initWithFormat:@"%@",GrossArray[j+10*i]];
            
            if ([isSelect isEqualToString:@"1"]&&[poleStr integerValue]>0){
                if(j!=9) {
                    poleStr = [NSString stringWithFormat:@"%ld",[poleStr integerValue] - [parStr integerValue]];
                    if (j<9) {
                        TotalNum = TotalNum + [poleStr integerValue];
                    }
                    if ([poleStr integerValue]>0) {
                        poleStr = [NSString stringWithFormat:@"+%@",poleStr];
                    }
                }else if (j==9) {
                    poleStr = [NSString stringWithFormat:@"%ld",TotalNum];
                    if (TotalNum>0) {
                        poleStr = [NSString stringWithFormat:@"+%@",poleStr];
                    }
                }
            }
            
            if (poleStr.length==1) {
                poleStr = [NSString stringWithFormat:@" %@",poleStr];
            }
            
            UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(UserPAR.x, BlueBackView.y_height+ kHvertical(8), UserPAR.width, circleView.height) textColor:BlackColor fontSize:kHorizontal(15) Title:poleStr];
            [Gross setTextAlignment:NSTextAlignmentCenter];
            
            [Gross sizeToFit];
            Gross.frame = CGRectMake(circleView.x + (circleView.width -Gross.width)/2, BlueBackView.y_height+ kHvertical(8), Gross.width, circleView.height);
            
            NSString *puttersTitle = [NSString string];
            if (poleStr.length>0) {
                puttersTitle = PuttersArray[j+10*i];
                if ([puttersTitle integerValue] <=0) {
                    puttersTitle = @"0";
                }
            }
            
            UILabel *Putters = [Factory createLabelWithFrame:CGRectMake(Gross.x_width, kHvertical(2)+circleView.y, kWvertical(20), kHvertical(11)) fontSize:kHvertical(8) Title:puttersTitle];
            [Putters sizeToFit];
            
            Gross.x = circleView.x + (circleView.width -Gross.width - Putters.width)/2;
            Putters.x = Gross.x_width;
            
            if (j==9) {
                circleView.backgroundColor = WhiteColor;
                Gross.textColor = BlackColor;
                Putters.textColor = BlackColor;
                
                PAR.frame = CGRectMake(kWvertical(14) + BlueBackView.width/10*j - kWvertical(2), BlueBackView.y, BlueBackView.width/10, kHvertical(29));
                
                UserPAR.frame = CGRectMake(kWvertical(14) + BlueBackView.width/10*j - kWvertical(2), PAR.y_height, BlueBackView.width/10, kHvertical(29));
                
                Gross.x = circleView.x;
                Putters.frame = CGRectMake(Gross.x_width, kHvertical(2)+circleView.y, kWvertical(20), kHvertical(11));
                
            }
            NSInteger diffrent = [DiffrendsArray[j+10*i] integerValue];
            
            NSInteger totalColor = showViewColorArray.count;
            if (diffrent<=0) {
                [Gross setTextColor:WhiteColor];
                [Putters setTextColor:WhiteColor];
                circleView.backgroundColor = showViewColorArray[totalColor-3];
                if (diffrent<=-1){
                    circleView.backgroundColor = showViewColorArray[totalColor-4];
                    if (diffrent<-1){
                        circleView.backgroundColor = showViewColorArray[totalColor-5];
                    }
                }
            }
            
            if ([GrossArray[10*i+j] isEqualToString:@""]) {
                circleView.backgroundColor = ClearColor;
                Gross.textColor = BlackColor;
                Putters.textColor = BlackColor;
            }else if ([GrossArray[10*i+j] isEqualToString:@"0"]){
                circleView.backgroundColor = ClearColor;
                Gross.textColor = ClearColor;
                Putters.textColor = ClearColor;
            }
            
            
            [_DataShowView addSubview:PAR];
            [_DataShowView addSubview:UserPAR];
            [_DataShowView addSubview:circleView];
            [_DataShowView addSubview:Gross];
            [_DataShowView addSubview:Putters];
            
            if (j<4) {
                UIView *levelLine = [Factory createViewWithBackgroundColor:rgba(226,232,238,1) frame:CGRectMake(BlueBackView.x, BlueBackView.y + kHvertical(29)*j, BlueBackView.width, 1)];
                if (j==3) {
                    levelLine.frame = CGRectMake(BlueBackView.x, circleView.y_height + kHvertical(7), BlueBackView.width, 1);
                }
                [_DataShowView addSubview:levelLine];
            }
            if (j<2) {
                UIView *verticalLine = [Factory createViewWithBackgroundColor:rgba(239,239,239,1) frame:CGRectMake(BlueBackView.x + BlueBackView.width*j , BlueBackView.y, 1, kHvertical(73) +kWvertical(27))];
                [_DataShowView addSubview:verticalLine];
            }
            NSInteger showLabelArrayCount = showLabelArray.count;
            if (i==1&&j<showLabelArrayCount) {
                CGFloat showY = 0;
                UIImageView *trophyView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(17), circleView.y_height + kHvertical(7)+kHvertical(17), kWvertical(34), kHvertical(36)) Image:[UIImage imageNamed:@"scoring一杆进洞"]];
                UILabel *HOLE_IN_ONELabel = [Factory createLabelWithFrame:CGRectMake(0, trophyView.y_height + kHvertical(4), ScreenWidth, kHvertical(14)) textColor:BlackColor fontSize:kHorizontal(10.0f) Title:@"一杆进洞"];
                [HOLE_IN_ONELabel setTextAlignment:NSTextAlignmentCenter];
                if (HOLE_IN_ONE) {
                    if (j==0) {
                        [_DataShowView addSubview:trophyView];
                        [_DataShowView addSubview:HOLE_IN_ONELabel];
                    }
                    showY = kHvertical(77);
                }
                
                UILabel *showlabel = [Factory createLabelWithFrame:CGRectMake(BlueBackView.x + BlueBackView.width/showLabelArrayCount*j ,  circleView.y_height + kHvertical(7) + kHvertical(17) + showY, BlueBackView.width/showLabelArrayCount, kWvertical(24)) textColor:WhiteColor fontSize:kHvertical(13) Title:showLabelArray[j]];
                [showlabel setTextAlignment:NSTextAlignmentCenter];
                
                UIView *showView = [Factory createViewWithBackgroundColor:showViewColorArray[j] frame:CGRectMake(showlabel.x + (showlabel.width - kWvertical(24))/2, showlabel.y,  kWvertical(24), kWvertical(24))];
                showView.layer.masksToBounds = YES;
                showView.layer.cornerRadius = kWvertical(12);
                if (j>showLabelArray.count-3) {
                    [showlabel setTextColor:rgba(95,95,95,1)];
                }
                UILabel *showName = [Factory createLabelWithFrame:CGRectMake(showlabel.x, showView.y_height + kHvertical(10), showlabel.width, kHvertical(14)) textColor:rgba(67,67,67,1) fontSize:kHorizontal(10) Title:showLabelTextArray[j]];
                [showName setTextAlignment:NSTextAlignmentCenter];
                DataShowViewHeight = showName.y_height;
                [_DataShowView addSubview:showView];
                [_DataShowView addSubview:showlabel];
                [_DataShowView addSubview:showName];
            }
        }
    }
    
    NSArray *shareIcon = @[@"scoring-groundIcon",@"scoring-wxfriends",@"scoring-Friendster",@"scoing-weibo"];
    NSArray *shareTitle = @[@"球友圈",@"微信好友",@"朋友圈",@"微博"];
    NSArray *shareIconEdg = @[@"22",@"28",@"22",@"29"];
    if (_status==3&&[_nameUid isEqualToString:userDefaultUid]) {
        [_shareButtonBackView removeFromSuperview];
        
        _shareButtonBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(65))];
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
            
            [_shareButtonBackView addSubview:sharBtn];
        }
        [self.view addSubview:_shareButtonBackView];
        
        if (_grossViewClick>0) {
            _shareButtonBackView.frame = CGRectMake(0, ScreenHeight - kHvertical(65), ScreenWidth, kHvertical(65));
        }else{
            [UIView animateWithDuration:1.0f animations:^{
                _shareButtonBackView.frame = CGRectMake(0, ScreenHeight - kHvertical(65), ScreenWidth, kHvertical(65));
            }];
        }
        _DataShowView.height = DataShowViewHeight;
    }
    [self.view addSubview:_DataShowView];
    [self createALertBestView];

}
// 创建分享界面
-(void)createShareView{
    _headerBackView.y = 0;
    _DataShowView.y = _DataShowView.y - 64;
    
    _shareBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 64, ScreenWidth+kWvertical(46), ScreenHeight*2)];
    
    UIView *shareBackView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(kWvertical(23), kHvertical(38), ScreenWidth, ScreenHeight)];
    
    
    NSArray *money = _moneyArray;
    
    UIView *imageView = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth-kWvertical(56))/2, _DataShowView.y_height + kHvertical(32), kWvertical(56), kWvertical(56)) Image:[UIImage imageNamed:@"scoing-downloadicon"]];
    UIImageView *golvonText = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth-kWvertical(56))/2, imageView.y_height+kHvertical(10), kWvertical(56), kHvertical(21)) Image:[UIImage imageNamed:@"scoring-golvonText"]];
    
    UILabel *publichBenifit = [Factory createLabelWithFrame:CGRectMake(0, golvonText.y_height + kHvertical(19), ScreenWidth, kHvertical(24)) textColor:rgba(34,34,34,1) fontSize:kHorizontal(17) Title:@"打球记分也能做公益"];
    [publichBenifit setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *indexLabel = [Factory createLabelWithFrame:CGRectMake(0, publichBenifit.y_height + kHvertical(12), ScreenWidth, kHvertical(19)) textColor:rgba(103,103,103,1) fontSize:kHorizontal(13.5) Title:[NSString stringWithFormat:@"本场捐出：%@元",money[0]]];
    indexLabel = [self AttributedStringLabel:indexLabel rang:NSMakeRange(5, indexLabel.text.length-6) changeColor:localColor];
    [indexLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    UILabel *totalLabel = [Factory createLabelWithFrame:CGRectMake(0, indexLabel.y_height, ScreenWidth, kHvertical(19)) textColor:rgba(103,103,103,1) fontSize:kHorizontal(13.5) Title:[NSString stringWithFormat:@"累计捐助：%@元",money[1]]];
    [totalLabel setTextAlignment:NSTextAlignmentCenter];
    totalLabel = [self AttributedStringLabel:totalLabel rang:NSMakeRange(5, totalLabel.text.length-6) changeColor:localColor];
    
    
    shareBackView.height = totalLabel.y_height + kHvertical(32);
    _shareBackView.height = shareBackView.y_height ;
    
    [shareBackView addSubview:_headerBackView];
    [shareBackView addSubview:_DataShowView];
    
    [shareBackView addSubview:imageView];
    [shareBackView addSubview:golvonText];
    [shareBackView addSubview:publichBenifit];
    [shareBackView addSubview:indexLabel];
    [shareBackView addSubview:totalLabel];
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
        [self CreateView];
    }else{
        [self reloadTotalData];
        
    }
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
                            
                            requestDict = @{
                                            @"pr":[poleIndexDict objectForKey:@"pushrod"],
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
                if (vcStatus!=_status) {
                    _needPopHome = YES;
                }
                
                _status = vcStatus;
                _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
                
                if (!_DataShowView) {
                    [self CreateView];
                }
                if (_status == 3&&[_nameUid isEqualToString:userDefaultUid]){
                    self.navigationItem.rightBarButtonItem = _rightBarbutton;
                    [_rightBarbutton setTitle:@"本地保存"];
                    
                }
                
                [_DataShowView removeAllSubviews];
                [_headerBackView removeAllSubviews];
                [_DataShowView removeFromSuperview];
                [_headerBackView removeFromSuperview];
                [self createContentViewHeader];
                [self createContentView];
                
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
                    [_DataShowView removeAllSubviews];
                    [_headerBackView removeAllSubviews];
                    [_DataShowView removeFromSuperview];
                    [_headerBackView removeFromSuperview];
                    [self createContentViewHeader];
                    [self createContentView];
                }
            }
        }
        _HUD.hidden = YES;
    }];
}


//选T提交
-(void)selectTsend:(NSInteger)index{
    NSMutableArray *playerNameIdArray = [NSMutableArray array];
    NSArray *playerArray = [_dataDict objectForKey:@"playerArrayKey"];//球员数组
    NSMutableArray *mPlayerArray = [NSMutableArray array];
    for (int i = 0; i<playerArray.count; i++) {
        NSMutableDictionary *playerDict = [NSMutableDictionary dictionaryWithDictionary:playerArray[i]];
        NSString *nameId = [playerDict objectForKey:@"nameId"];
        [playerNameIdArray addObject:nameId];
        [playerDict setValue:[NSString stringWithFormat:@"%ld",index-1] forKey:@"tcolor"];
        [mPlayerArray addObject:playerDict];
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_dataDict];
    [mDict setValue:mPlayerArray forKey:@"playerArrayKey"];
    
    [self saveData:mDict];
    //    t  uid:t值列表，用逗号分隔，比如:  5:0,9:2,15:4
    NSString *selectId = [NSString stringWithFormat:@"%@:%ld",userDefaultUid,index-1];
    
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"gid":_groupId,
                           @"t":selectId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=updatetcolor",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        
    }];
}

//提交18洞
-(void)clickPresShare{
    NSArray *selectArray = [_dataDict objectForKey:@"selectArrayKey"];//已选择洞号
    NSString *isSelect = [_dataDict objectForKey:@"isSelectKey"];
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
    
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=score",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        NSLog(@"%@",data);
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                if ([code isEqualToString:@"0"]) {
                    [self sureAchievement];
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
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=endofgame",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        [_HUD removeFromSuperview];
        
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
                    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
                    NSString *userGidKey = [NSString stringWithFormat:@"%@_gids",userDefaultUid];
                    
                    NSMutableArray *gidArray = (NSMutableArray *)[diskCache objectForKey:userGidKey];
                    [gidArray removeObject:_groupId];
                    if (gidArray.count>0) {
                        [diskCache setObject:gidArray forKey:userGidKey];
                        [diskCache removeObjectForKey:disckCacheKey];
                    }
                });
                _grossViewClick = 0;
                [self reloadTotalData];
                UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
                self.navigationItem.rightBarButtonItem = rightBarbutton;
            }
        }
    }];
}

#pragma mark - Action
//选T
-(void)SelectT:(UIButton *)selectBtn{
    UIView *grayBackView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.4) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [self.view addSubview:grayBackView];
    
    
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight - kHvertical(225), ScreenWidth, kHvertical(225))];
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(213,213,213,1) frame:CGRectMake(ScreenWidth/2 - kWvertical(89), kHvertical(32), kWvertical(178), 1)];
    
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2 - kWvertical(50), kHvertical(24), kWvertical(100), kHvertical(18)) textColor:rgba(155,155,155,1) fontSize:kHorizontal(13) Title:@"选择T的颜色"];
    [titleLabel setBackgroundColor:WhiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSArray *colorArray = @[rgba(68,68,68,1),rgba(255,200,74,1),rgba(1,144,255,1),rgba(249,249,249,1),rgba(237,87,55,1)];
    NSArray *colorName = @[@"黑",@"金",@"蓝",@"白",@"红"];
    for (int i = 0; i<5; i++) {
        UIButton *btn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/5 * i, kHvertical(50), ScreenWidth/5, kHvertical(100)) target:self selector:@selector(selectTClick:) Title:nil];
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
        [btn addSubview:cirlcleView];
        [btn addSubview:Tlabel];
        [btn addSubview:coloName];
        [backView addSubview:btn];
    }
    
    UIView *bottomLine = [Factory createViewWithBackgroundColor:rgba(207,207,207,1) frame:CGRectMake(0, kHvertical(177), ScreenWidth, 1)];
    UIButton *cancelBtn = [Factory createButtonWithFrame:CGRectMake(0, kHvertical(177), ScreenWidth, kHvertical(48)) titleFont:kHvertical(16) textColor:BlackColor backgroundColor:rgba(249,249,249,1) target:self selector:@selector(searchBarCancelButtonClicked:) Title:@"取消"];
    
    _grayBackView = grayBackView;
    [backView addSubview:lineView];
    [backView addSubview:titleLabel];
    [backView addSubview:cancelBtn];
    [backView addSubview:bottomLine];
    [grayBackView addSubview:backView];
}

//返回
-(void)leftBtnClick{
    if (_needPopHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
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

//确认
-(void)rightBtnClick{
    
    
    
    if (_status == 3&&[_nameUid isEqualToString:userDefaultUid]){
        
        [self saveProgressPhoto];
        
    }else{
        [self sureProgress];
    }
}
//本地成绩照片保存
-(void)saveProgressPhoto{
    [self createShareView];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_shareBackView.bounds.size.width-2,_shareBackView.bounds.size.height), YES, 2);
    [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    _headerBackView.y = 64;
    _DataShowView.y = _DataShowView.y + 64;
    [self.view addSubview:_headerBackView];
    [self.view addSubview:_DataShowView];
    
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
//确认成绩
-(void)sureProgress{
    
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


//选T点击
-(void)selectTClick:(UIButton *)btn{
    UIView *circleView = [btn.subviews objectAtIndex:1];
    UILabel *Tlabel = (UILabel *)[btn.subviews objectAtIndex:2];
    UILabel *colorNamelabel = (UILabel *)[btn.subviews objectAtIndex:3];
    Tlabel.hidden = NO;
    NSString *colorNameStr = colorNamelabel.text;
    
    UIView *viewCircleViw = [_SlectTBtn.subviews objectAtIndex:1];
    UILabel *colorName = [_SlectTBtn.subviews objectAtIndex:2];
    colorName.text = [NSString stringWithFormat:@"%@T",colorNameStr];
    viewCircleViw.backgroundColor = circleView.backgroundColor;
    [_grayBackView removeFromSuperview];
    
    NSArray *colorArray = @[rgba(68,68,68,1),rgba(255,200,74,1),rgba(1,144,255,1),rgba(249,249,249,1),rgba(237,87,55,1)];
    NSInteger selectTindex = 0;
    for (int i = 1; i<6; i++) {
        UIColor *selectColor = circleView.backgroundColor;
        if ([selectColor isEqual:colorArray[i-1]]) {
            selectTindex = i;
        }
    }
    [self selectTsend:selectTindex];
}

//分享
-(void)shareClick:(UIButton *)sender{
    NSInteger Tag = sender.tag;
    switch (Tag) {
        case 200:{
            
            [self createShareView];
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(_shareBackView.bounds.size.width-2,_shareBackView.bounds.size.height), YES, 2);
            [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            
            _headerBackView.y = 64;
            _DataShowView.y = _DataShowView.y + 64;
            
            [self.view addSubview:_headerBackView];
            [self.view addSubview:_DataShowView];
            
            
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
            [self createShareView];
            
            UIGraphicsBeginImageContextWithOptions(_shareBackView.bounds.size, YES, 2);
            [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            
            _headerBackView.y = 64;
            _DataShowView.y = _DataShowView.y + 64;
            
            [self.view addSubview:_headerBackView];
            [self.view addSubview:_DataShowView];
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *ext = [WXImageObject object];
            
            ext.imageData =  UIImageJPEGRepresentation(img,0.8);
            message.mediaObject = ext;
            
            UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(400, 700) sizeOfImage:img];
            message.thumbData =  UIImageJPEGRepresentation(sharImage,0.1);
            GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
            resp.message = message;
            resp.bText = NO;
            [WXApi sendResp:resp];
        }break;
        case 202:{
            [self createShareView];
            UIGraphicsBeginImageContextWithOptions(_shareBackView.bounds.size, YES, 2);
            [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            _headerBackView.y = 64;
            _DataShowView.y = _DataShowView.y + 64;
            [self.view addSubview:_headerBackView];
            [self.view addSubview:_DataShowView];
            //创建发送对象实例
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *ext = [WXImageObject object];
            
            ext.imageData =  UIImageJPEGRepresentation(img,0.8);
            message.mediaObject = ext;
            UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700, 400) sizeOfImage:img];
            
            message.thumbData =  UIImageJPEGRepresentation(sharImage,0.1);
            sendReq.message = message;
            sendReq.bText = NO;
            [WXApi sendReq:sendReq];
        }break;
        case 203:{
            if (![WeiboSDK isWeiboAppInstalled]) {
                //                [self showLoadSinaWeiboClient];
            }else {
                [self createShareView];
                UIGraphicsBeginImageContextWithOptions(_shareBackView.bounds.size, YES, 2);
                [_shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                _headerBackView.y = 64;
                _DataShowView.y = _DataShowView.y + 64;
                [self.view addSubview:_headerBackView];
                [self.view addSubview:_DataShowView];
                
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
#pragma mark ---- delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self pushToSystem];
            break;
            
        default:
            break;
    }
}
#pragma mark - 数据本地保存

-(void)saveData:(NSMutableDictionary *)mDict{
    _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YYDiskCache *diskCache = [[YYDiskCache alloc] initWithPath:cacherPath];
    NSString *disckCacheKey = [NSString stringWithFormat:@"%@_%@",_nameUid,_groupId];
    [diskCache setObject:_dataDict forKey:disckCacheKey];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - other
//格式化时间
-(NSString *)TimeStamp:(NSString *)strTime

{
    
    NSTimeInterval time=[strTime doubleValue];//
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



/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
