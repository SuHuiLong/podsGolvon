//
//  CompetitionViewController.m
//  FindModule
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CompetitionViewController.h"
#import "InterviewTableViewCell.h"
#import "ChildCompetionData.h"
#import "InterviewDetileViewController.h"

@interface CompetitionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, strong) DownLoadDataSource   *loadData;
@property (nonatomic, strong) NSMutableArray   *competionData;
@property (nonatomic, assign) NSInteger viewStr;

@end

static NSString *competionCellID = @"CompetitionTableViewCell";

@implementation CompetitionViewController
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)competionData{
    if (!_competionData) {
        _competionData = [[NSMutableArray alloc] init];
    }
    return _competionData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestCompetionData];
}
-(void)createUI{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 102, ScreenWidth, ScreenHeight - 102 -49)];
    _tableview.rowHeight = kHvertical(257);
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    _tableview.separatorStyle = NO;
    [_tableview registerClass:[InterviewTableViewCell class] forCellReuseIdentifier:competionCellID];
    [self.view addSubview:_tableview];
}
-(void)requestCompetionData{
    
    NSDictionary *parameters = @{@"lastid":@(0),
                                 @"type":_type,
                                 @"uid":userDefaultUid};

    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cao/findapi.php?findkey=gettypeall",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArr = data[@"data"];
            for (NSInteger i = 0; i<[tempArr count]; i++) {
                ChildCompetionData *model = [ChildCompetionData modelWithDictionary:tempArr[i]];
                _viewStr = [model.readnum integerValue];
                [self.competionData addObject:model];
            }
        }
        [_tableview reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _competionData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:competionCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell relayoutCompetionDataWithModel:_competionData[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InterviewDetileViewController *VC = [[InterviewDetileViewController alloc] init];
    ChildCompetionData *model = self.competionData[indexPath.row];
    VC.hidesBottomBarWhenPushed = YES;
    VC.readStr = model.readnum;
    VC.likeStr = model.clikenum;
    VC.titleStr = model.title;
    VC.addTimeStr = model.addts;
    VC.maskPic = model.pic;
    VC.ID = model.ID;
    VC.type = self.type;
    VC.htmlStr = model.url;
    VC.isLike = model.likestatr;
    __weak typeof(self) weakself = self;
    [VC setBlock:^(BOOL isView) {
        
        weakself.viewStr = [model.readnum integerValue];
        weakself.viewStr ++;
        model.readnum = [NSString stringWithFormat:@"%ld",(long)_viewStr];
        [weakself.tableview reloadData];

    }];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
