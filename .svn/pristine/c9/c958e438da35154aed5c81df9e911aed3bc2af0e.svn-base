//
//  PopoverView.h
//  Popover
//
//  Created by StevenLee on 2017/1/4.
//  Copyright © 2017年 StevenLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside; ///< 是否开启点击外部隐藏弹窗, 默认为YES.

+ (instancetype)popoverView;

/*! @brief 指向指定的点来显示弹窗
 *  @param toPoint       箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 *  @param titles        标题字符串集合
 *  @param selectedIndex 选中的下标
 *  @param handler       选择后的Block回调 (此Block不会导致内存泄露, 不用刻意设置弱引用)
 */
- (void)showToPoint:(CGPoint)toPoint withTitles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex handler:(void(^)(NSUInteger selectedIndex))handler;

@end



#pragma mark - Custom Cell
@interface PopoverViewCell : UITableViewCell

/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

- (void)setTitle:(NSString *)title;

@end
