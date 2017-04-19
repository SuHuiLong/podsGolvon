//
//  HF_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "HF_ViewController.h"
#import "HF_TableViewCell.h"
#import "huiFuModel.h"
#import "NewZhuanFangViewController.h"
#import "RespondDetailViewController.h"

@interface HF_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *_HUB;
    
}
@property (nonatomic,strong)DownLoadDataSource * loadData;
@property (nonatomic,strong)NSMutableArray *huiFuData;

@property (assign, nonatomic) int curragePage;
@property (assign, nonatomic) int allPage;
@property (assign, nonatomic) int row;
@property (assign, nonatomic) UIEdgeInsets    insets;

@property (copy, nonatomic) NSString    *typeStr;

@property (copy, nonatomic) NSString    *deleID;        //要删除的ID


@end

@implementation HF_ViewController
-(NSMutableArray *)huiFuData{
    if (!_huiFuData) {
        _huiFuData = [[NSMutableArray alloc]init];
    }
    return _huiFuData;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];

    _curragePage = 0;
    self.view.backgroundColor = [UIColor whiteColor];

    [self testNetState];
    [self createUI];
}
-(void)viewDidLayoutSubviews{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:self.insets];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:self.insets];
    }
}
-(void)testNetState{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        appdele.reachAbilety = status > 0;
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [self alertShowView:@"网络连接失败"];
        }else{
            [self requestComment];
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
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
#pragma mark ---- UI
-(void)createNav{
    
    self.navigationItem.title = @"评论";
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;

}
-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerClass:[HF_TableViewCell class]
       forCellReuseIdentifier:@"HF_TableViewCell"];
    [self.view addSubview:_tableView];
 
    [self createReplyRefresh];
}

-(void)createNoneView{
    
    _tableView.hidden = YES;
    _label = [[UILabel alloc]init];
    _label.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    _label.text = @"您还没有收到评论";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _label.textColor = textTintColor;
    [self.view addSubview:_label];
}

-(void)createReplyRefresh{
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshToReply)];
    self.tableView.mj_header = headerRefresh;
    
    MJRefreshBackNormalFooter *footerLoading = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadingToReply)];
    self.tableView.mj_footer = footerLoading;
    
}
#pragma mark ---- 点击事件
-(void)clickHeaderIcon:(huiFuModel *)model{
    NewDetailViewController *VC = [[NewDetailViewController alloc] init];
    __weak typeof(self) weakself = self;
    if (![model.uid isEqualToString:userDefaultUid]) {
        
        VC.hidesBottomBarWhenPushed = YES;
        VC.nameID = model.uid;
        [VC setBlock:^(BOOL isback) {
            
        }];
        [weakself.navigationController pushViewController:VC animated:YES];
    }

}
-(void)clickName:(huiFuModel *)model{
    
    NewDetailViewController *VC = [[NewDetailViewController alloc] init];
    __weak typeof(self) weakself = self;
    if (![model.uid isEqualToString:userDefaultUid]) {
        
        VC.hidesBottomBarWhenPushed = YES;
        VC.nameID = model.uid;
        [VC setBlock:^(BOOL isback) {
            
        }];
        [weakself.navigationController pushViewController:VC animated:YES];
    }
}
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---- 请求数据
-(void)headerRefreshToReply{
    _curragePage = 0;
    [self.tableView.mj_footer resetNoMoreData];
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"page":@(_curragePage)
                                 };
    __weak typeof(self) weakself = self;
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getcommets",apiHeader120];
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            NSArray *arr = data[@"data"];
            [weakself.huiFuData removeAllObjects];
            for (NSDictionary *temp in arr) {
                huiFuModel *model = [huiFuModel modelWithDictionary:temp];
                [weakself.huiFuData addObject:model];
            }
            [weakself.tableView reloadData];
        }
    }];
}
-(void)footerLoadingToReply{
    _curragePage++;
    if (_curragePage>_allPage) {
        _curragePage--;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"page":@(_curragePage)
                                 };
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getcommets",apiHeader120];
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *arr = data[@"data"];
            for (NSDictionary *temp in arr) {
                huiFuModel *model = [huiFuModel modelWithDictionary:temp];
                [weakself.huiFuData addObject:model];
            }
            [weakself.tableView reloadData];
        }
    }];

}
- (void)requestComment{
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.alpha = 0.5;
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"page":@(_curragePage)
                                 };
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getcommets",apiHeader120];
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        _HUB.hidden = YES;
        _HUB = nil;
        if (success) {
            NSArray *arr = data[@"data"];
            weakself.allPage = [data[@"pages"] intValue];
            for (NSDictionary *temp in arr) {
                huiFuModel *model = [huiFuModel modelWithDictionary:temp];
                [weakself.huiFuData addObject:model];
            }
            [weakself.tableView reloadData];
            if (weakself.huiFuData.count == 0) {
                [weakself createNoneView];
            }
        }
    }];
    
}

#pragma mark - tableview代理方法
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.insets];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:self.insets];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        RespondDetailViewController *vc = [[RespondDetailViewController alloc] init];
        [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
        huiFuModel *model = _huiFuData[indexPath.row];
        vc.inquireDynamicID = model.did;
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    huiFuModel *model = _huiFuData[indexPath.row];
    
//    评论内容
    CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
    
//    被回复内容
    CGSize formatSize = [model.orgcontent boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kHorizontal(12)]} context:nil].size;
    
    /** 1为专访评论，2为评论回复，3为朋友圈评论,4为朋友圈回复  * */
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {
        if (TitleSize.height + kHvertical(45)<kHvertical(65)) {
            return kHvertical(65);
        }
        return TitleSize.height + kHvertical(45);
        
    }else{
        
        return TitleSize.height + kHvertical(45) + kHvertical(22) + formatSize.height;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _huiFuData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.separatorColor = GPColor(242, 242, 242);
    HF_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HF_TableViewCell"];
    [cell relayoutWithModel:_huiFuData[indexPath.row]];
    huiFuModel *model = _huiFuData[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickHeadericonBlock = ^(huiFuModel *model){
        [weakSelf clickHeaderIcon:model];
    };
    cell.clickNameBlock = ^(huiFuModel *model){
        
        [weakSelf clickName:model];

    };
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) {
        cell.selected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakself = self;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        huiFuModel *model = _huiFuData[indexPath.row];
        NSDictionary *parameters = @{@"name_id":userDefaultId,
                                     @"cid":model.cid,
                                     @"type":model.type};
        [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=delcommet",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
            if (success) {
                
                NSString *code = data[@"code"];
                if ([code isEqualToString:@"0"]) {
                    
                    [weakself.huiFuData removeObjectAtIndex:indexPath.row];
                }
                [weakself.tableView reloadData];
            }
        }];
        
    }
}
@end
