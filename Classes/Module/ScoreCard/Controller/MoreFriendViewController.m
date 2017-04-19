//
//  MoreFriendViewController.m
//  TabBar
//
//  Created by 李盼盼 on 16/8/4.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "MoreFriendViewController.h"
#import "DownLoadDataSource.h"
#import "RulesTableViewCell.h"
#import "ScoreCardViewController.h"


static NSString *cellID = @"RulesTableView";
@interface MoreFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
/***  */
@property (strong, nonatomic) UITableView    *tableView;
/***  工具*/
@property (strong, nonatomic) DownLoadDataSource    *loadData;
/***  关注状态*/
@property (strong, nonatomic) NSNumber    *likeState;
@property (strong, nonatomic) NSString    *nameID;


@end

@implementation MoreFriendViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createTableView];
    

}
-(void)createNav{
    
    
    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navi.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 20, 44, 44);
    back.userInteractionEnabled = YES;
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [back addSubview:backImage];
    [back addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:back];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, 35, 120, 15)];
    if (self.view.frame.size.height <= 568)
    {
        title.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
        
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
    {
        title.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
        
    }else{
        
        title.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
        
    }
    title.text = @"关注球友";
    title.textAlignment = NSTextAlignmentCenter;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
    line.backgroundColor = NAVLINECOLOR;
    
    [navi addSubview:line];
    [navi addSubview:title];
    [self.view addSubview:navi];
    
}
-(void)pushBack{
    for (ScoreCardViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[ScoreCardViewController class]]) {
            VC.popID = 2;
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = kHvertical(55);
    [_tableView registerClass:[RulesTableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorColor = GPColor(244, 244, 244);
    [self.view addSubview:_tableView];
    
}

#pragma mark ---- 请求排行榜数据
-(void)requestData{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"nameID":userDefaultId};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRanking",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            weakself.state = data[@"FriendsRankingStatr"];
            if ([weakself.state isEqualToString:@"1"]) {
                [weakself.dataArr removeAllObjects];
                for (NSDictionary *friend_temp in data[@"FriendsRanking"]) {
                    RulesModel *model = [RulesModel relayoutWithModel:friend_temp];
                    [weakself.dataArr addObject:model];
                }
            }
            [weakself.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_state isEqualToString:@"0"]) {
        return 0;
    }else{
        return _dataArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RulesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    RulesModel *model = _dataArr[indexPath.row];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rankImage.hidden=YES;
    cell.allRankLabel.hidden = YES;
    cell.rankLabel.hidden = NO;
    cell.allRankLabel.text = model.rankNumber;
    cell.nickName.frame = CGRectMake(cell.headerImage.right + kWvertical(8), kHvertical(8), kWvertical(150), kHvertical(20));
    cell.nickName.textAlignment = NSTextAlignmentCenter;
    cell.nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    cell.nickName.textColor = GPColor(38, 38, 38);
    [cell.nickName sizeToFit];
    [cell relayoutWithModel:_dataArr[indexPath.row]];
    
    
    __weak typeof(self) weakself = self;
    cell.lickBtnBlock = ^(RulesModel *model){
        
        [weakself clickLikeBtn:model];
        
    };
//    cell.lickBtn.tag = 101*indexPath.row;
//    [cell.lickBtn addTarget:self action:@selector(clickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark ---- 点赞
-(void)clickLikeBtn:(RulesModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"nameID":userDefaultId,
                                @"rankNameID":model.name_id
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertRankClick",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSNumberFormatter *num = [[NSNumberFormatter alloc]init];
            weakself.likeState = data[@"data"][0][@"code"];
            NSString *str = [num stringFromNumber:_likeState];
            
            if ([str isEqualToString:@"1"]) {
                
            }
            
            [weakself requestData];
            
        }else{
            //                [weakself alertShowView:@"网络错误"];
        }
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RulesModel *model = _dataArr[indexPath.row];
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    if ([model.name_id isEqualToString:@"usergolvon"]) {
        [aid setBlock:^(BOOL isView) {
            
        }];
        [self.navigationController pushViewController:aid animated:YES];
    }else{
        detail.nameID = model.name_id;
        [detail setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

@end
