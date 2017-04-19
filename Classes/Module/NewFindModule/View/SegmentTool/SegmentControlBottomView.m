//
//  SegmentControlBottomView.m
//  FindModule
//
//  Created by apple on 2016/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SegmentControlBottomView.h"

@implementation SegmentControlBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
+(instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame{
    return [[self alloc] initWithFrame:frame];
}

/**
 *  给外界提供的方法（必须实现）
 *  @param index    外界控制器子控制器View的下表
 *  @param outsideVC    外界控制器（主控制器、self的父控制器）
 */
- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)outsideVC {
    
    CGFloat offsetX = index * self.frame.size.width;
    
    UIViewController *vc = outsideVC.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setChildViewController:(NSArray *)childViewController {
    _childViewController = childViewController;
    
    self.contentSize = CGSizeMake(self.frame.size.width * childViewController.count, 0);
}

@end
