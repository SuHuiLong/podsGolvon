//
//  ActivityViewController.m
//  FindModule
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ActivityViewController.h"
#import "InterviewTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "InterviewDetileViewController.h"
#import "ChildCompetionData.h"
#import "CountDown.h"
#import "TimeTool.h"

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate,LikeDelegate>

@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, strong) DownLoadDataSource   *loadData;
@property (nonatomic, strong) NSMutableArray   *activityDataArr;
@property (nonatomic, strong) NSMutableArray   *endTimeArr;
@property (nonatomic, strong) CountDown   *countDown;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger allPage;
@property (nonatomic, assign) NSInteger viewNum;
@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, strong) MBProgressHUD   *HUD;
@property (nonatomic, strong) UIView   *placeView;


@end

static NSString *activityCellID = @"ActivityTableViewCell";
@implementation ActivityViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)activityDataArr{
    if (!_activityDataArr) {
        _activityDataArr = [NSMutableArray array];
    }
    return _activityDataArr;
}
-(NSMutableArray *)endTimeArr{
    if (!_endTimeArr) {
        _endTimeArr = [NSMutableArray array];
    }
    return _endTimeArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBarHidden = YES;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestActivityData];
    [self createUI];
    _currentPage = 0;
    _allPage = 0;
    _viewNum = 0;
    _currentRow = 0;
    if ([_type isEqualToString:@"4"]) {
        
        self.countDown = [[CountDown alloc] init];
        __weak typeof(self) weakself = self;
        [self.countDown countDownWithPER_SECBlock:^{
            [weakself updateTimeInVisibleCells];
        }];

    }
}
-(void)createUI{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108 - 49)];
    _tableview.rowHeight = kHvertical(257);
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    _tableview.separatorStyle = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[InterviewTableViewCell class] forCellReuseIdentifier:activityCellID];
    [self.view addSubview:_tableview];
    
    MJRefreshBackFooter *footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(activityFooterRefresh)];
    self.tableview.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestActivityData)];
    self.tableview.mj_header = header;
}
-(void)createProgress{
    
    _placeView = [[UIView alloc] init];
    _placeView.backgroundColor = [UIColor whiteColor];
    _placeView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
    [self.view addSubview:_placeView];
    
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
    
}
#pragma mark ---- loadData
-(void)requestActivityData{
    
    if (_activityDataArr.count>0) {
        _HUD = nil;
        [_placeView removeFromSuperview];
    }else{
        [self createProgress];
    }
    
    NSDictionary *parameters = @{
                                 @"page":@(0),
                                 @"type":_type,
                                 @"uid":userDefaultUid
                                 };

    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=gettypeall",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_header endRefreshing];
        if (success) {
            [self.endTimeArr removeAllObjects];
            [self.activityDataArr removeAllObjects];
            NSArray *tempArr = data[@"data"];
            _allPage = [data[@"pagenum"] integerValue];
            for (NSInteger i = 0; i<[tempArr count]; i++) {
                ChildCompetionData *model = [ChildCompetionData modelWithDictionary:tempArr[i]];
                [self.endTimeArr addObject:tempArr[i][@"endts"]];
                [self.activityDataArr addObject:model];
            }
        }
        [_tableview reloadData];
    }];
}
-(void)activityFooterRefresh{
    _currentPage++;
    if (_currentPage>_allPage) {
        _currentPage--;
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSDictionary *parameters = @{
                                 @"page":@(_currentPage),
                                 @"type":_type,
                                 @"uid":userDefaultUid
                                 };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=gettypeall",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_footer endRefreshing];
        if (success) {
            NSArray *tempArr = data[@"data"];
            for (NSInteger i = 0; i<[tempArr count]; i++) {
                ChildCompetionData *model = [ChildCompetionData modelWithDictionary:tempArr[i]];
                [self.endTimeArr addObject:tempArr[i][@"endts"]];
                [self.activityDataArr addObject:model];
            }
        }
        [_tableview reloadData];
    }];

}
#pragma mark ---- 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _activityDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_type isEqualToString:@"4"]) {
        
        cell.temp.text = [self getNowTimeWithString:self.endTimeArr[indexPath.row]];
        [cell.temp sizeToFit];
        cell.tag = indexPath.row;
        
        cell.visitorLabel.text = cell.temp.text;
        cell.groundImage.frame = CGRectMake(ScreenWidth - cell.temp.width - 4 - kWvertical(24), 0, cell.temp.width+4+kWvertical(24), kHvertical(18));
        cell.visitorImage.frame = CGRectMake(8, kHvertical(4), kWvertical(11), kWvertical(11));
        cell.visitorLabel.frame = CGRectMake(cell.visitorImage.right+4, 0, cell.temp.width, kHvertical(18));
        [cell relayoutActivityDataWithModel:self.activityDataArr[indexPath.row]];

    }else{
        
        [cell relayoutOtherviewDataWithModel:self.activityDataArr[indexPath.row]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_joinstatr isEqualToString:@"1"]) {
        
        ChildCompetionData *model = self.activityDataArr[indexPath.row];
        ActivityDetailViewController *VC = [[ActivityDetailViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.titleStr = model.title;
        VC.addTimeStr = model.addts;
        VC.maskPic = model.pic;
        VC.ID = model.ID;
        VC.readStr = model.readnum;
        VC.htmlStr = model.url;
        __weak typeof(self) weakself = self;
        [VC setBlock:^(BOOL isVision) {
            weakself.viewNum = [model.readnum integerValue];
            weakself.viewNum++;
            model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewNum];
            [weakself.tableview reloadData];
        }];
        VC.endTimeStr = [self getNowTimeWithString:self.endTimeArr[indexPath.row]];
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        ChildCompetionData *model = self.activityDataArr[indexPath.row];
        InterviewDetileViewController *VC = [[InterviewDetileViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.titleStr = model.title;
        VC.addTimeStr = model.addts;
        VC.readStr = model.readnum;
        VC.likeStr = model.clikenum;
        VC.ID = model.ID;
        VC.type = self.type;
        VC.htmlStr = model.url;
        VC.isLike = model.likestatr;
        VC.maskPic = model.pic;
        VC.likeDelegate = self;
        __weak typeof(self) weakself = self;
        [VC setBlock:^(BOOL isView) {
            weakself.viewNum = [model.readnum integerValue];
            weakself.viewNum ++;
            model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewNum];
            [weakself.tableview reloadData];
        }];
        _currentRow = indexPath.row;
        [self.navigationController pushViewController:VC animated:YES];

    }
}
-(void)likeBtnSelected:(BOOL)isSelected withLikeNum:(NSString *)likenum{
    ChildCompetionData *model = self.activityDataArr[_currentRow];
    model.clikenum = likenum;
    model.likestatr = isSelected;
    [self.tableview reloadRow:_currentRow inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ---- countDown

-(void)updateTimeInVisibleCells{
    NSArray *cells = self.tableview.visibleCells;
    for (InterviewTableViewCell *cell in cells) {
        cell.temp.text = [self getNowTimeWithString:self.endTimeArr[cell.tag]];
        [cell.temp sizeToFit];
        
        cell.visitorLabel.text = cell.temp.text;
        cell.groundImage.frame = CGRectMake(ScreenWidth - cell.temp.width - 4 - kWvertical(24), 0, cell.temp.width+4+kWvertical(24), kHvertical(18));
        cell.visitorImage.frame = CGRectMake(8, kHvertical(4), kWvertical(11), kWvertical(11));
        cell.visitorLabel.frame = CGRectMake(cell.visitorImage.right+4, 0, cell.temp.width, kHvertical(18));
    }
}

-(NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [TimeTool getNowDateFromatAnDate:[formater dateFromString:aTimeString]];

    // 当前时间字符串格式
    NSDate  *nowDate = [NSDate date];
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [TimeTool getNowDateFromatAnDate:[formater dateFromString:nowDateStr]];
    
    
    NSString *nowTime = [TimeTool string_TimeTransformToTimestamp:nowDateStr withType:2];
    NSString *entTime = [TimeTool string_TimeTransformToTimestamp:aTimeString withType:2];
    
    if ([entTime intValue] < [nowTime intValue]) {
        return @"活动已经结束！";
    }else{
        
        NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
        int days = (int)(timeInterval/(3600*24));
        int hours = (int)((timeInterval-days*24*3600)/3600);
        int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
        int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
        
        NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
        
        //天
        dayStr = [NSString stringWithFormat:@"%d",days];
        //小时
        hoursStr = [NSString stringWithFormat:@"%d",hours];
        //分钟
        if(minutes<10)
            minutesStr = [NSString stringWithFormat:@"0%d",minutes];
        else
            minutesStr = [NSString stringWithFormat:@"%d",minutes];
        //秒
        if(seconds < 10)
            secondsStr = [NSString stringWithFormat:@"0%d", seconds];
        else
            secondsStr = [NSString stringWithFormat:@"%d",seconds];
        if (hours<=0&&minutes<=0&&seconds<=0&&days<=0) {
            return @"活动已经结束！";
            
        }
        if (days) {
            return [NSString stringWithFormat:@"%@天%@小时%@分%@秒", dayStr,hoursStr, minutesStr,secondsStr];
        }
        return [NSString stringWithFormat:@"%@小时%@分%@秒",hoursStr , minutesStr,secondsStr];
        

    }
    
}
-(NSInteger)getDayNumberWithYear:(NSInteger )y month:(NSInteger )m{
    int days[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if (2 == m && 0 == (y % 4) && (0 != (y % 100) || 0 == (y % 400))) {
        days[1] = 29;
    }
    return (days[m - 1]);
}
@end
