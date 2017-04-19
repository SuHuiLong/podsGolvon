//
//  SignUpViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SignUpViewController.h"
#import "GroupStatisticsViewController.h"
@interface SignUpViewController (){
    
    CGFloat playerBackView_y;
}
@property(nonatomic,copy)CABasicAnimation *rotationAnim;//旋转视图控件
@property(nonatomic,copy)UIImageView *scrollVIew;//旋转视图
@property(nonatomic,copy)UIView *playerBackView;//球员背景图
@property(nonatomic,copy)UIView *backView;//白色背景图
@property(nonatomic,strong)NSMutableArray *playerArray;//展示球员数组

@end

@implementation SignUpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadGroupData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        _rotationAnim = [CABasicAnimation animation];
        _rotationAnim.keyPath = @"transform.rotation.z";
        _rotationAnim.toValue = @(2 * M_PI);
        _rotationAnim.repeatCount = MAXFLOAT;
        _rotationAnim.duration = 5;
        _rotationAnim.cumulative = NO;
        _rotationAnim.autoreverses = NO;
        [_scrollVIew.layer addAnimation:_rotationAnim forKey:nil];
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resevNotic];
    self.view.backgroundColor = GPRGBAColor(238, 239, 241, 1.0);
    // Do any additional setup after loading the view.
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
    //    if ([PushToStat isEqualToString:@"13"]) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
    
    if ([PushToStat isEqualToString:@"15"]) {
        NSString *groupId = [extras objectForKey:@"gid"];
        if (groupId) {
            GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
            group.loginNameId = userDefaultId;
            group.nameUid = userDefaultUid;
            group.groupId = groupId;
            group.isLoadDta = YES;
            group.status = 1;
            group.hidesBottomBarWhenPushed = YES;
            group.needPopHome = YES;
            [self.navigationController pushViewController:group animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    
    if ([PushToStat isEqualToString:@"13"]||[PushToStat isEqualToString:@"12"]){
        [self loadGroupData];
    }
}




#pragma mark - CreateUI

-(void)createView{
    _backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(17), kHvertical(40), ScreenWidth - kWvertical(37), kHvertical(368))];
    
    _scrollVIew = [Factory createImageViewWithFrame:CGRectMake(WScale(33.1), HScale(94.4), kWvertical(19),kHorizontal(16)) Image: [UIImage imageNamed:@"signUpIcon"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _rotationAnim = [CABasicAnimation animation];
        _rotationAnim.keyPath = @"transform.rotation.z";
        _rotationAnim.toValue = @(2 * M_PI);
        _rotationAnim.repeatCount = MAXFLOAT;
        _rotationAnim.duration = 5;
        _rotationAnim.cumulative = NO;
        _rotationAnim.autoreverses = NO;
        [_scrollVIew.layer addAnimation:_rotationAnim forKey:nil];
    });
    [_backView addSubview:_scrollVIew];
    
    UILabel *signUpLabel = [[UILabel alloc] init];
    signUpLabel.text = @"正在组队";
    signUpLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    signUpLabel.textColor = [UIColor blackColor];
    
    [signUpLabel sizeToFit];
    
    _scrollVIew.frame = CGRectMake((_backView.width - signUpLabel.width - _scrollVIew.width-kWvertical(2))/2, kHvertical(24), kWvertical(19), kHorizontal(16));
    signUpLabel.frame = CGRectMake(_scrollVIew.x_width+kWvertical(2), kHvertical(19), signUpLabel.width, kHvertical(25));
    [_backView addSubview:signUpLabel];
    
    UIImageView *headerImageView = [Factory createImageViewWithFrame:CGRectMake((_backView.width - kHvertical(74))/2, kHvertical(74), kHvertical(74), kHvertical(74)) Image:nil];
    NSString *userImage = [userDefaults objectForKey:@"pic"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:userImage] placeholderImage:nil];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = kHvertical(37);
    [_backView addSubview:headerImageView];
    
    NSString *nickName = [userDefaults objectForKey:@"nickname"];
    UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(0, headerImageView.y_height + kHvertical(8), _backView.width, kHvertical(22)) textColor:rgba(0,0,0,1) fontSize:kHorizontal(16) Title:nickName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:nameLabel];
    
    UIView *line = [Factory createViewWithBackgroundColor:rgba(227,227,227,1) frame:CGRectMake(kWvertical(20), nameLabel.y_height+kHvertical(33), _backView.width - kWvertical(40), 1)];
    [_backView addSubview:line];
    
    playerBackView_y = line.y_height;
    
    [self.view addSubview:_backView];
    
    UIButton *exit = [Factory createButtonWithFrame:CGRectMake(kWvertical(19), ScreenHeight - kHvertical(121), ScreenWidth - kWvertical(38), kHvertical(40)) titleFont:kHorizontal(14) textColor:WhiteColor backgroundColor:rgba(53,141,227,1) target:self selector:@selector(exitClick) Title:@"退出组队"];
    [self.view addSubview:exit];
    
    [self createGroupPlayerView];
}


//创建球员进入界面
-(void)createGroupPlayerView{
    [_playerBackView removeFromSuperview];
    if (playerBackView_y<100) {
        playerBackView_y=kHvertical(213);
    }
    _playerBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, playerBackView_y, _backView.width, kHvertical(150))];
    [_backView addSubview:_playerBackView];
    
    
    for (int i = 0; i<_playerArray.count; i++) {
        
        UIImageView *headerIcon = [Factory createImageViewWithFrame:CGRectMake(kWvertical(96), kHvertical(44)+kHvertical(24)*i, kWvertical(11), kHvertical(14)) Image:[UIImage imageNamed:@"sigInHeaderIcon"]];
        
        [_playerBackView addSubview:headerIcon];
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%@ 加入了队伍",_playerArray[i]];
        
        UILabel *addLabel = [Factory createLabelWithFrame:CGRectMake(headerIcon.x_width+kWvertical(4), headerIcon.y-kHvertical(2), kWvertical(200), kHvertical(18)) textColor:rgba(55,55,55,1) fontSize:kHorizontal(13) Title:titleStr];
        
        addLabel = [self AttributedStringLabel:addLabel rang:NSMakeRange(titleStr.length-5, 5) changeColor:[UIColor lightGrayColor]];
        
        [_playerBackView addSubview:addLabel];
    }
    
}

#pragma mark - Action
-(void)exitClick{
    NSLog(@"退出");
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=quitgroup",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *code = [data objectForKey:@"code"];
                if ([code isEqualToString:@"0"]||[code isEqualToString:@"506"]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }];
}
//更新分组队员
-(void)loadGroupData{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=getgroupinfo",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *code = [data objectForKey:@"code"];
            if (code==nil) {
                NSString *isbuild = [data objectForKey:@"isbuild"];
                if ([isbuild isEqualToString:@"0"]) {
                    NSArray *list = [data objectForKey:@"list"];
                    NSMutableArray *mPlayerArray = [NSMutableArray array];
                    for (int i = 0; i<list.count; i++) {
                        NSDictionary *dict = list[i];
                        NSString *nickName = [dict objectForKey:@"nickname"];
                        [mPlayerArray addObject:nickName];
                    }
                    _playerArray = [NSMutableArray arrayWithArray:mPlayerArray];
                    [self createGroupPlayerView];
                    return;
                }
            }
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}
#pragma mark - 改变label颜色
-(UILabel *)AttributedStringLabel:(UILabel *)putLabel rang:(NSRange )changeRang changeColor:(UIColor *)changeColor{
    UILabel *testLabel = putLabel;
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:testLabel.text];
    
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:changeColor
     
                          range:changeRang];
    
    testLabel.attributedText = AttributedStr;
    
    return testLabel;
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
