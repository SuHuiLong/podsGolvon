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
@property(nonatomic,strong)NSMutableArray  *DataArry;
@end

@implementation TotalPhotoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    _DataArry = [NSMutableArray array];
    [super viewDidLoad];
}
-(void)createView{
    [self createNavigationView];
    [self createTableView];
    
}

//创建上导航
-(void)createNavigationView{
    UserTopNavigation *vc = [[UserTopNavigation alloc] init];
    
    
    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(60), kHvertical(14.5))  textColor:BlackColor fontSize:kHorizontal(15) Title:@"取消"];
    
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
    
    dispatch_queue_t concurrentQueue =  dispatch_queue_create("com.podsGolvon", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        //获取单个分组
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group!=nil) {
                //获取相册中一共的资源数量
                NSInteger count = [group numberOfAssets];
                NSString *total = [NSString stringWithFormat:@"%ld",(long)count];
                //获取相册的封面图片
                CGImageRef poster = [group posterImage];
                UIImage *headerImage = [UIImage imageWithCGImage:poster];
                //相册名
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                
                TotalPhotoModel *model = [[TotalPhotoModel alloc] init];
                model.headerImage = headerImage;
                model.libName = name;
                model.totalNum = total;
                if (count!=0) {
                    [_DataArry addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mainTableView reloadData];
                });
            }
        };
        //获取相册所有数据
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:nil];
    });
}


#pragma mark - 点击事件
//返回
-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *nameArray = [_totalDateDict allKeys];
    return _DataArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHvertical(53.5);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TotalPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentfier];

    if (cell == nil) {
        cell = [[TotalPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
    }
    TotalPhotoModel *indexModel = _DataArry[indexPath.row];
    [cell configModel:indexModel];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoicePhotoViewController *vc = [[ChoicePhotoViewController alloc] init];
    TotalPhotoModel *model = _DataArry[indexPath.item];
    vc.titleStr = model.libName;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
