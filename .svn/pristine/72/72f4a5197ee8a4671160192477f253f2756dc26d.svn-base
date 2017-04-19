



//
//  PublishSelectAddressViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishSelectAddressViewController.h"
#import "BallParkTableViewCell.h"

static NSString *history = @"history";

@interface PublishSelectAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController     *displayController;  //搜索控制器
@property (strong, nonatomic) DownLoadDataSource            *loadData;  //工具类
@property (strong, nonatomic) UISearchBar                   *searchBar;
@property (strong, nonatomic) NSMutableArray                *searchResults;     //存放搜寻结果
@property (strong, nonatomic) UITableView                   *tableView;
@property (strong, nonatomic) UIView                    *seachView;

@end

@implementation PublishSelectAddressViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResults = [@[] mutableCopy];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *locationCity = [userDefaults objectForKey:@"locationCity"];
    if (locationCity) {
        [_dataSouce insertObject:locationCity atIndex:0];
    }
    [_dataSouce insertObject:@"不显示地点" atIndex:0];
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    leftBarbutton.tintColor = GPColor(0, 0, 0);
    [leftBarbutton setImage:[UIImage imageNamed:@"多人操作返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    self.title = @"选择地点";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.barTintColor = GPColor(245, 245, 245);
    _searchBar.placeholder = @"搜索附近球场";
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
//返回
-(void)pressBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableview代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = GPColor(245, 245, 245);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 200, HScale(2.3))];
    label.textColor = GPColor(123, 123, 123);
    label.font = [UIFont systemFontOfSize:kHorizontal(13)];
    label.textAlignment = NSTextAlignmentCenter;
    if (tableView == _tableView) {
        label.text = @"附近地点";
        [label sizeToFit];
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
            return _dataSouce.count;
    }else{
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [_searchResults removeAllObjects];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:_dataSouce];
        [dataArray removeObjectAtIndex:0];
        [dataArray removeObjectAtIndex:0];
        
        for (BallParkSelectModel *selectModel in dataArray) {
            
            BOOL isContain = [selectModel.name containsString:_displayController.searchBar.text];
            
            if (isContain) {
                
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
    [cell.Backview removeFromSuperview];
    cell.ballParkName.frame = CGRectMake(10, HScale(2.3), ScreenWidth - WScale(14), HScale(2.7));

    if (tableView == _tableView) {
        
            [cell relayoutWithOldModel:_dataSouce[indexPath.row]];
    }else{
        
        [cell relayoutWithOldModel:_searchResults[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        
        
        _selectAddress(_dataSouce[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (tableView == _displayController.searchResultsTableView){
        
        [_displayController.searchBar resignFirstResponder];
        [_displayController setActive:NO animated:YES];
        
        _selectAddress(_searchResults[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.contentInset = UIEdgeInsetsZero;
    tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}



@end
