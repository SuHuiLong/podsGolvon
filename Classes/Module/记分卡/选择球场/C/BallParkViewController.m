//
//  BallParkViewController.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "BallParkViewController.h"
#import "BallParkTableViewCell.h"
#import "DownLoadDataSource.h"
#import "BallParkSelectModel.h"
#import "AddBallParkViewController.h"
#import <CoreLocation/CoreLocation.h>

static NSString *history = @"history";

@interface BallParkViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController     *displayController;  //搜索控制器
@property (strong, nonatomic) DownLoadDataSource            *loadData;  //工具类
@property (strong, nonatomic) UISearchBar                   *searchBar;
@property (strong, nonatomic) NSMutableArray                *searchResults;     //存放搜寻结果
@property (strong, nonatomic) NSMutableArray                *historyArr;        //历史记录
@property (strong, nonatomic) CLLocationManager             *manager;           //地图管理类
@property (strong, nonatomic) UITableView                   *tableView;
@property (assign, nonatomic) CGFloat                       latitude;   //纬度；
@property (assign, nonatomic) CGFloat                       longitude;  //经度；
@property (strong, nonatomic) UIView                *seachView;

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
    [super viewDidLoad];
    _latitude = 0;
    _longitude = 0;
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
    
    [self createLocation];
    [self downLoadHistoryData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.barTintColor = GPColor(245, 245, 245);
    _searchBar.placeholder = @"搜索";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:_searchBar];
    
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDelegate   = self;
    _displayController.searchResultsDataSource = self;
    [self createNoseachView];
    
}


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

-(void)pressBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goToAddBallPark{
    
    AddBallParkViewController *VC = [[AddBallParkViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)createLocation{
    
    _latitude = [[userDefaults objectForKey:@"latitude"] floatValue];
    _longitude = [[userDefaults objectForKey:@"longitude"] floatValue];
    [self downloadNowData];

//    if ([CLLocationManager locationServicesEnabled] || [CLLocationManager headingAvailable]) {
//        if (!_manager) {
//            
//            _manager = [[CLLocationManager alloc]init];
//            [_manager requestAlwaysAuthorization];
//            _manager.delegate = self;
//            _manager.distanceFilter = 20;//定位频率
//            _manager.headingFilter = 3;
//            _manager.desiredAccuracy = kCLLocationAccuracyKilometer;//定位精度
//            [_manager requestAlwaysAuthorization];//请求总是允许定位
//            [_manager requestWhenInUseAuthorization];//当用户用的时候就
//            [_manager startUpdatingLocation];//开始更新定位位置
//            [_manager startUpdatingHeading];//开启磁力计
//        }
//    }
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    
//    
//    CLLocation *location = [locations lastObject];
//    CLLocationCoordinate2D coordinate = location.coordinate;
//    _latitude  = coordinate.latitude;
//    _longitude = coordinate.longitude;
//    //    [location requestAlwaysAuthorization];//添加这句
//    
//    float a = coordinate.latitude;
//    float b = coordinate.longitude;
//    NSLog(@"%f,%f",a,b);
//    double x_pi = M_PI * 3000.0 / 180.0;
//    double x = a - 0.0065, y = b - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    _latitude = z * cos(theta);
//    _longitude = z * sin(theta);
//    
//    [self downloadNowData];
//}

-(void)downloadNowData{
    
    if (_dataSouce.count>1) {
        [_tableView reloadData];
    }else{
        
        NSString *lat = [userDefaults objectForKey:@"latitude"];
        NSString *lon = [userDefaults objectForKey:@"longitude"];
        if (!lat) {
            lat = @"0.0";
            lon = @"0.0";
        }
    NSDictionary *parameter = @{
                                @"jingdu":lon,
                                @"weidu":lat
                                };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_qiuchang_all",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            [self.dataSouce removeAllObjects];
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
                
                BallParkSelectModel *model = [BallParkSelectModel paresFromDictionary:temp];
                
                [self.dataSouce addObject:model];
            }
            
            [_tableView reloadData];
        }else{
            NSLog(@"请求错误");
            
        }
    }];
    }
}




#pragma mark ---- 历史记录

-(void)downLoadHistoryData{
    NSDictionary *parameter1 = @{
                                 @"name_id":userDefaultId
                                 };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_qiuchang_history",urlHeader120] parameters:parameter1 complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
                
                BallParkSelectModel *model = [BallParkSelectModel paresFromDictionary:temp];
                int Test = 0;
                for (int i = 0; i<_historyArr.count; i++) {
                    BallParkSelectModel *TestModel = _historyArr[i];
                    if ([model.ballParkID isEqualToString:TestModel.ballParkID]) {
                        Test++;
                    }
                }
                if (Test==0) {
                    [self.historyArr addObject:model];
                }
            }
            [_tableView reloadData];
            
        }else{
            
            NSLog(@"请求错误");
        }
    }];
    
}

/**
 * 定位失败
 */

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        NSLog(@"用户拒绝定位");
    }
    
    [self downloadNowData];
    
}



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
            return _historyArr.count;
        }else{
            return _dataSouce.count;
        }
    }else{

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [_searchResults removeAllObjects];
        
        for (BallParkSelectModel *selectModel in _dataSouce) {

               if ([selectModel.name rangeOfString:_displayController.searchBar.text options:NSCaseInsensitiveSearch].location !=NSNotFound) {

                    [_searchResults addObject:selectModel];
                }
            
        }
        if (!_searchResults.count && _displayController.searchBar.text.length > 0) {
            _seachView.hidden = NO;
            [self.view bringSubviewToFront:_seachView];
        }else{
            _seachView.hidden = YES;
        }
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
            
            [cell relayoutWithModel:_dataSouce[indexPath.row]];
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
            
            _selectPar(_dataSouce[indexPath.row]);
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



@end
