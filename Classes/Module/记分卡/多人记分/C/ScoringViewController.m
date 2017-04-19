//
//  ScoringViewController.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/7.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "ScoringViewController.h"
#import "CardScrollView.h"
#import "StatisticsViewController.h"
#import "DownLoadDataSource.h"
#import "CUSFlashLabel.h"
#import "SelectMethodMViewController.h"
#import "SelectPoleView.h"
#import "JPUSHService.h"
#import "MarkAlertView.h"

@interface ScoringViewController ()<UIScrollViewDelegate,WYScrollViewNetDelegate>{
    CardScrollView *_scroll;
    NSString *_slectIndex;
    NSInteger startNum;
    NSInteger selectStyle;
    NSMutableDictionary *MatchDict;
}

@property(nonatomic,strong)UIScrollView   *mainScrollView;
@property(nonatomic,strong)UILabel        *indexLable;
@property(nonatomic,strong)UILabel        *totleLabel;
@property(nonatomic,strong)UIImageView    *flagView;
@property(nonatomic,assign)NSInteger      dataIndex;
@property(nonatomic,assign)NSInteger      lastIndex;
@property(nonatomic,strong)NSMutableArray *nameArry;
@property(nonatomic,assign)NSInteger      changeStyle;
@property(nonatomic,assign)NSInteger      successStyle;
@property(nonatomic,strong)NSMutableArray  *orderArry;//当前洞排序数组
//@property(nonatomic,strong)NSMutableArray  *PlayerIndexIdArry;//当前洞用户Id数组

//@property (assign, nonatomic) BOOL               isConfirm;


//@property(nonatomic,strong)NSDictionary *MatchDict;

@end

@implementation ScoringViewController


-(NSMutableArray *)orderArry{
    if (!_orderArry) {
        _orderArry = [NSMutableArray array];
    }
    return _orderArry;
}

-(NSArray *)nameArry{
    if (_nameArry==nil) {
        _nameArry = [[NSMutableArray alloc] init];
    }
    return _nameArry;
}

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
    MatchDict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"MatchDict"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self setOrderArry];

    [self createUI];
    [self createLabel];
    [self resevNotic];
    if ([_LoginType isEqualToString:@"1"]) {
        [self insertView];
    }
    [self ViewAlert];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeAlert];
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
    NSString *UpdateChengJi = [extras objectForKey:@"PushToStat"];
    NSString *groupNameID = [extras objectForKey:@"groupNameID"];
    if ([UpdateChengJi isEqualToString:@"8"]) {
//        [self loadPlayerData:groupNameID];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)loadPlayerData:(NSString *)send{
    NSLog(@"%@",MatchDict);
    NSMutableDictionary *PlayerDict = [NSMutableDictionary dictionaryWithDictionary:[MatchDict objectForKey:@"PlayerDict"]];
    NSMutableDictionary *NewPlayerDict = [NSMutableDictionary dictionaryWithDictionary:[MatchDict objectForKey:@"PlayerDict"]];

    NSInteger playerNum = [[PlayerDict objectForKey:@"playerNum"] integerValue];
    
    for (int i = 1; i<5; i++) {
        NSString *nameId = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",i]];
        if ([nameId isEqualToString:send]) {
            [PlayerDict removeObjectForKey:[NSString stringWithFormat:@"第%d位id",i]];
            [PlayerDict removeObjectForKey:[NSString stringWithFormat:@"第%d位名字",i]];
            playerNum = playerNum - 1;
            [PlayerDict removeObjectForKey:@"playerNum"];
        }
    }
    [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)playerNum] forKey:@"playerNum"];
    
    NSMutableDictionary *testPlayerDict = [NSMutableDictionary dictionary];
    [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",1]] forKey:[NSString stringWithFormat:@"第%d位id",1]];
    [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",1]] forKey:[NSString stringWithFormat:@"第%d位名字",1]];
    [testPlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)playerNum] forKey:@"playerNum"];
    
    [testPlayerDict setValue:[PlayerDict objectForKey:@"group_id"] forKey:@"group_id"];
    NSInteger testIndex = 0;
    for (int j = 1; j<playerNum+1; j++) {
        NSString *nameId = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",j]];
        if (!nameId) {
            if (j<playerNum) {
            testIndex ++;
            if (j==2) {
                for (int k = 3; k< 5; k++) {
                    
                    [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",k]] forKey:[NSString stringWithFormat:@"第%d位id",k-1]];
                    [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",k]] forKey:[NSString stringWithFormat:@"第%d位名字",k-1]];
                    
                }
                
            }else if (j==3){
                [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",2]] forKey:[NSString stringWithFormat:@"第%d位id",2]];
                
                [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",2]] forKey:[NSString stringWithFormat:@"第%d位名字",2]];
                [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",4]] forKey:[NSString stringWithFormat:@"第%d位id",3]];
                
                [testPlayerDict setValue:[PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",4]] forKey:[NSString stringWithFormat:@"第%d位名字",3]];
            }
            }
        }

    }
    
    
    
    if (testIndex==0) {
        testPlayerDict = PlayerDict;
    }
        PlayerDict = testPlayerDict;
    
    [MatchDict setValue:testPlayerDict forKey:@"PlayerDict"];
    [MatchDict setValue:[NSString stringWithFormat:@"%@",_indexLable.text] forKey:@"退出时记分位置"];

    [userDefaults setValue:MatchDict forKey:@"MatchDict"];
    
    [self setOrderArry];
    
    
    [_scroll removeFromSuperview];

    MatchDict = [NSMutableDictionary dictionaryWithDictionary: [userDefaults objectForKey:@"MatchDict"]];
    NSLog(@"%@",[MatchDict objectForKey:@"退出时记分位置"]);
    [self createContentView];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

-(void)createUI{
    [self createNavi];
    [self createContentView];
}

-(void)createNavi{
    //pop返回
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.frame = CGRectMake(0, 0,WScale(16), HScale(11));
    
    UIImageView *BackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"多人操作返回"]];
    BackView.frame = CGRectMake(WScale(3.5), HScale(4.9), WScale(3.2), HScale(2.8));
    [BackBtn addSubview:BackView];
    [self.view addSubview:BackBtn];
    
    //操作记录
    
    UIButton *TotalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [TotalBtn addTarget:self action:@selector(pushToView) forControlEvents:UIControlEventTouchUpInside];
    TotalBtn.frame = CGRectMake(WScale(90), 0, WScale(10), HScale(10));
    
    UIImageView *TotalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"操作记录"]];
    TotalView.frame = CGRectMake(WScale(1.2), HScale(4.9), WScale(5.3), HScale(2.7));
    [TotalBtn addSubview:TotalView];
    [self.view addSubview:TotalBtn];
    
    
    _indexLable = [[UILabel alloc] init];
    _indexLable.frame = CGRectMake(WScale(20), HScale(3.9), WScale(26), HScale(4.8));
    NSString *indexStr = [MatchDict objectForKey:@"退出时记分位置"];
    if (!indexStr) {
        indexStr=@"1";
    }
    _indexLable.text = indexStr;

    _indexLable.textColor = GPColor(120, 120, 120);
    _indexLable.textAlignment = NSTextAlignmentRight;
    _indexLable.font = [UIFont systemFontOfSize:kHorizontal(22)];
    
    _flagView = [[UIImageView alloc] init];
    _flagView.frame = CGRectMake(WScale(47.2), HScale(4.8), WScale(4.5), HScale(3));
    _flagView.image = [UIImage imageNamed:@"洞默认"];

    
    NSMutableArray *marry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:@"已操作洞号"]];
    if (!marry) {
        marry = [NSMutableArray array];
    }
    for (int i = 0; i<marry.count; i++) {
        NSString *indexArry = marry[i];
        if ([indexArry integerValue] == [indexStr integerValue]) {
            _indexLable.textColor = localColor;
            _flagView.image = [UIImage imageNamed:@"洞选择"];
            selectStyle = 1;
            break;
        }else{
            selectStyle = 0;
            _indexLable.textColor = GPColor(120, 120, 120);
            _flagView.image = [UIImage imageNamed:@"洞默认"];
        }
    }
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(53.1), HScale(5.8), 14, 9)];
    selectImageView.image = [UIImage imageNamed:@"洞序向下"];
    [self.view addSubview:_indexLable];
    [self.view addSubview:_flagView];
    [self.view addSubview:selectImageView];
    
    UIButton *selectPoleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPoleBtn.frame = CGRectMake(WScale(40), HScale(3), WScale(20), HScale(5));
    [selectPoleBtn addTarget:self action:@selector(presentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectPoleBtn];
    
}


-(void)createContentView{
    NSMutableArray *imageViewArry = [[NSMutableArray alloc] init];
    NSArray *titleNumArry = @[@"3",@"4",@"5"];
    NSArray *titleArry = @[@"球员",@"杆数",@"总杆"];
    
    for (int i = 0; i<18; i++) {
        UIImageView *view = [[UIImageView alloc] init];
        view.frame = CGRectMake(ScreenWidth*i, 0,ScreenWidth, HScale(88.8));
        UILabel *criteriaLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(2.5))];
        criteriaLable.textColor = GPColor(22, 22, 22);
        criteriaLable.text = @"标准杆";
        criteriaLable.font = [UIFont systemFontOfSize:kHorizontal(12)];
        criteriaLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:criteriaLable];
        
        
        for (int a = 0; a<3; a++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.tag = 100000*(a+1)+i;
            titleBtn.frame = CGRectMake(WScale(13.9) + WScale(28.6)*a,  HScale(6.2), WScale(15), HScale(8.4));
            [titleBtn setTitle:titleNumArry[a] forState:UIControlStateNormal];
            [titleBtn setTitleColor:GPColor(120, 120, 120) forState:UIControlStateNormal];
            [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

            NSString *titleSelectStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
            NSString *indexTitleStr = [NSString stringWithFormat:@"%@",titleNumArry[a]];
            if ([titleSelectStr isEqualToString:indexTitleStr]) {
                titleBtn.selected = YES;
                titleBtn.backgroundColor = localColor;

            }
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(32.8)];
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn.layer.cornerRadius = titleBtn.frame.size.height/2;
            titleBtn.layer.masksToBounds = YES;
            titleBtn.layer.borderWidth = 1;
            titleBtn.layer.borderColor = [GPColor(234, 234, 234) CGColor];
            [view addSubview:titleBtn];
            
        }
        
        
        for (int b = 0; b<3; b++) {
            UILabel *titleLable = [[UILabel alloc] init];
            titleLable.frame = CGRectMake(WScale(7.7) + WScale(39.1)*b, HScale(18.2), WScale(6.4), HScale(2.5));
            titleLable.text = titleArry[b];
            titleLable.textColor = GPColor(22, 22, 22);
            titleLable.font = [UIFont systemFontOfSize:kHorizontal(12)];
            [view addSubview:titleLable];
            
        }
        NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
        NSString *playerNum = [PlayerDict objectForKey:@"playerNum"];
        for (int c=0; c<[playerNum integerValue]; c++) {
            UIView *line = [[UIView alloc] init];
            line.frame = CGRectMake(WScale(7.7), HScale(21.5)  + HScale(15.8)*c, WScale(84.6), 1);
            line.backgroundColor = GPColor(243, 243, 243);
            [view addSubview:line];
            
            NSMutableArray *nameArry = [NSMutableArray array];
            NSMutableArray *nameIdArry = [NSMutableArray array];
            
            
            NSArray *SortArry = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞用户顺序",i+1]];
            for (NSDictionary *userDict in SortArry) {
                NSString *nameId = [userDict objectForKey:@"name_id"];
                NSString *name = [userDict objectForKey:@"nick_name"];
//                NSString *Num = [userDict objectForKey:@"Num"];
                [nameIdArry addObject:nameId];
                [nameArry addObject:name];
            }
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.frame = CGRectMake(WScale(7.7), line.frame.origin.y+ HScale(6.3) , WScale(30), HScale(3));
            nameLabel.text = nameArry[c];
            nameLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
            nameLabel.textColor = GPColor(33, 32, 32);
            nameLabel.tag = 20000 + c +(i+1)*10;
            //20000 +i + c*10;
            //10000
            [view addSubview:nameLabel];
            
            UIButton *stemNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            stemNumBtn.frame = CGRectMake(WScale(42.5), line.frame.origin.y+HScale(3.7), WScale(15), HScale(8.4));
            
            NSString *poleStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i+1,nameIdArry[c]]];
            
            NSString *titleStr = poleStr;
            
            
           
            NSString *titleSelectStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞标准杆",i+1]];
            
            [stemNumBtn setTitle:@"1" forState:UIControlStateNormal];
            
            if ([titleSelectStr isEqualToString:@"5"]||[titleSelectStr isEqualToString:@"4"]) {
                [stemNumBtn setTitle:@"2" forState:UIControlStateNormal];
            }
            
            [stemNumBtn setTitleColor:GPColor(120, 120, 120) forState:UIControlStateNormal];
            
            if (titleStr) {
                [stemNumBtn setTitle:titleStr forState:UIControlStateNormal];
                [stemNumBtn setTitleColor:GPColor(32, 190, 189) forState:UIControlStateNormal];
            }
            

            stemNumBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(32.8)];
            stemNumBtn.tag = 138+c + 10*(i+1);
            [stemNumBtn addTarget:self action:@selector(stemBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            stemNumBtn.layer.cornerRadius = stemNumBtn.frame.size.height/2;
            stemNumBtn.layer.masksToBounds = YES;
            stemNumBtn.layer.borderWidth = 1;
            stemNumBtn.layer.borderColor = [GPColor(234, 234, 234) CGColor];
            [view addSubview:stemNumBtn];
            
            
            _totleLabel = [[UILabel alloc] init];
            _totleLabel.frame = CGRectMake(WScale(70), line.frame.origin.y+HScale(5.7), WScale(22.3), HScale(4.2));
            _totleLabel.textColor = GPColor(44, 44, 44);
            _totleLabel.tag = 10000 + c +(i+1)*10;
            NSInteger totleNum = 0;
            for (int m = 0; m<18; m++) {
                NSString *PlayerPoloNum = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",m+1,nameIdArry[c]]];
                totleNum += [PlayerPoloNum integerValue];
            }
            _totleLabel.text = @"0";

            if (totleNum>0) {
                _totleLabel.text = [NSString stringWithFormat:@"%ld",(long)totleNum];
            }
            
            _totleLabel.font = [UIFont systemFontOfSize:kHorizontal(20)];
            _totleLabel.textAlignment = NSTextAlignmentRight;
            [view addSubview:_totleLabel];

        }
        view.userInteractionEnabled = YES;
        
        [imageViewArry addObject:view];
    }
    
    
    
    _scroll = [[CardScrollView alloc]initWithFrame:CGRectMake(0, HScale(11.2), ScreenWidth, HScale(83)) WithImagesArry:imageViewArry];
    
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.placeholderImage = [UIImage imageNamed:@""];
    _scroll.netDelagate = self;
    __weak __typeof(self)weakSelf = self;
    NSString *loctionStr = [MatchDict objectForKey:@"退出时记分位置"];
    [MatchDict setValue:loctionStr forKey:@"上次移动的位置"];
    if (!loctionStr) {
        loctionStr = @"1";
    }
    _lastIndex = [loctionStr integerValue];

    _dataIndex = _lastIndex-1;
    
    _scroll.indexBlock = ^(NSInteger index){
        [weakSelf removeAlert];
        if (index>17) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击确定跳转至记分卡" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf pushToView];
//                }]];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                
//                [weakSelf presentViewController:alertController animated:YES completion:nil];
//            });
            index = 17;
        }

        
        
        if (weakSelf.dataIndex!=index) {
            
            NSInteger lastInter = [[weakSelf.MatchDict objectForKey:@"上次移动的位置"] integerValue];
            
            [weakSelf.MatchDict setValue:[NSString stringWithFormat:@"%ld",index+1] forKey:@"上次移动的位置"];
            
            weakSelf.dataIndex=index;
            weakSelf.lastIndex = index+1;
//            [weakSelf loadAllPoleData];
            if (lastInter==index) {
                [weakSelf postData];
                [weakSelf SortPoleData];
            }else if (lastInter == index+2){
                [weakSelf SortPoleData];

            }
            
            weakSelf.indexLable.text = [NSString stringWithFormat:@"%ld",(long)index+1];
            NSMutableArray *marry = [NSMutableArray arrayWithArray:[weakSelf.MatchDict objectForKey:@"已操作洞号"]];
            if (!marry) {
                marry = [NSMutableArray array];
            }
            for (int i = 0; i<marry.count; i++) {
                NSString *indexArry = marry[i];
                if ([indexArry integerValue] == index+1) {
                    weakSelf.indexLable.textColor = localColor;
                    weakSelf.flagView.image = [UIImage imageNamed:@"洞选择"];
                    
                    selectStyle = 1;
                    return;
                }else{
                    selectStyle = 0;
                    
                    weakSelf.indexLable.textColor = GPColor(120, 120, 120);
                    weakSelf.flagView.image = [UIImage imageNamed:@"洞默认"];
                }
            }
        }
    };
    [self.view addSubview:_scroll];
    
    NSString *loctionIdex = [MatchDict objectForKey:@"退出时记分位置"];
    if ([_indexLable.text isEqualToString:loctionIdex]) {
        NSLog(@"1");
        _flagView.image = [UIImage imageNamed:@"洞选择"];
    }
}

-(void)createMarkAlertView{

    NSArray *contentArry = @[@"点击设置出发洞",@"点击设置PAR",@"点击记录总杆"];
    for (int i = 0 ; i<3; i++) {
        UILabel *testLabel = [[UILabel alloc] init];
        testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
        testLabel.text = contentArry[i];
        [testLabel sizeToFit];
        CGFloat ViewWidth = testLabel.frame.size.width;
        
        MarkAlertView *alert = [[MarkAlertView alloc] initWithFrame:CGRectMake((ScreenWidth-WScale(42.5))/2 + WScale(32.5)-kWvertical(10),kHvertical(81) + kHvertical(245)*(i-1), ViewWidth+kWvertical(26),  kHvertical(33))];
        alert.tag = 400000 + i;
        alert.mode = MarkAlertViewModeLeft;
        if (i==0) {
            alert.mode = MarkAlertViewModeRight;
            alert.frame = CGRectMake( WScale(50.4) - ViewWidth - kWvertical(46) - WScale(4), kHvertical(23), ViewWidth+kWvertical(26),  kHvertical(33));
        }
        [alert createWithContent:contentArry[i]];
        [self.view addSubview:alert];
        


        
    }
}

-(void)createPushToStaticsMarkAlertView{
    MarkAlertView *testAlert = (MarkAlertView *)[self.view viewWithTag:400003];
    [testAlert removeFromSuperview];
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    testLabel.text = @"确认成绩";
    [testLabel sizeToFit];
    CGFloat ViewWidth = testLabel.frame.size.width;

    
    MarkAlertView *alert = [[MarkAlertView alloc] initWithFrame:CGRectMake(ScreenWidth-ViewWidth - WScale(12)-kWvertical(26),HScale(3.8) , ViewWidth+kWvertical(26),  kHvertical(33))];
    alert.tag = 400000 + 3;
    alert.mode = MarkAlertViewModeRight;
    
    [alert createWithContent:@"确认成绩"];
    [self.view addSubview:alert];
    
    
}

-(void)setOrderArry{
    NSMutableArray *PlayerArry = [NSMutableArray array];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *playerNum = [PlayerDict objectForKey:@"playerNum"];
    for (int m=0; m<[playerNum integerValue]; m++) {
        NSString *name_id = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",m+1]];
        NSString *nick_name = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",m+1]];
        
        NSDictionary *Player = @{
                                 @"nick_name":nick_name,
                                 @"name_id":name_id,
                                 @"Num":@"0"
                                 };
        [PlayerArry addObject:Player];
    }
    
    for (NSInteger i = 0; i<18; i++) {
        [MatchDict setValue:PlayerArry forKey:[NSString stringWithFormat:@"第%ld洞用户顺序",(long)i+1]];
    }
    
    
}


#pragma mark - 标准杆

-(void)titleBtnClick:(UIButton *)btn{
    [self removeAlert];
    selectStyle = 1;
    _changeStyle = 1;
    _indexLable.textColor = localColor;
    _flagView.image = [UIImage imageNamed:@"洞选择"];
    NSInteger indexPag = btn.tag%100;
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:100000+indexPag];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:200000+indexPag];
    UIButton *btn5 = (UIButton *)[self.view viewWithTag:300000+indexPag];
    NSInteger SelectNum = 0;
//    NSString *titleSelectStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%ld洞标准杆",(long)indexPag+1]];

    for (int i = 0; i<4; i++) {
        UIButton *NumBtn = (UIButton *)[self.view viewWithTag: 138+i+10*(indexPag+1)];
        
        UIColor *btnColor = NumBtn.titleLabel.textColor;
        if ([btnColor isEqual: GPColor(32, 190, 189)]) {
            SelectNum++;
        }
    };
    if (SelectNum==0) {
        for (int i = 0; i<4; i++) {
            UIButton *NumBtn = (UIButton *)[self.view viewWithTag: 138+i+10*(indexPag+1)];
            [NumBtn setTitle:@"1" forState:UIControlStateNormal];
            if (btn == btn5||btn == btn4) {
                [NumBtn setTitle:@"2" forState:UIControlStateNormal];
            }
        };
    }
    
    if (btn.tag == btn3.tag) {
        btn3.selected = YES;
        btn4.selected = NO;
        btn5.selected = NO;
        btn3.backgroundColor = localColor;
        btn4.backgroundColor = [UIColor whiteColor];
        btn5.backgroundColor = [UIColor whiteColor];

    }else if (btn.tag  == btn4.tag ){
        btn4.selected = YES;
        btn3.selected = NO;
        btn5.selected = NO;
        btn4.backgroundColor = localColor;
        btn3.backgroundColor = [UIColor whiteColor];
        btn5.backgroundColor = [UIColor whiteColor];

    }else if (btn.tag  == btn5.tag ){
        btn5.selected = YES;
        btn4.selected = NO;
        btn3.selected = NO;
        btn5.backgroundColor = localColor;
        btn3.backgroundColor = [UIColor whiteColor];
        btn4.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"1" forKey:@"2"];
    [MatchDict setValue:@"1" forKey:@"2"];
    [MatchDict setValue:btn.titleLabel.text forKey:[NSString stringWithFormat:@"第%ld洞标准杆",(long)indexPag+1]];

    [MatchDict setValue:[NSString stringWithFormat:@"%@",_indexLable.text] forKey:@"退出时记分位置"];
    NSString *index = _indexLable.text;
    NSMutableArray *marry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:@"已操作洞号"]];
    if (!marry) {
        marry = [NSMutableArray array];
    }
    
    
    NSInteger *selectInt = 0;
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
}


#pragma mark - 杆数操作
-(void)stemBtnClick:(UIButton *)btn{
    if (selectStyle==0) {
        return;
    }
    _changeStyle=1;
    btn.selected = YES;

    NSInteger total = [btn.titleLabel.text integerValue];
    _indexLable.textColor = localColor;
    _flagView.image = [UIImage imageNamed:@"洞选择"];
    if ([btn.titleLabel.textColor isEqual:GPColor(120, 120, 120)]) {
        [btn setTitleColor:GPColor(32, 190, 189) forState:UIControlStateNormal];
    }else{
        total++;
    }

    if (total==11) {
        total=1;
    }
    
    
    NSString *index = _indexLable.text;
    
    [btn setTitle:[NSString stringWithFormat:@"%ld",(long)total] forState:UIControlStateNormal];
    
    [btn setTitleColor:GPColor(32, 190, 189) forState:UIControlStateNormal];
    
//    [MatchDict setValue:[NSString stringWithFormat:@"%ld",(long)total]  forKey:[NSString stringWithFormat:@"第%d洞第%ld位",[index intValue],(long)(btn.tag - 137 - [index integerValue]*10)]];
    NSString *indexPolor = [NSString stringWithFormat:@"%ld",(long)total];
    NSMutableArray *nameIdArry = [NSMutableArray array];
    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *playerNum = [PlayerDict objectForKey:@"playerNum"];
    

    for (int i = 1; i<[playerNum intValue]+1; i++) {
        NSString *selectPlayerNameId = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",i]];
        [nameIdArry addObject:selectPlayerNameId];
    }
    
    
    NSInteger playerIndex = btn.tag - 137 - [index integerValue]*10;
    NSString *indexNameId = nameIdArry[playerIndex-1];
    NSString *indexPole = _indexLable.text;
    
    [MatchDict setValue:indexPolor forKey:[NSString stringWithFormat:@"第%@洞%@",indexPole,indexNameId]];
    
    NSLog(@"%@",[MatchDict objectForKey:[NSString stringWithFormat:@"第%@洞%@",indexPole,indexNameId]]);
    
    NSMutableArray *Donemarry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:[NSString stringWithFormat:@"第%ld位已完成洞号",(long)(btn.tag - 137 - [index integerValue]*10)]]];
    if (!Donemarry) {
        Donemarry = [NSMutableArray array];
    }
    
    NSInteger Test = 0;
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)[index integerValue]-1];
    for (NSString *Wstr in Donemarry) {
        if ([Wstr isEqualToString:indexStr]) {
            Test++;
        }
    }
    if (Test==0) {
        [Donemarry addObject:indexStr];
    }
    [MatchDict setValue:Donemarry forKey:[NSString stringWithFormat:@"第%ld位已完成洞号",(btn.tag - 137 - [index integerValue]*10)]];
//    NSLog(@"第%ld位已完成洞号%@",(btn.tag - 137 - [index integerValue]*10),Donemarry);
    [MatchDict setValue:[NSString stringWithFormat:@"%@",_indexLable.text] forKey:@"退出时记分位置"];
    NSMutableArray *marry = [NSMutableArray arrayWithArray:[MatchDict objectForKey:@"已操作洞号"]];
    if (!marry) {
        marry = [NSMutableArray array];
    }
    NSInteger *selectInt = 0;
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
       NSString *totalStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",x+1,nameIdArry[playerIndex-1]]];
        totalNum = totalNum+ [totalStr integerValue];
    }
    NSLog(@"第%ld位总杆为%ld杆",btn.tag-137 - [index integerValue]*10,(long)totalNum);
    [MatchDict setValue:[NSString stringWithFormat:@"%ld",(long)totalNum] forKey:[NSString stringWithFormat:@"第%ld位总杆",btn.tag-137 - [index integerValue]*10]];
    
    for (int i =0; i<18; i++) {
        UILabel *totalLabel = (UILabel *)[self.view viewWithTag:10000+(btn.tag-137 - [index integerValue]*10)+(i+1)*10 -1];
        totalLabel.text = [NSString stringWithFormat:@"%ld",(long)totalNum];
    }
    
    [userDefaults setValue:MatchDict forKey:@"MatchDict"];
    
    [self ViewAlert];
   
}

-(void)ViewAlert{
    
    NSMutableArray *PlayerIdArry = [NSMutableArray array];
    NSDictionary *playerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *playerNum = [playerDict objectForKey:@"playerNum"];
    
    for (int m=0; m<[playerNum integerValue]; m++) {
        NSString *nick_name = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",m+1]];
        NSString *name_id = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位id",m+1]];
        [PlayerIdArry addObject:name_id];
    }
    int a = 0;
    for (int j = 0; j<PlayerIdArry.count; j++) {
        
        for (int i= 1; i<19; i++) {
            NSString *PlayerScore = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",i,PlayerIdArry[j]]];
            if (!PlayerScore) {
                PlayerScore = @"0";
            }
            if ([PlayerScore isEqualToString:@"0"]) {
                a++;
                break;
            }
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
    if (_changeStyle==1) {
        _changeStyle=0;
        
        NSDictionary *indexDic;
        if (_lastIndex==1) {
            indexDic = totleArry[_lastIndex -1];
        }else{
            indexDic = totleArry[_lastIndex-2];
        }
        
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
        NSLog(@"%@",totleArry);
        NSDictionary *dict = @{
                               @"chengji_all":jsonString,
                               @"group_id":[PlayerDict objectForKey:@"group_id"],
                               @"dong_nu":[NSString stringWithFormat:@"%ld",(long)_lastIndex]
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



- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{

}

#pragma mark - 创建排序

-(void)SortPoleData{
    
    if (_lastIndex == 0) {
        return;
    }
    NSMutableArray *nameIdArry = [NSMutableArray array];
    NSArray *SortArry = [MatchDict objectForKey:[NSString stringWithFormat:@"第%ld洞用户顺序",_lastIndex-1]];
    for (NSDictionary *userDict in SortArry) {
        NSString *nameId = [userDict objectForKey:@"name_id"];
        [nameIdArry addObject:nameId];
    }
    
    
    NSMutableArray *PlayerArry = [NSMutableArray array];

    for (int m=0; m<SortArry.count; m++) {
        NSDictionary *userDict = SortArry[m];
        NSString *name_id = [userDict objectForKey:@"name_id"];
        NSString *nick_name = [userDict objectForKey:@"nick_name"];
        NSString *Num = [MatchDict objectForKey:[NSString stringWithFormat:@"第%ld洞%@",(long)_lastIndex-1,name_id]];
        if (!Num) {
            Num = @"1";
        }
        NSDictionary *Player = @{
                                 @"nick_name":nick_name,
                                 @"name_id":name_id,
                                 @"Num":Num
                                 };
        [PlayerArry addObject:Player];
    }
    NSLog(@"排序前的数据%@",PlayerArry);
    NSArray *IndexSortArry = PlayerArry;
    //[self SortPole:PlayerArry];
    _orderArry = [NSMutableArray array];
    for (NSInteger i=0; i<IndexSortArry.count; i++) {
        NSDictionary *userDict = IndexSortArry[i];
        UILabel *testLabel = (UILabel *)[self.view viewWithTag:20000+i+_lastIndex*10];
        testLabel.text = [userDict objectForKey:@"nick_name"];
        UILabel *totleLabel = (UILabel *)[self.view viewWithTag:10000+i+_lastIndex*10];
    
        UIButton *PlayerBtn = (UIButton *)[self.view viewWithTag:138+i+10*_lastIndex];
        NSString *Num = [MatchDict objectForKey:[NSString stringWithFormat:@"第%ld洞%@",(long)_lastIndex,[userDict objectForKey:@"name_id"]]];
        if (Num) {
            [PlayerBtn setTitle:Num forState:UIControlStateNormal];
        }
        
        
        NSInteger totalNum = 0;
        for (int x = 0; x<18; x++) {
            NSString *totalStr = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",x+1,[userDict objectForKey:@"name_id"]]];
            totalNum = totalNum+ [totalStr integerValue];
        }
        totleLabel.text = [NSString stringWithFormat:@"%ld",totalNum];
    }
    
    for (NSInteger i = _lastIndex-1; i<18; i++) {
        [MatchDict setValue:SortArry forKey:[NSString stringWithFormat:@"第%ld洞用户顺序",(long)i+1]];
    }
    [MatchDict setValue:IndexSortArry forKey:[NSString stringWithFormat:@"第%ld洞用户顺序",(long)_lastIndex]];
    [userDefaults setValue:MatchDict forKey:@"MatchDict"];
    
}






-(NSArray *)SortPole:(NSMutableArray *)sendArry{
//    NSArray *datArry = [NSArray array];
//    NSMutableArray *poleArry = [NSMutableArray array];
//    for (NSInteger i=0; i<sendArry.count; i++) {
//        NSDictionary *sendDict = sendArry[i];
//        NSString *PoleStr = [sendDict objectForKey:@"Num"];
//        [poleArry addObject:PoleStr];
//    }
//    
//    for (NSInteger x=0; x<poleArry.count; x++) {
//        for (NSInteger y = 0; y<poleArry.count-x-1; y++) {
//            if ([poleArry[y+1] integerValue]<[poleArry[y] integerValue]) {
//                NSInteger temp = [poleArry[y] integerValue];
//                poleArry[y] = poleArry[y+1];
//                poleArry[y+1] = [NSNumber numberWithInteger:temp];
//                NSArray *tempArry = sendArry[y];
//                sendArry[y] = sendArry[y+1];
//                sendArry[y+1] = tempArry;
//            }
//        }
//    }
//    NSLog(@"%@",poleArry);
//    datArry = sendArry;
//    return datArry;
    return sendArry;
}

#pragma mark - 请求总杆
-(void)loadAllPoleData{
    if (_lastIndex == 0) {
        return;
    }
    NSMutableArray *nameIdArry = [NSMutableArray array];
    NSArray *SortArry = [MatchDict objectForKey:[NSString stringWithFormat:@"第%ld洞用户顺序",_lastIndex-1]];
    for (NSDictionary *userDict in SortArry) {
        NSString *nameId = [userDict objectForKey:@"name_id"];
        [nameIdArry addObject:nameId];
    }

    for (int i = 0; i<nameIdArry.count; i++) {
        UILabel *totalLabel = (UILabel *)[self.view viewWithTag:10000 + i +_lastIndex*10];

        NSInteger totleNum = 0;
        for (int m = 0; m<18; m++) {
            NSString *PlayerPoloNum = [MatchDict objectForKey:[NSString stringWithFormat:@"第%d洞%@",m+1,nameIdArry[i]]];
            totleNum += [PlayerPoloNum integerValue];
        }
        totalLabel.text = @"0";
        
        if (totleNum>0) {
            totalLabel.text = [NSString stringWithFormat:@"%ld",(long)totleNum];
        }
        
    }
    
    
    
    
}




#pragma mark - 返回
-(void)popBack{
    _changeStyle = 1;

    [self postData];
    if ([_LoginType isEqualToString:@"1"]) {
        [self removeAlert];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)pushToView{
    [self removeAlert];

    _changeStyle = 1;
    _successStyle = 0;
    [self postData];
//    self.view = nil;
    
    NSMutableArray *PlayerArry = [NSMutableArray array];
    NSMutableArray *PlayerIdArry = [NSMutableArray array];
    NSDictionary *playerDict = [MatchDict objectForKey:@"PlayerDict"];
    NSString *playerNum = [playerDict objectForKey:@"playerNum"];
    
    for (int m=0; m<[playerNum integerValue]; m++) {
        NSString *nick_name = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位名字",m+1]];
        NSString *name_id = [playerDict objectForKey:[NSString stringWithFormat:@"第%d位id",m+1]];
        [PlayerArry addObject:nick_name];
        [PlayerIdArry addObject:name_id];
    }
    
    StatisticsViewController *vc = [[StatisticsViewController alloc] init];
    vc.nameIdArry = PlayerIdArry;
    vc.nameArry = PlayerArry;
    vc.userNameId = userDefaultId;
    vc.logInNumber = 4;
    [userDefaults setValue:userDefaultId forKey:@"StatisticsNameId"];
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)presentView{
    
//    SelectPoleView *vc = [[SelectPoleView alloc] init];
//    NSArray *selectArry = [self.MatchDict objectForKey:@"已操作洞号"];
//    [vc createWithData:selectArry index:_indexLable.text];
//    vc.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    
//    vc.indexBlock = ^(NSInteger index){
//        
//        NSLog(@"%ld",(long)index);
//        [_scroll scrollToIndex:index-1];
//    };
//    [self.view addSubview:vc];
//    
}


-(void)dealloc{

    NSLog(@"我看看释放掉没");
    
}
#pragma mark - 创建底部label
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

#pragma mark - 插入记录
-(void)insertView{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"windowID":@"ScoringViewController"
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

-(void)removeAlert{
    
    if ([_LoginType isEqualToString:@"1"]) {
        for (int i = 0; i<3; i++) {
            MarkAlertView *mView = (MarkAlertView *)[self.view viewWithTag:400000+i];
            
            [mView removeFromView];
            
        }
    }
}




-(void)ViewStatisticsAlert{
    
    [self createPushToStaticsMarkAlertView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
