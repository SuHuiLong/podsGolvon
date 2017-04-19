//
//  NewSingleScroingViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewSingleScroingViewController.h"
#import "CUSFlashLabel.h"
#import "NewSingleScroingScrollView.h"

@interface NewSingleScroingViewController ()<UIScrollViewDelegate>


@property(nonatomic,strong)UIScrollView  *mainScrollView;

@end

@implementation NewSingleScroingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - createView
-(void)createView{
    [self createNavagationView];
    [self createScrollView];
    [self createContentView];
}
//创建navagation
-(void)createNavagationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    
    UIButton *rightBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth-64, 0, 64, 64) image:nil target:self selector:@selector(rightBtnClick) Title:@"完成"];
    [rightBtn setTitleColor:rgba(53,141,227,1) forState:UIControlStateNormal];
    
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    [rightBtn setContentEdgeInsets:UIEdgeInsetsMake(31, 15, 11, 13)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"A5"];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake( ScreenWidth/2 + 15, 41, 11, 6) Image:[UIImage imageNamed:@"scoring向下角标"]];
    
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:rightBtn];
    [Uvc addSubview:titlelabel];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
    [self.view addSubview:arrowView];
}


-(void)createScrollView{

    UIScrollView *mainScreollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+kHvertical(65), ScreenWidth, ScreenHeight - 64 - kHvertical(65))];
    mainScreollView.delegate = self;
    [self.view addSubview:mainScreollView];
    _mainScrollView = mainScreollView;
    
    [_mainScrollView setContentSize:CGSizeMake(ScreenWidth*18, mainScreollView.height)];
    _mainScrollView.pagingEnabled = YES;
    
    
    for (int i = 0; i<18; i++) {
        NewSingleScroingScrollView *scrollViewContentView = [[NewSingleScroingScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, _mainScrollView.height)];
        [_mainScrollView  addSubview:scrollViewContentView];
    }
}

//设置上下文字内容
-(void)createContentView{
    UILabel *GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, 64 + kHvertical(13), kWvertical(77), kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(24.0f) Title:@"0"];
    UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(0, GrossLabel.y_height, kWvertical(77), kHvertical(20)) textColor:rgba(118,118,118,1) fontSize:kHorizontal(14.0f) Title:@"总杆"];
    [GrossLabel setTextAlignment:NSTextAlignmentCenter];
    [Gross setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:GrossLabel];
    [self.view addSubview:Gross];
    
    CUSFlashLabel *label2 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight - kHvertical(35), ScreenWidth, kHvertical(20))];
    [label2 setText:@"左右滑动切换球洞"];
    [label2 setFont:[UIFont systemFontOfSize:kHorizontal(14.0f)]];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:rgba(169,169,169,1)];
    [label2 setSpotlightColor:[UIColor whiteColor]];
    [label2 setContentMode:UIViewContentModeTop];
    [label2 startAnimating];
    [self.view addSubview:label2];
}

#pragma mark - Action
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigatio
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
