//
//  CycleView.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/10/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "CycleView.h"

#define ViewWidth self.frame.size.width   //环形进度条的视图宽度
#define ProgressWidth 1                 //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth  //环形进度条的半径
@interface CycleView ()
{
    CAShapeLayer *arcLayer;
    UILabel *label;
    NSTimer *progressTimer;
    
}
@property (nonatomic,assign)CGFloat i;

@end

@implementation CycleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawArc:context];
    
}

-(void)drawArc:(CGContextRef)context{
    CGRect rectFrame = CGRectMake(0, 0, 110, 110); // frame
    UIRectFrame(rectFrame); // 绘制矩形
    
    [SeparatorColor setStroke];
    [[UIColor clearColor] setFill]; // color
    
    //  绘制圆形
    CGContextAddEllipseInRect(context, rectFrame);
    
    //  绘图
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
