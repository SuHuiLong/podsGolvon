//
//  SucessView.m
//  SucessView
//
//  Created by shiyingdong on 16/7/22.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "SucessView.h"



@implementation SucessView


-(instancetype)initWithFrame:(CGRect)frame imageImageName:(NSString *)imageName descStr:(NSString *)desc{
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized(self) {
            _descStr = desc;
            _imageName = imageName;

            [self createUI];
        }
    }
    return self;
}


-(void)createUI{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWvertical(136), kHvertical(96))];
    backView.backgroundColor = rgba(0,0,0,0.7);
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5;

    
    _sucessImage = [[UIImageView alloc] initWithFrame: CGRectMake(kWvertical(52), kHvertical(21), kWvertical(32), kHvertical(32)) ];
    
    _sucessImage.image = [UIImage imageNamed:_imageName];

    
    _sucessLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, _sucessImage.y_height+kHvertical(6), kWvertical(130), kHvertical(17))];
    
    _sucessLabel.text = _descStr;
    _sucessLabel.textColor = [UIColor whiteColor];
    _sucessLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _sucessLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:backView];
    [self addSubview:_sucessImage];
    [self addSubview:_sucessLabel];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });

}



@end
