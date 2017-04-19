//
//  DrawArc.m
//  podsGolvon
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "DrawArc.h"

@implementation DrawArc

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //中间镂空的矩形框
    CGRect leftRect = CGRectMake(kWvertical(29),kHvertical(87),kWvertical(80), kWvertical(80));
    CGRect rightRect = CGRectMake(self.frame.size.width - kWvertical(29) - kWvertical(80),kHvertical(87),kWvertical(80), kWvertical(80));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //背景色
    //[[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.jpg"]] set];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    
    //画圆
    CGContextAddEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    //填充
    CGContextFillPath(ctx);
}
@end
