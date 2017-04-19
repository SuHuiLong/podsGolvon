//
//  SegmentControlControlStatic.h
//  FindModule
//
//  Created by apple on 2016/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentControlControlStatic;
@protocol SegmentControlControlStaticDelegate <NSObject>

- (void)SGSegmentedControlStatic:(SegmentControlControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index;


@end

@interface SegmentControlControlStatic : UIScrollView

/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;


@property (nonatomic, weak) id<SegmentControlControlStaticDelegate> delegate;



/** 对象方法创建 SGSegmentedControlStatic */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

/** 类方法创建 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

/** 对象方法创建，带有图片的 SGSegmentedControlStatic */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
/** 类方法创建，带有图片的 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

@end
