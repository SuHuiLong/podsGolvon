//
//  XT_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "XT_ViewController.h"
#import "XT_TableViewCell.h"
#import "XiTongModel.h"
#import "UserDetailViewController.h"


@interface XT_ViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    MBProgressHUD *_HUB;
    
}
@property (strong, nonatomic)DownLoadDataSource *loadData;
@property (strong, nonatomic)NSMutableArray *xiTongData;
@property (assign, nonatomic) int curragePage;
@property (assign, nonatomic) int allPage;
@property (assign, nonatomic) NSInteger row;
@property (copy, nonatomic) NSString    *deleID;        //要删除的ID
@property (copy, nonatomic) NSString    *logo;


@property (strong, nonatomic) UIView     *deleteGroundView;//删除的背景
@property (strong, nonatomic) UIView     *deleteView;//删除的view


@end

@implementation XT_ViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableArray *)xiTongData{
    if (!_xiTongData) {
        _xiTongData = [[NSMutableArray alloc]init];
    }
    return _xiTongData;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    _curragePage = 0;
    _allPage = 0;
    [self createNav];
    [self createUI];
    [self requestXiTong];
}
#pragma mark ---- UI
-(void)createNav{
    
    self.navigationItem.title = @"系统";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
}
-(void)createNoneView{

    _tableView.hidden = YES;

    _label = [[UILabel alloc]init];
    _label.text = @"您没有系统消息";
    _label.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));

    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _label.textColor = textTintColor;
    [self.view addSubview:_label];
    
}
-(void)createUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[XT_TableViewCell class] forCellReuseIdentifier:@"XT_TableViewCell"];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
    [self createRefresn];
    
}

#pragma mark ---- 点击事件
-(void)deleteMessage:(XiTongModel *)model{
    self.deleID = model.suid;
    
    _deleteGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _deleteGroundView.hidden = NO;
    _deleteGroundView.backgroundColor = GPRGBAColor(.2, .2, .2, .3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHidden)];
    [_deleteGroundView addGestureRecognizer:tap];
    [self.view addSubview:_deleteGroundView];
    
    _deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, HScale(14.8))];
    _deleteView.hidden = NO;
    _deleteView.backgroundColor = GPColor(245, 245, 245);
    [_deleteGroundView addSubview:_deleteView];
    [[[UIApplication sharedApplication] .windows firstObject] addSubview:_deleteGroundView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToDelet) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"删除" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [_deleteView addSubview:confirmBtn];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    [cancel addTarget:self action:@selector(clickToHidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    
    [_deleteView addSubview:cancel];
    
    [UIView animateWithDuration:0.4 animations:^{
        _deleteView.frame = CGRectMake(0, ScreenHeight - HScale(14.8), ScreenWidth, HScale(14.8));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        confirmBtn.frame = CGRectMake(0, 0, ScreenWidth, HScale(6.9));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        cancel.frame = CGRectMake(0, HScale(7.9), ScreenWidth, HScale(6.9));
    }];
    
    
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickToHidden{
    [_deleteView removeFromSuperview];
    [_deleteGroundView removeFromSuperview];
}
-(void)clickToDelet{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"name_id":userDefaultId,
                                @"suid":_deleID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=delsysmsg",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"0"]) {
                [weakself.xiTongData removeObjectAtIndex:self.row];
                [weakself clickToHidden];
            }
            [weakself.tableView reloadData];
        }
    }];
}
#pragma mark ----  请求数据
-(void)createRefresn{
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshToSystem)];
    self.tableView.mj_header = headerRefresh;
    
    MJRefreshBackNormalFooter *footerLoading = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadingToSystem)];
    self.tableView.mj_footer = footerLoading;
}

-(void)headerRefreshToSystem{
    _curragePage = 0;
    [self.tableView.mj_footer resetNoMoreData];
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"page":@(_curragePage)
                                 };
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getsysmsgs",apiHeader120];
    
    
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            NSArray *arr = data[@"data"];
            weakself.logo = data[@"logo"];

            [weakself.xiTongData removeAllObjects];
            for (NSDictionary *temp in arr) {
                
                XiTongModel *model = [XiTongModel modelWithDictionary:temp];
                [weakself.xiTongData addObject:model];
            }
            [weakself.tableView reloadData];
        }else{
            NSLog(@"请求失败");
        }
    }];

}
-(void)footerLoadingToSystem{
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
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getsysmsgs",apiHeader120];
    
    
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *arr = data[@"data"];
            weakself.logo = data[@"logo"];

            for (NSDictionary *temp in arr) {
                XiTongModel *model = [XiTongModel modelWithDictionary:temp];
                [weakself.xiTongData addObject:model];
            }
            [weakself.tableView reloadData];
        }else{
//            NSLog(@"请求失败");
        }
    }];

}
- (void)requestXiTong{
    __weak typeof(self) weakself = self;
    
    _HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUB.mode = MBProgressHUDModeIndeterminate;
    _HUB.alpha = 0.5;
    NSDictionary *parameters = @{
                                 @"name_id":userDefaultId,
                                 @"page":@(_curragePage)
                                 };
    NSString *path = [NSString stringWithFormat:@"%@msgapi.php?func=getsysmsgs",apiHeader120];
    
    
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.loadData downloadWithUrl:url parameters:parameters complicate:^(BOOL success, id data) {
        
        _HUB.hidden = YES;
        _HUB = nil;
        if (success) {
            NSArray *arr = data[@"data"];
            weakself.allPage = [data[@"totalNum"] intValue];
            weakself.logo = data[@"logo"];
            [weakself.xiTongData removeAllObjects];
            
            for (NSDictionary *temp in arr) {
                XiTongModel *model = [XiTongModel modelWithDictionary:temp];
                [weakself.xiTongData addObject:model];
            }
            
            [weakself.tableView reloadData];
            if ([arr count] == 0) {
                [weakself createNoneView];
            }else{
//                [self createUI];
            }
        }else{
            NSLog(@"请求失败");
        }
    }];
}

#pragma mark - tableview代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _xiTongData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XiTongModel *model = _xiTongData[indexPath.row];
    
    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(kWvertical(324), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(14)]} context:nil].size;
    
    if ([model.picurl isEqualToString:@"0"]) {
        
        return kHvertical(102)+contentSize.height + kHvertical(22);
    }else{
        
        return kHvertical(95) + kHvertical(205) + kHvertical(44);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XT_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XT_TableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell realyoutWithModel:_xiTongData[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    
    cell.deleteMessageBlock = ^(XiTongModel *model){
        weakSelf.row = indexPath.row;
        [weakSelf deleteMessage:model];
    };
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XiTongModel *model = _xiTongData[indexPath.row];
    NSString *pushUrlStr = model.url;
    if (pushUrlStr) {
        if (pushUrlStr.length>0) {
            UserDetailViewController *VC= [[UserDetailViewController alloc] init];
            VC.urlStr = pushUrlStr;
            VC.titleStr = model.title;
            VC.despStr = model.content;
            VC.picUrl = _logo;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
@end
