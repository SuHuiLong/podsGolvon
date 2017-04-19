//
//  AddGolferViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "AddGolferViewController.h"

#import "AddByInputViewController.h"
#import "AddByAddressBookViewController.h"
#import "GolfersViewController.h"
#import "GolfersModel.h"

#import "SegmentButton.h"
#import "SegmentControlBottomView.h"
#import "SegmentControlControlStatic.h"

@interface AddGolferViewController ()<SegmentControlControlStaticDelegate,UIScrollViewDelegate>
//标题
@property (nonatomic, strong) SegmentControlControlStatic *titleView;
//下划线
@property (nonatomic, strong) SegmentControlBottomView *bottomSView;


@end

@implementation AddGolferViewController
-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
    [self reciveNotice];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];


}
//接收更改数据通知
-(void)reciveNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPlayerData:) name:@"playerChangeNotice" object:nil];
}

-(void)reloadPlayerData:(NSNotification *)notice{
    NSDictionary *userInfo = notice.userInfo;
    GolfersModel *model = [GolfersModel modelWithDictionary:userInfo];
    if ([[userInfo objectForKey:@"isSelect"] isEqualToString:@"1"]){
        for (GolfersModel *Model in _selectPlayerArray) {
            if ([Model.addType isEqualToString:model.addType]&&[Model.addType integerValue]>1) {
                [_selectPlayerArray removeObject:Model];
            }
        }
        [_selectPlayerArray addObject:model];
        
    }else{
        
        for (int i = 0; i<_selectPlayerArray.count; i++) {
            GolfersModel *Model = _selectPlayerArray[i];
            if ([Model.uid isEqualToString:model.uid]) {
                [_selectPlayerArray removeObject:Model];
            }
            if ([Model.phoneStr isEqualToString:model.phoneStr]) {
                [_selectPlayerArray removeObject:Model];
            }
            
        }
        
//        for (GolfersModel *Model in _selectPlayerArray) {
//        }
    }
    
    
    [userDefaults setValue:[NSString stringWithFormat:@"%ld",_selectPlayerArray.count] forKey:@"selectPlayerNum"];
    
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createSegmentView];
}

//上导航

-(void)createNavigationView{
    self.navigationItem.title = @"球员添加";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];
    //左边按钮
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popToBack)];
    [leftBarbutton setImage:[UIImage imageNamed:@"BlackBack"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    //右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

//创建segmentController
-(void)createSegmentView{
    
    
    AddByInputViewController *inputVC = [[AddByInputViewController alloc] init];
    
    AddByAddressBookViewController *addressVC = [[AddByAddressBookViewController alloc] init];
    
    GolfersViewController *golferVC = [[GolfersViewController alloc] init];
   
    inputVC.selectPlayerArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
    addressVC.selectPlayerArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
    golferVC.selectPlayerArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
    
    
    
    [self addChildViewController:golferVC];
    [self addChildViewController:addressVC];
    [self addChildViewController:inputVC];
    
    
    NSArray *childVCArr = @[golferVC,inputVC,addressVC];
    NSArray *titleArr = @[@"球友",@"手机联系人",@"手动添加"];
    
    self.bottomSView = [[SegmentControlBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVCArr;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    [self.view addSubview:_bottomSView];
    
    self.titleView = [SegmentControlControlStatic segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, kHvertical(45)) delegate:self childVcTitle:titleArr];
    [self.view addSubview:_titleView];

}

#pragma mark - Action
//返回
-(void)popToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//完成
-(void)clickDone{
    
    if (self.SelectPlayerblock !=nil) {
        self.SelectPlayerblock(_selectPlayerArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickDone:(SelectPlayerblock)block{
    self.SelectPlayerblock = block;
}

#pragma mark - Delegate

- (void)SGSegmentedControlStatic:(SegmentControlControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    NSLog(@"index - - %ld", (long)index);
    if (index == 2) {
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"selectAddByInput" object:nil userInfo:@{@"num":[NSString stringWithFormat:@"%ld",_selectPlayerArray.count]}];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"hidenInputKeybord" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    // 2.把对应的标题选中
    [self.titleView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
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
