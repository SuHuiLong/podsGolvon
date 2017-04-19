//
//  DrawRectLineView.h
//  podsGolvon
//
//  Created by SHL on 2016/10/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawRectLineView : UIView

typedef NS_ENUM(NSInteger, DrawRectLineViewStyle) {
    //直线
    DrawRectLineViewStyleLine,
    //矩形
    DrawRectLineViewStyleRectangle,
    //三角形
    DrawRectLineViewStyletriangle
};
@property(nonatomic,assign)NSInteger DrawRectLineViewStyle;


//线宽
@property(nonatomic,assign)CGFloat  lineWidth;
//颜色
@property(nonatomic,copy)NSArray  *lineColorArray;
//起点
@property(nonatomic,assign)CGPoint  begainRect;
//终点
@property(nonatomic,assign)CGPoint  endRect;

@property(nonatomic,copy)UIColor  *contentColor;


@end
