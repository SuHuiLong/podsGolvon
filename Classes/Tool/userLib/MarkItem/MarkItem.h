//
//  MarkItem.h
//  Golvon
//
//  Created by Steven on 7/3/16.
//  Copyright © 2016 苏辉龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarkItem : NSObject

@property (nonatomic, assign) CGPoint centerStart;
@property (nonatomic, assign) CGPoint centerEnd;
@property (nonatomic, weak)   UIView *view;

/*! @brief 便利构造器
 *  @param view        视图
 *  @param centerStart 视图开始中点
 *  @param centerEnd   视图结束中点
 */
+ (instancetype)itemWithView:(UIView *)view centerStart:(CGPoint)centerStart centerEnd:(CGPoint)centerEnd;

/*! @brief 根据滑动百分比更新控件位置
 *  @param ratio 滑动比率
 */
- (void)updateViewPositionWithRatio:(CGFloat)ratio;

@end
