//
//  RankListViewController.m
//  podsGolvon
//
//  Created by apple on 2017/1/13.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import "RankListViewController.h"
#import "ChildRankListViewController.h"
#import "MonthListViewController.h"
#import "YearListViewController.h"
#import "HYPageView.h"
#import "PopoverView.h"


@interface RankListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray   *titleArr;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSArray   *selecedArr;

@property (copy, nonatomic) NSString *selectedStr;

@property (nonatomic, strong) NSMutableArray   *typeArr;

@end

@implementation RankListViewController
-(NSArray *)selecedArr{
    if (!_selecedArr) {
        _selecedArr = [NSMutableArray array];
    }
    return _selecedArr;
}
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}
-(NSMutableArray *)typeArr{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
-(NSArray *)parArr{
    if (!_parArr) {
        _parArr = [NSArray array];
    }
    return _parArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.selecedArr = @[@"全部",@"2016年",@"2017年"];
    self.parArr = @[@"week",@"month",@"year"];
    self.selectedIndex = 2;
    [self createSubview];
}
-(void)createSubview{
    
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withTitles:@[@"周榜",@"月榜",@"年榜"] withViewControllers:@[@"ChildRankListViewController",@"MonthListViewController",@"YearListViewController"] withParameters:nil];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"scprdLefticon"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    [leftButton setTintColor:[UIColor blackColor]];
    [leftButton addTarget:self action:@selector(clickFollowBtn) forControlEvents:UIControlEventTouchUpInside];
    pageView.leftButton = leftButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"scordRighticon"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 50, 40);
    [rightButton setTintColor:[UIColor blackColor]];
    [rightButton addTarget:self action:@selector(clickTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    pageView.rightButton = rightButton;

    [self.view addSubview:pageView];
}

-(void)clickFollowBtn{
    
    PopoverView *popoverView = [PopoverView popoverView];
    [popoverView showToPoint:CGPointMake(28, 60) withTitles:self.selecedArr selectedIndex:_selectedIndex handler:^(NSUInteger selectedIndex){
        _selectedIndex = selectedIndex;
        if (selectedIndex == 0) {
            //            [self requestDataWithString:@"all"];
        }else if (selectedIndex == 1){
            //            [self requestDataWithString:@"2016"];
        }else{
            //            [self requestDataWithString:@"2017"];
        }
    }];

}
-(void)clickTimeBtn{
    
    PopoverView *popoverView = [PopoverView popoverView];
    [popoverView showToPoint:CGPointMake(CGRectGetWidth(self.view.bounds) - 28, 60) withTitles:self.selecedArr selectedIndex:_selectedIndex handler:^(NSUInteger selectedIndex){
        _selectedIndex = selectedIndex;
        if (selectedIndex == 0) {
            
//            [self requestDataWithString:@"all"];
            
        }else if (selectedIndex == 1){
            
//            [self requestDataWithString:@"2016"];
        }else{
//            [self requestDataWithString:@"2017"];
        }
    }];
}

@end
