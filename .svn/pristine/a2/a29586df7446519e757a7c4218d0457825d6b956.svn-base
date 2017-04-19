//
//  RankingListViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RankingListViewController.h"
#import "RulesModel.h"
#import "RulesTableViewCell.h"

@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UIView                  *navi;
}
@property (strong, nonatomic) UITableView    *tableView;
/***  好友的排行*/
@property (strong, nonatomic) NSMutableArray    *friendRankArr;
/***  全部的排行*/
@property (strong, nonatomic) NSMutableArray    *allRankArr;
/***  工具类*/
@property (strong, nonatomic) DownLoadDataSource    *loadData;
/***  关注状态*/
@property (strong, nonatomic) NSNumber    *likeState;
@property (strong ,nonatomic) RulesModel *selfModel;


@end

static NSString *identifier = @"RulesTableViewCell";
@implementation RankingListViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(NSMutableArray *)friendRankArr{
    if (!_friendRankArr) {
        _friendRankArr = [[NSMutableArray alloc]init];
    }
    return _friendRankArr;
}
-(NSMutableArray *)allRankArr{
    if (!_allRankArr) {
        _allRankArr = [[NSMutableArray alloc]init];
    }
    return _allRankArr;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
}
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *header = [[UIImageView alloc]init];
    header.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(181));
    header.backgroundColor = [UIColor magentaColor];
    header.contentMode = UIViewContentModeScaleAspectFill;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 6;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[RulesTableViewCell class] forCellReuseIdentifier:identifier];
    _tableView.tableHeaderView = header;
    _tableView.rowHeight = kHvertical(52);
    [self.view addSubview:_tableView];
    [self requestData];
}
-(void)createNav{
    
    navi                 = [[UIView alloc]init];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];
    [navi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kHvertical(0));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, kHvertical(64)));
    }];
    
    UILabel *title  = [[UILabel alloc]init];
    title.textColor = [UIColor blackColor];
    title.text      = @"打球去";
    title.font      = [UIFont systemFontOfSize:kHorizontal(15)];
    [navi addSubview:title];
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(navi);
    }];
    [title sizeToFit];
    
}
#pragma mark ---- 请求排行榜数据
-(void)requestData{
    
    NSDictionary *parameter = @{@"nameID":userDefaultId};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/SelectRanking",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
//            if (data[@"UserRank"][@"zongChangCi"]) {
//                
//                _selfModel = [RulesModel relayoutWithModel:data[@"UserRank"]];
//                
//            }else{
//                
////                [self createNoneRank];
//                
//            }
            
//            [self.allRankArr removeAllObjects];
            for (NSDictionary *all_temp in data[@"Ranking"]) {
                RulesModel *model = [RulesModel relayoutWithModel:all_temp];
//                _coverURL = data[@"Ranking"][0][@"touxiang_url"];
//                _headerURL = data[@"Ranking"][0][@"picture_url"];
//                _nickName = data[@"Ranking"][0][@"nickname"];
//                _firstNameID = data[@"Ranking"][0][@"name_id"];
                [self.allRankArr addObject:model];
                
            }
            
//            SimpleInterest *manager = [SimpleInterest sharedSingle];
//            if (manager.isFromA == YES) {
//                manager.isFromA = NO;
//                _nameID = manager.supportNameID;
//                int row = 0;
//                for (int i = 0; i<_allRankArr.count; i++) {
//                    RulesModel *model1 = _allRankArr[i];
//                    if ([model1.name_id isEqualToString:_nameID]) {
//                        row = i;
//                    }
//                }
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSIndexPath *targetIndexpath = [NSIndexPath indexPathForRow:row inSection:1];
//                    [self.tableView selectRowAtIndexPath:targetIndexpath animated:YES scrollPosition:UITableViewScrollPositionTop];
////                    [self requestWithBadgeValue];
//                });
//                
//            }
            
            
            _FriendsRankingStatr = data[@"FriendsRankingStatr"];
            if ([_FriendsRankingStatr isEqualToString:@"1"]) {
                NSLog(@"好友状态%@",data[@"FriendsRankingStatr"]);
                [self.friendRankArr removeAllObjects];
                
                for (NSDictionary *friend_temp in data[@"FriendsRanking"]) {
                    RulesModel *model = [RulesModel relayoutWithModel:friend_temp];
                    [self.friendRankArr addObject:model];
                }
            }
            
            
        }
        
//        [self setModel];
        [_tableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _friendRankArr.count;
    }else{
        return _allRankArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    [cell relayoutWithModel:_allRankArr[indexPath.row]];
    if (indexPath.section == 0) {
        [cell relayoutWithModel:_friendRankArr[indexPath.row]];
    }else{
        [cell relayoutWithModel:_allRankArr[indexPath.row]];
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    navi.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:self.tableView.contentOffset.y/400];
    
}


@end
