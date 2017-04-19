//
//  RecommendViewController.m
//  FindModule
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecomentTableViewCell.h"
#import "RecomentOtherCell.h"
#import "RecomentInterviewCell.h"

#import "SDCycleScrollView.h"
#import "BannerModel.h"
#import "UserDetailViewController.h"

#import "RecomInformModel.h"
#import "RecomInteModel.h"
#import "ChildRecomModel.h"
#import "ActivityDetailViewController.h"

#import "InterviewDetileViewController.h"
#import "CountDown.h"

@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LikeDelegate>
@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, strong) SDCycleScrollView   *bannerView;
@property (nonatomic, strong) DownLoadDataSource   *loadData;
@property (nonatomic, strong) NSMutableArray   *bannerArr;
@property (nonatomic, strong) NSMutableArray   *bannerIDArr;
@property (nonatomic, strong) NSMutableArray   *recomentDataArr;
@property (nonatomic, strong) NSMutableArray   *inteDataArr;
@property (nonatomic, strong) NSMutableArray   *informationDataArr;
@property (nonatomic, strong) NSMutableArray   *endTimeArr;
@property (nonatomic, assign) NSInteger viewStr;
@property (nonatomic, assign) NSInteger allPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger interviewReadnum;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger dataArrCount;
@property (nonatomic, strong) CountDown   *countDown;
@property (nonatomic, strong) MBProgressHUD   *HUD;
@property (nonatomic, strong) UIView   *placeView;

@end
static NSString *cellID = @"RecomentTableViewCell";
static NSString *interViewID = @"RecomentInterviewCell";
static NSString *saiID = @"saiID";
static NSString *huoID = @"huoID";
static NSString *lvID = @"lvID";

@implementation RecommendViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)endTimeArr{
    if (!_endTimeArr) {
        _endTimeArr = [NSMutableArray array];
    }
    return _endTimeArr;
}
-(NSMutableArray *)recomentDataArr{
    if (!_recomentDataArr) {
        _recomentDataArr = [NSMutableArray array];
    }
    return _recomentDataArr;
}
-(NSMutableArray *)inteDataArr{
    if (!_inteDataArr) {
        _inteDataArr = [NSMutableArray array];
    }
    return _inteDataArr;
}
-(NSMutableArray *)informationDataArr{
    if (!_informationDataArr) {
        _informationDataArr = [NSMutableArray array];
    }
    return _informationDataArr;
}
-(NSMutableArray *)bannerIDArr{
    if (!_bannerIDArr) {
        _bannerIDArr = [NSMutableArray array];
    }
    return _bannerIDArr;
}
-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _currentPage = 0;
    _allPage = 0;
    _viewStr = 0;
    _interviewReadnum = 0;
    _currentIndex = 0;
    _dataArrCount = 0;
    [self requestBannerData];
    [self createTableview];
    [self requestRecomentData];
}

#pragma mark ---- UI
-(void)createBanner{
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(169)) delegate:self placeholderImage:nil];
    _bannerView.backgroundColor = WhiteColor;
//    [UIImage imageNamed:@"发现专访默认图"
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.currentPageDotColor = localColor;
}
-(void)createTableview{
    [self createBanner];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64-44) style:UITableViewStylePlain];
    _tableview.tableHeaderView = _bannerView;
    [_tableview registerClass:[RecomentTableViewCell class] forCellReuseIdentifier:cellID];
    [_tableview registerClass:[RecomentInterviewCell class] forCellReuseIdentifier:interViewID];
    [_tableview registerClass:[RecomentOtherCell class] forCellReuseIdentifier:saiID];
    [_tableview registerClass:[RecomentOtherCell class] forCellReuseIdentifier:huoID];
    [_tableview registerClass:[RecomentOtherCell class] forCellReuseIdentifier:lvID];

    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview setDelegate:self];
    [self.tableview setDataSource:self];
    [self.view addSubview:_tableview];
    
    MJRefreshBackFooter *footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(recommentFooterRefresh)];
    self.tableview.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestRecomentData)];
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
#pragma mark ---- LoadData
-(void)requestRecomentData{
    
    if (_inteDataArr.count > 0) {
        _HUD = nil;
        [_placeView removeFromSuperview];
    }else{
        [self createProgress];
    }
    [self requestBannerData];
    NSDictionary *parameters = @{
                                 @"page":@(0),
                                 @"type":_type,
                                 @"uid":userDefaultUid
                                 };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=gettypeall",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_header endRefreshing];
        if (success) {
            _HUD = nil;
            [_placeView removeFromSuperview];
            [_informationDataArr removeAllObjects];
            [_inteDataArr removeAllObjects];
            [_endTimeArr removeAllObjects];
            [_recomentDataArr removeAllObjects];
            NSDictionary *tempArr = data;
            NSDictionary *inforDic = tempArr[@"information"];
            _allPage = [tempArr[@"pagenum"] integerValue];
            RecomInformModel *informationModel = [RecomInformModel modelAddDictionary:inforDic];
            [self.informationDataArr addObject:informationModel];
            for (NSDictionary *tempDic in tempArr[@"inte"]) {
                RecomInteModel *inteModel = [RecomInteModel modelAddDictionary:tempDic];
                [self.inteDataArr addObject:inteModel];
            }
            NSArray *arr =  tempArr[@"recommend"];
            for (NSInteger i = 0; i< arr.count; i++) {
                ChildRecomModel *recommentModel = [ChildRecomModel modelAddDictionary:arr[i]];
                [self.endTimeArr addObject:recommentModel.endts];
                [self.recomentDataArr addObject:recommentModel];
                if ([recommentModel.type isEqualToString:@"4"]) {
                    self.countDown = [[CountDown alloc] init];
                    __weak typeof(self) weakself = self;
                    [self.countDown countDownWithPER_SECBlock:^{
                        [weakself updateTimeInVisibleCells];
                    }];
                }
            }
            _dataArrCount = self.recomentDataArr.count;
            [_tableview reloadData];
        }
    }];
}

-(void)recommentFooterRefresh{
    _currentPage++;
    if (_currentPage>_allPage) {
        _currentPage--;
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSDictionary *parameters = @{@"page":@(_currentPage),
                                 @"type":_type,
                                 @"uid":userDefaultUid};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=gettypeall",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        [self.tableview.mj_footer endRefreshing];
        if (success) {
            NSDictionary *tempArr = data;
            NSDictionary *inforDic = tempArr[@"information"];
            RecomInformModel *informationModel = [RecomInformModel modelAddDictionary:inforDic];
            [self.informationDataArr addObject:informationModel];
            
            for (NSDictionary *tempDic in tempArr[@"inte"]) {
                
                RecomInteModel *inteModel = [RecomInteModel modelAddDictionary:tempDic];
                [self.inteDataArr addObject:inteModel];
            }
            NSArray *arr =  tempArr[@"recommend"];
            for (NSInteger i = 0; i< arr.count; i++) {
                ChildRecomModel *recommentModel = [ChildRecomModel modelAddDictionary:arr[i]];
                [self.endTimeArr addObject:recommentModel.endts];
                [self.recomentDataArr addObject:recommentModel];
            }
            
            [_tableview reloadData];
        }
    }];

}
//获取tableview数据
-(void)requestTableViewDataWithPage:(NSInteger)page{
    
    
    

}

//获取轮播图数据
-(void)requestBannerData{
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_advertisement",urlHeader120] parameters:nil complicate:^(BOOL success, id data) {
        if (success) {
            self.bannerArr = [NSMutableArray array];
            self.bannerIDArr = [NSMutableArray array];
            NSArray *tempArr = data[@"data"];
            for (NSDictionary *tempDic in tempArr) {
                BannerModel *model = [BannerModel modelWithDictionary:tempDic];
                [self.bannerArr addObject:model.picture_url];
                [self.bannerIDArr addObject:model.advertisement_url];
            }
            _bannerView.imageURLStringsGroup = self.bannerArr;
        }
    }];
}

#pragma mark ---- 点击事件
-(void)clickToVC:(NSInteger)tag{
    
    RecomInteModel *model = self.inteDataArr[tag];
    InterviewDetileViewController *VC = [[InterviewDetileViewController alloc] init];
    VC.type = @"2";
    VC.htmlStr = model.url;
    VC.maskPic = model.pic;
    VC.ID = model.vid;
    VC.readStr = model.readnum;
    VC.likeStr = model.clikenum;
    VC.titleStr = model.title;
    VC.addTimeStr = model.time;
    VC.isLike = model.likestatr;
//    VC.likeDelegate = self;
    _currentIndex = tag;
    __weak typeof(self) weakself = self;
    [VC setBlock:^(BOOL isView) {
        
        weakself.viewStr = [model.readnum integerValue];
        weakself.viewStr ++;
        model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewStr];
        [weakself.tableview reloadData];

    }];
    self.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---- UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_informationDataArr.count>0) {
        return 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.recomentDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(5);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return kHvertical(60);
            break;
        case 1:
            return kHvertical(238);
            break;
            
        default:
            return kHvertical(297);
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RecomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell relayoutDataWithModel:self.informationDataArr[0]];
        return cell;

    }else if (indexPath.section == 1){
        
        RecomentInterviewCell *interCell = [tableView dequeueReusableCellWithIdentifier:interViewID forIndexPath:indexPath];

        interCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [interCell relayoutDataWithArr:self.inteDataArr];
        
        [interCell setBlock:^(NSInteger tag) {
            [self clickToVC:tag];
        }];
        return interCell;
        
    }else if(indexPath.section ==  _dataArrCount+1){
        
        RecomentOtherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:lvID forIndexPath:indexPath];
        otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [otherCell relyoutDataWithModel:self.recomentDataArr[_dataArrCount-1]];
        otherCell.tempLabel.text = [self getNowTimeWithString:self.endTimeArr[_dataArrCount-1]];
        [otherCell.tempLabel sizeToFit];

        otherCell.timeLabel.text = otherCell.tempLabel.text;
        otherCell.timeIcon.image = [UIImage imageNamed:@"findTimeIcon"];
        otherCell.timegroundView.frame = CGRectMake(ScreenWidth - otherCell.tempLabel.width - 4 - kWvertical(24), otherCell.typeLabel.bottom, otherCell.tempLabel.width+4+kWvertical(24), kHvertical(18));
        otherCell.timeIcon.frame = CGRectMake(8, kHvertical(4), kWvertical(11), kWvertical(11));
        otherCell.timeLabel.frame = CGRectMake(otherCell.timeIcon.right+4, 0, otherCell.tempLabel.width, kHvertical(18));
        return otherCell;
    }else{
//        else if (indexPath.section == 2){
        
            RecomentOtherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:saiID forIndexPath:indexPath];
            otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [otherCell relyoutDataWithModel:self.recomentDataArr[indexPath.section-2]];
            
            return otherCell;
//        }else if (indexPath.section == 3){
//            
//            RecomentOtherCell *other = [tableView dequeueReusableCellWithIdentifier:huoID forIndexPath:indexPath];
//            other.selectionStyle = UITableViewCellSelectionStyleNone;
//            [other relyoutDataWithModel:self.recomentDataArr[1]];
//            
//            return other;
//            
//        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        RecomInformModel *model = self.informationDataArr[0];
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
        _currentIndex = indexPath.section;

        __weak typeof(self) weakself = self;
        [VC setBlock:^(BOOL isView) {
            weakself.viewStr = [model.readnum integerValue];
            weakself.viewStr ++;
            model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewStr];
            [weakself.tableview reloadData];
        }];

        [self.navigationController pushViewController:VC animated:YES];

        
    }else if (indexPath.section == 1){
        return;
    }else if (indexPath.section == _dataArrCount+1){
        
        ChildRecomModel *model = self.recomentDataArr[indexPath.section-2];
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
            
            weakself.viewStr = [model.readnum integerValue];
            weakself.viewStr ++;
            model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewStr];
            [weakself.tableview reloadData];

        }];
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        
        ChildRecomModel *model = self.recomentDataArr[indexPath.section-2];
        InterviewDetileViewController *VC = [[InterviewDetileViewController alloc] init];
        VC.type = model.type;
        VC.htmlStr = model.url;
        VC.titleStr = model.title;
        VC.addTimeStr = model.addts;
        VC.likeStr = model.clikenum;
        VC.isLike = model.likestatr;
        VC.ID = model.ID;
        VC.readStr = model.readnum;
        VC.maskPic = model.pic;
        VC.hidesBottomBarWhenPushed = YES;
        __weak typeof(self) weakself = self;
        [VC setBlock:^(BOOL isView) {
            
            weakself.viewStr = [model.readnum integerValue];
            weakself.viewStr ++;
            model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewStr];
            [weakself.tableview reloadData];
        }];
        
        [self.navigationController pushViewController:VC animated:YES];
    }
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark ---- bannerDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *url = self.bannerIDArr[index];
    UserDetailViewController *VC = [[UserDetailViewController alloc] init];
    VC.urlStr = url;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];

}


#pragma mark ---- countDown
-(void)updateTimeInVisibleCells{
    NSArray *cells = [self.tableview visibleCells];

    for (RecomentOtherCell *cell in cells) {
        
        NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
        
        if (indexPath.section == 4) {
            
            cell.tempLabel.text = [self getNowTimeWithString:self.endTimeArr[_dataArrCount-1]];
            [cell.tempLabel sizeToFit];
            
            cell.timeLabel.text = cell.tempLabel.text;
            cell.timegroundView.frame = CGRectMake(ScreenWidth - cell.tempLabel.width - 4 - kWvertical(24), cell.typeLabel.bottom, cell.tempLabel.width+4+kWvertical(24), kHvertical(18));
            cell.timeIcon.frame = CGRectMake(8, kHvertical(4), kWvertical(11), kWvertical(11));
            cell.timeLabel.frame = CGRectMake(cell.timeIcon.right+4, 0, cell.tempLabel.width, kHvertical(18));
        }
    }
    
}
-(NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
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
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"活动已经结束！";
    }
    if (days) {
        return [NSString stringWithFormat:@"%@天%@小时%@分%@秒", dayStr,hoursStr, minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"%@小时%@分%@秒",hoursStr , minutesStr,secondsStr];
    
    
}

-(NSInteger)getDayNumberWithYear:(NSInteger )y month:(NSInteger )m{
    int days[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if (2 == m && 0 == (y % 4) && (0 != (y % 100) || 0 == (y % 400))) {
        days[1] = 29;
    }
    return (days[m - 1]);
}

-(void)likeBtnSelected:(BOOL)isSelected withLikeNum:(NSString *)likenum{
    
//    RecomInteModel *model = self.inteDataArr[_currentIndex];
//    model.clikenum = likenum;
//    model.likestatr = isSelected;
    
//    ChildRecomModel *model1 = self.recomentDataArr[_currentIndex];
//    model1.clikenum = likenum;
//    model1.likestatr = isSelected;
    if (_currentIndex == 0) {
        
        RecomInformModel *model2 = self.informationDataArr[_currentIndex];
        model2.clikenum = likenum;
        model2.likestatr = isSelected;
        [self.tableview reloadSection:_currentIndex withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
