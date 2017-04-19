//
//  SegmentControlBottomView.h
//  FindModule
//
//  Created by apple on 2016/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentControlBottomView : UIScrollView

/** 子控制器的个数 */
@property (nonatomic, strong) NSArray *childViewController;

/** 对象方法创建 SGSegmentedControlBottomView */
- (instancetype)initWithFrame:(CGRect)frame;
/** 类方法创建 SGSegmentedControlBottomView */
+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame;

/**
 *  展示对应下标的对应子控制器的view（给外界提供的方法 -> 必须实现）
 *  @param index    外界控制器子控制器View的下标
 *  @param outsideVC    外界控制器（主控制器、self的父控制器）
 */
- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)outsideVC;

@end
