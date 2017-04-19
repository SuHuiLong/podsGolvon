//
//  Follow_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/2.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Follow_ViewController.h"
#import "DownLoadDataSource.h"
#import "JPUSHService.h"
#import "Massage_TableViewCell.h"
#import "DZ_ViewController.h"
#import "HF_ViewController.h"
#import "XT_ViewController.h"

@interface Follow_ViewController()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)DownLoadDataSource *loadData;

@property (copy, nonatomic)NSString *pingUnread;
@property (copy, nonatomic)NSString *zanUnread;
@property (copy, nonatomic)NSString *xitongUnread;
@property (copy, nonatomic)NSString *unview;
@end

@implementation Follow_ViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadUnviewData];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.pingUnread = 0;
    self.zanUnread = 0;
    [self createUI];
    
    [self createNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUnreadData:) name:@"reloadUnreadData" object:nil];
}

-(void)reloadUnreadData:(NSNotification *)noti{
    [self loadUnviewData];
}
-(void)createNav{
    
    self.navigationItem.title = @"消息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
}
-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)createUI{
    
    UIView *back = [[UIView alloc]init];
    back.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    back.frame = CGRectMake(0, 0, ScreenWidth, HScale(1));
    [self.view addSubview:back];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.rowHeight = ScreenHeight * 0.123;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.backgroundColor = [UIColor colorWithRed:245.0f/256.0f green:245.0f/256.0f blue:245.0f/256.0f alpha:1];
    _tableView.tableHeaderView = back;
    [self.view addSubview:_tableView];
}
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [SucessView new];
    sView.frame = CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8));
    sView.imageName = @"失败";
    sView.descStr = str;
    [sView didFaild];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
#pragma mark ---- 请求未读数据
-(void)loadUnviewData{
    NSDictionary *parameter = @{@"name_id":userDefaultId};
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=unreadinfo",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            weakself.pingUnread = [NSString stringWithFormat:@"%@",data[@"commet"]];
            weakself.zanUnread = [NSString stringWithFormat:@"%@",data[@"clicks"]];
            weakself.xitongUnread = data[@"sysmsgs"];
            [userDefaults setValue:self.unview forKey:@"allRead"];
            
            [weakself.tableView reloadData];
        }
    }];
}

#pragma mark ---- 更新未读评论状态数据
-(void)requUnreadComment{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=setreadcommets",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            if ([data[@"code"] isEqualToString:@"0"]) {
                
                weakself.pingUnread = @"0";
                [weakself loadUnviewData];
            }else{
//                NSLog(@"评论更新失败");
                [weakself alertShowView:@"网络错误"];
            }
        }
        [weakself.tableView reloadData];
    }];
}
#pragma mark ---- 更新未读点赞状态数据
-(void)requUnreadZan{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=setreadclicks",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            if ([data[@"code"] isEqualToString:@"0"]) {
                weakself.zanUnread = @"0";
                [weakself loadUnviewData];
            }else{

            }
        }
        [weakself.tableView reloadData];
    }];
}
#pragma mark ---- 更新未读状系统态数据
-(void)requUnreadSystem{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{@"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@msgapi.php?func=setreadsysmsgs",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            if ([data[@"code"] isEqualToString:@"0"]) {
                
                weakself.xitongUnread = @"0";
                [weakself loadUnviewData];
            }else{
                
//                NSLog(@"系统更新失败");
            }
            
        }
        [weakself.tableView reloadData];
    }];
}

#pragma mark ----- UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Massage_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Massage_TableViewCell"];
    
    if (cell == nil) {
        cell = [[Massage_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Massage_TableViewCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.unread.hidden = YES
        ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        if ([_pingUnread isEqualToString:@"0"]) {
            
            cell.unread.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.unread.hidden = NO;
            [cell relayoutDataWithImage:@"comment(message)" AndWithTitle:@"评论" AndWithUnread:
             _pingUnread];
        }
    }else if (indexPath.row == 1){
        if ([_zanUnread isEqualToString:@"0"]) {
            
            cell.unread.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.unread.hidden = NO;
            [cell relayoutDataWithImage:@"likeIcon(message)" AndWithTitle:@"点赞" AndWithUnread:_zanUnread];
        }
    }else if (indexPath.row == 2){
        if ([_xitongUnread isEqualToString:@"0"]) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(12.3)-0.5, ScreenWidth, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:lineView];
            
            cell.unread.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.unread.hidden = NO;
            [cell relayoutDataWithImage:@"system(message)" AndWithTitle:@"系统" AndWithUnread:_xitongUnread];
        }
    }
    NSInteger unReadNum = [_zanUnread integerValue] + [_pingUnread integerValue] + + [_xitongUnread integerValue];
    [JPUSHService setBadge:unReadNum];
    [UIApplication sharedApplication].applicationIconBadgeNumber=unReadNum;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HF_ViewController *huifu = [[HF_ViewController alloc]init];
        huifu.hidesBottomBarWhenPushed = YES;
        [self requUnreadComment];
        [self.navigationController pushViewController:huifu animated:YES];
    }else if (indexPath.row == 1){
        
        DZ_ViewController *dianzan = [[DZ_ViewController alloc]init];
        dianzan.hidesBottomBarWhenPushed = YES;
        [self requUnreadZan];
        [self.navigationController pushViewController:dianzan animated:YES];
    }else if (indexPath.row == 2){
        XT_ViewController *xitong = [[XT_ViewController alloc]init];
        xitong.hidesBottomBarWhenPushed = YES;
        [self requUnreadSystem];
        [self.navigationController pushViewController:xitong animated:YES];
    }
}

@end
