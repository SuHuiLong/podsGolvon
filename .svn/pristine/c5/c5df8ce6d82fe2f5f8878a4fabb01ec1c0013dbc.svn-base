//
//  userTopNavigation.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "UserTopNavigation.h"

@implementation UserTopNavigation

- (instancetype)init
{
    self = [super init];
    if (self) {
        @synchronized (self) {
            [self createView];
        }
    }
    return self;
}

-(void)createView{
    self.frame = CGRectMake(0, 0, ScreenWidth, 64);
    self.backgroundColor = WhiteColor;
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,WScale(15),64)];
    [self addSubview:_leftBtn];
    
    _rightBtn= [[UIButton alloc] initWithFrame:CGRectMake(WScale(85),0,WScale(15),64)];
    [self addSubview:_rightBtn];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, kHvertical(31.5), 120, 15)];
    if (self.frame.size.height <= 568)
    {
        _title.font = [UIFont systemFontOfSize:kHorizontal(20)];
    }
    else if (self.frame.size.height > 568 && self.frame.size.height <= 667)
    {
        _title.font = [UIFont systemFontOfSize:kHorizontal(18)];
    }else{
        _title.font = [UIFont systemFontOfSize:kHorizontal(17)];
    }
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
    _line.backgroundColor = NAVLINECOLOR;
    [self addSubview:_line];
    
    
//    [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _title.hidden = YES;
    _line.hidden = YES;

}

-(void)createLeftWithImage:(id)leftView{
    _leftBtn.hidden = NO;
    if (leftView) {
        [_leftBtn addSubview:leftView];
    }
}

-(void)createRightWithImage:(id)rightView{
    _rightBtn.hidden = NO;
    _rightBtn.userInteractionEnabled = YES;
    if (rightView) {
        [_rightBtn addSubview:rightView];
    }
}

-(void)createTitleWith:(NSString *)titleStr{
    _title.hidden = NO;
    _title.text = titleStr;
}

-(void)isViewLine:(BOOL)isView{
    if (isView) {
        _line.hidden = NO;
    }else{
    
    }
}

@end
