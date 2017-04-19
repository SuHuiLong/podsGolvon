//
//  SupportViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/8/11.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "SupportViewController.h"
#import "SupportTableViewCell.h"
#import "ScoreCardViewController.h"

static NSString *cellID = @"SupportTableViewCell";
@interface SupportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView    *tableView;
/***  数据源*/
@property (strong, nonatomic) NSMutableArray    *dataArr;
/***  工具类*/
@property (strong, nonatomic) DownLoadDataSource    *loadData;

@end

@implementation SupportViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    
    return _dataArr;
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
    
    [self requsetData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
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
    title.text = @"赞了我的球友";
    title.textAlignment = NSTextAlignmentCenter;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, ScreenWidth, 1)];
    line.backgroundColor = NAVLINECOLOR;
    
    [navi addSubview:line];
    [navi addSubview:title];
    [self.view addSubview:navi];
    
}
-(void)pushBack{
//    for (ScoreCardViewController *VC in self.navigationController.viewControllers) {
//        if ([VC isKindOfClass:[ScoreCardViewController class]]) {
//            VC.popID = 2;
            [self.navigationController popViewControllerAnimated:YES];
//
//        }
//    }
}

-(void)createUI{
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = kHvertical(67);
    [_tableView registerClass:[SupportTableViewCell class] forCellReuseIdentifier:cellID];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorColor = GPColor(244, 244, 244);
    [self.view addSubview:_tableView];
    
}
-(void)createNoneView{
    
    _tableView.hidden = YES;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    label.text = @"您还没有收到点赞";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kHorizontal(16)];
    label.textColor = textTintColor;
    [self.view addSubview:label];
}
#pragma mark ---- 请求数据
-(void)requsetData{
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRankingClickUser",urlHeader120] parameters:@{@"nameID":userDefaultId} complicate:^(BOOL success, id data) {
        if (success) {
            
            [weakself.dataArr removeAllObjects];
            NSArray *tempArr = data[@"data"];
            if (tempArr.count == 0) {
                [self createNoneView];
            }else{
                _tableView.hidden = NO;
            }
            for (NSDictionary *temp in tempArr) {
                
                SupportModel *model = [SupportModel initWithFromDictionary:temp];
                
                [weakself.dataArr addObject:model];
            }
            
            [weakself.tableView reloadData];
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

#pragma mark ---- UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    [cell relayoutWithModel:_dataArr[indexPath.row]];
    
    __weak typeof(self) weakself = self;
    cell.setFollowBtnBlock = ^(SupportModel *model){
        [weakself clickFollowBtn:model];
    };
    return cell;
}
#pragma mark ---- 关注
-(void)clickFollowBtn:(SupportModel *)model{
    NSLog(@"model%@",model);
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":model.nameID
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *strCode = data[@"data"][0][@"code"];
            
//            NSString *implementCode = data[@"data"][0][@"implementCode"];
            
            if ([strCode isEqualToString:@"1"]) {
                [self requsetData];
                [_tableView reloadData];
            }
            
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SupportModel *model = _dataArr[indexPath.row];
    
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
