//
//  NoneFriendViewController.m
//  TabBar
//
//  Created by 李盼盼 on 16/8/4.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "NoneFriendViewController.h"
#import "RecommendModel.h"
#import "RecommendTableViewCell.h"
#import "MBProgressHUD.h"
#import "ScoreCardViewController.h"


@interface NoneFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUB;
    
}
/***  tableView*/
@property (strong, nonatomic) UITableView    *tableView;
/***  请求数据工具类*/
@property (strong, nonatomic) DownLoadDataSource    *loadData;
/***  关注图标*/
@property (strong, nonatomic) UIImageView    *followimage;
@property (strong, nonatomic) NSString    *nameID;

@end

static NSString *cellID = @"RecommendTableViewCell";

@implementation NoneFriendViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_dataArr.count == 0) {
        
        [self requestLoadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)createNav{
    
    
    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navi.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 20, 44, 44);
    back.userInteractionEnabled = YES;
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    [back addSubview:backImage];
    backImage.image = [UIImage imageNamed:@"返回"];
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
    title.text = @"球友推荐";
    title.textAlignment = NSTextAlignmentCenter;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, ScreenWidth, 1)];
    line.backgroundColor = NAVLINECOLOR;
    
    [navi addSubview:line];
    [navi addSubview:title];
    [self.view addSubview:navi];
    
}
-(void)createUI{
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kWvertical(67);
    [_tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.separatorColor = GPColor(244, 244, 244);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
}
-(void)pushBack{
    for (ScoreCardViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[ScoreCardViewController class]]) {
            VC.popID = 2;
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

#pragma mark ---- 请求数据
-(void)requestLoadData{
    
    _dataArr = [NSMutableArray array];
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.alpha = 0.5;
    
    NSDictionary *parameter = @{@"nameID":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/FriendsRecommend",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *dict = data[@"FriendsReco"];
            
            [_dataArr removeAllObjects];
            for (NSDictionary *temp in dict) {
                RecommendModel *model = [RecommendModel initWithFromDictionary:temp];
                [self.dataArr addObject:model];
                _nameID = model.nameID;
            }
            [_tableView reloadData];
            
            [self createUI];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        
        _HUB.hidden = YES;
        _HUB = nil;
        
    }];
}

#pragma mark ---- UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    [cell relayoutWithModel:_dataArr[indexPath.row]];
    
    __weak typeof(self) weakself = self;
    cell.followBtnBlock = ^(RecommendModel *model){
        
        [weakself clickFollowBtn:model];
        
    };
 
    return cell;
}

#pragma mark ---- 关注
-(void)clickFollowBtn:(RecommendModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":model.nameID
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            
            NSString *strCode = data[@"data"][0][@"code"];
            NSString *implementCode = data[@"data"][0][@"implementCode"];
            
            if ([strCode isEqualToString:@"1"]) {
                if ([implementCode isEqualToString:@"1"]) {
                    model.state = YES;
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
                    for (RecommendModel *item in weakself.dataArr) {
                        if (item == model) {
                            item.state = YES;
                        }
                        [array addObject:item];
                    }
                    [weakself.dataArr removeAllObjects];
                    weakself.dataArr = array;
                    [weakself.tableView reloadData];
                }else{
                    model.state = NO;
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
                    for (RecommendModel *item in weakself.dataArr) {
                        if (item == model) {
                            item.state = NO;
                        }
                        [array addObject:item];
                    }
                    [weakself.dataArr removeAllObjects];
                    weakself.dataArr = array;
                    [weakself.tableView reloadData];
                }
            }
//            NSLog(@"关注状态%@",data[@"data"][0][@"implementCode"]);
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendModel *model = _dataArr[indexPath.row];
    NewDetailViewController *detail = [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    if ([model.nameID isEqualToString:@"usergolvon"]) {
        [aid setBlock:^(BOOL isView) {
            
        }];
        aid.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aid animated:YES];
    }else{
        detail.nameID = model.nameID;
        [detail setBlock:^(BOOL isback) {
            
        }];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
