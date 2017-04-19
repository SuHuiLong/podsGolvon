//
//  JobViewController.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "JobViewController.h"
#import "LeftMode.h"
#import "Rightmode.h"
#import "rightJobTableView.h"
#import "LeftJobtableView.h"
#import "ConsummateViewController.h"
#import "Edit_ViewController.h"

@interface JobViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 父类请求*/
@property (nonatomic,strong)DownLoadDataSource * RequestData;

/** 父类模型数组*/
@property (nonatomic,strong)NSMutableArray * superArr;
/** 右边子类数组*/
@property (nonatomic,strong)NSMutableArray * RightArr;

@property (strong,nonatomic) UITableView *leftTable;
@property (strong,nonatomic) UITableView *rightTable;



@property (nonatomic,assign) NSInteger leftLabelIntger;

@property (nonatomic, assign) int ID;

@end

@implementation JobViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.ID = [self.controllerID intValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.superArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.RightArr =[[NSMutableArray alloc]initWithCapacity:0];
    [self navV];
    //左边tableView
    [self creatLeftTableView];
   //右边tableView
    [self creatRighttTableView];
    self.view.backgroundColor = GPColor(244, 244, 244);

}

//创建导航条
- (void)navV{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(41.6), HScale(4.5), ScreenWidth * 0.171, ScreenHeight * 0.033)];
    _titleLabel.text = @"行业选择";
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:_titleLabel];
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    _backBtn.frame = CGRectMake(0, HScale(3), ScreenWidth * 0.091, ScreenHeight * 0.066);
    [_backBtn addTarget:self action:@selector(pressesBack) forControlEvents:UIControlEventTouchUpInside];
 
    [_navView addSubview:_backBtn];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 1)];
    lineView.backgroundColor = GPColor(212, 213, 214);
    [self.view addSubview:lineView];
}
//返回
- (void)pressesBack{

    if (_ID == 1) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}



#pragma mark - 懒加载
- (DownLoadDataSource *)RequestData{

    if (!_RequestData) {
        _RequestData  = [[DownLoadDataSource alloc]init];
    }
    return _RequestData;
}
- (NSMutableArray *)superArr{

    if (!_superArr) {
        _superArr = [[NSMutableArray alloc]init];
    }
    return _superArr;
}
- (NSMutableArray *)RightArr{
    if (!_RightArr) {
        _RightArr = [[NSMutableArray alloc]init];
    }
    return _RightArr;
}

//请求数据左边
- (void)requestData{
   
    __weak typeof(self) weakself = self;
    NSString *path = [NSString stringWithFormat:@"%@commonapi.php?func=getfwork",apiHeader120] ;
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
  [self.RequestData downloadWithUrl:url parameters:nil complicate:^(BOOL success, id data) {
   
      if (success) {
          NSArray *arr = data;
          for (NSDictionary *leftDic in arr) {
              LeftMode *lefeMode = [LeftMode LeftWithDictionary:leftDic];
              [weakself.superArr addObject:lefeMode];
          }
          //左边刷新
          [weakself.leftTable reloadData];
      }
     
  }];

}

//左视图
- (void)creatLeftTableView{

    _leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, ScreenWidth/2, ScreenHeight-65)];
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.rowHeight = 50;
    self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_leftTable registerClass:[LeftJobtableView class] forCellReuseIdentifier:@"left"];
    [self.view addSubview:_leftTable];
    self.leftTable.backgroundColor = GPColor(244, 244, 244);
    //请求数据
    [self requestData];
    [self RightRequestData:[NSString stringWithFormat:@"%d",1]];
}

//右视图
- (void)creatRighttTableView{
    _rightTable = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 65, ScreenWidth/2, ScreenHeight-65)];
    _rightTable.delegate = self;
    _rightTable.rowHeight = 50;
    _rightTable.dataSource = self;
    self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rightTable];
    
}

//右边请求数据
- (void)RightRequestData:(NSString*)params{
    __weak typeof(self) weakself = self;
    NSString *path = [NSString stringWithFormat:@"%@commonapi.php?func=getcwork",apiHeader120];
    NSString *url = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.RequestData downloadWithUrl:url parameters:@{@"wid":params} complicate:^(BOOL success, id data) {
      
        if (success) {
            NSArray *arr = data;
            for (NSDictionary *RightDic in arr) {
                
                Rightmode *rightMode = [Rightmode RightWithDictionary:RightDic];
                [weakself.RightArr addObject:rightMode];
            }
            //左边刷新
            [weakself.rightTable reloadData];
        }
        
    }];


}


#pragma mark ---- 代理方法tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_leftTable == tableView) {

        return self.superArr.count;

    
    }else{
        
        return self.RightArr.count;

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HScale(7.5);

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftTable == tableView) {
        LeftJobtableView *cell =[tableView dequeueReusableCellWithIdentifier:@"left"];

        LeftMode*model = _superArr[indexPath.row];
        [cell reloadWithMode:model];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.leftLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
        if (indexPath.row == self.leftLabelIntger) {
            cell.leftLabel.textColor = localColor;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.leftView.hidden = YES;
        }else{
            cell.leftLabel.textColor = GPColor(132, 141, 158);
            cell.contentView.backgroundColor = GPColor(242, 244, 248);
            cell.leftView.hidden = NO;
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        rightJobTableView *Rightcell = [tableView dequeueReusableCellWithIdentifier:@"right"];
        if (Rightcell == nil) {
            Rightcell = [[rightJobTableView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"right"];
        }
        [Rightcell relayoutAndModel:_RightArr[indexPath.row]];

        return Rightcell;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _controllerID = 0;
    if (_leftTable == tableView) {
        
        LeftMode *leftM = _superArr[indexPath.row];
      
        [self RightRequestData:leftM.work_id];
        self.leftLabelIntger = indexPath.row;
        [_leftTable reloadData];
        [_RightArr removeAllObjects];
        
    }else if(_rightTable == tableView){
            Rightmode *model = _RightArr[indexPath.row];
        
            if (_ID == 2) {
                
                for (Edit_ViewController *VC in self.navigationController.viewControllers) {
                    if ([VC isKindOfClass:[Edit_ViewController class]]) {
                        
                        VC.jobStr = model.work_content;
                        VC.jobID = model.work_id;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            }else{
                if ([self.delegate respondsToSelector:@selector(selectedWorkname:WorkID:)]) {
                    [self.delegate selectedWorkname:model.work_content WorkID:model.work_id];
                }
                [self dismissViewControllerAnimated:YES completion:nil];

            }
            
        }
}


- (BOOL)shouldAutorotate{
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end
