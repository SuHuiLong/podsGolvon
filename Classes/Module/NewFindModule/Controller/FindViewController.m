
//  FindViewController.m
//  podsGolvon
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "FindViewController.h"
#import "RecommendViewController.h"
#import "InterviewViewController.h"
#import "ActivityViewController.h"
#import "YSLContainerViewController.h"


@interface FindViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong) DownLoadDataSource   *loadData;
//标题
@property (nonatomic, strong) NSMutableArray   *titleArr;
//标题对应type
@property (nonatomic, strong) NSMutableArray   *typeArr;
//是否能报名
@property (nonatomic, strong) NSMutableArray   *canSendArray;
@end

@implementation FindViewController


-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
-(NSMutableArray *)typeArr{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
-(NSMutableArray *)canSendArray{
    if (!_canSendArray) {
        _canSendArray = [NSMutableArray array];
    }
    return _canSendArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigation];
    [self requestData];
}
#pragma mark ---- createUI
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
-(void)createNavigation{
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    titleView.textColor = deepColor;
    titleView.text = @"发现";
    [titleView sizeToFit];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
}

-(void)requestData{
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=findtop",urlHeader120] parameters:nil complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArr = data;
            for (NSInteger i = 0; i<[tempArr count]; i++) {
                [self.titleArr addObject:data[i][@"content"]];
                [self.typeArr addObject:data[i][@"typenum"]];
                NSString *joinstatr = data[i][@"joinstatr"];
                if (joinstatr) {
                    [self.canSendArray addObject:joinstatr];
                }
            }
            [self createUI];
        }
    }];
    
}
-(void)createUI{
    //推荐
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    recommendVC.type = self.typeArr[0];
    recommendVC.title = self.titleArr[0];
    
    //专访
    InterviewViewController *interviewVC = [[InterviewViewController alloc] init];
    interviewVC.type = self.typeArr[1];
    interviewVC.title = self.titleArr[1];
    
    NSMutableArray *childVCArr = [NSMutableArray arrayWithObjects:recommendVC,interviewVC, nil];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.typeArr];
    [tempArr removeObjectAtIndex:0];
    [tempArr removeObjectAtIndex:0];
    
    NSMutableArray *tempTitleArr = [NSMutableArray arrayWithArray:self.titleArr];
    [tempTitleArr removeObjectAtIndex:0];
    [tempTitleArr removeObjectAtIndex:0];

    NSMutableArray *canSendArray = [NSMutableArray arrayWithArray:self.canSendArray];
    if (canSendArray.count>0) {
        
    }
    [canSendArray removeObjectAtIndex:0];
    [canSendArray removeObjectAtIndex:0];

    
    for (NSInteger i = 0; i<[tempArr count]; i++) {
        ActivityViewController *VC = [[ActivityViewController alloc] init];
        VC.type = tempArr[i];
        VC.title =
  //@[@"单个",@"三个个个",@"八个哥哥哥哥"][i];
        tempTitleArr[i];
        VC.joinstatr = canSendArray[i];
        [childVCArr addObject:VC];
    }
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;

    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc] initWithControllers:childVCArr topBarHeight:statusHeight + navigationHeight parentViewController:self];

    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont systemFontOfSize:kHorizontal(16)];
    [self.view addSubview:containerVC.view];
}

#pragma mark ---- delegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
}

@end
