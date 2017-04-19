//
//  DrawRectLineView.m
//  podsGolvon
//
//  Created by SHL on 2016/10/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "DrawRectLineView.h"

@implementation DrawRectLineView

- (void)drawRect:(CGRect)rect {
    switch (_DrawRectLineViewStyle) {
        case DrawRectLineViewStyleLine:{
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, _lineWidth);  //线宽
            CGContextSetAllowsAntialiasing(context, true);
            CGContextSetRGBStrokeColor(context, [_lineColorArray[0] floatValue] / 255.0, [_lineColorArray[1] floatValue] / 255.0, [_lineColorArray[2] floatValue] / 255.0, [_lineColorArray[3] floatValue]);  //线的颜色
            CGContextBeginPath(context);
            
            CGContextMoveToPoint(context, _begainRect.x,_begainRect.y);  //起点坐标
            CGContextAddLineToPoint(context, _endRect.x,_endRect.y);   //终点坐标
            CGContextStrokePath(context);
        }break;
        case DrawRectLineViewStyleRectangle:{
            //创建路径并获取句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形
            CGRect rectangle = CGRectMake(_lineWidth,_lineWidth,_endRect.x - _begainRect.x,_endRect.y - _begainRect.y);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();
            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
            //设置矩形填充色
            [_contentColor setFill];
            //矩形边框颜色
            [GPRGBAColor([_lineColorArray[0] floatValue], [_lineColorArray[1] floatValue], [_lineColorArray[2] floatValue], [_lineColorArray[3] floatValue]) setStroke];
            //边框宽度
            CGContextSetLineWidth(currentContext,_lineWidth);
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);
        }break;
        case DrawRectLineViewStyletriangle:{
            NSLog(@"2");
        }break;
            
        default:
            break;
    }
}
@end









