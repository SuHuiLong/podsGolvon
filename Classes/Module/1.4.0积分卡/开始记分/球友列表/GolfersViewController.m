//
//  GolfersViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "GolfersViewController.h"
#import "GolfersTableViewCell.h"
@interface GolfersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)UITableView  *mainTableView;
//总数据源
@property(nonatomic,strong)NSDictionary  *dataDict;
@property(nonatomic,strong)UILabel *label;
@end

@implementation GolfersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - createView
-(void)createView{
    [self createNavagationView];
    [self createTableView];
}

-(void)createNavagationView{
    
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];

    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    
    UIButton *rightBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth-70, 0, 70, 64) image:nil target:self selector:@selector(rightBtnClick) Title:@"完成"];
    [rightBtn setTitleColor:rgba(53,141,227,1) forState:UIControlStateNormal];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    [rightBtn setContentEdgeInsets:UIEdgeInsetsMake(31, 15, 11, 13)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"球友列表"];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:rightBtn];
    [Uvc addSubview:titlelabel];
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
}

-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView registerClass:[GolfersTableViewCell class] forCellReuseIdentifier:@"GolfersTableViewCell"];
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

-(void)createNoneView{
    
    _mainTableView.hidden = YES;
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    _label.text = @"您还没有互相关注的球友，赶快去添加吧！";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _label.textColor = textTintColor;
    [self.view addSubview:_label];
}

-(void)createAlertView{
    SucessView *sview = [[SucessView alloc] initWithFrame:CGRectMake((ScreenWidth- kWvertical(136))/2, kHvertical(286), kWvertical(136), kHvertical(96)) imageImageName:@"失败" descStr:@"最多选择三名球员"];
    
    [self.view addSubview:sview];
    
}
#pragma mark - initData
-(void)initData{
    __weak typeof(self) weakself = self;
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    NSDictionary *dict = @{
                           @"name_id":userDefaultId
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=getfriends",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *recent = [data objectForKey:@"recent"];
                NSArray *allletters = [data objectForKey:@"allletters"];
                NSDictionary *freinds = [data objectForKey:@"freinds"];
                
                
                if (allletters.count == 0) {
                    [self createNoneView];
                }
                
                NSMutableArray *mRecent = [NSMutableArray array];
                for (int i =0; i<recent.count; i++) {
                    GolfersModel *model = [[GolfersModel alloc] init];
                    [model configData:recent[i]];
                    for (int j = 0; j<_selectPlayerArray.count; j++) {
                        GolfersModel *selectModel = _selectPlayerArray[j];
                        if ([model.uid isEqualToString:selectModel.uid]) {
                            model.isSelect = YES;
                        }
                    }
                    [mRecent addObject:model];
                }
                
                NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
                NSWidthInsensitiveSearch|NSForcedOrderingSearch;
                NSComparator sort = ^(NSString *obj1,NSString *obj2){
                    NSRange range = NSMakeRange(0,obj1.length);
                    return [obj1 compare:obj2 options:comparisonOptions range:range];
                };
                NSMutableArray *mAllletters = [NSMutableArray arrayWithArray: [allletters sortedArrayUsingComparator:sort]];
                
                NSLog(@"字符串数组排序结果%@",mAllletters);
                
                
                NSMutableDictionary *mFreinds = [NSMutableDictionary dictionary];
                for (int i =0; i<mAllletters.count; i++) {
                    NSString *str = mAllletters[i];
                    NSArray *characterArray = [freinds objectForKey:str];
                    NSMutableArray *mCharacterArray = [NSMutableArray array];
                    for (int j = 0; j<characterArray.count; j++) {
                        GolfersModel *model = [[GolfersModel alloc] init];
                        [model configData:characterArray[j]];
                        for (int j = 0; j<_selectPlayerArray.count; j++) {
                            GolfersModel *selectModel = _selectPlayerArray[j];
                            if ([model.uid isEqualToString:selectModel.uid]) {
                                model.isSelect = YES;
                            }
                        }
                        [mCharacterArray addObject:model];
                    }
                    [mFreinds setValue:mCharacterArray forKey:str];
                }
                
                if (recent.count>0) {
                    [mAllletters insertObject:@"0" atIndex:0];
                    
                    [mFreinds setValue:mRecent forKey:@"0"];
                }
                
                NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//                [dataDict setObject:mRecent forKey:@"recent"];
                [dataDict setObject:mAllletters forKey:@"allleters"];
                [dataDict setObject:mFreinds forKey:@"freinds"];
                weakself.dataDict = [NSDictionary dictionaryWithDictionary:dataDict];
                [weakself.mainTableView reloadData];
            }
        }
    }];
}


#pragma mark - Action
//左按钮返回
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//右按钮完成
-(void)rightBtnClick{
    
    if (self.SelectPlayerblock !=nil) {
        self.SelectPlayerblock(_selectPlayerArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickDone:(SelectPlayerblock)block{
    self.SelectPlayerblock = block;
}



//选中按钮点击
-(void)selectBtnClick:(UIButton *)sender{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_dataDict];
    NSArray *allletters = [mDict objectForKey:@"allleters"];
    NSMutableDictionary *freinds = [NSMutableDictionary dictionaryWithDictionary:[mDict objectForKey:@"freinds"]];
    NSInteger selectNum = _selectPlayerArray.count;

    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    NSString *selectStr = allletters[indexPath.section];
    NSMutableArray *selectModelArray = [NSMutableArray arrayWithArray:[freinds objectForKey:selectStr]];
    
    GolfersModel *selectModel = selectModelArray[indexPath.item];
    if (selectModel.isSelect) {
        selectModel.isSelect = NO;
        for (GolfersModel *model in _selectPlayerArray) {
            if ([model.uid isEqualToString:selectModel.uid]) {
                NSMutableArray *selectArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
                [selectArray removeObject:model];
                _selectPlayerArray = [NSArray arrayWithArray:selectArray];
            }
        }
    }else{
        if (selectNum>4) {
            
            [self createAlertView];
            
            return;
        }else{
            selectModel.isSelect = YES;
            NSMutableArray *selectArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
            [selectArray insertObject:selectModel atIndex:selectArray.count-1];
            _selectPlayerArray = [NSArray arrayWithArray:selectArray];
        }
    }

    [selectModelArray replaceObjectAtIndex:indexPath.item withObject:selectModel];
    [freinds setValue:selectModelArray forKey:allletters[indexPath.section]];
    [mDict setValue:freinds forKey:@"freinds"];
    _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
    [_mainTableView reloadData];
    

    
    
}


#pragma mark - Deleate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataDict.allKeys==0) {
        return 0;
    }else{
//        NSArray *recent = [_dataDict objectForKey:@"recent"];
        NSArray *allletters = [_dataDict objectForKey:@"allleters"];
        NSInteger sections = 0;
//        if (recent.count>0) {
//            sections = 1;
//        }
        if (allletters.count>0) {
            sections = sections + allletters.count;
        }
        return sections;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataDict.allKeys==0) {
        return 0;
    }else{
//        NSArray *recent = [_dataDict objectForKey:@"recent"];
        NSArray *allletters = [_dataDict objectForKey:@"allleters"];
        NSDictionary *freinds = [_dataDict objectForKey:@"freinds"];
//        if (recent.count>0) {
//            if (section == 0) {
//                return recent.count;
//            }else{
//                NSArray *freindsArray = [freinds objectForKey:allletters[section - 1]];
//                return freindsArray.count;
//            }
//        }else{
            NSArray *freindsArray = [freinds objectForKey:allletters[section]];
            return freindsArray.count;
//        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(45);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GolfersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GolfersTableViewCell" forIndexPath:indexPath];
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
//    NSArray *recent = [_dataDict objectForKey:@"recent"];
    NSArray *allletters = [_dataDict objectForKey:@"allleters"];
    NSDictionary *freinds = [_dataDict objectForKey:@"freinds"];
    
//    if (recent.count>0) {
//        if (indexPath.section == 0) {
//            [cell configModel:(GolfersModel *)recent[indexPath.row]];
//        }else{
//            NSArray *freindsArray = [freinds objectForKey:allletters[indexPath.section - 1]];
//            [cell configModel:(GolfersModel *)freindsArray[indexPath.row-1]];
//        }
//    }else{
        NSArray *freindsArray = [freinds objectForKey:allletters[indexPath.section ]];
        [cell configModel:(GolfersModel *)freindsArray[indexPath.row]];
//    }

    
    
    
    return cell;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    NSArray *recent = [_dataDict objectForKey:@"recent"];
    NSArray *allletters = [_dataDict objectForKey:@"allleters"];
    NSDictionary *freinds = [_dataDict objectForKey:@"freinds"];
    
    UIView *headerView = [Factory createViewWithBackgroundColor:GPColor(238, 239, 241) frame:CGRectMake(0, 0, ScreenWidth, kHvertical(30))];

    NSString *titleStr = [NSString string];
//    if (recent.count>0) {
//        if (section == 0) {
//            titleStr = @"最近";
//        }else{
//            titleStr = allletters[section - 1];
//        }
//    }else{
        titleStr = allletters[section];
    if ([titleStr isEqualToString:@"0"]) {
        titleStr = @"最近";
    }
//    }

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
