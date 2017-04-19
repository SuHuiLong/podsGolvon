//
//  UserBallParkViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/10/18.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "UserBallParkViewController.h"
#import "GolfersTableViewCell.h"
#import "UserBallParkModel.h"

@interface UserBallParkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)UITableView  *mainTableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;

@end

@implementation UserBallParkViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(238,239,241,1);
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


#pragma mark - CreateView
-(void)createView{
    [self createNavagationView];
    [self createTableView];
}

//创建navagation
-(void)createNavagationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    
    
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"球场列表"];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:titlelabel];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
}

-(void)createTableView{
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView registerClass:[GolfersTableViewCell class] forCellReuseIdentifier:@"GolfersTableViewCell"];
    mainTableView.backgroundColor = GPColor(238, 239, 241);
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
    
}


#pragma mark - initData
-(void)initViewData{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":_name_id
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=usercourses",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _dataArray = [NSMutableArray array];
                NSDictionary *homecourse = [data objectForKey:@"homecourse"];
                if (![homecourse isKindOfClass:[NSArray class]]) {
                    UserBallParkModel *model = [UserBallParkModel modelWithDictionary:homecourse];
                    model.title = @"我的主场";
                    NSArray *homecourseArray = @[model];
                    [_dataArray addObject:homecourseArray];
                }
                
                
                NSDictionary *cityArrayDict = [data objectForKey:@"data"];
                if (![cityArrayDict isKindOfClass:[NSArray class]]) {
                NSArray *cityNameAray = [cityArrayDict allKeys];
                for (int i = 0; i<cityNameAray.count; i++) {
                    NSMutableArray *cityModelArray= [NSMutableArray array];
                    NSArray *cityDictArray = [cityArrayDict objectForKey:cityNameAray[i]];
                    for (NSDictionary *parkDict in cityDictArray) {
                        UserBallParkModel *model = [UserBallParkModel modelWithDictionary:parkDict];
                        model.title = cityNameAray[i];
                        [cityModelArray addObject:model];
                    }
                    [_dataArray addObject:cityModelArray];
                }
            }
                
            }

            [_mainTableView reloadData];
        }
    }];
    
}



//-(void)initData{
//    _dataArray = [NSMutableArray array];
//    for (int i = 0; i<5; i++) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (int j = 0; j<5; j++) {
//            NSDictionary *dict = @{
//                                   @"image":[userDefaults objectForKey:@"pic"],
//                                   @"name":[NSString stringWithFormat:@"%d",100+i+10*j],
//                                   @"section":[NSString stringWithFormat:@"%d",i]
//                                   };
//            [array addObject:dict];
//        }
//        [_dataArray addObject:array];
//    }
//
//}

#pragma mark - Action

-(void)leftBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Deleate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *indexSectionNum = _dataArray[section];
    return indexSectionNum.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(45);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GolfersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GolfersTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserBallParkModel *model = _dataArray[indexPath.section][indexPath.row];
    
    [cell configParkModel:model];
    
    return cell;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:GPColor(238, 239, 241) frame:CGRectMake(0, 0, ScreenWidth, kHvertical(30))];
    UserBallParkModel *model = _dataArray[section][0];
    
    NSString *titleStr = model.title;
    
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), 0, ScreenWidth/2, kHvertical(30)) textColor:BlackColor fontSize:kHorizontal(13.0f) Title:titleStr];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
