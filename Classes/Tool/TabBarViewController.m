//
//  TabBarViewController.m
//  Golvon
//
//  Created by shiyingdong on 16/4/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "TabBarViewController.h"
#import "SelfNavigationViewController.h"
#import "HomePageViewController.h"
#import "FindAceViewController.h"
#import "NewStartScoringViewController.h"
#import "NewSelf_ViewController.h"
#import "FindViewController.h"
#import "ScoreCardViewController.h"

//榜单新的
#import "RankListViewController.h"
@interface TabBarViewController ()<UITabBarControllerDelegate>


@property (weak, nonatomic) UIViewController    *originalSelectedController;

@property (assign, nonatomic) int    controllId;

@end

@implementation TabBarViewController
-(void)setup
{
    //  添加突出按钮
    [self addCenterButtonWithImage:[UIImage imageNamed:@"NavigationBar_ScoreCardDefault"] selectedImage:[UIImage imageNamed:@"NavigationBar_ScoreCardSelected"]];
    self.delegate=self;
    
}
#pragma mark - addCenterButton
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    //  设定button大小为适应图片
    CGFloat W = buttonImage.size.width;
    CGFloat H = buttonImage.size.height;
    _button.frame = CGRectMake(self.tabBar.center.x - W/2, CGRectGetHeight(self.tabBar.bounds)-H - 8, W, H);
    
    [_button setImage:buttonImage forState:UIControlStateNormal];
    [_button setImage:selectedImage forState:UIControlStateSelected];
    
    _button.adjustsImageWhenHighlighted=NO;
    
    [self.tabBar addSubview:_button];
}

-(void)pressChange:(id)sender
{
    self.controllId = 2;
    self.selectedIndex=2;
    _button.selected=YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTabBarVC];
    [self setup];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];

    self.delegate=self;
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = YES;
    _originalSelectedController = self.viewControllers[0];
    self.controllId = 0;
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tabBar bringSubviewToFront:_button];

}
// 初始化所有子控制器
- (void)setTabBarVC{
    
    
    
    [self setTabBarChildController:[[HomePageViewController alloc] init] title:@"首页" image:@"NavigationBar_homeDefault" selectImage:@"NavigationBar_homeSelected"];
    
    [self setTabBarChildController:[[FindViewController alloc] init] title:@"发现" image:@"NavigationBar_FindDefault" selectImage:@"NavigationBar_FindSelected"];
    
    [self setTabBarChildController:[[NewStartScoringViewController alloc] init] title:@"" image:@"" selectImage:@""];

    [self setTabBarChildController:[[ScoreCardViewController alloc] init] title:@"榜单" image:@"NavigationBar_RankDefault" selectImage:@"NavigationBar_RankSelected"];

    
    [self setTabBarChildController:[[NewSelf_ViewController alloc] init] title:@"我的" image:@"NavigationBar_MyCenterDefault" selectImage:@"NavigationBar_MyCenterSelected"];
    
    [self createLaunchImageAnimation];
}
// 添加tabbar的子viewcontroller
- (void)setTabBarChildController:(UIViewController*)controller title:(NSString*)title image:(NSString*)imageStr selectImage:(NSString*)selectImageStr{
    
    SelfNavigationViewController * nav = [[SelfNavigationViewController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    
    nav.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:GPColor(151, 171, 189)} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:GPColor(53, 141, 227)} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
}


- (void)createLaunchImageAnimation {
    //增加一个 程序加载时候的启动动画。下面使我们自己实现的一个 隐藏的动画效果
    
    UIImageView * startView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"启动页"]];
    startView.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //tabr 的视图上
    [self.view addSubview:startView];
    [UIView animateWithDuration:4 animations:^{
        startView.alpha = 0;
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
    }];
   
}
- (BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return UIInterfaceOrientationPortrait;

}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark- TabBar Delegate

//  换页和button的状态关联上
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == tabBarController.viewControllers[0] && viewController == _originalSelectedController) {
        HomePageViewController *homeVC = [(UINavigationController *)viewController viewControllers][0];
        
            [homeVC startHeaderRefresh];
    }
    _originalSelectedController = viewController;
    
    if (self.selectedIndex==2) {
        _button.selected=YES;
        
    }else
    {
        _button.selected=NO;
    }
    
    
}
@end
