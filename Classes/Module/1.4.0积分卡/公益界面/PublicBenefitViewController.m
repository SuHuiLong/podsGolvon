//
//  PublicBenefitViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublicBenefitViewController.h"
#import "PublicBenefitTableViewCell.h"
#import "PublicBenefitModel.h"
#import "PublicBenefitDetailViewController.h"
#import "RankingListViewController.h"
#import "NewDetailViewController.h"
@interface PublicBenefitViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property(nonatomic,strong)UITableView  *mainTableView;
//头部数据源
@property(nonatomic,copy)NSDictionary  *headerDict;
//tablview数据源
@property(nonatomic,copy)NSArray  *dataArray;

@property (strong, nonatomic) UIView    *placeView;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation PublicBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    
    [self createNavigationView];
    [self createTableView];
    [self createProgress];
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

//创建tableview
-(void)createTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[PublicBenefitTableViewCell class] forCellReuseIdentifier:@"PublicBenefitTableViewCell"];
    _mainTableView = tableView;
}

-(void)initData{
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=charityrank",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        [_HUD removeFromSuperview];
        [_placeView removeFromSuperview];
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _headerDict = [NSDictionary dictionary];
                NSString *totalcharity = [data objectForKey:@"totalcharity"];
                NSString *totalgames = [data objectForKey:@"totalgames"];
                NSString *totalpeople = [data objectForKey:@"totalpeople"];
                _headerDict = @{
                                @"totalcharity":totalcharity,
                                @"totalgames":totalgames,
                                @"totalpeople":totalpeople,
                                };
                NSArray *dataArray = [data objectForKey:@"data"];
                NSMutableArray *mDataArray = [NSMutableArray array];
                for (NSInteger i=0; i<dataArray.count; i++) {
                    PublicBenefitModel *model = [PublicBenefitModel new];
                    [model configData:dataArray[i]];
                    model.rank = [NSString stringWithFormat:@"%ld",i+1];
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
//规则页
-(void)DetailClick{
    PublicBenefitDetailViewController *vc = [[PublicBenefitDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tablevieDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_headerDict) {
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    NSInteger num = _dataArray.count;
    if (num>10) {
        return 10;
    }
    return  num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(55);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }
    return kHvertical(42);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section==0) {
        return kHvertical(319);
    }
    return 0;
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
    UIView *headerView = [UIView new];
    if (section==1) {
        headerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(42))];
        UILabel *title = [Factory createLabelWithFrame:CGRectMake(kWvertical(12), 0, kWvertical(200), kHvertical(42)) textColor:rgba(44,44,44,1) fontSize:kHorizontal(13) Title:@"公益榜"];
        
        
        
        
        UILabel *moreLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - kWvertical(23), kHvertical(42)) textColor:rgba(150,150,150,1) fontSize:kHorizontal(11) Title:@"更多"];
        UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(moreLabel.x_width+kWvertical(4), kHvertical(15.5), kWvertical(6), kHvertical(11)) Image:[UIImage imageNamed:@"message_notifi_arrow"]];

        [moreLabel setTextAlignment:NSTextAlignmentRight];
        [headerView addSubview:title];
        [headerView addSubview:arrowView];
        [headerView addSubview:moreLabel];
        
        headerView.userInteractionEnabled = YES;
        __weak __typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            RankingListViewController *vc = [[RankingListViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [headerView addGestureRecognizer:tap];
    }
    return headerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    footerView.userInteractionEnabled = YES;
    if (section==0) {
        footerView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(313))];
        UIImageView  *footerImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(212)) Image:[UIImage imageNamed:@"publishBenefitBanner"]];
        UIView *alapView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.33) frame:CGRectMake(0, kHvertical(170), ScreenWidth, kHvertical(42))];
        UILabel *desc = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), kHvertical(170), ScreenWidth, kHvertical(42)) textColor:rgba(255,255,255,1) fontSize:kHorizontal(13) Title:@"关爱球童，打球记分也能做公益！"];
        UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - 10-6, kHvertical(186), 6, 11) Image:[UIImage imageNamed:@"message_notifi_arrow"]];
        footerImageView.userInteractionEnabled = YES;
        __weak __typeof(self)weakSelf = self;
        UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf DetailClick];
        }];
        [footerImageView addGestureRecognizer:tpg];
        
        [footerImageView addSubview:alapView];
        [footerImageView addSubview:desc];
        [footerImageView addSubview:arrowView];
        [footerView addSubview:footerImageView];

        UILabel *title = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), desc.y_height+kHvertical(8), kWvertical(200), kHvertical(17)) textColor:rgba(44,44,44,1) fontSize:kHorizontal(12) Title:@"累计公益"];
        [footerView addSubview:title];
        
        NSString *totalcharity = [_headerDict objectForKey:@"totalcharity"];
        NSString *totalgames = [_headerDict objectForKey:@"totalgames"];
        NSString *totalpeople = [_headerDict objectForKey:@"totalpeople"];

        NSArray *dataArray = @[totalpeople,totalcharity,totalgames];
        NSArray *nameArray = @[@"捐赠人数",@"捐赠总金额",@"捐赠总场次"];
        for (int i =0; i<3; i++) {
            UILabel *dataLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i, desc.y_height+kHvertical(34), ScreenWidth/3, kHvertical(33)) textColor:rgba(0,0,0,1) fontSize:kHorizontal(24) Title:dataArray[i]];
            UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/3*i, dataLabel.y_height, ScreenWidth/3, kHvertical(16)) textColor:rgba(122,125,134,1) fontSize:kHorizontal(11) Title:nameArray[i]];
            [dataLabel setTextAlignment:NSTextAlignmentCenter];
            [nameLabel setTextAlignment:NSTextAlignmentCenter];
            [footerView addSubview:dataLabel];
            [footerView addSubview:nameLabel];
        }
        UIView *line = [Factory createViewWithBackgroundColor:rgba(220,220,220,1) frame:CGRectMake(0, kHvertical(313), ScreenWidth, 1)];
        
        UIView *lineView = [Factory createViewWithBackgroundColor:rgba(238, 239, 241, 1) frame:CGRectMake(0, line.y_height, ScreenWidth, 5)];
        
        [footerView addSubview:line];
        [footerView addSubview:lineView];
    }
    return footerView;
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
