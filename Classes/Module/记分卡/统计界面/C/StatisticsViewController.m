//
//  StatisticsViewController.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/14.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "StatisticsViewController.h"
#import "WXApi.h"
#import "ImageTool.h"

#import "JPUSHService.h"

@interface StatisticsViewController (){
    UIView *backView;
    UIView *SecBackView;
    UIView *sharBackView;
    NSDictionary *MatchDict;
    NSDictionary *playerDict;
    NSInteger loginStyle;
    MBProgressHUD *_HUB;
}

@property (nonatomic,strong) UIImage  *shareImage;
@property(nonatomic, assign) CGFloat  Swidth;
@property(nonatomic, assign) CGFloat  Sheight;
@property(nonatomic, assign) CGFloat  WScale;
@property(nonatomic, assign) CGFloat  HScale;
@property(nonatomic, assign) CGFloat  kHorizontal;

//@property(nonatomic,strong)NSArray    *nameArry;
//@property(nonatomic,strong)NSArray    *nameIdArry;

@property (nonatomic,  copy) NSMutableArray *totlePoleArry;


#import "JPUSHService.h"

@end
@implementation StatisticsViewController


-(NSMutableArray *)totlePoleArry{
    if (!_totlePoleArry) {
        _totlePoleArry = [NSMutableArray array];
    }
    return _totlePoleArry;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(NSDictionary *)MatchDict{
    if (MatchDict == nil) {
        MatchDict = [NSDictionary new];
    }
    return MatchDict;
}



- (void)viewDidLoad {
    MatchDict = [userDefaults objectForKey:@"MatchDict"];
    if (4>_logInNumber>0) {
        MatchDict = [userDefaults objectForKey:@"ViewMatchDict"];
    }
    playerDict = [MatchDict objectForKey:@"PlayerDict"];
    _userNameId = [userDefaults objectForKey:@"StatisticsNameId"];

    [self loadPlayerData];
    
    _Swidth = ScreenWidth;
    _Sheight= ScreenHeight;
    
    [super viewDidLoad];
    self.view.backgroundColor = GPColor(245, 246, 247);
    [self createBtn];
    [self resevNotic];
    if (_logInNumber == 2){
        NSDictionary *PlaceDict = [MatchDict objectForKey:@"PlaceDict"];
        _GroupId = [PlaceDict objectForKey:@"group_id"];
        [self insertGroup];
    }else if (_logInNumber == 5){
        [self insertGroup];
    }
    
    if (_longinType==1) {
        [self downloadData];
    }else{
        _GroupId = [playerDict objectForKey:@"group_id"];
        [self createView];
    }
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [userDefaults removeObjectForKey:@"StatisticsNameId"];

}

-(void)loadPlayerData{
    _nameIdArry = [NSArray array];
    _nameArry = [NSArray array];
    NSMutableArray *nameArry = [NSMutableArray array];
    NSMutableArray *nameIdArry = [NSMutableArray array];
    NSString *playerNum = [playerDict objectForKey:@"playerNum"];
    for (int i = 1; i<[playerNum intValue]+1; i++) {
        NSString *nameId = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位id",i]];
        NSString *nickName = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",i]];
        if (nameId) {
            [nameArry addObject:nickName];
            [nameIdArry addObject:nameId];
        }
    }
    _nameArry = [NSArray arrayWithArray:nameArry];
    _nameIdArry = [NSArray arrayWithArray:nameIdArry];
}


-(void)resevNotic{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMiss) name:@"ToBackNotic" object:nil];
#pragma mark- 接收自定义推送消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)networkDidReceiveMessage:(NSNotification *)noti{
    NSLog(@"%@",noti);
    id dict = noti.userInfo;
    NSDictionary *extras = [dict objectForKey:@"extras"];
    NSString *UpdateChengJi = [extras objectForKey:@"UpdateChengJi"];
    if ([UpdateChengJi isEqualToString:@"6"]) {
        [self downloadData];
    }
    NSString *PushToStat = [extras objectForKey:@"PushToStat"];
    if ([PushToStat isEqualToString:@"8"]) {
        [self downloadData];
    }
    NSString *JPushCode = [extras objectForKey:@"JPushCode"];
    if ([JPushCode isEqualToString:@"6"]) {
        NSString *boolValid =[extras objectForKey:@"boolValid"];
        if ([boolValid isEqualToString:@"1"]) {
            [userDefaults setValue:@"1" forKey:@"showCharityView"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//底部按钮
-(void)createBtn{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(HScale(2.7), WScale(78.5), HScale(6.4), WScale(11.5));
    [backBtn setImage:[UIImage imageNamed:@"统计返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, WScale(90), HScale(11.8), WScale(8))];
    backLabel.textColor = GPColor(104, 103, 103);
    backLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.text = @"返回";
    
    [self.view addSubview:backBtn];
    [self.view addSubview:backLabel];
    
    //确认成绩,分享微信好友,朋友圈,保存相册
    
    NSArray *descArry  = @[@"朋友圈",@"好友",@"保存到本地"];
    NSArray *imageArry = @[@"分享成绩",@"分享好友",@"保存到相册"];
    NSArray *tagArry   = @[@"1346",@"1347",@"1348"];
    if (_logInNumber != 1) {
        descArry  = @[@"确认成绩"];
        imageArry = @[@"确认成绩"];
        tagArry   = @[@"1345"];
        if (_logInNumber == 2){
            descArry  = @[@"刷新"];
            imageArry = @[@"记分卡刷新_默认"];
            tagArry   = @[@"1349"];
        }else if (_logInNumber == 3){
            descArry  = [NSArray array];
            imageArry = [NSArray array];
            tagArry   = [NSArray array];
        }else if (_logInNumber==0){
            descArry  = [NSArray array];
            imageArry = [NSArray array];
            tagArry   = [NSArray array];
        }else if (_logInNumber == 5){
            descArry  = @[@"刷新"];
            imageArry = @[@"记分卡刷新_默认"];
            tagArry   = @[@"1349"];
        }
    }
    
    
    for (int i=0; i<descArry.count; i++) {
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(HScale(90.9) - HScale(9.1)*i, WScale(78.5), HScale(6.4), WScale(11.5));
        [sureBtn setImage:[UIImage imageNamed:imageArry[i]] forState:UIControlStateNormal];
        sureBtn.tag = [tagArry[i] integerValue];
        
        [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(HScale(88.2) - HScale(9.1)*i, WScale(90), HScale(11.8), WScale(8))];
        sureLabel.textColor = GPColor(104, 103, 103);
        sureLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        sureLabel.textAlignment = NSTextAlignmentCenter;
        sureLabel.text = descArry[i];
        [self.view addSubview:sureLabel];
        [self.view addSubview:sureBtn];
    }
    }

//记分界面
-(void)createView{
    _WScale = _Swidth*0.01;
    _HScale = _Sheight*0.01;
    _kHorizontal = _Swidth/375.0;
    
    NSInteger nameCount = _nameArry.count;
    sharBackView = nil;
    sharBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _Sheight, _Swidth)];
    sharBackView.backgroundColor = [UIColor whiteColor];
    
    //背景
    SecBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _Sheight, _WScale*(32.2)+_WScale*(10.7)*nameCount)];
    SecBackView.backgroundColor = [UIColor whiteColor];
    
    
    //分享二维码
    UIImageView *Quickmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分享二维码文字"]];
    Quickmark.frame = CGRectMake(HScale(70.6), WScale(79.5), HScale(18.9), WScale(11.5));
    //    Quickmark.frame = CGRectMake(HScale(71.6), WScale(82.4), HScale(26.1), WScale(11.5));
    UIImageView *Quickmark2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"  "]];
    Quickmark2.frame = CGRectMake(HScale(90.5), WScale(74.5), HScale(9.3), WScale(16.5));
    
    [sharBackView addSubview:Quickmark];
    [sharBackView addSubview:Quickmark2];

    
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, _WScale*(6.1), _Sheight, _WScale*(26.1)+_WScale*(10.7)*nameCount)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(_HScale*(1.5), _WScale*(1.6), _HScale*(5.8), _WScale*(10.7))];
    iconView.image = [UIImage imageNamed:@"统计logo"];
    
    NSDictionary *place_dic = [MatchDict objectForKey:@"PlaceDict"];
    
    UILabel *localeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_HScale*(11.1), _WScale*(2.7), _HScale*(45), _WScale*(4.8))];
    localeLabel.textColor = GPColor(58, 58, 65);
    localeLabel.font = [UIFont systemFontOfSize:_kHorizontal*(13)];
    localeLabel.text = [place_dic objectForKey:@"qiuchang_name"];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_HScale*(11.1), _WScale*(8), _HScale*(40), _WScale*(4.3))];
    timeLabel.textColor = GPColor(133, 133, 142);
    timeLabel.font = [UIFont systemFontOfSize:_kHorizontal*(11)];
    NSMutableString *chuangjian_time = [NSMutableString stringWithFormat:@"%@",[place_dic objectForKey:@"chuangjian_time"]];
    [chuangjian_time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [chuangjian_time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [chuangjian_time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日 "];
    
    [chuangjian_time deleteCharactersInRange:NSMakeRange(17, chuangjian_time.length-17)];

    
//    2016年09月03日 12:11:11
    timeLabel.text = chuangjian_time;
    
    NSArray *descArry = @[@"老鹰球",@"小鸟球",@"标准杆",@"柏忌",@"双柏忌"];
    NSArray *colorArry = @[GPColor(250, 186, 83),GPColor(231, 104, 108),localColor,GPColor(79, 140, 227),GPColor(79, 88, 240)];
    CGFloat viewX = 0;
    for (int i = 0; i<5; i++) {
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(_HScale*(56.8) + viewX, _WScale*(5.3), _HScale*(1.6), _WScale*(2.9))];
        colorView.layer.cornerRadius = colorView.frame.size.height/2;
        colorView.layer.masksToBounds = YES;
        colorView.backgroundColor = colorArry[i];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.text = descArry[i];
        descLabel.frame = CGRectMake(colorView.frame.origin.x+_HScale*(2.8), _WScale*(5.1), _HScale*(3), _WScale*(3.7));
        descLabel.font = [UIFont systemFontOfSize:_kHorizontal*(10)];
        descLabel.textColor = GPColor(81, 73, 73);
        [descLabel sizeToFit];
        viewX = viewX + descLabel.frame.size.width + _HScale*(4);
        [backView addSubview:colorView];
        [backView addSubview:descLabel];
    }
    NSArray *titleArry = @[@"洞序",@"标准杆"];
    
    //标准杆
    NSInteger ninePar = 0;
    NSInteger nineteenPar = 0;
    for (int i = 0; i<2+nameCount; i++) {
        UILabel *nameLable = [[UILabel alloc] init];
        if (i<2) {
            nameLable.frame = CGRectMake(_HScale*(2.5), _WScale*(13.6)+_WScale*(5.9)*i, _HScale*(6), _WScale*(5.9));
            nameLable.text = titleArry[i];
            
            nameLable.textColor = GPColor(133, 133, 142);
            nameLable.font = [UIFont systemFontOfSize:10];
        }else{
            nameLable.frame = CGRectMake(_HScale*(2.5), _WScale*(26.1)+_WScale*(10.7)*(i-2), _HScale*(9.5), _WScale*(10.7));
            nameLable.text = _nameArry[i-2];
            nameLable.textColor = GPColor(38, 38, 38);
            nameLable.font = [UIFont systemFontOfSize:11];
        }
        [backView addSubview:nameLable];
    }
    //洞序
    for (int i = 0; i<21; i++) {
        UILabel *NumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_HScale*(13) + _HScale*(4)*i, _WScale*(13.6), _HScale*(4), _WScale*(5.9))];
        if (i<9) {
            NumLabel.text = [NSString stringWithFormat:@"%d",i+1];
        }else if (i==9){
            NumLabel.text = @"OUT";
            
        }else if (i<19){
            NumLabel.text = [NSString stringWithFormat:@"%d",i];
        }else if (i==19){
            NumLabel.text = @"IN";
        }else if (i==20){
            NumLabel.text = @"TOT";
            NumLabel.frame = CGRectMake(_HScale*(93) , _WScale*(13.6), _HScale*(7), _WScale*(5.9));
        }
        NumLabel.textColor = GPColor(47, 46, 45);
        NumLabel.font = [UIFont systemFontOfSize:_kHorizontal*(11)];
        NumLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:NumLabel];
        //标准杆
        UILabel *ParLabel = [[UILabel alloc] initWithFrame:CGRectMake(_HScale*(13) + _HScale*(4)*i, _WScale*(19.5), _HScale*(4), _WScale*(5.9))];
        NSString *ParStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
        NSString *SingleScore = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,_nameIdArry[0]]];
        if ([ParStr isEqualToString:@"3"]&&SingleScore == nil) {
            ParStr = nil;
        }
        if (i<9) {
            ninePar = ninePar+ [ParStr integerValue];
            if (ParStr) {
                ParLabel.text = ParStr;
            }else{
                ParLabel.text = @"";
            }
        }else if (i==9){
            nineteenPar = ninePar;
            ParLabel.text = [NSString stringWithFormat:@"%ld",(long)ninePar];
        }else if (i<19){
            ParStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i]];
            SingleScore = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i,_nameIdArry[0]]];
            if ([ParStr isEqualToString:@"3"]&&SingleScore == nil) {
                ParStr = nil;
            }
            
            nineteenPar = nineteenPar+ [ParStr integerValue];
            
            if (ParStr) {
                ParLabel.text = ParStr;
            }else{
                ParLabel.text = @"";
            }
        }else if (i==19){
            ParLabel.text = [NSString stringWithFormat:@"%ld",(long)(nineteenPar-ninePar)];
        }else if (i==20){
            ParLabel.text = [NSString stringWithFormat:@"%ld",(long)nineteenPar];
            ParLabel.frame = CGRectMake(_HScale*(93) , _WScale*(19.5), _HScale*(7), _WScale*(5.9));
        }
        ParLabel.textColor = GPColor(133, 133, 142);
        ParLabel.font = [UIFont systemFontOfSize:_kHorizontal*(11)];
        ParLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:ParLabel];
    }
    
    _totlePoleArry = [NSMutableArray array];
    for (int x = 0; x<nameCount; x++) {
        //杆数
        NSInteger nineStem = 0;
        NSInteger nineteenStem = 0;
        
        for (int i = 0; i<21; i++) {
            //杆数label
            UILabel *stemLabel = [[UILabel alloc] initWithFrame:CGRectMake(_HScale*(13) + _HScale*(4)*i,_WScale*(26.1)+_WScale*(10.7)*x, _HScale*(4),_WScale*(10.7))];
            stemLabel.textColor = [UIColor whiteColor];
            stemLabel.font = [UIFont systemFontOfSize:_kHorizontal*(13)];
            stemLabel.textAlignment = NSTextAlignmentCenter;
            NSString *titleStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,_nameIdArry[x]]];
            if ([titleStr isEqualToString:@"0"]) {
                titleStr = [[NSString alloc] init];
            }
            
            //杆数背景
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(_HScale*(13.5) + _HScale*(4)*i,_WScale*(26.1) + _WScale*(2.7) + _WScale*(10.7)*x, _HScale*(3), _WScale*(5.3))];
            circleView.backgroundColor = colorArry[2];
            circleView.layer.cornerRadius = circleView.frame.size.height/2;
            circleView.layer.masksToBounds = YES;
            
            NSString *ParStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
            if ([ParStr isEqualToString:@"0"]) {
                ParStr = [NSString string];
            }
            NSInteger balance = 0;
            
            if (i<9) {
                nineStem = nineStem+ [titleStr integerValue];
                if (titleStr) {
                    
                    stemLabel.text = titleStr;
                    balance = [titleStr integerValue] - [ParStr integerValue];
                }else{
                    stemLabel = nil;
                    circleView = nil;
                }
            }else if (i==9){
                stemLabel.text = [NSString stringWithFormat:@"%ld",(long)nineStem];
                nineteenStem = nineStem;
                circleView = nil;
                stemLabel.textColor = [UIColor blackColor];
            }else if (i<19){
                titleStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i,_nameIdArry[x]]];

//                titleStr =  [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞第%d位",i,x+1]];
                ParStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i]];
                if ([titleStr isEqualToString:@"0"]) {
                    titleStr = [[NSString alloc] init];
                }
                nineteenStem = nineteenStem+ [titleStr integerValue];
                if (titleStr) {
                    stemLabel.text = titleStr;
                    
                    balance = [titleStr integerValue] - [ParStr integerValue];
                }else{
                    stemLabel = nil;
                    circleView = nil;
                }
            }else if (i==19){
                stemLabel.text =[NSString stringWithFormat:@"%ld",(long)nineteenStem-nineStem];
                circleView = nil;
                stemLabel.textColor = [UIColor blackColor];
            }else if (i==20){
                NSString *totleStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d位总杆",x+1]];
                if (!totleStr) {
                    totleStr = @"0";
                }
                stemLabel.text =[NSString stringWithFormat:@"%ld",(long)nineteenStem];
                stemLabel.frame = CGRectMake(_HScale*(93) ,_WScale*(26.1)  + _WScale*(10.7)*x, _HScale*(7), _WScale*(10.7));
                circleView = nil;
                stemLabel.textColor = [UIColor blackColor];
                [_totlePoleArry addObject:[NSString stringWithFormat:@"%ld",(long)nineteenStem]];
            }
            if (balance>2) {
                balance = 3;
            }else if (balance<-2){
                balance = -2;
            }
            switch (balance) {
                case -2:
                    circleView.backgroundColor = colorArry[0];
                    break;
                case -1:
                    circleView.backgroundColor = colorArry[1];
                    break;
                case 0:
                    circleView.backgroundColor = colorArry[2];
                    break;
                case 1:
                    circleView.backgroundColor = colorArry[3];
                    break;
                case 2:
                    circleView.backgroundColor = colorArry[4];
                    break;
                case 3:
                    circleView.backgroundColor = [UIColor whiteColor];
                    stemLabel.textColor = [UIColor blackColor];
                    break;
                default:
                    break;
            }
            if (titleStr.length ==0) {
                circleView.backgroundColor = [UIColor whiteColor];
            }
            [backView addSubview:circleView];
            [backView addSubview:stemLabel];
        }
    }
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_HScale*(9.9), 0, 1, _WScale*(26.1))];
    verticalLine.backgroundColor = GPColor(244, 244, 244);
    
    for (int i = 0; i<3+nameCount; i++) {
        UIView *line = [[UIView alloc] init];
        if (i<2) {
            line.frame = CGRectMake(_HScale*(9.9), _WScale*(13.6)+_WScale*(5.9)*i, _HScale*(90.1), 1);
        }else{
            line.frame = CGRectMake(0, _WScale*(26.1)+_WScale*(10.7)*(i-2)-1, _Sheight, 1);
        }
        line.backgroundColor = GPColor(244, 244, 244);
        if (i==3+nameCount-1) {
            line.backgroundColor = GPColor(234, 234, 234);
        }
        [backView addSubview:line];
    }
    NSInteger selfIndex = 0;
    NSInteger UserNum = _nameArry.count;
//    if (!_userNameId) {
        _userNameId = [userDefaults objectForKey:@"StatisticsNameId"];
//    }
    for (NSInteger m = 0; m<UserNum; m++) {
        NSString *nameId = [playerDict objectForKey:[NSString stringWithFormat:@"第%ld位id",(long)m+1]];
        if ([nameId isEqualToString:_userNameId]) {
            selfIndex = m;
        }
    }
    //个人选择框
    for (int i=0; i<2; i++) {
        UIView *SelectVer = [[UIView alloc] initWithFrame:CGRectMake((_HScale*(100)-1)*i,_WScale*(26.1) +_WScale*(10.7)*selfIndex , 1, _WScale*(10.7))];
        SelectVer.backgroundColor = GPColor(71, 194, 189);
        UIView *Selectline = [[UIView alloc] initWithFrame:CGRectMake(0, _WScale*(26.1)+_WScale*(10.7)*(i + selfIndex) , _Sheight, 1)];
        Selectline.backgroundColor = GPColor(71, 194, 189);
        [backView addSubview:SelectVer];
        [backView addSubview:Selectline];
    }
    //勾选符号
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(_HScale*(0.6), _WScale*(30)+_WScale*(10.7)*selfIndex, _HScale*(1.6), _WScale*(2.9))];
    [selectView setImage:[UIImage imageNamed:@"勾选"]];
    [backView addSubview:selectView];
    [backView addSubview:verticalLine];
    [backView addSubview:iconView];
    [backView addSubview:localeLabel];
    [backView addSubview:timeLabel];
    [SecBackView addSubview:backView];
    [self.view addSubview:SecBackView];
}

-(void)dissMiss{
    if (_logInNumber == 2||_logInNumber == 0||_logInNumber == 5){
        [self exitThisGroup];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    self.view = nil;
}

-(void)sureClick:(UIButton *)btn{
    switch (btn.tag) {
        case 1345:{
            NSInteger PoloNum = 0;
            for (int i = 0; i<_nameArry.count; i++) {
//                NSArray *mArry = [NSArray array];
                NSLog(@"%@",[MatchDict objectForKey:[NSString stringWithFormat:@"第%d位已完成洞号",i+1]]);
               NSArray *mArry = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d位已完成洞号",i+1]];
                if (mArry.count<18) {
                    PoloNum++;
                }
            }
            if (PoloNum==0) {
                //确认成绩
                NSInteger testInter = 0;
                for (NSInteger i = 0; i<_totlePoleArry.count; i++) {
                    NSString *poleStr = _totlePoleArry[i];
                    NSInteger totlePole = [poleStr integerValue];
                    if (totlePole<58) {
                        testInter++;
                    }
                }
                if (testInter!=0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"哇噻，你的成绩已创造高坛奇迹，也突破了平台极限，我们无法保存你的这次成绩！" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self SureProgress:4444];
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"暂不提交" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                    return;
                }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已完成所有记分，现在确认成绩吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self SureProgress:PoloNum];
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                }

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未完成所有记分，现在就确认成绩吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self SureProgress:PoloNum];
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"继续记分" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }
        }break;
        case 1346:{
            NSMutableArray *mArry = [MatchDict objectForKey:@"已操作洞号"];
            if (mArry.count<17) {
                NSLog(@"已完成的%@",mArry);
            }
            //分享朋友圈
            [self clickToPengYouQuan];
        }break;
        case 1347:{
            //分享好友
            [self clickToHaoYou];
        }break;
        case 1348:{
            //保存本地
            [self savePoto];
            
        }break;
        case 1349:{
            //刷新
            [self downloadData];
        }break;
        case 1350:{
            //退出
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定退出记分吗" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self exitGroup];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }break;
            
        default:
            break;
    }
}

#pragma mark - 保存本地
-(void)savePoto{
    [sharBackView addSubview:SecBackView];
    UIGraphicsBeginImageContextWithOptions(sharBackView.bounds.size, YES, 2);
    [sharBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(img, self,  @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    [self.view addSubview:SecBackView];
//    [self downloadData];
}


-(void)downloadData{
    _userNameId = [userDefaults objectForKey:@"StatisticsNameId"];

    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"group_id":_GroupId,
                           @"name_id":_userNameId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_achievement_groupid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        
        if (success) {
            [userDefaults removeObjectForKey:@"ViewMatchDict"];
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
                for (int x = 0; x<pesonArry.count; x++) {
                    NSString *Num = [pesonArry[x] objectForKey:@"Num"];
                    NSString *Name = [pesonArry[x] objectForKey:@"nick_name"];
                    NSString *name_id = [pesonArry[x] objectForKey:@"name_id"];
                    NSLog(@"第%@洞%@",PoloNum,name_id);
                    [dataDict setValue:Num forKey:[NSString stringWithFormat:@"第%@洞%@",PoloNum,name_id]];
                    [PlayerDict setValue:name_id forKey:[NSString stringWithFormat:@"第%d位id",x+1]];
                    [PlayerDict setValue:Name forKey:[NSString stringWithFormat:@"第%d位名字",x+1]];
                }
                [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)pesonArry.count] forKey:@"playerNum"];
            }
            if ([data objectForKey:@"groupUser"]) {
                NSMutableArray *userArry = [NSMutableArray array];
                NSMutableArray *userIdArry = [NSMutableArray array];
                for (NSDictionary *userDict in [data objectForKey:@"groupUser"]) {
                    NSString *userName  = [userDict objectForKey:@"nickname"];
                    NSString *userDongNumber = [userDict objectForKey:@"userDongNumber"];
                    NSMutableArray *DoneNUm = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0 ; i<[userDongNumber integerValue]; i++) {
                        [DoneNUm addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    
                    [userArry addObject:userName];
                    [userIdArry addObject:[userDict objectForKey:@"name_id"]];
                }
                _nameArry = userArry;
                _nameIdArry = userIdArry;
                
                for (int i = 0; i<userIdArry.count; i++) {
                    NSString *Num = [NSString stringWithFormat:@"%ld",(long)userIdArry.count];
                    [PlayerDict setValue:Num forKey:@"playerNum"];
                    NSString *Name = userArry[i];
                    NSString *name_id = userIdArry[i];
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
            [PlayerDict setValue:_GroupId forKey:@"group_id"];
            [dataDict setValue:PlayerDict forKey:@"PlayerDict"];
            [userDefaults setValue:dataDict forKey:@"ViewMatchDict"];
            
            NSLog(@"%@",[userDefaults objectForKey:@"ViewMatchDict"]);
            MatchDict = [userDefaults objectForKey:@"MatchDict"];
            if (_logInNumber>0) {
                MatchDict = [userDefaults objectForKey:@"ViewMatchDict"];
            }
            if (_longinType==1) {
                MatchDict = [userDefaults objectForKey:@"ViewMatchDict"];
            }
            if (_logInNumber == 0) {
                NSDictionary *PlaceDict = [MatchDict objectForKey:@"PlaceDict"];
                _GroupId = [PlaceDict objectForKey:@"group_id"];

                [self insertGroup];
            }
            playerDict = [MatchDict objectForKey:@"PlayerDict"];
            _Swidth = ScreenHeight;
            _Sheight = ScreenWidth;
            [self loadPlayerData];
            [SecBackView removeFromSuperview];
            [self createView];
        }else{
        }
    }];
}

-(void)insertGroup{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"groupID":_GroupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertBrowseGroup",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
    }];
}

-(void)exitThisGroup{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"groupID":_GroupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteBrowseGroup",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        
    }];
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

#pragma mark - 分享好友
-(void)clickToHaoYou{
    [sharBackView addSubview:SecBackView];
    UIGraphicsBeginImageContextWithOptions(sharBackView.bounds.size, YES, 2);
    [sharBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.view addSubview:SecBackView];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData =  UIImageJPEGRepresentation(img,0.8);
    message.mediaObject = ext;
    
    UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700, 400) sizeOfImage:img];
    
    message.thumbData =  UIImageJPEGRepresentation(sharImage,0.1);
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}
#pragma mark - 分享朋友圈

-(void)clickToPengYouQuan{
    
    [sharBackView addSubview:SecBackView];
    UIGraphicsBeginImageContextWithOptions(sharBackView.bounds.size, YES, 2);
    [sharBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.view addSubview:SecBackView];
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
    
}

#pragma mark - 确认成绩
-(void)SureProgress:(NSInteger)Type{
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.labelText = @"成绩确认中";
    _HUB.alpha = 0.5;

    /**
     *  所有数据 totleArry
     */
    NSMutableArray *totleArry = [NSMutableArray array];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    
    for (int i=0; i<18; i++) {
        
        NSString *PoloNum = [NSString stringWithFormat:@"%d",i+1];
        if (!PoloNum) {
            PoloNum = @"0";
        }
        
        NSString *Par = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
        if (!Par) {
            Par = @"0";
        }
        NSMutableArray *PlayerArry = [NSMutableArray array];
        NSString *playerNum = [PlayerDict objectForKey:@"playerNum"];
        for (int m=0; m<[playerNum intValue]; m++) {
            NSString *name_id = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",m+1]];
            NSString *nick_name = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",m+1]];
            NSString *Num = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,name_id]];
            if (!Num) {
                Num = @"0";
            }
            NSDictionary *Player = @{
                                     @"nick_name":nick_name,
                                     @"name_id":name_id,
                                     @"Num":Num
                                     };
            [PlayerArry addObject:Player];
        }
        NSDictionary *dataDict =  @{
                                    @"PoloNum":PoloNum,
                                    @"Par":Par,
                                    @"Players":PlayerArry
                                    };
        [totleArry addObject:dataDict];
    }
    

    
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:totleArry options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = nil;
        if ([jsonData length] > 0){
            jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
        NSLog(@"%@",totleArry);
        NSString *dong_nu = [MatchDict objectForKey:@"退出时记分位置"];
    if (!dong_nu) {
        dong_nu = @"1";
    }
        NSDictionary *dict = @{
                               @"chengji_all":jsonString,
                               @"group_id":_GroupId,
                               @"dong_nu":dong_nu
                               };
        [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_user_chengji",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
            if (success) {
                [self SuccessSureProgress:Type];
            }else{
                _HUB.hidden = YES;
                SucessView *sView = [SucessView new];
                sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
                sView.imageName = @"失败";
                sView.descStr = @"操作失败";
                [sView didFaild];
                [self.view addSubview:sView];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    sView.hidden = YES;
                });
            }
        }];
}

-(void)SuccessSureProgress:(NSInteger)Type{

    UIButton *sureBtn = (UIButton *)[self.view viewWithTag:1345];
    sureBtn.userInteractionEnabled = NO;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];

    NSDictionary *dict = @{
                           @"group_id":_GroupId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/update_group_chengjistatr",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        sureBtn.userInteractionEnabled = YES;
        _HUB.hidden = YES;
        _HUB = nil;
        if (success) {
            [userDefaults removeObjectForKey:@"MatchDict"];
            [userDefaults removeObjectForKey:@"ViewMatchDict"];

        NSDictionary *SureDict = [data objectForKey:@"data"][0];
        NSString *chengji_statr = [SureDict objectForKey:@"chengji_statr"];
        if ([chengji_statr isEqualToString:@"1"]) {
            if (Type == 0) {
                [userDefaults setValue:@"1" forKey:@"showCharityView"];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];

           
        }
            
            
            
        }else{
            SucessView *sView = [SucessView new];
            sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
            sView.imageName = @"失败";
            sView.descStr = @"操作失败";
            [sView didFaild];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sView.hidden = YES;
            });
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
        NSString *code = [data objectForKey:@"code"];
        if ([code isEqualToString:@"1"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (UIView *)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}




@end
