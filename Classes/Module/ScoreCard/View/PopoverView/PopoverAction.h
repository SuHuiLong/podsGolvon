//
//  PopoverAction.h
//  Popover
//
//  Created by StevenLee on 2017/1/4.
//  Copyright © 2017年 StevenLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopoverAction : NSObject

@property (nonatomic, assign, readonly) BOOL isSelected; ///< 是否已经选中
@property (nonatomic, copy, readonly) NSString *title; ///< 标题
@property (nonatomic, copy, readonly) void(^handler)(PopoverAction *action); ///< 选择回调, 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.

+ (instancetype)actionWithTitle:(NSString *)title isSelected:(BOOL)isSelected handler:(void (^)(PopoverAction *action))handler;

@end
