//
//  CodeViewController.m
//  单人记分
//
//  Created by 李盼盼 on 16/6/16.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "CodeViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "JPUSHService.h"
#import "StatisticsViewController.h"


@interface CodeViewController ()

@property (nonatomic ,strong)UIImageView *headermage;
@property (nonatomic ,strong)UILabel *nickName;
@property (nonatomic ,strong)UILabel *messageLabel;
@property (nonatomic ,strong)UIImageView *barcode;
@property (nonatomic ,copy)  UILabel  *GroupId;
@property(nonatomic,strong)NSMutableArray  *userArry;
@property(nonatomic,strong)NSMutableArray  *userIdArry;


//_userArry = [NSMutableArray array];
//_userIdArry = [NSMutableArray array];

@end

@implementation CodeViewController

-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillDisappear:YES];
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GPColor(32, 190, 189);
    [self createUI];
    [self resevNotic];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
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
    if ([UpdateChengJi isEqualToString:@"7"]) {
//        _GroupId = [extras objectForKey:@"GroupId"];
//        [self downloadData];
        [self pressBack];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


-(void)createUI{
    
    
    //    返回
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.frame = CGRectMake(0, 0, WScale(16), HScale(11));
    UIImageView *BackView = [[UIImageView alloc] initWithFrame:CGRectMake( WScale(3.5), HScale(4.9), 19, 19)];
    
    BackView.image = [UIImage imageNamed:@"白色统一返回"];
    
    [BackBtn addSubview:BackView];
    [self.view addSubview:BackBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    titleLabel.text = @"我的二维码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.view.frame.size.height <= 568)
    {
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(20)];
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667){
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(18)];
    }else{
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(17)];
    }
    [self.view addSubview:titleLabel];
    
    UIView *groundView = [[UIView alloc]initWithFrame:CGRectMake(WScale(11.5)/2, HScale(12.3), WScale(88.5), HScale(66.5))];
    groundView.backgroundColor = [UIColor whiteColor];
    groundView.layer.cornerRadius = 6;
    [self.view addSubview:groundView];
    
    _headermage = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(88.5)-WScale(19.7))/2, HScale(2.5), WScale(19.7), HScale(11.1))];
    _headermage.layer.masksToBounds = YES;
    _headermage.layer.cornerRadius = HScale(11.1)/2;
    
    [_headermage sd_setImageWithURL:[userDefaults objectForKey:@"pic"]placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    [groundView addSubview:_headermage];
    
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake((WScale(88.5)-WScale(45.3))/2, HScale(16.3), WScale(45.3), HScale(3.6))];
    _nickName.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"nickname"]];
    _nickName.textAlignment = NSTextAlignmentCenter;
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(17)];
    [groundView addSubview:_nickName];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake((WScale(88.5)-WScale(57.6))/2, HScale(20.5), WScale(57.6), HScale(3.1))];
    NSString *siignature = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"siignature"]];
    if (!siignature) {
        siignature=@"";
    }
    _messageLabel.text = siignature;
    _messageLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor colorWithRed:156/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [groundView addSubview:_messageLabel];
    
    _barcode = [[UIImageView alloc] init];
    _barcode.frame = CGRectMake((WScale(88.5)-WScale(57.6))/2, HScale(25.9), WScale(57.6), HScale(32.4));
    [groundView addSubview:_barcode];
    UIImage *Fristimage = [QRCodeGenerator qrImageForString:userDefaultUid imageSize:(int)_barcode.frame.size.width];
    _barcode.image = Fristimage;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, HScale(61), WScale(88.5), HScale(2.4));
    label.textColor = [UIColor colorWithRed:156/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    label.font = [UIFont systemFontOfSize:kHorizontal(11)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"扫描上面的二维码图案，即刻邀请我加入";
    [groundView addSubview:label];
}
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
//    [self downloadData];
}




-(void)downloadData{
    
    __weak typeof(self) weakself = self;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"group_id":_GroupId,
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_achievement_groupid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        
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
                for (int x = 0; x<dataInter; x++) {
                    NSLog(@"第%@洞第%d位",PoloNum,x+1);
                    NSString *Num = [pesonArry[x] objectForKey:@"Num"];
                    NSString *Name = [pesonArry[x] objectForKey:@"nick_name"];
                    NSString *name_id = [pesonArry[x] objectForKey:@"name_id"];
                    [dataDict setValue:Num forKey:[NSString stringWithFormat:@"第%@洞第%d位",PoloNum,x+1]];
                    [PlayerDict setValue:name_id forKey:[NSString stringWithFormat:@"第%d位id",x+1]];
                    [PlayerDict setValue:Name forKey:[NSString stringWithFormat:@"第%d位名字",x+1]];
                }
                [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)dataInter] forKey:@"playerNum"];
            }
            if ([data objectForKey:@"groupUser"]) {
                _userArry = [NSMutableArray array];
                _userIdArry = [NSMutableArray array];
                for (NSDictionary *userDict in [data objectForKey:@"groupUser"]) {
                    NSString *userName  = [userDict objectForKey:@"nickname"];
                    NSString *userDongNumber = [userDict objectForKey:@"userDongNumber"];
                    NSMutableArray *DoneNUm = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0 ; i<[userDongNumber integerValue]; i++) {
                        [DoneNUm addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    //                [dataDict setValue:DoneNUm forKey:@"第1位已完成洞号"];
                    
                    [_userArry addObject:userName];
                    [_userIdArry addObject:[userDict objectForKey:@"name_id"]];
                }
                
                
                
                
                for (int i = 0; i<_userIdArry.count; i++) {
                    NSString *Num = [NSString stringWithFormat:@"%ld",(long)_userIdArry.count];
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
            
            
            
            [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)_userArry.count] forKey:@"playerNum"];
            [PlayerDict setValue:_GroupId forKey:@"group_id"];
            [dataDict setValue:PlayerDict forKey:@"PlayerDict"];
            NSLog(@"%@",[userDefaults objectForKey:@"ViewMatchDict"]);
            NSLog(@"%@",dataDict);
            

                
                [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)_userArry.count] forKey:@"playerNum"];
                [userDefaults setObject:dataDict forKey:@"ViewMatchDict"];

                NSMutableArray *nameIdArry = [NSMutableArray array];

                for (int i = 0; i<_userArry.count; i++) {
                    NSString *name_id = [PlayerDict objectForKey:[NSString stringWithFormat:@"第%d位id",i+1]];
                    [nameIdArry addObject:name_id];
                }
                StatisticsViewController *vc = [[StatisticsViewController alloc] init];
                vc.nameArry = _userArry;
                vc.nameIdArry = nameIdArry;
                vc.logInNumber =2;
                vc.longInView = @"CodeViewController";
//                vc.userNameId = userDefaultId;
                [userDefaults setValue:userDefaultId forKey:@"StatisticsNameId"];

                [self presentViewController:vc animated:YES completion:^{
                    [self pressBack];
            }];
//                [self presentViewController:vc animated:YES completion:nil];
            
            
        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误,请检查网络后重试" preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                
//                [self presentViewController:alertController animated:YES completion:nil];
//            });
        
            SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: @"网络错误"];
            [self.view addSubview:sView];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sView.hidden = YES;
            });
        
        }
    }];
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
