 
//
//  StartScoringViewController.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "StartScoringViewController.h"
#import "StartScoringTableViewCell.h"
#import "AddStartScoringTableViewCell.h"
#import "QRCodeReaderViewController.h"
#import "SingleScoringViewController.h"
#import "ScoringViewController.h"
#import "BallParkViewController.h"
#import "DownLoadDataSource.h"
#import "BallParkSelectModel.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#import "JPUSHService.h"
#import "StarPlayerModel.h"
#import "MarkAlertView.h"


@interface StartScoringViewController ()<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate,UITextFieldDelegate>{
    MBProgressHUD *_HUB;
    MBProgressHUD *_HUB2;
    /***  出发按钮*/
    UIButton *startBtn;
    /***  出发文字*/
    UILabel *startLabel;
    AddStartScoringTableViewCell *addCell;
    AddStartScoringTableViewCell *cell;

    MarkAlertView *_alert;
}



@property(nonatomic,strong)UIImageView     *SelectImage;
@property(nonatomic,strong)UILabel         *SelectName;
@property(nonatomic,strong)UITableView     *mainTableView;
@property(nonatomic,strong)NSMutableArray  *dataArry;
//@property(nonatomic,strong)NSString        *imageUrl;
@property(nonatomic,strong)NSString        *zongbiaozhun;
@property(nonatomic,strong)NSString        *selectIndex;

@property(nonatomic,strong)NSMutableArray  *PlaceDataSouce;


//@property(nonatomic,strong)NSString        *selectTestPlayerNickName;


@end

@implementation StartScoringViewController

-(NSMutableArray *)PlaceDataSouce{
    if (!_PlaceDataSouce) {
        _PlaceDataSouce = [NSMutableArray array];
    }
    return _PlaceDataSouce;
}

-(NSMutableArray *)dataArry{
    if (_dataArry == nil) {
        _dataArry = [[NSMutableArray alloc] init];
    }
    return _dataArry;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_mainTableView reloadData];
}
- (void)viewDidLoad {
    _nameStr = @"请选择球场";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];

    [self createTableView];
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"多人操作返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    UIBarButtonItem *RightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(ScoresCaddie)];
    RightBarbutton .tintColor = [UIColor blackColor];
    [RightBarbutton setImage:[UIImage imageNamed:@"g0-扫描二维码"]];
    self.navigationItem.rightBarButtonItem = RightBarbutton;
    self.title = @"打球记分";
    
    [self loadNearPark];
    [self resevNotic];
    [self viewMarkAlertView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_alert removeFromSuperview];
}
#pragma mark- 接收自定义推送消息
-(void)resevNotic{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)networkDidReceiveMessage:(NSNotification *)noti{
    NSLog(@"%@",noti);
    id dict = noti.userInfo;
    if (!_groupID||[_groupID isEqualToString:@"0"]) {
        return;
    }
    NSDictionary *extras = [dict objectForKey:@"extras"];
//    NSString *UpdateChengJi = [extras objectForKey:@"UpdateChengJi"];
//    if ([UpdateChengJi isEqualToString:@"6"]) {
//        [self downloadData];
//    }
    NSString *PushToStat = [extras objectForKey:@"PushToStat"];
    if ([PushToStat isEqualToString:@"8"]) {
        [self createJustGroup];
    }
    
}

-(void)loadData{
    _dataArry= [[NSMutableArray alloc] init];
    NSString *nickname = [userDefaults objectForKey:@"nickname"];
    NSString *pole_number = [userDefaults objectForKey:@"polenum"];
    NSString *picture_url = [userDefaults objectForKey:@"pic"];
    NSDictionary *dict = @{
                           @"nick_name":nickname,
                           @"name_id":userDefaultId,
                           @"meanPole":pole_number,
                           @"picture_url":picture_url
                           };
    StarPlayerModel *model = [StarPlayerModel pareFrom:dict];
    [_dataArry addObject:model];
    for (int i = 0; i<3; i++) {
        NSDictionary *otherDict = @{
                                    @"nick_name":@"",
                                    @"name_id":@"0",
                                    @"meanPole":@"",
                                    @"picture_url":@"",
                                    };
        StarPlayerModel *model2 = [StarPlayerModel pareFrom:otherDict];
        
        [_dataArry addObject:model2];
    }
    [_mainTableView reloadData];
}



-(void)loadNearPark{

    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"jingdu":lon,
                           @"weidu":lat
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_qiuchang_all",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            _PlaceDataSouce = [NSMutableArray array];
            for (NSDictionary *temp in dic[@"data"]) {
                
                BallParkSelectModel *model = [BallParkSelectModel paresFromDictionary:temp];
                [self.PlaceDataSouce addObject:model];
            }
            
            NSDictionary *temp = dic[@"data"][0];
            NSLog(@"%@",temp);
            _nameStr = [temp objectForKey:@"qiuchang_name"];
            _qiuchang_id = [temp objectForKey:@"qiuchang_id"];
            [_mainTableView reloadData];
            [self createJustGroup];
        }
    }];
}




//返回
-(void)pressBack{
    if (!_groupID) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupID":_groupID
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteGroup",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)createTableView{
    _mainTableView = [[UITableView alloc] init];
    _mainTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerClass:[AddStartScoringTableViewCell class] forCellReuseIdentifier:@"AddStartScoringTableViewCell"];
    [_mainTableView registerClass:[StartScoringTableViewCell class] forCellReuseIdentifier:@"StartScoringTableViewCell"];
    
    _mainTableView.backgroundColor = GPColor(248, 248, 248);
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_mainTableView];
}
//提示语
-(void)viewMarkAlertView{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nameID":userDefaultId,
                           @"windowID":@"SelectMethodMViewController"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertWindowBrows",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (!success) {
            return ;
        }
        NSDictionary *dataDict = [data objectForKey:@"data"];
        NSInteger longInNum = 0;
        if (dataDict) {
            NSString *code = [dataDict objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {
                NSArray *windowBrows = [dataDict objectForKey:@"windowBrows"];
                for (NSDictionary *windowDict in windowBrows) {
                    NSString *windowID = [windowDict objectForKey:@"windowID"];
                    if ([windowID isEqualToString:@"SelectMethodMViewController"]) {
                        NSString *browsNumber = [windowDict objectForKey:@"browsNumber"];
                        longInNum = longInNum + [browsNumber integerValue];
                    }
                    
                }
            }
            if (longInNum<3) {
                [self createAlertMark];
            }
        }
    }];
    
}


-(void)createAlertMark{
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    testLabel.text = @"扫描添加球友";
    [testLabel sizeToFit];
    CGFloat x = ScreenWidth - testLabel.frame.size.width - kWvertical(68);
    
    _alert = [[MarkAlertView alloc] initWithFrame:CGRectMake(x, 23, 10, kHvertical(33))];
    _alert.mode = MarkAlertViewModeRight;
//    alert.tag = 101;
    [_alert createWithContent:@"扫描添加球友"];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:_alert];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            _alert.alpha = 0;
        } completion:^(BOOL finished) {
            [_alert removeFromSuperview];
        }];
    });
}

-(void)createJustGroup{

    if (!_groupID) {
        _groupID = @"0";
    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"saishi_id":@"bisai123",
                           @"jilu_user":userDefaultId,
                           @"bisai_lun":@"1",
                           @"groupId":_groupID,
                           @"testqiuchangID":_qiuchang_id
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsetJustGroup",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (!success) {
            return ;
        }
            NSDictionary *dataDict = [data objectForKey:@"data"];
            if (dataDict) {
                NSString *code = [dataDict objectForKey:@"code"];
                if ([code isEqualToString:@"200"]) {
                    _groupID = [dataDict objectForKey:@"group_id"];
                }else if ([code isEqualToString:@"300"]){
                    _dataArry = [NSMutableArray array];
                    for (int i = 0; i<4; i++) {
                        NSDictionary *otherDict = @{
                                                    @"nick_name":@"",
                                                    @"name_id":@"0",
                                                    @"meanPole":@"",
                                                    @"picture_url":@"",
                                                    };
                        StarPlayerModel *model2 = [StarPlayerModel pareFrom:otherDict];
                        [_dataArry addObject:model2];
                    }

                    
                    NSArray *listGroupUser = [dataDict objectForKey:@"listGroupUser"];
                    for (NSDictionary *userDict in listGroupUser) {
                        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                        NSString *scanning_number = [userDict objectForKey:@"scanning_number"];
                        [mDict setValue:[userDict objectForKey:@"nickName"] forKey:@"nick_name"];
                        [mDict setValue:[userDict objectForKey:@"nameID"] forKey:@"name_id"];
                        [mDict setValue:[userDict objectForKey:@"meanPole"] forKey:@"meanPole"];
                        [mDict setValue:[userDict objectForKey:@"userPic"] forKey:@"picture_url"];
                        StarPlayerModel *model = [StarPlayerModel pareFrom:mDict];
                        NSInteger index = [scanning_number integerValue];
                        [_dataArry removeObjectAtIndex:index];
                        [_dataArry insertObject:model atIndex:index];
                    }
                    
                    NSDictionary *testqiuchang = [dataDict objectForKey:@"testqiuchang"];
                    _nameStr = [testqiuchang objectForKey:@"qiuchang_name"];
                    _qiuchang_id = [testqiuchang objectForKey:@"qiuchang_id"];
                    [_mainTableView reloadData];
                }
            }
        
    }];
}


#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(void)SelectPlace{
    
    BallParkViewController *ballPark = [[BallParkViewController alloc]init];
    
    UIViewController * controller = self.view.window.rootViewController;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    ballPark.view.backgroundColor = [UIColor whiteColor];
    ballPark.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController * jackNavigationController = [[UINavigationController alloc] initWithRootViewController:ballPark];
    [jackNavigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    
//    __weak __typeof(self)weakSelf = self;
    
//    ballPark.selectPar = ^(BallParkSelectModel *selectPark){
//
//        weakSelf.nameStr = [NSString stringWithFormat:@"%@",selectPark.name];
//        weakSelf.zongbiaozhun = [NSString stringWithFormat:@"%@",selectPark.name];
//        weakSelf.qiuchang_id = [NSString stringWithFormat:@"%@",selectPark.ballParkID];
//        
//        [weakSelf reloadPark];
//        [weakSelf.mainTableView reloadData];
//    };
//    ballPark.dataSouce = _PlaceDataSouce;
    [self presentViewController:jackNavigationController animated:YES completion:nil];
    
}

-(void)startNow:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    if (!_qiuchang_id) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请再选择球场后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        btn.userInteractionEnabled = YES;
        return;
    }
    
    
    NSMutableArray *nameIdArry = [NSMutableArray array];
    
    for (StarPlayerModel *model in _dataArry) {
        NSString *nameId = model.name_id ;
        [nameIdArry addObject:nameId];
    }
    //_dataArry
    NSString *nameIdStr;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:nameIdArry options:NSJSONWritingPrettyPrinted error:nil];
    if ([jsonData length] > 0){
        nameIdStr  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.alpha = 0.5;
    _HUB.hidden = NO;
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupID":_groupID,
                           @"qiuChangId":_qiuchang_id
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SetOut",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        _HUB.hidden = YES;
        _HUB = nil;
        btn.userInteractionEnabled = YES;
        if (success) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
            NSDictionary *dataUserDict = data[@"data"];
            NSString *code = [dataUserDict objectForKey:@"code"];
            NSMutableArray *ingPlayerArry = [NSMutableArray array];
            if ([code isEqualToString:@"300"]) {
                NSArray *listNick = [dataUserDict objectForKey:@"listNick"];
                for (NSDictionary *ingDict in listNick) {
                    NSString *ingPlayer = [ingDict objectForKey:@"nickName"];
                    [ingPlayerArry addObject:ingPlayer];
                }
                NSString *descStr = [NSString stringWithFormat:@"以下用户   %@有正在进行的记分,请结束正在进行的记分之后重试.",ingPlayerArry];
                NSLog(@"%@",descStr);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:descStr preferredStyle:UIAlertControllerStyleAlert];
//                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }]];
//                    
//                    [self presentViewController:alertController animated:YES completion:nil];
//                });
                
            }
                        
            if ([code isEqualToString:@"1"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
                NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                
                NSDictionary *placeData  = @{
                                             @"qiuchang_id":_qiuchang_id,
                                             @"qiuchang_name":_nameStr,
                                             @"chuangjian_time":currentDateStr
                                             };

                NSMutableArray *userDataArry = [NSMutableArray new];
                NSInteger totle = _dataArry.count;
                for (NSInteger i = 0; i<totle; i++) {
                    StarPlayerModel *model = _dataArry[i];
                    if (![model.name_id isEqualToString:@"0"]) {
                        [userDataArry addObject:model];
                    }
                }
                _dataArry = [[NSMutableArray alloc] initWithArray:userDataArry];
                
                for (int i=0; i<_dataArry.count; i++) {
                    StarPlayerModel *model = _dataArry[i];
                    NSString *playerName = model.nick_name;
                    NSString *playerId = model.name_id;
                    [dataDict setValue:playerName forKey:[NSString stringWithFormat:@"第%d位名字",i+1]];
                    [dataDict setValue:playerId forKey:[NSString stringWithFormat:@"第%d位id",i+1]];
                }
                _dataArry = userDataArry;
                NSString *playerNum = [NSString stringWithFormat:@"%ld",(long)_dataArry.count];
                [dataDict setValue:playerNum forKey:@"playerNum"];
                [dataDict setValue:_groupID forKey:@"group_id"];
                NSMutableDictionary *MatchDict = [[NSMutableDictionary alloc] init];
                [MatchDict setValue:placeData forKey:@"PlaceDict"];
                [MatchDict setValue:dataDict forKey:@"PlayerDict"];
                [userDefaults setValue:MatchDict forKey:@"MatchDict"];
                if (_dataArry.count==1) {
                    SingleScoringViewController *vc = [[SingleScoringViewController alloc] init];
                    vc.LoginType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ScoringViewController *vc = [[ScoringViewController alloc] init];
                    vc.LoginType = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
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
                [sView removeFromSuperview];
            });
            
        }
    }];
}

//扫描二维码
-(void)ScoresCaddie{
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSInteger test = 0;
        for (int i = 0; i<wSelf.dataArry.count; i++) {
            StarPlayerModel *model = wSelf.dataArry[i];
            if ([resultAsString isEqualToString:model.name_id]) {
                test++;
            }
        }
        if (test==0) {
            [wSelf addPresent:resultAsString];
        }
    }];
    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader animated:YES];
}

-(void)addPresent:(id)sender{
    
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":sender
                           };
    NSMutableDictionary *getDict = [NSMutableDictionary dictionary];
    
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_name_id",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *dataDic = [data objectForKey:@"data"];
            if (dataDic.count==0) {
                
                
                SucessView *sView = [SucessView new];
                sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
                sView.imageName = @"失败";
                sView.descStr = @"二维码无效";
                [sView didFaild];
                [self.view addSubview:sView];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [sView removeFromSuperview];
                });
                
                return ;
            }
            NSDictionary *userDict = dataDic[0];
            NSString *ing = [userDict objectForKey:@"unGroupStatr"];
            
            if ([ing isEqualToString:@"1"]) {
                SucessView *sView = [SucessView new];
                sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
                sView.imageName = @"失败";
                sView.descStr = @"添加失败";
                [sView didFaild];
                [self.view addSubview:sView];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [sView removeFromSuperview];
                });
                return ;
            }
            
            if (dataDic.count==1) {
                [getDict setValue:[userDict objectForKey:@"nickname"] forKey:@"nick_name"];
                [getDict setValue:[userDict objectForKey:@"picture_url"] forKey:@"picture_url"];
                [getDict setValue:[userDict objectForKey:@"meanPole"] forKey:@"meanPole"];
                [getDict setValue:sender forKey:@"name_id"];
                
                [self addPlayer:getDict];
                
            }
            [_mainTableView reloadData];
            
        }else{
            SucessView *sView = [SucessView new];
            sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
            sView.imageName = @"失败";
            sView.descStr = @"网络错误";
            [sView didFaild];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [sView removeFromSuperview];
            });

        }
    }];
    
}
////删除扫描的好友
//-(void)deleat:(id)sender{
//
//    StarPlayerModel *model = _dataArry[[_selectIndex integerValue]];
//    NSString *nameId = model.name_id;
//    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
//    NSDictionary *dict = @{
//                           @"groupNameID":nameId,
//                           @"groupID":_groupID
//                           };
//    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteGroupUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
//        NSLog(@"%@",data);
//        NSString *code = [data objectForKey:@"code"];
//        if ([code isEqualToString:@"1"]) {
//            
//            [self loadData];
//            [_dataArry removeObjectAtIndex:[_selectIndex integerValue]];
//
//        }
//    }];
//    
//    [_mainTableView reloadData];
//    
//}
#pragma mark - TableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else if(section == 1){
        return 1;
    }else if(section == 2){

        return 3;
    }else{
        return 0;
    }
}

-(void)addPlayer:(id)sender{

    NSInteger playerIndex = 0;
    StarPlayerModel *model = [StarPlayerModel pareFrom:sender];
    for (int i = 1; i<5; i++) {
        StarPlayerModel *dataModel = _dataArry[i-1];
        if ([dataModel.name_id isEqualToString:@"0"]) {
            
            playerIndex = i-1;
            break;
        }
        
    }

    if (!_qiuchang_id) {
        return;
    }
    
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"scannerNameId":[sender objectForKey:@"name_id"],
                           @"groupId":_groupID,
                           @"UserNumber":[NSString stringWithFormat:@"%ld",(long)playerIndex],
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/ScannerUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dataDict= [data objectForKey:@"data"];
            NSString *code = [dataDict objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                [_dataArry removeObjectAtIndex:playerIndex];
                
                [_dataArry insertObject:model atIndex:playerIndex];
                
                [_mainTableView reloadData];
            }

        }
    }];
}

-(void)reloadPark{

    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupID":_groupID,
                           @"testqiuchangID":_qiuchang_id
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/UpdateGroupQiuChang",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {

    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return kHvertical(60);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat Vheight = 0;
    
    if (section==0) {
        Vheight = kHvertical(67);
    }else if(section==1){
        Vheight = 0;
    }else if (section==3) {
        if (_dataArry.count==4) {
            Vheight =  HScale(86.8)-HScale(12.6)*4 - 64-HScale(0.9);
        }else{
            Vheight = HScale(86.8)-HScale(12.6)*(_dataArry.count+1) - 64-HScale(0.9);
        }
    }
    return Vheight;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //球场选择
    
    UIView *selectBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WScale(21.6), kHvertical(67))];
    
    selectBackView.backgroundColor = [UIColor whiteColor];
    
    selectBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectPlace)];
    [selectBackView addGestureRecognizer:tpg];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(14))];
    lineView.backgroundColor =  GPColor(248, 248, 248);
    
    
    //选择球场的图片
    _SelectImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(18), kHvertical(32), kWvertical(17),kHvertical(20))];

    _SelectImage.image = [UIImage imageNamed:@"go-球场选择"];
    //选择球场的名称
    _SelectName = [[UILabel alloc] initWithFrame:CGRectMake(_SelectImage.frame.origin.x+_SelectImage.frame.size.width+kWvertical(18), kHvertical(31), WScale(90)-(_SelectImage.frame.origin.x+_SelectImage.frame.size.width+kWvertical(18)), kHvertical(21))];
    _SelectName.text =_nameStr;
    _SelectName.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _SelectName.textColor = [UIColor blackColor];

    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(92.3), kHvertical(35),kWvertical(8), kHvertical(14))];
    selectView.image = [UIImage imageNamed:@"前往球场"];

    [selectBackView addSubview:lineView];
    [selectBackView addSubview:selectView];
    [selectBackView addSubview:_SelectName];
    [selectBackView addSubview:_SelectImage];
    if (section==0) {
        return selectBackView;
    }else if(section == 3){
        
        CGFloat Vheight = 0;
        
        if (_dataArry.count==4) {
            Vheight = HScale(86.8)-HScale(12.6)*(_dataArry.count) - 64-HScale(0.9);
        }else{
            Vheight = HScale(86.8)-HScale(12.6)*(_dataArry.count+1) - 64-HScale(0.9);
        }
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Vheight)];
        backView.backgroundColor = [UIColor clearColor];
        
        startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.frame = CGRectMake(WScale(8.8), Vheight-HScale(20.9), WScale(82.4), HScale(6.7));
        startBtn.layer.masksToBounds = YES;
        startBtn.layer.cornerRadius = HScale(3.35);
        startBtn.userInteractionEnabled = YES;
        
        [startBtn setBackgroundImage:[self imageWithColor:localColor] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[self imageWithColor:GPColor(48, 157, 149)] forState:UIControlStateHighlighted];
        
        [startBtn addTarget:self action:@selector(startNow:) forControlEvents:UIControlEventTouchUpInside];
        startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WScale(82.4), HScale(6.7))];
        startLabel.text = @"出发";
        startLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
        startLabel.textColor = [UIColor whiteColor];
        startLabel.textAlignment = NSTextAlignmentCenter;
        [startBtn addSubview:startLabel];
        
        [backView addSubview:startBtn];
        
        return backView;
        
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return kHvertical(12);
    }
    return CGFLOAT_MIN;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bakView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(12))];
    bakView.backgroundColor = [UIColor clearColor];
    return bakView;
}

-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    return image;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addCell = [tableView dequeueReusableCellWithIdentifier:@"AddStartScoringTableViewCell" forIndexPath:indexPath];
    addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section ==2) {
        addCell.headView.tag = 117+indexPath.row;
        addCell.nameLabel.tag = 127+indexPath.row;
        addCell.deleatView.tag = 137+indexPath.row;
        addCell.nameLabel.delegate = self;
        [addCell.nameLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [addCell.deleatView addTarget:self action:@selector(deleat:) forControlEvents:UIControlEventTouchUpInside];
        
        StarPlayerModel *model = _dataArry[indexPath.row+1];
        NSInteger testInt = 0;
        for (int i = 1; i<4; i++) {
            if (model.picture_url.length==0) {
                testInt++;
            }
        }
        if (testInt==0) {
            [addCell pareModel:model];
            return addCell;
        }
        

        if (testInt!=0) {
            [addCell pareTestModel:model];
        }
    }else{
        StarPlayerModel *model = _dataArry[indexPath.row];
        [addCell pareModel:model];
        
    }
    return addCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==2) {
//        
//        [self ScoresCaddie];3
//        
//        [_mainTableView reloadData];
//    }
}


#pragma mark - textFeildDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!_groupID) {
        return;
    }
    
    NSInteger index = textField.tag+10 - 136;
    StarPlayerModel *model = _dataArry[index];
    NSString *nameId = model.name_id;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupNameID":nameId,
                           @"groupID":_groupID
                           };
    if ([nameId isEqualToString:@"0"]) {
        
    }else{
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteGroupUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
//        NSLog(@"%@",data);
//        NSString *code = [data objectForKey:@"code"];
//        if ([code isEqualToString:@"1"]) {
//            NSDictionary *dict = @{
//                                   @"nick_name":@"",
//                                   @"name_id":@"0",
//                                   @"meanPole":@"",
//                                   @"picture_url":@""
//                                   };
//            StarPlayerModel *model = [StarPlayerModel pareFrom:dict];
//            [_dataArry removeObjectAtIndex:index];
//            [_dataArry insertObject:model atIndex:index];
//        }
    }];
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    UIButton *deleatView = (UIButton *)[self.view viewWithTag:textField.tag + 10];
    UIImageView *headerImage = (UIImageView *)[self.view viewWithTag:textField.tag - 10];
//    addCell.headView.tag = 123+indexPath.row;

    NSString *textStr = textField.text;
    if (textStr.length>0) {
        deleatView.hidden = NO;
        headerImage.image = [UIImage imageNamed:@"go-输入－激活"];
    }else{
        deleatView.hidden = YES;
        headerImage.image = [UIImage imageNamed:@"go-输入－默认"];
    }
    
    switch (textField.tag) {
        case 127:{
            
        }break;
        case 128:{
            
        }break;
        case 129:{
            
        }break;
            
        default:
            break;
    }

}



#pragma mark - 删除球员
-(void)deleat:(UIButton *)sender{
    
    NSInteger index = sender.tag - 136;
    
    UITextField *PlayerText = (UITextField *)[self.view viewWithTag:sender.tag - 10];
    UIImageView *headerImage = (UIImageView *)[self.view viewWithTag:sender.tag - 20];
    PlayerText.text = @"";
    headerImage.image = [UIImage imageNamed:@"go-输入－默认"];
    sender.hidden = YES;
    
    StarPlayerModel *model = _dataArry[index];
    NSString *nameId = model.name_id;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"groupNameID":nameId,
                           @"groupID":_groupID
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/DeleteGroupUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        NSLog(@"%@",data);
        NSString *code = [data objectForKey:@"code"];
//        if ([code isEqualToString:@"1"]) {
            NSDictionary *dict = @{
                                   @"nick_name":@"",
                                   @"name_id":@"0",
                                   @"meanPole":@"",
                                   @"picture_url":@""
                                   };
            StarPlayerModel *model = [StarPlayerModel pareFrom:dict];
            [_dataArry removeObjectAtIndex:index];
            [_dataArry insertObject:model atIndex:index];
            [_mainTableView reloadData];
//        }
    }];
    [_mainTableView reloadData];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tagIndex = textField.tag;
    NSString *nickName = textField.text;
    if (nickName.length<1) {
        return;
    }
    switch (tagIndex) {
        case 127:{
            
        }break;
        case 128:{
            
        }break;
        case 129:{
            
        }break;
            
        default:
            break;
    }
    
    _HUB2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB2.mode = MBProgressHUDModeIndeterminate;
    _HUB2.alpha = 0.5;
    _HUB2.hidden = NO;
    _mainTableView.userInteractionEnabled = NO;
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)(tagIndex -126)];
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"nickName":nickName,
                           @"UserNumber":indexStr,
                           @"groupId":_groupID,
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertTemporaryUser",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        _mainTableView.userInteractionEnabled = YES;
        _HUB2.hidden = YES;
        [_HUB removeFromSuperview];
        if (success) {
            NSString *code = [data objectForKey:@"code"];
            if ([code isEqualToString:@"1"]) {
                NSString *TemporaryNameID = [data objectForKey:@"TemporaryNameID"];

                NSDictionary *userDict = @{
                                           @"nick_name":nickName,
                                           @"name_id":TemporaryNameID,
                                           @"meanPole":@"",
                                           @"picture_url":@""
                                           };
                StarPlayerModel *model = [StarPlayerModel pareFrom:userDict];
                [_dataArry removeObjectAtIndex:[indexStr integerValue]];
                [_dataArry insertObject:model atIndex:[indexStr integerValue]];
//                [_mainTableView reloadData];
            }
        }
    }];
}

#pragma mark - 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 0; i<3; i++) {
        UITextField *textfield = (UITextField *)[self.view viewWithTag:127+i];
        [textfield resignFirstResponder];
        
    }
}

@end
