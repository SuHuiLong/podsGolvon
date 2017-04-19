//
//  RankingListViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/11/3.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RankingListViewController.h"
#import "PublicBenefitTableViewCell.h"
#import "PublicBenefitModel.h"
#import "MJRefresh.h"
@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
}
//tableview
@property(nonatomic,strong)UITableView  *mainTableView;
//tablview数据源
@property(nonatomic,copy)NSArray  *dataArray;

@end

@implementation RankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createRefreash];
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
}
//创建导航
-(void)createNavigationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"公益"];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:titlelabel];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
    
}
//创建tableview
-(void)createTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    [tableView registerClass:[PublicBenefitTableViewCell class] forCellReuseIdentifier:@"PublicBenefitTableViewCell"];
    _mainTableView = tableView;
}
#pragma mark - initData
-(void)initData{
    if (_page==0) {
        _dataArray = [NSArray array];
    }
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId,
                           @"page":[NSString stringWithFormat:@"%ld",(long)_page]
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=charityrank",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            [_mainTableView.mj_footer endRefreshing];
            [_mainTableView.mj_header endRefreshing];
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [data objectForKey:@"data"];
                NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:_dataArray];
                for (NSInteger i=0; i<dataArray.count; i++) {
                    PublicBenefitModel *model = [PublicBenefitModel new];
                    [model configData:dataArray[i]];
                    model.rank = [NSString stringWithFormat:@"%ld",mDataArray.count+1];
                    model.vid = [dataArray[i] objectForKey:@"vid"];
                    [mDataArray addObject:model];
                }
                _dataArray = [NSArray arrayWithArray:mDataArray];
                [_mainTableView reloadData];
            }
        }
    }];
}



#pragma mark - Action
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - tablevieDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = _dataArray.count;
    return  num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(55);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(42);
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PublicBenefitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicBenefitTableViewCell"];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PublicBenefitModel *model = _dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    headerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(42))];
    UILabel *title = [Factory createLabelWithFrame:CGRectMake(kWvertical(12), 0, kWvertical(200), kHvertical(42)) textColor:rgba(44,44,44,1) fontSize:kHorizontal(13) Title:@"公益榜"];
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(19), kHvertical(10), kWvertical(6), kHvertical(11)) Image:[UIImage imageNamed:@""]];
    
//    UILabel *moreLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - kWvertical(23), kHvertical(42)) textColor:rgba(150,150,150,1) fontSize:kHorizontal(11) Title:@"更多"];
//    [moreLabel setTextAlignment:NSTextAlignmentRight];
    [headerView addSubview:title];
    [headerView addSubview:arrowView];
//    [headerView addSubview:moreLabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PublicBenefitModel *model = _dataArray[indexPath.row];
    
    NewDetailViewController *VC = [[NewDetailViewController alloc]init];
    VC.nameID = model.uid;
    VC.hidesBottomBarWhenPushed = YES;
    [VC setBlock:^(BOOL isback) {
        
    }];
    [self.navigationController pushViewController:VC animated:YES];
    
}



#pragma mark - 刷新
-(void)createRefreash{
    //    头部刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    //    立即刷新
    self.mainTableView.mj_header = refreshHeader;
    //    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.mainTableView.mj_footer = refreshFooter;
}
//开始刷新
-(void)refreshHeaderData{
    [self.mainTableView.mj_header beginRefreshing];
}

//刷新
-(void)headerRefresh{
    _page = 0;
    [self initData];
}
//加载
-(void)footerRefresh{
    _page++;
    [self initData];
}






@end
