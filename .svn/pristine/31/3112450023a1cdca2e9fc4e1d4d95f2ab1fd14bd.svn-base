//
//  MonthListViewController.m
//  podsGolvon
//
//  Created by apple on 2017/1/17.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import "MonthListViewController.h"
#import "RankListHeaderView.h"
#import "RulesModel.h"
#import "RulesTableViewCell.h"


@interface MonthListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, strong) NSMutableArray   *monthDataArr;

@property (nonatomic, strong) DownLoadDataSource   *LoadDataManager;
@property (nonatomic, strong) UIView    *placeView;
@property (nonatomic, strong) MBProgressHUD   *HUD;

@property (nonatomic, strong) RulesModel   *model;
@property (nonatomic, strong) NSMutableArray   *selfArr;
@property (copy, nonatomic) NSString *state;        //打球状态
@property (nonatomic, strong) NSArray   *headerArr;

@end

static NSString *cellID = @"cellID";
@implementation MonthListViewController
-(NSMutableArray *)monthDataArr{
    if (!_monthDataArr) {
        _monthDataArr = [NSMutableArray array];
    }
    return _monthDataArr;
}
-(NSArray *)headerArr{
    if (!_headerArr) {
        _headerArr = [NSArray array];
    }
    return _headerArr;
}
-(DownLoadDataSource *)LoadDataManager{
    if (!_LoadDataManager) {
        _LoadDataManager = [[DownLoadDataSource alloc] init];
    }
    return _LoadDataManager;
}
-(NSMutableArray *)selfArr{
    if (!_selfArr) {
        _selfArr = [NSMutableArray array];
    }
    return _selfArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestMonthData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
-(void)requestMonthData{
    if ([_monthDataArr count] > 0) {
        [_placeView removeFromSuperview];
        _HUD = nil;
    }else{
        [self createProgress];
    }
    NSDictionary *parameters = @{@"nameID":userDefaultId,
                                 @"month":@"1"};
    [self.LoadDataManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRanking",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        
        if (success) {
            
            self.state = data[@"UserRank"][@"zongChangCi"];
            NSArray *arr = data[@"UserRank"];
            if ([arr count] >0) {
                RulesModel *model = [RulesModel relayoutWithModel:data[@"UserRank"]];
                self.model = model;
                [self.selfArr addObject:model];
            }
            
            NSArray *tempArr = data[@"Ranking"];
            for (NSDictionary *tempDic in tempArr) {
                RulesModel *model = [RulesModel relayoutWithModel:tempDic];
                [self.monthDataArr addObject:model];
            }
            
            if (self.monthDataArr.count>3) {
                
                self.headerArr = [self.monthDataArr subarrayWithRange:NSMakeRange(0, 3)];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
                [self.monthDataArr removeObjectsAtIndexes:indexSet];

            }
        }
        if (!_tableview) {
            [self createTableview];
        }
    }];
    
}
#pragma mark ---- UI
-(void)createProgress{
    
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_placeView];
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
}

-(void)createTableview{
    
    RankListHeaderView *headerView = [[RankListHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(200))];
    [headerView relayoutHeaderDataWithArrar:self.headerArr];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableview.tableHeaderView = headerView;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.rowHeight = kHvertical(55);
    _tableview.separatorStyle = false;
    [_tableview registerClass:[RulesTableViewCell class] forCellReuseIdentifier:cellID];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [self.view addSubview:_tableview];
}

#pragma mark ---- tableView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(30))];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(13), 0, kWvertical(30), kHvertical(30))];
        title.text = @"全部";
        title.font = [UIFont systemFontOfSize:kHorizontal(13)];
        title.textColor = GPColor(123, 123, 123);
        [headerview addSubview:title];
        
        UILabel *chang = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(274), 0, kWvertical(30), kHvertical(30))];
        chang.text = @"场次";
        chang.font = [UIFont systemFontOfSize:kHorizontal(13)];
        chang.textColor = GPColor(123, 123, 123);
        [headerview addSubview:chang];
        
        UILabel *like = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-kWvertical(44), 0, kWvertical(30), kHvertical(30))];
        like.text = @"点赞";
        like.font = [UIFont systemFontOfSize:kHorizontal(13)];
        like.textColor = GPColor(123, 123, 123);
        [headerview addSubview:like];
        return headerview;
        
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell relayoutWithModel:self.selfArr[0]];
        return cell;
    }
    [cell relayoutWithModel:self.monthDataArr[indexPath.row]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.monthDataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kHvertical(30);
    }
    return kHvertical(3);
}


@end
