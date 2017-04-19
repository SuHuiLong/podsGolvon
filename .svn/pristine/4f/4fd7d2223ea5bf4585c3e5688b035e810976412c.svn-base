//
//  BallParkViewController.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "BallParkViewController.h"
#import "BallParkTableViewCell.h"
#import "AddBallParkViewController.h"
#import "MJRefresh.h"

static NSString *history = @"history";

@interface BallParkViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSInteger page;
    NSInteger _lastPosition;
    NSString *searchKey;
}

@property (strong, nonatomic) UISearchDisplayController     *displayController;  //搜索控制器
@property (strong, nonatomic) DownLoadDataSource            *loadData;  //工具类
@property (strong, nonatomic) UISearchBar                   *searchBar;
@property (strong, nonatomic) NSMutableArray                *searchResults;     //存放搜寻结果
@property (strong, nonatomic) NSMutableArray                *historyArr;        //历史记录
@property (strong, nonatomic) CLLocationManager             *manager;           //地图管理类
@property (strong, nonatomic) UITableView                   *tableView;
@property (assign, nonatomic) CGFloat                       latitude;   //纬度；
@property (assign, nonatomic) CGFloat                       longitude;  //经度；
@property (strong, nonatomic) UIView                        *seachView;

@property (strong, nonatomic) NSMutableArray    *dataSouce;         //数据
@property (nonatomic,copy)NSString *searchKey;//搜索关键字


@property (strong, nonatomic) UIView    *placeView;
@property (strong, nonatomic) MBProgressHUD *HUD;


@end

@implementation BallParkViewController

-(NSMutableArray*)dataSouce{
    if (!_dataSouce) {
        
        _dataSouce = [[NSMutableArray alloc]init];
    }
    return _dataSouce;
}

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc]init];
    }
    return _historyArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;    
}
- (void)viewDidLoad {
    page = 0;
    [super viewDidLoad];
    [self createView];
    [self createRefresh];
    [self downloadNowData];
    [self downLoadHistoryData];
    [self createProgress];

}
#pragma mark - createView
-(void)createView{
    [self createNavagationView];

}


//等待
-(void)createProgress{
    
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_placeView];
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
}


//头部视图
-(void)createNavagationView{
    _searchResults = [@[] mutableCopy];
    self.view.backgroundColor = [UIColor whiteColor];
    

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    leftBarbutton.tintColor = GPColor(0, 0, 0);
    [leftBarbutton setImage:[UIImage imageNamed:@"多人操作返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goToAddBallPark)];
    rightBarbutton.tintColor = GPColor(0, 0, 0);
    [rightBarbutton setImage:[UIImage imageNamed:@"球场添加"]];
    self.navigationItem.rightBarButtonItem = rightBarbutton;

    
    self.title = @"选择球场";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.barTintColor = GPColor(245, 245, 245);
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:_searchBar];
    
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDelegate   = self;
    _displayController.searchResultsDataSource = self;
    [self createNoseachView];
    
}

//没有搜索结果
-(void)createNoseachView{
    
    _seachView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight)];
    _seachView.backgroundColor = GPColor(245, 245, 245);
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake((ScreenWidth - 280)/2, 20, 280, 35);
    label.text = @"没有搜索到您要找的球场";
    label.font = [UIFont systemFontOfSize:kHorizontal(14)];
    label.textColor = GPColor(150, 150, 150);
    label.textAlignment = NSTextAlignmentCenter;
    [_seachView addSubview:label];
    
    
    _seachView.hidden = YES;
    [self.view addSubview:_seachView];
    
    
}
#pragma mark - initData

-(void)downloadNowData{
    if (page==0) {
        self.dataSouce = [NSMutableArray array];
    }
    __weak typeof(self) weakself = self;
    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"lng":lon,
                           @"lat":lat,
                           @"name_id":userDefaultId,
                           @"page":pageStr
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=courselist",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.HUD removeFromSuperview];
        [weakself.placeView removeFromSuperview];
        
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [data objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {

                    for (NSInteger i = 0; i<dataArray.count; i++) {
                        NSDictionary *pordataDict = dataArray[i];
                        NearParkModel *model = [[NearParkModel alloc] init];
                        [model configData:pordataDict];
                        [weakself.dataSouce addObject:model];
                    }
                    [weakself.tableView.mj_header endRefreshing];
                    [weakself.tableView.mj_footer endRefreshing];
                }
            }
        }
        [weakself.tableView reloadData];
    }];
}

// 历史记录
-(void)downLoadHistoryData{
    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    __weak typeof(self) weakself = self;
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"lng":lon,
                           @"lat":lat,
                           @"name_id":userDefaultId,
                           @"history":@"1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=courselist",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [data objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {
                    weakself.historyArr = [NSMutableArray array];
                    for (NSInteger i = 0; i<dataArray.count; i++) {
                        NSDictionary *pordataDict = dataArray[i];
                        NearParkModel *model = [[NearParkModel alloc] init];
                        [model configData:pordataDict];

                        NSInteger diffrent = 0;
                        for (NearParkModel *parkModel in weakself.historyArr) {
                            if ([parkModel.qname isEqualToString:model.qname]) {
                                diffrent++;
                            }
                        }
                        
                        if (weakself.historyArr.count<5&&diffrent==0) {
                            [weakself.historyArr addObject:model];
                        }
                    }
                }
            }
        }
        [weakself.tableView reloadData];
    }];
    
}

//加载搜索数据
-(void)loadSearchData{

    NSString *lat = [userDefaults objectForKey:@"latitude"];
    NSString *lon = [userDefaults objectForKey:@"longitude"];
    if (!lat) {
        lat = @"0.0";
        lon = @"0.0";
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    __weak typeof(self) weakself = self;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"lng":lon,
                           @"lat":lat,
                           @"name_id":userDefaultId,
                           @"keyword":_searchKey,
                           @"page":pageStr
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=courselist",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [data objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {
                    if (page == 0) {
                        _searchResults = [NSMutableArray array];
                    }
                    for (NSInteger i = 0; i<dataArray.count; i++) {
                        NSDictionary *pordataDict = dataArray[i];
                        NearParkModel *model = [[NearParkModel alloc] init];
                        [model configData:pordataDict];
                        [weakself.searchResults addObject:model];
                    }
                }
            }
        }
        [weakself.displayController.searchResultsTableView reloadData];
    }];
}



#pragma mark - Action
//返回
-(void)pressBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//前往添加球场
-(void)goToAddBallPark{
    
    AddBallParkViewController *VC = [[AddBallParkViewController alloc]init];
    __weak typeof(self) weakself = self;
    VC.newPark =  ^(NearParkModel *model){
        weakself.selectPar(model);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 刷新
-(void)createRefresh{
    //    头部刷新
   MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    //    立即刷新
    self.tableView.mj_header = refreshHeader;
    //    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = refreshFooter;
}
//开始刷新
-(void)refreshHeaderData{
    [self.tableView.mj_header beginRefreshing];
}

//刷新
-(void)headerRefresh{
    page = 0;
    [self downloadNowData];
}
//加载
-(void)footerRefresh{
    page = page +1;
    [self downloadNowData];
}



#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return 2;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = GPColor(245, 245, 245);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 200, HScale(2.3))];
    label.textColor = GPColor(123, 123, 123);
    label.font = [UIFont systemFontOfSize:kHorizontal(13)];
    label.textAlignment = NSTextAlignmentCenter;
    if (tableView == _tableView) {
        if (section == 0) {
            label.text = @"常去球场";
            [label sizeToFit];
        }else{
            label.text = @"附近球场";
            [label sizeToFit];
        }
    }else{
        label.text = @"搜索结果";
        [label sizeToFit];
    }
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HScale(4.3);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HScale(7.5);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _tableView) {
        if (section == 0) {
            return self.historyArr.count;
        }else{
            return  self.dataSouce.count;
        }
    }else{

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
//        [_searchResults removeAllObjects];
//        for (BallParkSelectModel *selectModel in self.dataSouce) {
//            if ([selectModel.name rangeOfString:_displayController.searchBar.text options:NSCaseInsensitiveSearch].location !=NSNotFound) {
//                [_searchResults addObject:selectModel];
//            }
//        }
//        if (!_searchResults.count && _displayController.searchBar.text.length > 0) {
//            _seachView.hidden = NO;
//            [self.view bringSubviewToFront:_seachView];
//        }else{
//            _seachView.hidden = YES;
//        }
        return _searchResults.count;
    }
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _seachView.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BallParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:history];

    if (!cell) {
        cell = [[BallParkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:history];
    }
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            [cell relayoutWithModel:_historyArr[indexPath.row]];
        }else if(indexPath.section == 1){
            NearParkModel *model = self.dataSouce[indexPath.row];
            [cell relayoutWithModel:model];
        }
    }else{
        [cell relayoutWithModel:_searchResults[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            
            _selectPar(_historyArr[indexPath.row]);
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            _selectPar(self.dataSouce[indexPath.row]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else if (tableView == _displayController.searchResultsTableView){
        
        [_displayController.searchBar resignFirstResponder];
        [_displayController setActive:NO animated:YES];
        
        _selectPar(_searchResults[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.contentInset = UIEdgeInsetsZero;
    tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


#pragma mark - 预加载
-(void)scrollViewDidScroll:(UITableView *)tableView{
    if ([tableView isEqual:_tableView]||[tableView isEqual:_displayController.searchResultsTableView]) {
        CGPoint pInView = [self.view convertPoint:tableView.center toView:tableView];
        // 获取这一点的indexPath
        NSIndexPath *indexPathNow = [tableView indexPathForRowAtPoint:pInView];
        NSInteger indexNow = indexPathNow.item;
        if (indexNow > _lastPosition) {
            _lastPosition = indexNow;
            NSInteger beganLoadData = _dataSouce.count - indexNow;
            if ( beganLoadData == 12) {
                page ++;
                if (tableView==_tableView) {
                    [self downloadNowData];
                }else{
                    [self loadSearchData];
                }
            }
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _searchKey = searchText;
    [self loadSearchData];
    
}


@end
