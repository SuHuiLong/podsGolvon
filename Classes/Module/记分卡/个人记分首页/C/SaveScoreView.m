//
//  SaveScoreView.m
//  单人记分
//
//  Created by 李盼盼 on 16/6/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SaveScoreView.h"
#import "ScorViewCell.h"
#import "ScorModel.h"
#import "CodeViewController.h"
#import "DownLoadDataSource.h"
#import "OwnMessageModel.h"
#import "StatisticsViewController.h"
#import "StartScoringViewController.h"
#import "SingleScoringViewController.h"
#import "ScoringViewController.h"
#import "WXApi.h"
#import "ImageTool.h"

#import "SWTableViewCell.h"
#import "OwnShareCharityModel.h"



static NSString *identifier = @"ScorViewCell";

@interface SaveScoreView ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>{

    
}

@property (strong, nonatomic ) DownLoadDataSource *loadData;
@property (nonatomic ,strong ) UITableView        *tableView;
@property (nonatomic ,strong ) UILabel            *nickName;
@property (nonatomic ,strong ) UILabel            *pole;
@property (nonatomic ,strong ) UILabel            *scorNum;
@property (strong, nonatomic ) UILabel            *changci;
@property (strong, nonatomic ) UILabel            *zhuaniao;
@property (strong, nonatomic ) UILabel            *charity;
@property (nonatomic ,strong ) NSMutableArray     *scoArr;
@property (nonatomic ,strong ) NSMutableArray     *bestArr;
@property (strong, nonatomic ) NSMutableArray     *ownModel;
@property (nonatomic , assign) NSString           *GroupId;
@property (nonatomic , strong) ScorModel          *dataIng;
@property (nonatomic ,   copy) NSString           *groupIngId;
@property (nonatomic, strong ) NSString           *chengjiID;
/**
 *  index
 */
@property (assign, nonatomic ) NSInteger          locationIndex;


@property (nonatomic         ) BOOL               useCustomCells;
@property (nonatomic, weak   ) UIRefreshControl   *refreshControl;
@property (nonatomic,copy    ) NSString           *jilu_user;//记录人id


@property (nonatomic, strong ) NSString           *header_url;
/**
 *  点击的位置
 */
@property (assign, nonatomic ) NSInteger          SelectIndex;

@end

@implementation SaveScoreView
-(NSMutableArray *)scoArr{
    if (!_scoArr) {
        _scoArr = [[NSMutableArray alloc]init];
    }
    return _scoArr;
}
-(NSMutableArray *)bestArr{
    if (!_bestArr) {
        _bestArr = [[NSMutableArray alloc]init];
    }
    return _bestArr;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestWithScoreData];
    [self requestOwnMessageData];
    [self loadIngData];
    [_tableView reloadData];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadIngData];
    [self createNav];
    [self createTableView];
}
-(void)createNav{
    UIView *groundView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    groundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:groundView];

    UIButton *back           = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame               = CGRectMake(0, 20, 44, 44);

    UIImageView *backImage   = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image          = [UIImage imageNamed:@"返回"];
    [back addSubview:backImage];
    [back addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [groundView addSubview:back];

    UILabel *titleLabel      = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    titleLabel.text          = @"记分记录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.view.frame.size.height <= 568)
    {
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
        
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
    {
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    }else{
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
        
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [groundView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
    line.backgroundColor = GPColor(214, 214, 214);
    [self.view addSubview:line];
}
#pragma mark ---- 返回
-(void)pressBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 跳转到我的二维码
-(void)clickToCode{
    
    CodeViewController *code = [[CodeViewController alloc]init];
    [self.navigationController pushViewController:code animated:YES];
    
}
#pragma mark ---- 创建tableView
-(void)createTableView{
    
    UIView *headerBackView         = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(9.9), ScreenWidth, HScale(23.8))];
    headerBackView.backgroundColor = GPColor(245, 245, 245);
    [self.view addSubview:headerBackView];

    UIView *headerView             = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(1), ScreenWidth, HScale(22))];
    headerView.backgroundColor     = [UIColor whiteColor];
    [headerBackView addSubview:headerView];
    
    
        //    头像
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(4.8), HScale(1.9), WScale(12.3), HScale(6.9))];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = WScale(12.3)/2;
    [headerView addSubview:_headerImage];
    
    //昵称
    _nickName = [[UILabel alloc]init];
    _nickName.frame = CGRectMake(WScale(18.7), HScale(2.5), WScale(40), HScale(3.1));
    [headerView addSubview:_nickName];
    
    //    平均杆数
    _pole = [[UILabel alloc]init];
    _pole.frame = CGRectMake(WScale(18.7), HScale(6.3), WScale(25), HScale(2.5));
    _pole.textColor = GPColor(155, 155, 155);
    _pole.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [headerView addSubview:_pole];
    
    //
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(10.8)+0.5, ScreenWidth, 0.5)];
    line.backgroundColor = GPColor(239, 239, 239);
    [headerView addSubview:line];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(86.1), HScale(4.3), WScale(5.1), HScale(2.8))];
    image.image = [UIImage imageNamed:@"二维码"];
    if ([_name_id isEqualToString:userDefaultId]) {
        [headerView addSubview:image];

    }
    
    
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (_controllID == 1) {
//        
//        codeBtn.userInteractionEnabled = NO;
//    }else{
//        
//        codeBtn.userInteractionEnabled = YES;
//        
//    }
    [codeBtn addTarget:self action:@selector(clickToCode) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn setImage:[UIImage imageNamed:@"前往球场"] forState:UIControlStateNormal];
    codeBtn.frame = CGRectMake(WScale(86.5), HScale(0.6), WScale(15), HScale(10.5)-0.5);
    
    if ([_name_id isEqualToString:userDefaultId]) {
        [headerView addSubview:codeBtn];
    }
    
    /**场次，抓鸟，慈善*/
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(WScale(31.5), HScale(14), 1, HScale(5.4))];
    line2.backgroundColor = GPColor(239, 239, 239);
    [headerView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - WScale(31.5), HScale(14), 1, HScale(5.4))];
    line3.backgroundColor = GPColor(239, 239, 239);
    [headerView addSubview:line3];
    
    _changci = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(12.6), ScreenWidth / 3, HScale(3.7))];
    _changci.textColor = localColor;
    _changci.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    _changci.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_changci];
    
    
    _zhuaniao = [[UILabel alloc]initWithFrame:CGRectMake(_changci.frame.origin.x + _changci.frame.size.width, HScale(12.6), ScreenWidth / 3, HScale(3.7))];
    _zhuaniao.textColor = localColor;
    _zhuaniao.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    _zhuaniao.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_zhuaniao];
    
    
    _charity = [[UILabel alloc]initWithFrame:CGRectMake(_zhuaniao.frame.origin.x + _zhuaniao.frame.size.width, HScale(12.6), ScreenWidth / 3, HScale(3.7))];
    _charity.textColor = localColor;
    _charity.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    _charity.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_charity];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height-0/5, ScreenWidth, 0.5)];
    line4.backgroundColor = GPColor(214, 214, 214);
    [headerView addSubview:line4];
    
    NSArray *titleArr = @[@"场次(次)",@"抓鸟(次)",@"慈善(元)"];
    for (int i = 0; i<3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/3, HScale(17.5), ScreenWidth/3, HScale(2.4))];
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
        titleLabel.textColor = [UIColor colorWithRed:142/255.0f green:142/255.0f blue:142/255.0f alpha:1];
        [headerView addSubview:titleLabel];
        
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(WScale(0), 64, ScreenWidth, ScreenHeight-64)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.separatorStyle = NO;
//    if (_controllID == 1) {
//        _tableView.allowsSelection = NO;
//    }
//    _tableView.backgroundColor = GPColor(245, 245, 245);
    [_tableView registerClass:[ScorViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = headerBackView;
}
#pragma mark ---- 请求个人信息数据
-(void)requestOwnMessageData{
    NSDictionary *dict = @{
                           @"name_id":_name_id
                           };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_name_id",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
                OwnMessageModel *model = [OwnMessageModel pareFrom:temp];
                
                [self.ownModel addObject:model];
                
                NSLog(@"用户、、、ID%@",temp[@"name_id"]);
                [self setUpModel:model];
            }
            self.view.backgroundColor = [UIColor colorWithRed:245.0f/256.0f green:245.0f/256.0f blue:245.0f/256.0f alpha:1];
        }
        [_tableView reloadData];
    }];
}
-(void)setUpModel:(OwnMessageModel *)model{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.touxiang_url]];
    
    _nickName.text = [NSString stringWithFormat:@"%@",model.nickname];
    
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(15)];
    [_nickName sizeToFit];
    
    _pole.text = [NSString stringWithFormat:@"%@ 平均杆数",model.meanPole];
    
    _changci.text = [NSString stringWithFormat:@"%@",model.changCi];
    
    _zhuaniao.text = [NSString stringWithFormat:@"%@",model.zhuaNiao];
    
    _charity.text = [NSString stringWithFormat:@"%@",model.charity];
    
}
#pragma mark ---- 请求记分信息数据
-(void)requestWithScoreData{
    
    NSDictionary *parameter = @{
                                @"name_id":_name_id
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_group_chengji",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if(success){
            
            NSDictionary *dic = data;
            NSArray *dataArry = [dic objectForKey:@"data"];
            
            NSDictionary *temp = dataArry[0][@"best"];
            if (temp) {
                NSString *code = [temp objectForKey:@"code"];
                if ([code isEqualToString:@"1"]) {
                    ScorModel *model = [ScorModel pareFromWithDictionary:temp];
                    [self.bestArr addObject:model];
                }

            }
            self.scoArr  = [NSMutableArray array];
            NSLog(@"%@",dataArry);
            for (NSDictionary *temp1 in dataArry[1][@"data_all"]) {
                NSString *code = [temp1 objectForKey:@"code"];
                if ([code isEqualToString:@"0"]) {
                    return ;
                }
                ScorModel *model = [ScorModel pareFromWithDictionary:temp1];
                _money = model.charity;
                [self.scoArr addObject:model];

            }

            [_tableView reloadData];
        }
    }];
}

#pragma mark - 请求正在进行的数据

-(void)loadIngData{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_name_id,
                           @"code":@"1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_group_ing",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            _dataIng = nil;
            NSDictionary *dataDict = [data objectForKey:@"data"][0];
            NSLog(@"%@",dataDict);
            NSArray *dataAll = [dataDict objectForKey:@"data_all"];
            if (dataAll.count<1) {
                [_tableView reloadData];
                return ;
            }
            for (NSDictionary *dict in dataAll) {
                NSString *request = [dict objectForKey:@"chengji_qurestatr"];
                if ([request isEqualToString:@"0"]) {
                    _groupIngId = [dict objectForKey:@"group_id"];
                    
                    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"chuangjian_time"]];
                    [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
                    [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
                    
                    [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
                    [time deleteCharactersInRange:NSMakeRange(0, 5)];
                    [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
                    
                    NSString *dongIngNum = [dict objectForKey:@"dongIngNum"];
                    
                    NSString *groupStatr = [dict objectForKey:@"groupStatr"];
                    if (!groupStatr) {
                        groupStatr = [NSString string];
                    }
                    NSString *ingStr;
                    if (![groupStatr isEqualToString:@"1"]) {
                        ingStr = [NSString stringWithFormat:@"%@  未完成",time];
                    }else{
                        ingStr = [NSString stringWithFormat:@"正在进行 完成%@/18洞",dongIngNum];
                    }
                    NSString *qiuchang_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"qiuchang_name"]];
                    _jilu_user = [dict objectForKey:@"jilu_user"];
                    NSDictionary *ingDict = @{
                                              @"ingStr":ingStr,
                                              @"qiuchang_name":qiuchang_name,
                                              @"groupStatr":groupStatr,
                                              };
                    
                    _dataIng = [ScorModel pareFromWithDictionary:ingDict];
                }
            }
            [_tableView reloadData];

        }
    }];
    
}



#pragma mark ---- 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_scoArr.count>0) {
        return 2;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (_bestArr) {
            return 1;
        }else{
            return 0;
        }
    }
    return _scoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return HScale(42);
    }else{
        return HScale(3.9);
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HScale(11.8);
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ScorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.underway addTarget:self action:@selector(ClickUnderway) forControlEvents:UIControlEventTouchUpInside];
        
    cell.scoreImage.hidden = YES;
    cell.money.hidden = YES;
    cell.underway.hidden = YES;
    cell.poleNum.hidden = YES;
    cell.playImage.hidden = YES;
    cell.circle.hidden = YES;
    cell.poleNum.hidden = YES;
    cell.moneyImage.hidden = YES;
    cell.line2.hidden = YES;

 
    if (indexPath.section == 0) {
        cell.scoreImage.hidden = NO;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(11.8)-0.5, ScreenWidth, 0.5)];
        line1.backgroundColor = NAVLINECOLOR;
        [cell addSubview:line1];
        
        if (_bestArr) {
            [cell relayoutWithBestDictionary:_bestArr[0]];
        }
        
    }else if (indexPath.section == 1){
        cell.money.hidden = NO;
        if (_scoArr) {
            
            [cell relayoutWithDictionary:_scoArr[indexPath.row]];
        }
        
        if (indexPath.row == 0) {
            
            if (_dataIng) {
                if ([_name_id isEqualToString:userDefaultId]) {
                    cell.underway.hidden = NO;

                }
                cell.playImage.hidden = NO;
                cell.circle.hidden = NO;
                cell.money.hidden = YES;
                [cell relayoutWithLoadingDictionary:_dataIng];
            }
        }
        if (indexPath.row == _scoArr.count-1) {
            cell.line2.hidden = NO;
        }else{
            cell.line2.hidden = YES;
        }
    }
    UILongPressGestureRecognizer *tgp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    tgp.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:tgp];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.userInteractionEnabled = YES;
    if (section==2) {
        view = [[UIView alloc]init];
        UIView *backView = [[UIView alloc] init];
        _tableView.userInteractionEnabled = YES;
        backView.userInteractionEnabled = YES;
        backView.frame = CGRectMake(0, 0, ScreenWidth, HScale(58));
        backView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"零记录icon"]];
        imageView.frame = CGRectMake(WScale(50) - HScale(7), HScale(14.1), HScale(14), HScale(14));
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(29.8), ScreenWidth, HScale(3))];
        descLabel.text = @"你还未记录过一场打球记分";
        descLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
        descLabel.textColor = [UIColor blackColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = CGRectMake(WScale(39), HScale(34.6), WScale(24), HScale(3.7));
        [Btn setImage:[UIImage imageNamed:@"历史_前往@3x"] forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(GoStart) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:Btn];
        [backView addSubview:imageView];
        [backView addSubview:descLabel];
        [view addSubview:backView];
        
    }else{
        view = [[UIView alloc]init];
        
        view.backgroundColor = GPColor(245, 245, 245);
        _scorNum = [[UILabel alloc]init];
        _scorNum.frame = CGRectMake(WScale(2.9), HScale(0.7), ScreenWidth, HScale(2.5));
        _scorNum.font = [UIFont systemFontOfSize:kHorizontal(12)];
        _scorNum.textColor = GPColor(136, 136, 136);
        [view addSubview:_scorNum];
        if (section == 0) {
            _scorNum.text = @"最好成绩";
            [_scorNum sizeToFit];
        }else if (section == 1){
            NSString *totalStr = [NSString stringWithFormat:@"%lu",(unsigned long)_scoArr.count];
            if (_scoArr.count<1) {
                totalStr = @"0";
            }
            _scorNum.text = [NSString stringWithFormat:@"记分统计(%lu)",(unsigned long)_scoArr.count];
        }
    }
    return view;
}

-(void)GoStart{
    StartScoringViewController *vc = [[StartScoringViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_controllID == 1) {
        return NO;
    }else{
        if (indexPath.section==0) {
            return FALSE;
        }else{
            if (_dataIng) {
                if (indexPath.row==0) {
//                    if (![_jilu_user isEqualToString:userDefaultId]) {
//                        return FALSE;
//                    }
                }
            }
            return TRUE;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_dataIng) {
            [self.scoArr removeObjectAtIndex:0];
        }
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    ScorModel *model = _scoArr[indexPath.row];
    _chengjiID = model.group_chengji_id;
    _GroupId = model.group_id;
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView setEditing:NO animated:YES];
        weakSelf.locationIndex = indexPath.row;
        
        if(indexPath.row == 0){
            if(weakSelf.dataIng || [model.zongganshu isEqualToString:@"0"]){
                if (_dataIng) {
                    _GroupId = _groupIngId;
                }
                
                if (![_jilu_user isEqualToString:userDefaultId]) {
                    [weakSelf exitGroup];
                }else{
                    [weakSelf clickToDelegate];
                }

            }else{
                [weakSelf requestWithShareData];
            }
        }else{
            if ([model.zongganshu isEqualToString:@"0"]) {
                [weakSelf clickToDelegate];
            }else{
                [weakSelf requestWithShareData];
            }
        }
    }];
    
    layTopRowAction1.backgroundColor =localColor;
    if(indexPath.row == 0){
        if(_dataIng || [model.zongganshu isEqualToString:@"0"]){
            
            [layTopRowAction1 setTitle:@"删除"];
            layTopRowAction1.backgroundColor = [UIColor redColor];
            if (![_jilu_user isEqualToString:userDefaultId]) {
                if ([model.qiuchang_name isEqualToString:@"0"]||_dataIng) {
                    [layTopRowAction1 setTitle:@"退出"];
                }

            }
            
        }
        
        
    }else{
        if ([model.zongganshu isEqualToString:@"0"]) {
            
            [layTopRowAction1 setTitle:@"删除"];
            layTopRowAction1.backgroundColor = [UIColor redColor];
        }
    }
    
    NSArray *arr = @[layTopRowAction1];
    
    return arr;
}
-(void)clickToShare{
    
    /**灰色蒙版*/
    _groundView = [[UIView alloc]init];
    _groundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _groundView.backgroundColor = [UIColor blackColor];
    _groundView.alpha = 0.5;
    _groundView.hidden = NO;
    _groundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBack)];
    [self.view addSubview:_groundView];
    [_groundView addGestureRecognizer:tap];
    /**背景图片*/
    _viewGroundView = [[UIImageView alloc]init];
    _viewGroundView.frame = CGRectMake((ScreenWidth - WScale(76.5))/2, HScale(12.7), WScale(76.5), HScale(74.7));
    [_viewGroundView setImage:[UIImage imageNamed:@"底板"]];
    _viewGroundView.layer.cornerRadius = 8;
    _viewGroundView.hidden = NO;
    _viewGroundView.backgroundColor = [UIColor whiteColor];
    _viewGroundView.userInteractionEnabled = YES;
    [self.view addSubview:_viewGroundView];
    
    /**口号*/
    UIImageView *slogan = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(33.6))/2, HScale(55.3), WScale(33.6), HScale(2.2))];
    slogan.image = [UIImage imageNamed:@"打球公益口号"];
    [_viewGroundView addSubview:slogan];
    
    UIImageView *sloganImage = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(31.2))/2, HScale(58.9), WScale(31.2), HScale(2.8))];
    sloganImage.image = [UIImage imageNamed:@"打球去和大城小爱"];
    [_viewGroundView addSubview:sloganImage];
    
    /**Friendster朋友圈*/
    UIButton *friendster = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendster setBackgroundImage:[UIImage imageNamed:@"微信朋友圈"] forState:UIControlStateNormal];
    friendster.frame = CGRectMake(WScale(14.1), HScale(67), WScale(13.3), HScale(6.4));
    [friendster addTarget:self action:@selector(clickToPengYouQuan) forControlEvents:UIControlEventTouchUpInside];
    [_viewGroundView addSubview:friendster];
    
    /**Friendster好友*/
    UIButton *friend = [UIButton buttonWithType:UIButtonTypeCustom];
    [friend setBackgroundImage:[UIImage imageNamed:@"微信好友"] forState:UIControlStateNormal];
    friend.frame = CGRectMake(WScale(76.5) - WScale(17.9) - WScale(10.7), HScale(67), WScale(10.7), HScale(6.3));
    [friend addTarget:self action:@selector(clickToHaoYou) forControlEvents:UIControlEventTouchUpInside];
    [_viewGroundView addSubview:friend];
    
    
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WScale(76.5), HScale(51.1))];
    shareImage.image = [UIImage imageNamed:@"分享上_底色"];
    [_viewGroundView addSubview:shareImage];
    
    _shareViewBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, HScale(50), WScale(76.5), HScale(23.5))];
    _shareViewBottom.image = [UIImage imageNamed:@"分享下_"];
    
    /**头像*/
    UILabel *groundLabel = [[UILabel alloc]init];
    groundLabel.frame = CGRectMake((WScale(76.5) - WScale(14.4))/ 2, HScale(2.5), WScale(14.4), HScale(8.19));
    groundLabel.backgroundColor = [UIColor whiteColor];
    groundLabel.layer.masksToBounds = YES;
    groundLabel.layer.cornerRadius = HScale(8.19)/2;
    [_viewGroundView addSubview:groundLabel];
//
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(((WScale(76.5) - WScale(14.4))/ 2)+2, HScale(2.5)+2, WScale(14.4)-4, HScale(8.19)-4)];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = (HScale(8.19)-4)/2;

    [_viewGroundView addSubview:_headerImage];

    /**
     场次等数据界面
     */
    _dataView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScale(76.5), HScale(50))];
    _dataView.backgroundColor = [UIColor clearColor];
    
    /**捐助场次*/
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(24.7), WScale(76.5), HScale(2.7))];
    label.text = @"本次成绩";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = GPColor(178, 176, 176);
    label.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_dataView addSubview:label];
    
    
    _changThis = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(28), WScale(76.5), HScale(6.7))];
    _changThis.textAlignment = NSTextAlignmentCenter;
    _changThis.textColor = GPColor(217, 69, 54);
    _changThis.font = [UIFont systemFontOfSize:kHorizontal(32)];
    [_dataView addSubview:_changThis];
    
    
    
    /**累计金额  场次*/
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(WScale(16.3), HScale(43.3), WScale(13.9), HScale(2.7))];
    label1.text = @"累计金额";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = GPColor(64, 64, 64);
    label1.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_dataView addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(WScale(76.5)-WScale(16.3)- WScale(13.9), HScale(43.3), WScale(13.9), HScale(2.7))];
    label2.text = @"累计场次";
    label2.textColor = GPColor(64, 64, 64);
    label2.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_dataView addSubview:label2];
    /**本次金额*/
    
    UILabel *donateLabel = [[UILabel alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(56))/2, HScale(36.1), WScale(56), HScale(3))];
    donateLabel.textAlignment = NSTextAlignmentCenter;
    [_dataView addSubview:donateLabel];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WScale(24), HScale(3))];
    logoImage.image = [UIImage imageNamed:@"携手打球去"];
    [donateLabel addSubview:logoImage];
    
    UILabel *donate = [[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.origin.x+logoImage.frame.size.width+3, 3, WScale(24), HScale(3))];
    donate.text = @"打球去捐出";
    donate.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [donate sizeToFit];
    [donateLabel addSubview:donate];
    
    _moneyThis = [[UILabel alloc]initWithFrame:CGRectMake(donate.frame.origin.x + donate.frame.size.width+3, 3, WScale(12), HScale(3))];
    _moneyThis.textAlignment = NSTextAlignmentCenter;
    _moneyThis.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _moneyThis.textColor = GPColor(238, 108, 33);
    
    [donateLabel sizeToFit];
    [donateLabel addSubview:_moneyThis];
    
    /**总金额*/
    _allMoney = [[UILabel alloc]initWithFrame:CGRectMake(WScale(10.3), HScale(47.2), WScale(25.9), HScale(3))];
    _allMoney.textAlignment = NSTextAlignmentCenter;
    _allMoney.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _allMoney.textColor = GPColor(238, 108, 33);
    [_dataView addSubview:_allMoney];
    
    /**总场次*/
    _allChang = [[UILabel alloc]initWithFrame:CGRectMake(WScale(76.5)-WScale(16.3)- WScale(13.9), HScale(47.2), WScale(13.9), HScale(3))];
    _allChang.textAlignment = NSTextAlignmentCenter;
    _allChang.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _allChang.textColor = GPColor(238, 108, 33);
    
    [_dataView addSubview:_allChang];

    [_viewGroundView addSubview:_dataView];
    
}

-(void)createShareOtherView{

    _shareView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - WScale(76.5))/2, HScale(12.7), WScale(76.5), HScale(74.7))];
    
    _shareView.backgroundColor = [UIColor whiteColor];
    _shareView.image = [UIImage imageNamed:@"分享底板"];
    
    [_shareView addSubview:_headerImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(12.1), WScale(76.5), HScale(3.6))];
    nameLabel.text = [userDefaults objectForKey:@"nickname"];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_shareView addSubview:nameLabel];
    
    UIImageView *thanksLabel = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(8.8), HScale(17.1), WScale(58.9), HScale(2.8))];
    
    thanksLabel.image = [UIImage imageNamed:@"分享_感谢话语"];
    
    
    
    [_shareView addSubview:thanksLabel];
    
    
    
    
    UIImageView *QRView = [[UIImageView alloc] initWithFrame:CGRectMake((WScale(76.5)-HScale(9))/2, HScale(53.5), HScale(9), HScale(9))];
    
    QRView.image = [UIImage imageNamed:@"分享二维码"];
    
    [_shareView addSubview:QRView];
    
    UIImageView *slogan = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(33.6))/2, HScale(64.5), WScale(33.6), HScale(2.2))];
    slogan.image = [UIImage imageNamed:@"打球公益口号"];
    [_shareView addSubview:slogan];
    
    UIImageView *sloganImage = [[UIImageView alloc]initWithFrame:CGRectMake((WScale(76.5)-WScale(31.2))/2, HScale(68.1), WScale(31.2), HScale(2.8))];
    sloganImage.image = [UIImage imageNamed:@"打球去和大城小爱"];
    [_shareView addSubview:sloganImage];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(74.7)-1, WScale(76.5), 1)];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    [_shareView addSubview:topView];
    
    //创建浅色边框
    for (NSInteger i = 0; i<2; i++) {
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake((WScale(76.5)-1)*i, HScale(20), 1, HScale(54.4))];
        
        leftView.backgroundColor = [UIColor whiteColor];
        [_shareView addSubview:leftView];
    }
    
}


#pragma mark - 保存本地


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

-(void)clickToBack{
    _groundView.hidden = YES;
    _viewGroundView.hidden = YES;
    _groundView = nil;
    _viewGroundView = nil;
    
}

-(void)clickToHaoYou2{
    [self createShareOtherView];
    [self clickToBack];
    [_shareView addSubview:_dataView];
    UIGraphicsBeginImageContextWithOptions(_shareView.bounds.size, YES, 2);
    [_shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(img, self,  @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);

}


#pragma mark - 分享好友
-(void)clickToHaoYou{
    [self createShareOtherView];
    [self clickToBack];
    [_shareView addSubview:_dataView];
    UIGraphicsBeginImageContextWithOptions(_shareView.bounds.size, YES, 2);
    [_shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //    [self.view addSubview:SecBackView];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData =  UIImageJPEGRepresentation(img,1.0);
    message.mediaObject = ext;
    
    //    UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700, 400) sizeOfImage:img];
    
    message.thumbData =  UIImageJPEGRepresentation(img,0.1);
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];


}
#pragma mark - 分享朋友圈

-(void)clickToPengYouQuan{
    
    [self createShareOtherView];
    [self clickToBack];
    [_shareView addSubview:_dataView];
    UIGraphicsBeginImageContextWithOptions(_shareView.bounds.size, YES, 2);
    [_shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    [self.view addSubview:SecBackView];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
#pragma 创建大图
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData =  UIImageJPEGRepresentation(img,1.2);
    message.mediaObject = ext;
    //    UIImage *sharImage = [[ImageTool shareTool] resizeImageToSize:CGSizeMake(700, 400) sizeOfImage:img];
    
    message.thumbData =  UIImageJPEGRepresentation(img,0.1);
    sendReq.message = message;
    sendReq.bText = NO;
    [WXApi sendReq:sendReq];
    
}

/**
 *  长按手势
 */
-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    if (![_name_id isEqualToString:userDefaultId]) {
        return;
    }
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) {
            return ;
        }
        if (indexPath.section == 0) {
            return;
        }
        NSLog(@"%ld",(long)indexPath.row);
        NSString *content;
        
        __weak __typeof(self)weakSelf = self;
        ScorModel *model = _scoArr[indexPath.row];
        _chengjiID = model.group_chengji_id;
        _GroupId = model.group_id;

        weakSelf.locationIndex = indexPath.row;
            
            if(indexPath.row == 0){
                if(weakSelf.dataIng || [model.zongganshu isEqualToString:@"0"]){
                    if (_dataIng) {
                        _GroupId = _groupIngId;
                    }
                    if ([model.qiuchang_name isEqualToString:@"0"]||[_jilu_user isEqualToString:userDefaultId]) {
                        content = @"退出记分";
                        
                        if (![_jilu_user isEqualToString:userDefaultId]) {
                            content = @"退出记分";
                        }else{
                            content = @"删除记分";
                        }
                        
                    }else{
                        if ([model.zongganshu isEqualToString:@"0"]) {
                            content = @"删除记分";
                            
                        }else{

                        content = @"点击分享";
                        }
                        
                    }

                        
//                        if (weakSelf.dataIng) {
//                            content = @"删除记分";
//                        }
//                    }else{
//                        content = @"退出记分";
//                    }
                
                }else{
                    content = @"点击分享";
                }
            }else{
                if ([model.zongganshu isEqualToString:@"0"]) {
                    content = @"删除记分";
                    
                }else{
                    content = @"点击分享";
                }
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            if([content isEqualToString:@"点击分享"]) {
                [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf requestWithShareData];
                }]];
            }else{
                [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if ([content isEqualToString:@"退出记分"]) {
                        [weakSelf exitGroup];
                    } else if([content isEqualToString:@"删除记分"]) {
                        [weakSelf clickToDelegate];
                    }
                }]];
            }
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });

        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//            [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                if ([content isEqualToString:@"退出记分"]) {
//                    [weakSelf exitGroup];
//                } else if([content isEqualToString:@"删除记分"]) {
//                    [weakSelf clickToDelegate];
//                } else if([content isEqualToString:@"点击分享"]) {
//                    [weakSelf requestWithShareData];
//                }
//                
//            }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
//        });

        
    }
}

-(void)ClickUnderway{
    
    NSString *content = [NSString new];
    __weak __typeof(self)weakSelf = self;
    ScorModel *model = _dataIng;
    _chengjiID = model.group_chengji_id;
    _GroupId = model.group_id;
    
    
    _GroupId = _groupIngId;
    
    if (![_jilu_user isEqualToString:userDefaultId]) {
        content = @"退出记分";
    }else{
        content = @"删除记分";
    }
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if ([content isEqualToString:@"退出记分"]) {
                [weakSelf exitGroup];
            } else if([content isEqualToString:@"删除记分"]) {
                [weakSelf clickToDelegate];
            } else if([content isEqualToString:@"点击分享"]) {
                [weakSelf requestWithShareData];
            }
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

//分享数据
-(void)requestWithShareData{
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc]init];
    ScorModel *model = _scoArr[_locationIndex];
    NSDictionary *dic = @{
                          @"name_id":userDefaultId,
                          @"group_id":model.group_id
                          };
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_gerencishan",urlHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            OwnShareCharityModel *model = [[OwnShareCharityModel alloc]init];
            model.charity = data[@"data"][0][@"charity"];
            model.picture_url = [userDefaults objectForKey:@"pic"];
            model.zongganshu = data[@"data"][0][@"zongganshu"];
            model.cishan_jiner = data[@"data"][0][@"cishan_jiner"];
            model.zongchangshu = data[@"data"][0][@"zongchangshu"];
            [self clickToShare];
            [self setModelWith:model];
        }
        [_tableView reloadData];
    }];
}



#pragma mark - 加载数据(loadData)

-(void)setModelWith:(OwnShareCharityModel *)model{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url]];
    
    _changThis.text = [NSString stringWithFormat:@"%@",model.zongganshu];
    
    _moneyThis.text = model.charity;
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.charity,@"元"];
    NSMutableAttributedString *attributed2 = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed2.length-1, 1)];
    _moneyThis.attributedText = attributed2;
    [_moneyThis sizeToFit];
    
    
    _allMoney.text = model.cishan_jiner;
    NSString *allMoney = [NSString stringWithFormat:@"%@ %@",model.cishan_jiner,@"元"];
    NSMutableAttributedString *attributedAllMoney = [[NSMutableAttributedString alloc]initWithString:allMoney];
    [attributedAllMoney addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributedAllMoney.length-1, 1)];
    _allMoney.attributedText = attributedAllMoney;
    
    
    _allChang.text = model.zongchangshu;
    NSString *allChang = [NSString stringWithFormat:@"%@ %@",model.zongchangshu,@"场"];
    NSMutableAttributedString *attributedAllChang = [[NSMutableAttributedString alloc]initWithString:allChang];
    [attributedAllChang addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributedAllChang.length-1, 1)];
    _allChang.attributedText = attributedAllChang;
    
}

-(void)clickToDelegate{

    NSDictionary *dict = @{
                           @"groupChengJiId":_chengjiID,
                           @"groupId":_GroupId
                           };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/UpdataGroupDeleStatr",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            [self requestWithScoreData];
            [self requestOwnMessageData];
            [self loadIngData];
            if ([_GroupId isEqualToString:_groupIngId]) {
                [userDefaults removeObjectForKey:@"MatchDict"];
            }
            
            
            
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _SelectIndex = indexPath.row;
        ScorModel *model = nil;
        if (indexPath.section==0) {
            model = _bestArr[0];
            _GroupId = model.group_id;
            
        }else if (indexPath.section == 1){

            if (indexPath.row==0) {
                
                NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
                if ([_name_id isEqualToString:userDefaultId]) {
                    NSDictionary *PlayerDict = [MatchDict objectForKey:@"PlayerDict"];

                if (PlayerDict) {
                    NSString *peopleNum = [PlayerDict objectForKey:@"playerNum"];
                    
                    if ([peopleNum isEqualToString:@"1"]) {
                        
                        SingleScoringViewController *vc = [[SingleScoringViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        
                        ScoringViewController *vc =[[ScoringViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    return;
                }
                    
            }
                _GroupId = _groupIngId;
                
            }
            model = _scoArr[indexPath.row];
            _GroupId = model.group_id;
        }
        
        
        [self downloadData];

    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:localColor
                                                title:@"分享"];
    
    return rightUtilityButtons;
}

-(void)downloadData{
    
    _tableView.userInteractionEnabled = NO;
    [userDefaults removeObjectForKey:@"ViewMatchDict"];
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"group_id":_GroupId,
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_achievement_groupid",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        _tableView.userInteractionEnabled = YES;
        
        if (success) {
            NSArray *placeArry = [data objectForKey:@"qiuchang"];
            NSMutableArray *userArry = [NSMutableArray array];
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
            for (int i = 0; i<dataArr.count; i++) {
                NSMutableDictionary *singlePoloData = [[NSMutableDictionary alloc] initWithDictionary:dataArr[i]];
                singlePoloData = dataArr[i];
                NSString *Par = [singlePoloData objectForKey:@"Par"];
                NSString *PoloNum = [singlePoloData objectForKey:@"PoloNum"];
                
                [dataDict setValue:Par forKey:[NSString stringWithFormat:@"第%@洞标准杆",PoloNum]];
                
                NSArray *pesonArry = [singlePoloData objectForKey:@"Players"];
                for (int x = 0; x<pesonArry.count; x++) {
                    NSString *Num = [pesonArry[x] objectForKey:@"Num"];
//                    NSString *Name = [pesonArry[x] objectForKey:@"nick_name"];
                    NSString *name_id = [pesonArry[x] objectForKey:@"name_id"];
                    NSLog(@"第%@洞%@",PoloNum,name_id);
                    [dataDict setValue:Num forKey:[NSString stringWithFormat:@"第%@洞%@",PoloNum,name_id]];
                }
            }
            
            NSArray *groupUserArry = [data objectForKey:@"groupUser"];
            
            for (int i = 0; i<groupUserArry.count; i++) {
                NSDictionary *userDict = groupUserArry[i];
                
                NSString *userName  = [userDict objectForKey:@"nickname"];
                [userArry addObject:userName];
            
            }
            
            NSString *qiuChangName = [placeData objectForKey:@"qiuchang_name"];
            if ([qiuChangName isEqualToString:@"0"]) {
                if([_jilu_user isEqualToString:userDefaultId]){
                    StartScoringViewController *vc = [[StartScoringViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                return;
            }
            
            NSMutableArray *nameIdArry = [NSMutableArray array];
            
            for (NSDictionary *userDict in [data objectForKey:@"groupUser"]) {
                NSString *userDongNumber =  [userDict objectForKey:@"userDongNumber"];
                NSString *name_id =         [userDict objectForKey:@"name_id"];
                
                NSMutableArray *DoneNUm = [[NSMutableArray alloc] init];
                for (NSInteger i = 0 ; i<[userDongNumber integerValue]; i++) {
                    [DoneNUm addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                }
                [nameIdArry addObject:name_id];
            }
            
            
            for (int i = 0; i<userArry.count; i++) {
                NSString *name_id = nameIdArry[i];
                [PlayerDict setValue:name_id forKey:[NSString stringWithFormat:@"第%d位id",i+1]];
                
                NSString *Num = [NSString stringWithFormat:@"%ld",(long)nameIdArry.count];
                [PlayerDict setValue:Num forKey:@"playerNum"];
                
                NSString *Name = userArry[i];
                [PlayerDict setValue:Name forKey:[NSString stringWithFormat:@"第%d位名字",i+1]];
            }
            
            
            [PlayerDict setValue:[NSString stringWithFormat:@"%ld",(long)userArry.count] forKey:@"playerNum"];
            [PlayerDict setValue:_GroupId forKey:@"group_id"];
            [dataDict setValue:PlayerDict forKey:@"PlayerDict"];
            NSLog(@"%@",[userDefaults objectForKey:@"ViewMatchDict"]);
            NSLog(@"%@",dataDict);
            [userDefaults setObject:dataDict forKey:@"ViewMatchDict"];
            StatisticsViewController *vc = [[StatisticsViewController alloc] init];
            vc.nameArry = userArry;
                if (_dataIng&&_SelectIndex == 0) {
                    vc.logInNumber =2;
                }else{
                    if ([_name_id isEqualToString:userDefaultId]) {
                        vc.logInNumber = 1;
                    }else{
                    vc.logInNumber = 3;
                    }
                }
            NSInteger *testIndex = 0;
            for (NSString *PlayerNameId in nameIdArry) {
                if ([_name_id isEqualToString:PlayerNameId]) {
                    testIndex++;
                }
            }
            if (testIndex==0) {
                vc.logInNumber = 3;
            }
            
            vc.nameIdArry = nameIdArry;
            vc.userNameId = _name_id;
            [userDefaults setValue:_name_id forKey:@"StatisticsNameId"];

            [self presentViewController:vc animated:YES completion:nil];
            
            
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
            [self loadIngData];
            [self requestWithScoreData];
        }
    }];
}



//- (BOOL)shouldAutorotate{
//    return NO;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}


@end
