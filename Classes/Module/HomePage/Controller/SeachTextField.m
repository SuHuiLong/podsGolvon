//
//  SeachTextField.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/10/10.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SeachTextField.h"

@implementation SeachTextField
-(CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect inset = CGRectMake(bounds.origin.x+kWvertical(23), bounds.origin.y, bounds.size.width-25, bounds.size.height);//
    return inset;
}

@end
