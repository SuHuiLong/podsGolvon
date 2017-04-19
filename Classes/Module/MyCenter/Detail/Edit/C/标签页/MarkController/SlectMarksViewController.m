


//
//  SlectMarksViewController.m
//  Golvon
//
//  Created by shiyingdong on 16/4/27.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SlectMarksViewController.h"
#import "JCTagListView.h"
#import "SelectMarkModel.h"

@interface SlectMarksViewController ()

@property(nonatomic,strong)NSMutableArray *dataArry;
@property (nonatomic, strong)JCTagListView *tagListView;
@end


@implementation SlectMarksViewController


-(NSMutableArray *)markArry{
    if (!_markArry) {
        _markArry = [NSMutableArray array];

    }
    return _markArry;
}

-(NSMutableArray *)markTextArry{
    if (!_markTextArry) {
        _markTextArry = [NSMutableArray array];
        
    }
    return _markTextArry;
}

-(NSMutableArray *)SelectMarkTitleArry{
    if (!_SelectMarkTitleArry) {
        _SelectMarkTitleArry = [NSMutableArray array];
        }
    return _SelectMarkTitleArry;
}



-(NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc] init];
    }
    return _dataArry;
}



- (void)viewDidLoad {
    _SelectMarkTitleArry = [[NSMutableArray alloc] init];
    
    NSArray *labelArry = [userDefaults objectForKey:@"SelectLabel"];
    if (!labelArry) {
        labelArry = [userDefaults objectForKey:@"labels"];
    }
    self.SelectMarkArry = labelArry;
    
    
    self.view.backgroundColor= [UIColor whiteColor];
    [super viewDidLoad];
    [self createNav];
    [self downLoadData];
    [self createTitleView];
}

-(void)createTitleView{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, HScale(8.5))];
    titleView.backgroundColor = GPRGBAColor(244, 245, 246,1.f);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(3.1), ScreenWidth, HScale(2.7))];
    titleLabel.text = @"选择标签(最多6个)";
    titleLabel.textColor = GPRGBAColor(183, 183, 183, 1.f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    [titleView addSubview:titleLabel];
    [self.view addSubview:titleView];

}

-(void)createListView{
    if (_dataArry) {
        NSMutableArray *dataMarry = [NSMutableArray array];
        for (SelectMarkModel *model in _dataArry) {
            [dataMarry addObject:model.markText];
        }
        
        _tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 64+HScale(8.5), ScreenWidth, ScreenHeight-64-HScale(8.5))];
        _tagListView.backgroundColor = GPRGBAColor(244, 245, 246,1.f);
        [self.view addSubview:_tagListView];
        
        self.tagListView.canSelectTags = YES;
        self.tagListView.tagCornerRadius = 5.0f;
        self.tagListView.tagBackgroundColor = GPRGBAColor(254, 255, 255, 1.f);
        self.tagListView.tagStrokeColor = GPRGBAColor(224, 225, 226, 1.f);
        self.tagListView.tagTextColor = GPRGBAColor(113, 113, 113, 1.f);
        self.tagListView.tagSelectedBackgroundColor = localColor;
        self.tagListView.tagTextSelectedBackgroundColor = [UIColor whiteColor];
        self.tagListView.tagCornerRadius = 3;
        
        [self.tagListView.tags addObjectsFromArray:dataMarry];
        [self.tagListView.selectedTags addObjectsFromArray:_SelectMarkTitleArry];
        __weak typeof(self) weakSelf = self;
        
        [self.tagListView setCompletionBlockWithDeSelected:^(NSInteger index) {
            SelectMarkModel *model = weakSelf.dataArry[index];
            [weakSelf.markArry removeObject:model.markId];
            [weakSelf.SelectMarkTitleArry removeObject:model.markText];
            
            
            NSMutableArray *userLabelArry = [[NSMutableArray alloc] init];
            for (int i =0; i<weakSelf.markArry.count; i++) {
                NSDictionary *dict = @{
                                       @"label_content":weakSelf.SelectMarkTitleArry[i],
                                       @"label_id":weakSelf.markArry[i]
                                       };
                [userLabelArry addObject:dict];
            }
            [userDefaults setValue:userLabelArry forKey:@"SelectLabel"];
            NSLog(@"%@",weakSelf.markArry);
        }];
        
        [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
            SelectMarkModel *model = weakSelf.dataArry[index];
            [weakSelf.markArry addObject:model.markId];
            [weakSelf.SelectMarkTitleArry addObject:model.markText];
            NSMutableArray *userLabelArry = [[NSMutableArray alloc] init];
            for (int i =0; i<weakSelf.markArry.count; i++) {
                NSDictionary *dict = @{
                                       @"label_content":weakSelf.SelectMarkTitleArry[i],
                                       @"label_id":weakSelf.markArry[i]
                                       };
                [userLabelArry addObject:dict];
            }
            [userDefaults setValue:userLabelArry forKey:@"SelectLabel"];            
            NSLog(@"%@",weakSelf.markArry);
            if (weakSelf.markArry.count>5) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tagListView.tags removeObjectsInArray:@[weakSelf.dataArry[index]]];
                    
                });
            }
        }];
    }
}

/**
 *  查询所有标签
 */

-(void)downLoadData{
    _markArry = [NSMutableArray array];
    _SelectMarkTitleArry = [NSMutableArray array];
    for (NSDictionary *dict in _SelectMarkArry) {
        [_SelectMarkTitleArry addObject:[dict objectForKey:@"label_content"]];
        [_markArry addObject:[dict objectForKey:@"label_id"]];

    }
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_label_all",urlHeader120] parameters:nil complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArr = data[@"data"];
            _dataArry = [NSMutableArray array];
            for (NSDictionary *DataDict in tempArr) {
                SelectMarkModel *model = [SelectMarkModel ShlFromDictionary:DataDict];
                [_dataArry addObject:model];
            }
            [self createListView];
        }
    }];
    
}


-(void)createNav{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(0), HScale(4.6), ScreenWidth, ScreenHeight * 0.033)];
    titleLabel.text = @"标签选择";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [backBtn addSubview:backImage];
    
    [backBtn addTarget:self action:@selector(pressesBack2) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(ScreenWidth-kWvertical(44), 20, kWvertical(44), kWvertical(44));
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:localColor forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(FinishButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    [navView addSubview:finishBtn];

    
}


//返回
- (void)pressesBack2{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成
- (void)FinishButton{
    if ([self.markArry count] >0) {
        self.lableName = @"已选择标签";
    }else{
        self.lableName = @"请选择标签";

    }
    self.back(self.markArry);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
