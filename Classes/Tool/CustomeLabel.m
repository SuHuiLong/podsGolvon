//
//  CustomeLabel.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "CustomeLabel.h"

@implementation CustomeLabel

-(instancetype)init{
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}
-(void)drawTextInRect:(CGRect)rect{
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
    
}
@end
