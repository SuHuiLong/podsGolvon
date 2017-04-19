//
//  SingleScoringViewController.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "SingleScoringViewController.h"
#import "CardScrollView.h"
#import "CUSFlashLabel.h"
#import "StatisticsViewController.h"
#import "SelectPoleView.h"
#import "MarkAlertView.h"



@interface SingleScoringViewController ()<UIScrollViewDelegate,WYScrollViewNetDelegate,WYScrollViewLocalDelegate>{

    NSMutableDictionary *MatchDict;

}

@property (nonatomic ,strong) UIButton      *allPole;
@property (nonatomic ,strong) UILabel       *poleLabel;
@property (nonatomic ,strong) UIButton      *record;
@property (nonatomic ,strong) UIButton      *backBtn;
//@property (nonatomic ,strong) UIButton      *normBtn;
//@property (nonatomic ,strong) UIButton      *poleNum;
@property (nonatomic ,strong) UIImageView   *flagImage;
@property (nonatomic ,strong) UILabel       *flagNumLabel;
@property (nonatomic ,strong) UIImageView   *groundView;
@property (nonatomic ,strong) NSArray       *normtitles;
@property (nonatomic ,strong) NSArray       *poletitles;
@property (nonatomic ,strong) CardScrollView *scroll;
@property (nonatomic, assign) NSInteger selectStyle;//button状态
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic ,strong) UILabel       *pole;//总杆

@property(nonatomic,assign)NSInteger      dataIndex;
@property(nonatomic,assign)NSInteger      lastIndex;
@property(nonatomic,assign)NSInteger      changeStyle;
@property(nonatomic,assign)NSInteger      successStyle;


@end

@implementation SingleScoringViewController

-(NSMutableDictionary *)MatchDict{
    if (MatchDict == nil) {
        MatchDict = [NSMutableDictionary new];
    }
    return MatchDict;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSDictionary *dict = [userDefaults objectForKey:@"MatchDict"];
    if (!dict) {
        self.view = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    MatchDict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"MatchDict"]];

    [super viewDidLoad];
    [self createNav];
    [self createLabel];
    [self createUI];
    if ([_LoginType isEqualToString:@"1"]) {
        [self insertView];
    }
    [self ViewAlert];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeAlert];
}
#pragma mark - 插入记录
-(void)insertView{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"windowID":@"SingleScoringViewController"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertWindowBrows",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        NSDictionary *dataDict = [data objectForKey:@"data"];
        NSInteger longInNum = 0;
        if (dataDict) {
            NSString *code = [dataDict objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {
                NSArray *windowBrows = [dataDict objectForKey:@"windowBrows"];
                for (NSDictionary *windowDict in windowBrows) {
                    NSString *windowID = [windowDict objectForKey:@"windowID"];
                    if ([windowID isEqualToString:@"SingleScoringViewController"]||[windowID isEqualToString:@"ScoringViewController"]) {
                        NSString *browsNumber = [windowDict objectForKey:@"browsNumber"];
                        longInNum = longInNum + [browsNumber integerValue];
                    }
                    
                }
            }
            if (longInNum<3) {
                [self createMarkAlertView];
            }
        }
    }];

}


-(void)createNav{
    //    返回
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.frame = CGRectMake(0, 0, WScale(16), HScale(11));
    
    UIImageView *BackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"多人操作返回"]];
    BackView.frame = CGRectMake(WScale(3.5), HScale(4.9), WScale(3.2), HScale(2.8));
    [BackBtn addSubview:BackView];
    [self.view addSubview:BackBtn];
    
    //    洞数
    _flagNumLabel = [[UILabel alloc] init];
    
    _flagNumLabel.frame = CGRectMake(WScale(20), HScale(3.9), WScale(26), HScale(4.8));
    NSString *exitIndex = [MatchDict objectForKey:@"退出时记分位置"];
    if (!exitIndex) {
        exitIndex = @"1";
    }
    _flagNumLabel.text = exitIndex;
    _flagNumLabel.textColor = GPColor(120, 120, 120);
    
    _flagNumLabel.textAlignment = NSTextAlignmentRight;
    _flagNumLabel.font = [UIFont systemFontOfSize:kHorizontal(22)];
    [self.view addSubview:_flagNumLabel];
    
    _flagImage = [[UIImageView alloc] init];
    _flagImage.frame = CGRectMake(WScale(47.2), HScale(4.8), WScale(4.5), HScale(3));
//    NSString *selectIndex = [MatchDict objectForKey:@""];
    _flagImage.image = [UIImage imageNamed:@"洞默认"];
    [self.view addSubview:_flagImage];
    
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(53.1), HScale(5.8), 14, 9)];
    selectImageView.image = [UIImage imageNamed:@"洞序向下"];
    [self.view addSubview:selectImageView];
    
    //    总杆
    _allPole = [UIButton buttonWithType:UIButtonTypeCustom];
    _allPole.frame = CGRectMake(WScale(9.1), HScale(11.6), WScale(7.5), HScale(7.2));
    [_allPole addTarget:self action:@selector(clickToPoleNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allPole];
    
    _poleLabel = [[UILabel alloc]init];
    _poleLabel.frame = CGRectMake(0, 0, WScale(7.5), HScale(4.2));
    _poleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _poleLabel.textAlignment = NSTextAlignmentCenter;


    NSInteger totleNum = 0;
    for (int m = 0; m<17; m++) {
        NSString *PlayerPoloNum = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",m+1,userDefaultId]];
        totleNum += [PlayerPoloNum integerValue];
    }
    _poleLabel.text = @"0";
    
    if (totleNum>0) {
        _poleLabel.text = [NSString stringWithFormat:@"%ld",(long)totleNum];
    }

    
    [_allPole addSubview:_poleLabel];
    
    _pole = [[UILabel alloc]init];
    _pole.frame = CGRectMake(0, HScale(3.3), WScale(7.5), HScale(3));
    _pole.text = @"总杆";
    _pole.textAlignment = NSTextAlignmentCenter;
    _pole.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_allPole addSubview:_pole];
    
    //    记录
    _record = [UIButton buttonWithType:UIButtonTypeCustom];
    _record.frame = CGRectMake(ScreenWidth - WScale(23.6), HScale(7.6), WScale(20), HScale(12));
    [_record addTarget:self action:@selector(clickToPoleNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_record];
    
    UIImageView *recordImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"操作记录"]];
    recordImage.frame = CGRectMake(WScale(8.1), HScale(5) , WScale(5.3), HScale(2.7));
    [_record addTarget:self action:@selector(clickToRecord) forControlEvents:UIControlEventTouchUpInside];
    [_record addSubview:recordImage];
    
    UILabel *recordLabel = [[UILabel alloc]init];
    recordLabel.frame = CGRectMake(WScale(7), HScale(7.7), WScale(7.5), HScale(3));
    recordLabel.text = @"记录";
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_record addSubview:recordLabel];
    
    UIButton *selectPoleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPoleBtn.frame = CGRectMake(WScale(40), HScale(3), WScale(20), HScale(5));
    [selectPoleBtn addTarget:self action:@selector(presentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectPoleBtn];
    
}

-(void)createUI{
    NSMutableArray *imageViewArry = [[NSMutableArray alloc]init];
    for (int i = 0; i<18; i++) {
        _groundView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, HScale(75))];
        [self.view addSubview:_groundView];
        
        _flagImage.image = [UIImage imageNamed:@"洞默认"];
        _flagNumLabel.textColor = GPColor(120, 120, 120);

        //    标准杆
        UILabel *normPole = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(4.5))];
        normPole.text = @"标准杆";
        normPole.font = [UIFont systemFontOfSize:kHorizontal(22)];
        normPole.textColor = GPColor(39, 39, 39);
        normPole.textAlignment = NSTextAlignmentCenter;
        [_groundView addSubview:normPole];
        
        UILabel *norm = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-WScale(32.5))/2, HScale(9.3), WScale(32.5), HScale(18.9))];
        norm.backgroundColor = localColor;
        norm.layer.masksToBounds = YES;
        norm.layer.cornerRadius = HScale(18.9)/2;
        [_groundView addSubview:norm];
        
        UIButton *normBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        normBtn.frame = CGRectMake((ScreenWidth-WScale(32.5)+2)/2, HScale(9.3)+1, WScale(32.5)-2, HScale(18.9)-2);
        NSString *norStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
        
        if (!norStr) {
            norStr = @"3";
            [MatchDict setValue:@"3" forKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
            [userDefaults setValue:MatchDict forKey:@"MatchDict"];
        }
        normBtn.tag = 1000+i;
        [normBtn setTitle:norStr forState:UIControlStateNormal];
        [normBtn addTarget:self action:@selector(addToNormPole:) forControlEvents:UIControlEventTouchUpInside];
        normBtn.layer.masksToBounds = YES;
        
        normBtn.layer.cornerRadius = (HScale(18.9)-2)/2;
        normBtn.backgroundColor = [UIColor whiteColor];
        [normBtn setTitleColor:localColor forState:UIControlStateNormal];
        normBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(90)];
        [_groundView addSubview:normBtn];
        
        //    杆数
        UIButton *poleNum = [UIButton buttonWithType:UIButtonTypeCustom];
        poleNum.frame = CGRectMake((ScreenWidth-WScale(32.5))/2, HScale(34.8), WScale(32.5), HScale(18.9));
        poleNum.layer.masksToBounds = YES;
        
        NSString *titleStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,userDefaultId]];
        if ([titleStr isEqualToString:@"0"]){
            titleStr = nil;
        }

        if (!titleStr) {
            titleStr = @"1";
            poleNum.backgroundColor = GPColor(204, 204, 204);

            poleNum.selected = YES;
        }else{
            poleNum.backgroundColor = localColor;
            poleNum.selected = NO;
        }
        
        [poleNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [poleNum setTitle:titleStr forState:UIControlStateNormal];
        [poleNum addTarget:self action:@selector(addToPoleNum:) forControlEvents:UIControlEventTouchUpInside];
        poleNum.tag = 138+i;
        poleNum.layer.cornerRadius = HScale(18.9)/2;
        poleNum.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(90)];
        [_groundView addSubview:poleNum];
        
        UILabel *poleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-WScale(12))/2, ScreenHeight-HScale(23.7)-HScale(18.4), WScale(12), HScale(4.5))];
        poleNumLabel.text = @"杆数";
        poleNumLabel.font = [UIFont systemFontOfSize:kHorizontal(22)];
        poleNumLabel.textColor = GPColor(39, 39, 39);
        [_groundView addSubview:poleNumLabel];
        _groundView.userInteractionEnabled = YES;
        [imageViewArry addObject:_groundView];
        
    }
    _scroll = [[CardScrollView alloc]initWithFrame:CGRectMake(0, HScale(18.4), ScreenWidth, HScale(75)) WithImagesArry:imageViewArry];
    _scroll.placeholderImage = [UIImage imageNamed:@""];
    _scroll.netDelagate = self;
    __weak __typeof(self)weakSelf = self;
    NSString *loctionStr = [MatchDict objectForKey:@"退出时记分位置"];
    
    if (!loctionStr) {
        loctionStr = @"1";
    }

    _lastIndex = [loctionStr integerValue];
    if (_index == _lastIndex) {
        [_flagImage setImage:[UIImage imageNamed:@""]];
    }
    _dataIndex = _lastIndex-1;
    
    _scroll.indexBlock = ^(NSInteger index){
        [weakSelf removeAlert];

        if (weakSelf.dataIndex!=index) {
            weakSelf.dataIndex=index;
            [weakSelf postData];
        }
        if (index>17) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击确定跳转至记分卡" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf clickToRecord];
//                }]];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                
//                [weakSelf presentViewController:alertController animated:YES completion:nil];
//            });
            index = 17;
        }
        
        
        weakSelf.lastIndex = index+1;
        
        weakSelf.flagNumLabel.text = [NSString stringWithFormat:@"%ld",(long)index+1];
        weakSelf.index = index+1;
        NSMutableArray *marry = [weakSelf.MatchDict objectForKey:@"已操作洞号"];
        if (!marry) {
            marry = [NSMutableArray array];
        }
        for (int i = 0; i<marry.count; i++) {
            NSString *indexArry = marry[i];
            if ([indexArry integerValue] == index+1) {
                weakSelf.flagNumLabel.textColor = localColor;
                weakSelf.flagImage.image = [UIImage imageNamed:@"洞选择"];
                _selectStyle = 1;
                return;
            }else{
                _selectStyle = 0;
                weakSelf.flagNumLabel.textColor = GPColor(120, 120, 120);
                weakSelf.flagImage.image = [UIImage imageNamed:@"洞默认"];
            }
        }
    };
    [self.view addSubview:_scroll];
    
    
    
    NSString *loctionIdex = [MatchDict objectForKey:@"退出时记分位置"];
    if ([_flagNumLabel.text isEqualToString:loctionIdex]) {
        NSLog(@"1");
        _flagImage.image = [UIImage imageNamed:@"洞选择"];
    }
    
}

-(void)createLabel{
    
    CUSFlashLabel *label2 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(0, HScale(94.2), ScreenWidth, HScale(3.5))];
    [label2 setText:@"左右滑动切换球洞"];
    [label2 setFont:[UIFont systemFontOfSize:kHorizontal(14)]];
    label2.textAlignment = NSTextAlignmentCenter;

    [label2 setTextColor:localColor];
    [label2 setSpotlightColor:[UIColor whiteColor]];
    [label2 setContentMode:UIViewContentModeTop];
    [label2 startAnimating];
    [self.view addSubview:label2];
    
}

-(void)createMarkAlertView{
    
    NSArray *contentArry = @[@"点击设置出发洞",@"点击设置PAR",@"点击记录总杆"];
    for (int i = 0 ; i<3; i++) {
        UILabel *testLabel = [[UILabel alloc] init];
        testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
        testLabel.text = contentArry[i];
        [testLabel sizeToFit];
        CGFloat ViewWidth = testLabel.frame.size.width;

        MarkAlertView *alert = [[MarkAlertView alloc] initWithFrame:CGRectMake((ScreenWidth-WScale(32.5))/2 + WScale(32.5),HScale(27.7) + HScale(25.5)*(i-1) -kHvertical(7), ViewWidth+kWvertical(26),  kHvertical(33))];
        alert.tag = 200000 + i;
        alert.mode = MarkAlertViewModeLeft;
        if (i==0) {
            alert.mode = MarkAlertViewModeTop;
            alert.frame = CGRectMake((ScreenWidth-ViewWidth-kWvertical(20))/2, HScale(7.8)+kHvertical(4), ViewWidth+kWvertical(26),  kHvertical(33));
        }
        [alert createWithContent:contentArry[i]];
        [self.view addSubview:alert];
    }
}

-(void)createPushToStaticsMarkAlertView{
    
    MarkAlertView *testAlert = (MarkAlertView *)[self.view viewWithTag:200003];
    [testAlert removeFromSuperview];
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    testLabel.text = @"确认成绩";
    [testLabel sizeToFit];
    CGFloat ViewWidth = testLabel.frame.size.width;
    
    MarkAlertView *alert = [[MarkAlertView alloc] initWithFrame:CGRectMake(ScreenWidth-ViewWidth - WScale(19)-kWvertical(26),HScale(12.7) , ViewWidth+kWvertical(26),  kHvertical(33))];
    alert.tag = 200000 + 3;
    alert.mode = MarkAlertViewModeRight;

    [alert createWithContent:@"确认成绩"];
    [self.view addSubview:alert];

}


-(void)clickToPoleNum{
    NSLog(@"跳转到总杆数界面");
}
-(void)clickToRecord{
    [self removeAlert];

    NSLog(@"跳转到记录界面");
    [self postData];

    StatisticsViewController *vc =[[StatisticsViewController alloc] init];
    NSDictionary *playerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *nameStr =  [playerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",1]];
    vc.nameArry = @[nameStr];
    vc.nameIdArry = @[userDefaultId];
    vc.userNameId = userDefaultId;
    vc.logInNumber = 4;
    [userDefaults setValue:userDefaultId forKey:@"StatisticsNameId"];

    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)pressBack{
    [self removeAlert];

    NSLog(@"点击了返回按钮");
    [self postData];
    if ([_LoginType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
#pragma mark - 标准杆操作
-(void)addToNormPole:(UIButton *)sender{
    _selectStyle = 1;
    _changeStyle = 1;
    [self removeAlert];


    _flagNumLabel.textColor = localColor;
    [_flagImage setImage:[UIImage imageNamed:@"洞选择"]];
    NSInteger total = [sender.titleLabel.text integerValue];
    total++;
    if (total==6) {
        total=3;
    }
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)total] forState:UIControlStateNormal];

    UIButton *PoleNumBtn = (UIButton *)[self.view viewWithTag:138+sender.tag-1000];        
        UIColor *btnColor = PoleNumBtn.backgroundColor;
        if (![btnColor isEqual: localColor]) {
            [PoleNumBtn setTitle:@"1" forState:UIControlStateNormal];
            if (![sender.titleLabel.text isEqualToString:@"3"]) {
                [PoleNumBtn setTitle:@"2" forState:UIControlStateNormal];
            }
        }
    

    [MatchDict setValue:sender.titleLabel.text forKey:[NSString stringWithFormat:@"第%@洞标准杆",_flagNumLabel.text]];
    [MatchDict setValue:[NSString stringWithFormat:@"%@",_flagNumLabel.text] forKey:@"退出时记分位置"];
    NSMutableArray *marry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:@"已操作洞号"]];
    if (!marry) {
        marry = [NSMutableArray array];
    }
    
    NSInteger *selectInt = 0;
    NSString *index = _flagNumLabel.text;
    for (int i = 0; i<marry.count; i++) {
        NSString *slectStr = marry[i];
        if ([slectStr isEqualToString:index]) {
            selectInt++;
        }
    }
    if (selectInt == 0) {
        [marry addObject:index];
        [MatchDict setValue:marry forKey:@"已操作洞号"];
    }
    [userDefaults setValue:MatchDict forKey:@"MatchDict"];
    
    
    NSLog(@"%@",[MatchDict objectForKey:@"第1洞标准杆"]);
    
}

#pragma mark - 杆数操作
-(void)addToPoleNum:(UIButton *)sender{

    [self removeAlert];
    
    _changeStyle = 1;

    _flagNumLabel.textColor = localColor;
    [_flagImage setImage:[UIImage imageNamed:@"洞选择"]];
    NSInteger total = [sender.titleLabel.text integerValue];
    if (sender.selected) {
        total = [sender.titleLabel.text integerValue] - 1;
        [sender setBackgroundColor:localColor];
    }
    total++;
    sender.selected = NO;

    if (total==11) {
        total=1;
    }
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)total] forState:UIControlStateNormal];
    
    NSString *BtnTitle = sender.titleLabel.text;
    
    NSString *str1 = [NSString stringWithFormat:@"%@",BtnTitle];
    
    NSString *str2 = [NSString stringWithFormat:@"第%@洞%@",_flagNumLabel.text,userDefaultId];
    
    [MatchDict setValue:str1  forKey:str2];

    
    NSMutableArray *Donemarry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:[NSString stringWithFormat:@"第%d位已完成洞号",1]]];
    if (!Donemarry) {
        Donemarry = [NSMutableArray array];
    }
    NSInteger Test = 0;
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)_index];
    for (NSString *Wstr in Donemarry) {
        if ([Wstr isEqualToString:indexStr]) {
            Test++;
        }
    }
    if (Test==0) {
        [Donemarry addObject:indexStr];
    }
    [MatchDict setValue:Donemarry forKey:[NSString stringWithFormat:@"第%d位已完成洞号",1]];
    
    NSLog(@"第%d位已完成洞号%@",1,Donemarry);
    
    
    
    NSMutableArray *marry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:@"已操作洞号"]];
    if (!marry) {
        marry = [NSMutableArray array];
    }
    
    NSInteger *selectInt = 0;
    NSString *index = _flagNumLabel.text;
    for (int i = 0; i<marry.count; i++) {
        NSString *slectStr = marry[i];
        if ([slectStr isEqualToString:index]) {
            selectInt++;
        }
    }
    if (selectInt == 0) {
        [marry addObject:index];
        [MatchDict setValue:marry forKey:@"已操作洞号"];
    }
    

    
    
    NSInteger totalNum = 0;
    for (int x = 0; x<18; x++) {
        NSString *totalStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",x+1 ,userDefaultId]];
        totalNum = totalNum+ [totalStr integerValue];
    }
    [MatchDict setValue:[NSString stringWithFormat:@"%ld",(long)totalNum] forKey:[NSString stringWithFormat:@"第%d位总杆",1]];
    

    _poleLabel.text = [NSString stringWithFormat:@"%ld",(long)totalNum];
    
    [MatchDict setValue:[NSString stringWithFormat:@"%@",_flagNumLabel.text] forKey:@"退出时记分位置"];
    [userDefaults setValue:MatchDict forKey:@"MatchDict"];
    
    [self ViewAlert];
}

-(void)ViewAlert{
    int a = 0;
    for (int i= 1; i<19; i++) {
        NSString *PlayerScore = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i,userDefaultId]];
        if (!PlayerScore) {
            PlayerScore = @"0";
        }
        if ([PlayerScore isEqualToString:@"0"]) {
            a++;
            break;
        }
    }
    if (a==0) {
        [self ViewStatisticsAlert];
    }

}



#pragma mark - 提交数据
-(void)postData{
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
            Par = @"3";
        }
        NSMutableArray *PlayerArry = [NSMutableArray array];
        NSString *playerNum = [PlayerDict objectForKey:@"playerNum"];
        
        for (int m=0; m<[playerNum integerValue]; m++) {
            NSString *name_id = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",m+1]];
            NSString *nick_name = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",m+1]];
            NSString *Num = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,userDefaultId]];
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
    if (_changeStyle==1) {
        _changeStyle=0;
        
        NSLog(@"%ld",(long)_lastIndex);
        NSDictionary *indexDic = totleArry[_lastIndex-1];
        
        if (_successStyle ==1) {
            totleArry = [NSMutableArray array];
            [totleArry addObject:indexDic];
        }
        
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:totleArry options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = nil;
        if ([jsonData length] > 0){
            jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
        NSString *group_id = [PlayerDict objectForKey:@"group_id"];
        NSString *dong_nu = [NSString stringWithFormat:@"%ld",(long)_lastIndex];
        NSDictionary *dict = @{
                               @"chengji_all":jsonString,
                               @"group_id":group_id,
                               @"dong_nu":dong_nu
                               };
        [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_user_chengji",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
            if (success) {
                _successStyle = 1;
            }else{
                _successStyle = 0;
            }
        }];
        
    }
    
}


-(void)presentView{
    
//    SelectPoleView *vc = [[SelectPoleView alloc] init];
//    NSArray *selectArry = [self.MatchDict objectForKey:@"已操作洞号"];
//    vc.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//
//    vc.indexBlock = ^(NSInteger index){
//    
//        NSLog(@"%ld",(long)index);
//        [_scroll scrollToIndex:index-1];
//    };
//    [self.view addSubview:vc];

}

-(void)removeAlert{

    if ([_LoginType isEqualToString:@"1"]) {
        for (int i = 0; i<3; i++) {
            MarkAlertView *mView = (MarkAlertView *)[self.view viewWithTag:200000+i];
            [mView removeFromSuperview];
        }
    }
    

}


-(void)ViewStatisticsAlert{
    
    [self createPushToStaticsMarkAlertView];
}


@end




