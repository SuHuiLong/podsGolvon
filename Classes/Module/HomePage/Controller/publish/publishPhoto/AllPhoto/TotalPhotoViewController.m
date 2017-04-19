//
//  TotalPhotoViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "TotalPhotoViewController.h"
#import "TotalPhotoCell.h"
#import "TotalPhotoModel.h"

#import "ChoicePhotoViewController.h"

static NSString *indentfier = @"TotalPhotoIndentfier";

@interface TotalPhotoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_mainTableView;
}
@property(nonatomic,strong)NSMutableArray  *viewArry;
@end

@implementation TotalPhotoViewController

- (void)viewDidLoad {
    _viewArry = [NSMutableArray array];
    [super viewDidLoad];
}
-(void)createView{
    [self createNavigationView];
    [self createTableView];
    
}

//创建上导航
-(void)createNavigationView{
    UserTopNavigation *vc = [[UserTopNavigation alloc] init];
    
    
    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(30), kHvertical(14.5))  textColor:BlackColor fontSize:kHorizontal(15) Title:@"取消"];
    
    [vc.rightBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    [vc createRightWithImage:sendLabel];
    [vc createTitleWith:@"照片"];
    [self.view addSubview:vc];
}

//创建tableView
-(void)createTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[TotalPhotoCell class] forCellReuseIdentifier:indentfier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView = tableView;
}


-(void)initData{
    NSArray *nameArray = [_totalDateDict allKeys];
    for (int i = 0 ; i<nameArray.count; i++) {
        NSArray *indexArry = [_totalDateDict objectForKey:nameArray[i]];
        TotalPhotoModel *model = [[TotalPhotoModel alloc] init];
        if (indexArry.count == 0) {
            indexArry = @[model];
        }else{
            
            model = indexArry[0];
            model.totalNum = [NSString stringWithFormat:@"%ld",(long)indexArry.count];
        }
        [_viewArry addObject:model];
    }
    [_mainTableView reloadData];
}


#pragma mark - 点击事件
//返回
-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *nameArray = [_totalDateDict allKeys];
    return nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHvertical(53.5);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TotalPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentfier];

    if (cell == nil) {
        cell = [[TotalPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
    }
    TotalPhotoModel *indexModel = _viewArry[indexPath.row];
    [cell configModel:indexModel];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoicePhotoViewController *vc = [[ChoicePhotoViewController alloc] init];
    NSArray *nameArray = [_totalDateDict allKeys];
    NSMutableArray *indexArry = [_totalDateDict objectForKey:nameArray[indexPath.row]];
    TotalPhotoModel *model = indexArry[0];
    [indexArry insertObject:@"PublishCamera" atIndex:0];
    vc.dataArray = indexArry;
    vc.logInType = @"1";
    vc.titleStr = model.libName;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
