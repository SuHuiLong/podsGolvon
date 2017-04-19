//
//  MarkItem.m
//  Golvon
//
//  Created by Steven on 7/3/16.
//  Copyright © 2016 苏辉龙. All rights reserved.
//

#import "MarkItem.h"

@implementation MarkItem

- (instancetype)initWithView:(UIView *)view centerStart:(CGPoint)centerStart centerEnd:(CGPoint)centerEnd
{
    if (!(self = [super init])) return nil;
    
    self.view = view;
    self.centerStart = centerStart;
    self.centerEnd = centerEnd;
    // 将视图放在起始位置
    self.view.center = self.centerStart;
    
    return self;
}

/*! @brief 便利构造器
 *  @param view        视图
 *  @param centerStart 视图开始中点
 *  @param centerEnd   视图结束中点
 */
+ (instancetype)itemWithView:(UIView *)view centerStart:(CGPoint)centerStart centerEnd:(CGPoint)centerEnd
{
    return [[MarkItem alloc] initWithView:view centerStart:centerStart centerEnd:centerEnd];
    
    
}

/*! @brief 根据滑动百分比更新控件位置 */
- (void)updateViewPositionWithRatio:(CGFloat)ratio
{
    self.view.center = CGPointMake(self.centerStart.x+(self.centerEnd.x-self.centerStart.x)*ratio, self.centerStart.y+(self.centerEnd.y-self.centerStart.y)*ratio);
}

@end
