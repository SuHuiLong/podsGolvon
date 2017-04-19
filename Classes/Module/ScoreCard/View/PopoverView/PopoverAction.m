//
//  PopoverAction.m
//  Popover
//
//  Created by StevenLee on 2017/1/4.
//  Copyright © 2017年 StevenLee. All rights reserved.
//

#import "PopoverAction.h"

@interface PopoverAction ()

@property (nonatomic, assign, readwrite) BOOL isSelected; ///< 是否已经选中
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) void(^handler)(PopoverAction *action); ///< 选择回调

@end

@implementation PopoverAction

+ (instancetype)actionWithTitle:(NSString *)title isSelected:(BOOL)isSelected handler:(void (^)(PopoverAction *action))handler {
    PopoverAction *action = [[self alloc] init];
    action.isSelected = isSelected;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}

@end
