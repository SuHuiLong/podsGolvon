//
//  AddBallParkViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/8/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "AddBallParkViewController.h"
#import "AddBallParkTableViewCell.h"
#import "StartScoringViewController.h"
#import "BallParkSelectModel.h"

@interface AddBallParkViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    /**
     *  输入球场
     */
    UITextField *ballTextField;
    UIButton *deleBallPark;
    UIBarButtonItem *rightBarbutton;
    UIButton *resignFirstResponder;
    UILabel *noneLabel;
    NSString *plistPath;
}
/***  tableview*/
@property (strong, nonatomic) UITableView        *tableView;
/***  数据源*/
@property (strong, nonatomic) NSMutableArray     *dataArr;
/***  工具类*/
@property (strong, nonatomic) DownLoadDataSource *loadData;
/***  球场名字*/
@property (copy, nonatomic  ) NSMutableString    *ballParkName;
/***  球场ID*/
@property (copy, nonatomic  ) NSMutableString    *ballParkID;

/***  根数据*/
@property (strong, nonatomic) NSMutableDictionary    *rootDic;
/***  详情数据*/
@property (strong, nonatomic) NSMutableDictionary    *ballParkDic;

@end

static NSString *cellID = @"AddBallParkTableViewCell";
@implementation AddBallParkViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableString *)ballParkName{
    if (!_ballParkName) {
        _ballParkName = [[NSMutableString alloc]init];
    }
    return _ballParkName;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self createPath];
    [self requestHistoryBallPark];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加球场";
    [self createUI];
    
    // ios7以上的导航栏默认是半透明的  关闭就是纯白色了
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIBarButtonItem *leftBarbutton        = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    leftBarbutton.tintColor               = GPColor(0, 0, 0);
    [leftBarbutton setImage:[UIImage imageNamed:@"多人操作返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;

    rightBarbutton                        = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickComplete)];
    rightBarbutton.enabled                = NO;
    self.navigationItem.rightBarButtonItem = rightBarbutton;
    
}
-(void)clickComplete{
    
    
    [self requestWithData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (StartScoringViewController *VC in self.navigationController.viewControllers) {
            
            if ([VC isKindOfClass:[StartScoringViewController class]]) {
                VC.nameStr = _ballParkName;
                VC.qiuchang_id = _ballParkID;
                [self.navigationController popToViewController:VC animated:YES];
                
            }
        }
        
    });
    
}
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//讲ballpark写入沙盒
-(void)createPath{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    

    plistPath = [[filePath objectAtIndex:0] stringByAppendingPathComponent:@"historyBallPark.plist"];
    
}



-(void)createUI{
    /**
     headerView
     */
    UIView *headerView         = [[UIView alloc]init];
    headerView.frame           = CGRectMake(0, 0, ScreenWidth, kHvertical(77));
    headerView.backgroundColor = GPColor(250, 250, 250);


    UIView *white              = [[UIView alloc]init];
    white.frame                = CGRectMake(0, 0, ScreenWidth, headerView.height - kHvertical(8));
    white.backgroundColor      = [UIColor whiteColor];

    

    UILabel *label             = [[UILabel alloc]init];
    label.frame                = CGRectMake(kWvertical(12), kHvertical(8), kWvertical(140), kHvertical(17));
    label.backgroundColor      = [UIColor whiteColor];
    label.textColor            = GPColor(87, 87, 87);
    label.textAlignment        = NSTextAlignmentLeft;
    label.font                 = [UIFont systemFontOfSize:kHorizontal(12)];
    label.text                 = @"球场名称(城市+球场名)";

    
    
    ballTextField                 = [[UITextField alloc]init];
    ballTextField.frame           = CGRectMake(kWvertical(12), label.bottom, ScreenWidth - kWvertical(15), kHvertical(42));
    ballTextField.delegate        = self;
    ballTextField.backgroundColor = [UIColor whiteColor];
    ballTextField.textColor       = GPColor(87, 87, 87);
    ballTextField.font            = [UIFont systemFontOfSize:kHorizontal(14)];
    ballTextField.placeholder     = @"例如：上海虹桥高尔夫";
    ballTextField.tintColor       = localColor;
    ballTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    ballTextField.text            = _ballParkName;
    [ballTextField addTarget:self action:@selector(clickToDown) forControlEvents:UIControlEventEditingChanged];
    [white addSubview:label];
    [white addSubview:ballTextField];
    [headerView addSubview:white];
    
    
    
    /**
     *  tableview
     */
    _tableView                 = [[UITableView alloc]init];
    _tableView.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    _tableView.dataSource      = self;
    _tableView.delegate        = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = headerView;
    [_tableView registerClass:[AddBallParkTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    
    
    
    resignFirstResponder                 = [UIButton buttonWithType:UIButtonTypeCustom];
    resignFirstResponder.hidden          = YES;
    resignFirstResponder.backgroundColor = [UIColor clearColor];
    resignFirstResponder.frame           = CGRectMake(0, kHvertical(68), ScreenWidth, ScreenHeight - kHvertical(68)-kHvertical(64));
    [resignFirstResponder addTarget:self action:@selector(clickResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:resignFirstResponder];
}


#pragma mark ---- UITextFieldDelegate
-(void)clickToDown{
    
    if (ballTextField.text.length > 1) {
        rightBarbutton.enabled = YES;
        rightBarbutton.tintColor = GPColor(0, 0, 0);
        
    }else{
        rightBarbutton.enabled = NO;
    }
    
}

-(void)clickResignFirstResponder{
    
    if (ballTextField.text.length > 1) {
        rightBarbutton.enabled = YES;
        rightBarbutton.tintColor = GPColor(0, 0, 0);
    }else{
        
        rightBarbutton.enabled = NO;
    }
    [ballTextField resignFirstResponder];
}


#pragma mark ---- 手动输入球场
-(void)requestWithData{
    NSString *name = ballTextField.text;
    NSDictionary *parameters = @{@"QiuChangName":name,
                                 @"nameID":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insertCustomQiuChang",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            
            if ([data[@"code"] isEqualToString:@"1"]) {
                
                _ballParkName = data[@"qiuchang_name"];
                _ballParkID   = data[@"qiuchang_id"];
                
            }else{
                NSLog(@"输入失败");
            }
            
        }else{
            NSLog(@"请求失败");
        }
    }];

}

#pragma mark ---- 请求历史记录
-(void)requestHistoryBallPark{

    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/selectCustomQiuChang",urlHeader120] parameters:@{@"nameID":userDefaultId} complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data[@"data"];
            
            for (NSDictionary *temp in dic) {
                BallParkSelectModel *model = [BallParkSelectModel paresFromDictionary:temp];
                [self.dataArr addObject:model];
                
                [_tableView reloadData];
                
                
            }
            if (_dataArr.count == 0) {
                [self createNoneHistory];
            }
            
            //根数据
//            _rootDic = [[NSMutableDictionary alloc]init];
//            [_rootDic setObject:dic forKey:@"ballPark"];
//            
//            [_rootDic writeToFile:plistPath atomically:YES];
//            
//            NSLog(@"%@",_rootDic);
        }
    }];
    
    
}
-(void)createNoneHistory{
    
    [noneLabel removeFromSuperview];
    noneLabel               = [[UILabel alloc]init];
    noneLabel.text          = @"暂无历史添加";
    noneLabel.font          = [UIFont systemFontOfSize:kHorizontal(14)];
    noneLabel.frame         = CGRectMake((ScreenWidth - kWvertical(84))/2, kHvertical(122), kWvertical(84), kHvertical(20));
    noneLabel.textColor     = GPColor(65, 65, 65);
    noneLabel.textAlignment = NSTextAlignmentCenter;
    [_tableView addSubview:noneLabel];
    
}
#pragma mark ---- UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHvertical(44);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(31);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = GPColor(136, 136, 136);
    label.frame = CGRectMake(kWvertical(12), kHvertical(7), kWvertical(48), kHvertical(17));
    label.text = @"历史添加";
    label.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [header addSubview:label];
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddBallParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell relayoutWithModel:_dataArr[indexPath.row]];
    
    
    __weak typeof(self) weakself = self;
    cell.deleteHistoryBallPark = ^(BallParkSelectModel *model){

        [weakself deleteHistoryBallPark:model];
    };
    return cell;
}
-(void)deleteHistoryBallPark:(BallParkSelectModel *)model{
    NSLog(@"%@",model);
    NSDictionary *parameters = @{@"qiuchang_id":model.historyBallParkID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/deleteCustomQiuChang",urlHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            if ([data[@"code"] isEqualToString:@"1"]) {
                
            }else{
                
            }
            [_dataArr removeAllObjects];
            
            [self requestHistoryBallPark];
            
            [_tableView reloadData];
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];

                [self presentViewController:alertController animated:YES completion:nil];
                
            });
        }
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BallParkSelectModel *model = _dataArr[indexPath.row];
    
    for (StartScoringViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[StartScoringViewController class]]) {
            
            VC.nameStr = model.name;
            VC.qiuchang_id = model.historyBallParkID;
            [self.navigationController popToViewController:VC animated:YES];
            
        }
    }
    
}
@end
