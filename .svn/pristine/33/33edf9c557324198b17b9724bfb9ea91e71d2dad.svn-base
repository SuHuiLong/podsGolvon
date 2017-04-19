//
//  MarkAlertView.h
//  Golvon
//
//  Created by shiyingdong on 16/8/10.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkAlertView : UIView


typedef enum {
    /** pointedViewInLeft */
    MarkAlertViewModeLeft,
    /** pointedViewInRight */
    MarkAlertViewModeRight,
    /** pointedViewInTop */
    MarkAlertViewModeTop,
    /** pointedViewInBottom */
    MarkAlertViewModeBottom,
    /** pointedViewInCenterBottom */
    MarkAlertViewModeCenterBottom,
    /** pointedViewInLeftTop */
    MarkAlertViewModeLeftTop,
} MarkAlertViewMode;

@property (assign) MarkAlertViewMode mode;

@property(nonatomic,copy)UIView         *backView;//总背景
@property(nonatomic,copy)UIView         *labelBackView;//内容背景
@property(nonatomic,copy)UILabel        *contentLabel;//显示内容
@property(nonatomic,copy)UIImageView    *pointedView;//尖角图标

/**
 *  显示内容
 */
@property(nonatomic,copy)NSString       *content;
/**
 *  显示类型
 */
@property(nonatomic,copy)NSString       *type;


-(void)createWithContent:(NSString *)content;

-(void)removeFromView;

@end
