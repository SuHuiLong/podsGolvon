//
//  Self_GuanZhuViewController.m
//  Golvon
//
//  Created by shiyingdong on 16/4/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_GuanZhuViewController.h"
#import "Self_GuanZhuTableViewCell.h"
#import "Slef_GuanZhuModel.h"
#import "NewDetailViewController.h"
#import "AidViewController.h"
#import "NewStatisticsViewController.h"
#import "GroupStatisticsViewController.h"
#import "GolvonAlertView.h"


@interface Self_GuanZhuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *_HUB;
    
}
@property (strong, nonatomic) DownLoadDataSource *downLoad;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UILabel *noneLabel;
@property (assign, nonatomic) int currpage;
@property (assign, nonatomic) int allPage;


@property (copy, nonatomic) NSString    *player;            //打球记分人数
@property (copy, nonatomic) NSString    *isfinished;        //是否完成
@property (copy, nonatomic) NSString    *isvali;            //是否有效
@property (copy, nonatomic) GolvonAlertView     *alertView;


@end

@implementation Self_GuanZhuViewController




-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(DownLoadDataSource *)downLoad{
    if (!_downLoad) {
        _downLoad = [[DownLoadDataSource alloc]init];
    }
    return _downLoad;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    [self createUI];
    [self requestData];
}
-(void)createNav{
    
    
    self.navigationItem.title = @"关注";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
}
-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = HScale(10);
    [self.view addSubview:_tableView];
    
//    头部刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    立即刷新
//    [refreshHeader beginRefreshing];
    self.tableView.mj_header = refreshHeader;
    
//    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = refreshFooter;
    
}
//提示界面
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)createAlertView:(Slef_GuanZhuModel *)model{
    
    _alertView = [[GolvonAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:@"记分已完成" leftBtn:@"查看记分卡" right:@"取消"];
    __weak __typeof(self)weakSelf = self;
    [_alertView.leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        if ([weakSelf.player isEqualToString:@"1"]) {
            NewStatisticsViewController *VC = [[NewStatisticsViewController alloc] init];
            VC.loginNameId = userDefaultId;
            VC.nameUid = model.nameID;
            VC.groupId = model.groupID;
            VC.isLoadDta = YES;
            VC.status = 1;
            VC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else{
            GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
            group.loginNameId = userDefaultId;
            group.nameUid = model.nameID;
            group.groupId = model.groupID;
            group.isLoadDta = YES;
            group.status = 1;
            group.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:group animated:YES];
        }
        [weakSelf.alertView removeFromSuperview];
    }];
    
    [_alertView.rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakSelf headerRefresh];
        [weakSelf.alertView removeFromSuperview];
    }];
    [self.view addSubview:_alertView];
}
-(void)createNoneDataView{
    
    _tableView.hidden = YES;
    [_noneLabel removeFromSuperview];
    _noneLabel = [[UILabel alloc]init];
    _noneLabel.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    if ([_name_id isEqualToString:userDefaultUid]) {
        _noneLabel.text = @"您还没有关注的用户";

    }else{
        _noneLabel.text = @"对方还没有关注的用户";

    }
    _noneLabel.textAlignment = NSTextAlignmentCenter;
    _noneLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _noneLabel.textColor = textTintColor;
    [self.view addSubview:_noneLabel];
}
#pragma mark ----  请求数据
-(void)requestData{
    __weak typeof(self) weakself = self;
    NSDictionary *dic = @{@"name_id":_name_id,
                          @"login_nameid":userDefaultId,
                          @"statr_number":[NSString stringWithFormat:@"%d",_currpage],
                          };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_folnameid",urlHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *arr = data[@"data"];
            if ([arr count] == 0) {
                [weakself createNoneDataView];
            }
            weakself.allPage = (int)data[@"allpage"];
            for (NSDictionary *temp in arr) {
                Slef_GuanZhuModel *model = [Slef_GuanZhuModel pareFromDictionary:temp];
                [weakself.dataArr addObject:model];
            }
            [weakself.tableView reloadData];
        }
    }];
}
//头部刷新
-(void)headerRefresh{
    _currpage = 0;
    __weak typeof(self) weakself = self;
    [self.tableView.mj_footer resetNoMoreData];
    
    NSDictionary *dic = @{@"name_id":_name_id,
                          @"login_nameid":userDefaultId,
                          @"statr_number":[NSString stringWithFormat:@"%d",_currpage],
                          };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_folnameid",urlHeader120] parameters:dic complicate:^(BOOL success, id data) {
        [weakself.tableView.mj_header endRefreshing];
        if (success) {
            [weakself.dataArr removeAllObjects];
            NSDictionary *dic = data;
            weakself.allPage = (int)data[@"allpage"];
            for (NSDictionary *temp in dic[@"data"]) {
                Slef_GuanZhuModel *model = [Slef_GuanZhuModel pareFromDictionary:temp];
                [weakself.dataArr addObject:model];
            }
            [weakself.tableView reloadData];
        }
    }];

}
-(void)footerRefresh{
    _currpage++;
    if (_currpage>_allPage) {
        _currpage--;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *dic = @{@"name_id":_name_id,
                          @"login_nameid":userDefaultId,
                          @"statr_number":[NSString stringWithFormat:@"%d",_currpage],
                          };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_follow_folnameid",urlHeader120] parameters:dic complicate:^(BOOL success, id data) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            NSDictionary *dic = data;
            weakself.allPage = (int)data[@"allpage"];
            for (NSDictionary *temp in dic[@"data"]) {
                Slef_GuanZhuModel *model = [Slef_GuanZhuModel pareFromDictionary:temp];
                [weakself.dataArr addObject:model];
            }
            [weakself.tableView reloadData];
        }
        
    }];

}


#pragma mark ---- tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Self_GuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Self_GuanZhuTableViewCell"];
    if (cell == nil) {
        cell = [[Self_GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Self_GuanZhuTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataArr.count>0) {
        [cell relayoutDataWithModel:_dataArr[indexPath.row]];
    }
    __weak typeof(self) weakself = self;
    cell.followBtnBlock = ^(Slef_GuanZhuModel *model){
        [weakself clickFollowBtn:model];
    };
    cell.headerImage.tag = 101*indexPath.row;
    [cell.headerImage addTarget:self action:@selector(clickToImage:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Slef_GuanZhuModel *model = _dataArr[indexPath.row];
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    
    if ([model.groupStatr isEqualToString:@"1"]) {
        
        __weak typeof(self) weakself = self;
        NSDictionary *paramters = @{@"name_id":userDefaultId,
                                    @"gid":model.groupID};
        
        [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=checkgroup",apiHeader120] parameters:paramters complicate:^(BOOL success, id data) {
            
            if (success) {
                // 1是结束和有效
                NSDictionary *ginfo = data[@"ginfo"];
                weakself.isfinished = ginfo[@"isfinished"]; //是否结束
                weakself.isvali = ginfo[@"isvali"];         //是否有效
                weakself.player = ginfo[@"players"];       //组队人数
                if ([weakself.isfinished isEqualToString:@"1"]) {
                    [weakself createAlertView:model];
                    return;
                    
                }else{
                    
                    if ([weakself.player isEqualToString:@"0"]) {
                        
                        [weakself alertShowView:@"记分已删除"];
                        return;
                        
                    }else if ([weakself.player isEqualToString:@"1"]) {
                        
                        NewStatisticsViewController *VC = [[NewStatisticsViewController alloc] init];
                        VC.loginNameId = userDefaultId;
                        VC.nameUid = model.nameID;
                        VC.groupId = model.groupID;
                        VC.isLoadDta = YES;
                        VC.status = 1;
                        VC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:VC animated:YES];
                        
                    }else{
                        
                        GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
                        group.loginNameId = userDefaultId;
                        group.nameUid = model.nameID;
                        group.groupId = model.groupID;
                        group.isLoadDta = YES;
                        group.status = 1;
                        group.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:group animated:YES];
                        
                    }
                }
                
            }
        }];
    }else{
        
        if ([model.nameID isEqualToString:@"usergolvon"]) {
            [aid setBlock:^(BOOL isView) {
                
            }];
            [self.navigationController pushViewController:aid animated:YES];
            
        }else if ([model.nameID isEqualToString:userDefaultId]){
            
            detail.nameID = model.nameID;
            [detail setBlock:^(BOOL isback) {
                
            }];
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            
            detail.nameID = model.nameID;
            [detail setBlock:^(BOOL isback) {
                
            }];
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    
    
}
#pragma mark ---- 头像跳转
-(void)clickToImage:(UIButton *)image{
    NSInteger tag = image.tag/101;
    Slef_GuanZhuModel *model = _dataArr[tag];
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    
    if ([model.groupID isEqualToString:@"1"]) {
        if ([model.gnum isEqualToString:@"1"]) {
            NewStatisticsViewController *VC = [[NewStatisticsViewController alloc] init];
            VC.loginNameId = userDefaultId;
            VC.nameUid = model.nameID;
            VC.groupId = model.groupID;
            VC.isLoadDta = YES;
            VC.status = 1;
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            GroupStatisticsViewController *group = [[GroupStatisticsViewController alloc] init];
            group.loginNameId = userDefaultId;
            group.nameUid = model.nameID;
            group.groupId = model.groupID;
            group.isLoadDta = YES;
            group.status = 1;
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }
    }
    
    
    if ([model.nameID isEqualToString:@"usergolvon"]) {
        [aid setBlock:^(BOOL isView) {
            
        }];
        [self.navigationController pushViewController:aid animated:YES];
    }else{
        
        detail.nameID = model.nameID;
        [detail setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail animated:YES];
    }

}
#pragma mark ---- 加关注&&取消关注
-(void)clickFollowBtn:(Slef_GuanZhuModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":model.nameID
                                };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *strCode = data[@"data"][0][@"code"];
            NSString *implementCode = data[@"data"][0][@"implementCode"];
            
            if ([strCode isEqualToString:@"1"]) {
                if ([implementCode isEqualToString:@"1"]) {
                    model.isFollow = YES;
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
                    for (Slef_GuanZhuModel *item in weakself.dataArr) {
                        if (item == model) {
                            item.isFollow = YES;
                        }
                        [array addObject:item];
                    }
                    [weakself.dataArr removeAllObjects];
                    weakself.dataArr = array;
                    [weakself.tableView reloadData];
                }else{
                    model.isFollow = NO;
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
                    for (Slef_GuanZhuModel *item in weakself.dataArr) {
                        if (item == model) {
                            item.isFollow = NO;
                        }
                        [array addObject:item];
                    }
                    [weakself.dataArr removeAllObjects];
                    weakself.dataArr = array;
                    [weakself.tableView reloadData];
                }
            }
            strCode = nil;
            implementCode = nil;
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [weakself presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
}

@end
