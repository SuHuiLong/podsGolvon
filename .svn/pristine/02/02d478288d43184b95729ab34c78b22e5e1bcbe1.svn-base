//
//  CurrentViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "CurrentViewController.h"

@implementation CurrentViewController

-(UIViewController *)currentControll{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
