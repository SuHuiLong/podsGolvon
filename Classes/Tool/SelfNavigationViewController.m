//
//  SelfNavigationViewController.m
//  podsGolvon
//
//  Created by SHL on 2017/1/12.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import "SelfNavigationViewController.h"

@interface SelfNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SelfNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    if (translation.x <= 0) {
        return NO;
    }
    if ([self.topViewController isKindOfClass:NSClassFromString(@"NewStatisticsViewController")]||[self.topViewController isKindOfClass:NSClassFromString(@"GroupStatisticsViewController")] || [self.topViewController isKindOfClass:NSClassFromString(@"InterviewDetileViewController")]) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
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
