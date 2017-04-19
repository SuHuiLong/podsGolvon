//
//  LoopProgressView.m
//  test
//
//  Created by SHL on 2016/10/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoopProgressView.h"

#import <QuartzCore/QuartzCore.h>

#define ViewWidth self.frame.size.width   //环形进度条的视图宽度
#define ProgressWidth 2.5                 //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth  //环形进度条的半径

@interface LoopProgressView()
{
    CAShapeLayer *arcLayer;
    //杆数label
    UILabel *_label;
    //杆
    UILabel *_RodLabel;
    NSTimer *progressTimer;
}
@property (nonatomic,assign)int i;

@end

@implementation LoopProgressView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    _i=0;
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(progressContext, ProgressWidth);
    CGContextSetRGBStrokeColor(progressContext, 1, 1, 1, 0.4);
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, xCenter, yCenter, Radius, 0, 2*M_PI, 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    //    //绘制环形进度环
    CGFloat to = 1 * M_PI * 2; // - M_PI * 0.5为改变初始位置
    
    
    
    _label = [Factory createLabelWithFrame:CGRectMake(0, 0, self.width, self.height) textColor:WhiteColor fontSize:kHorizontal(56) Title:@"42"];
    _label.font = [UIFont fontWithName:Light size:kHorizontal(56)];
    _label.text = @"0";
    _label.center = CGPointMake(xCenter, yCenter);
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label sizeToFit];
    _label.frame = CGRectMake((self.width - _label.width)/2, 0, _label.width, self.height);

    [self addSubview:_label];
    
    _RodLabel = [Factory createLabelWithFrame:CGRectMake(_label.x_width + kWvertical(1), kHvertical(34), kWvertical(15), kHvertical(13)) textColor:WhiteColor fontSize:kHorizontal(9) Title:@"杆"];
    [self addSubview:_RodLabel];

    
    
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius startAngle:-to/4 endAngle:to clockwise:YES];
    arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;//46,169,230
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor=GPRGBAColor(255, 255, 255, 0.5).CGColor;
    arcLayer.lineWidth=ProgressWidth;
    arcLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:arcLayer];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self drawLineAnimation:arcLayer];
    });
    
    
    if (self.progress > 0) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
    }else if (self.progress == 0){
    
        [self sizeToFitLabel];
    }
}

-(void)newThread
{
    @autoreleasepool {
        
        
        CGFloat time = self.progress/[self.poleNumber floatValue]*0.8;
//        time = time/[self.poleNumber floatValue];
        
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
        
        
//        [progressTimer ]
        
        [[NSRunLoop currentRunLoop] run];
    }
}

//NSTimer不会精准调用
-(void)timeLabel
{
    _i += 1;
    if (_poleNumber.length>2) {
        _label.font = [UIFont fontWithName:Light size:kHorizontal(46)];
    }
    _label.text = [NSString stringWithFormat:@"%d",_i];
    if (_i >= [self.poleNumber integerValue]) {
        [progressTimer invalidate];
        progressTimer = nil;
    }
    [_label sizeToFit];
    _label.frame = CGRectMake((self.width - _label.width)/2, 0, _label.width, self.height);
    _RodLabel.frame = CGRectMake(_label.x_width + kWvertical(1), kHvertical(34), kWvertical(15), kHvertical(13));
 }

-(void)sizeToFitLabel{
    _label.text = _poleNumber;
    if (_poleNumber.length>2) {
        _label.font = [UIFont fontWithName:Light size:kHorizontal(48)];
    }
    [_label sizeToFit];

    _label.frame = CGRectMake((self.width - _label.width)/2, 0, _label.width, self.height);
    _RodLabel.frame = CGRectMake(_label.x_width + kWvertical(1), kHvertical(34), kWvertical(15), kHvertical(13));

}


//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration= _progress;//动画时间
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

@end
