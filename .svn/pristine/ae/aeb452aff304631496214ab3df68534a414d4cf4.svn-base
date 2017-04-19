//
//  MarkAlertView.m
//  Golvon
//
//  Created by shiyingdong on 16/8/10.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "MarkAlertView.h"

@implementation MarkAlertView

/**
 *  top kHvertical(7)
 *  left kWvertical(3)
 *  right kWvertical(6)
 *
 *  bottom kHvertical(26)
 */


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized (self) {
            [self createUI];
        }
    }
    return self;
}

-(void)createUI{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kHvertical(33))];
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    
    _labelBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(7), 20, kHvertical(22))];
    _labelBackView.backgroundColor = GPColor(32,190,189);
    _labelBackView.layer.masksToBounds = YES;
    _labelBackView.layer.cornerRadius = 2.0f;
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(10), kHvertical(11), 10, kHvertical(16))];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    
    _pointedView = [[UIImageView alloc] init];
    _pointedView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_labelBackView];
    [self addSubview:_contentLabel];
    [self addSubview:_pointedView];
}



-(void)createWithContent:(NSString *)content{
    
    _contentLabel.text = content;
    [_contentLabel sizeToFit];
    
    _labelBackView.frame = CGRectMake(0, kHvertical(7), _contentLabel.frame.size.width+kWvertical(20), kHvertical(22));
    
    _backView.frame = CGRectMake(0, 0, _labelBackView.frame.size.width+kWvertical(6), kHvertical(33));
    
    [self cretePointWithMode];
}


-(void)cretePointWithMode{
    if (_mode == MarkAlertViewModeLeft) {
        _pointedView.frame = CGRectMake(0, kHvertical(24 ), kWvertical(9), kHvertical(9));
        _pointedView.image = [UIImage imageNamed:@"提示下"];
    }else if (_mode == MarkAlertViewModeRight){
        _pointedView.frame = CGRectMake(_labelBackView.frame.size.width-kWvertical(3), kHvertical(12), kWvertical(9), kHvertical(12));
        _pointedView.image = [UIImage imageNamed:@"提示右"];
    }else if (_mode == MarkAlertViewModeTop){
        _pointedView.frame = CGRectMake(_labelBackView.frame.size.width/2 - kWvertical(9), 0, kWvertical(18), kHvertical(10));
        _pointedView.image = [UIImage imageNamed:@"提示上"];
    }else if (_mode == MarkAlertViewModeCenterBottom){
        _pointedView.frame = CGRectMake(_labelBackView.frame.size.width/2 - kWvertical(9), kHvertical(24), kWvertical(18), kHvertical(10));
        _pointedView.image = [UIImage imageNamed:@"提示中心下"];
        
    }else if (_mode == MarkAlertViewModeLeftTop){
        _pointedView.frame = CGRectMake(0 , kHvertical(4), kWvertical(9), kHvertical(9));
        _pointedView.image = [UIImage imageNamed:@"提示左边上"];
    }

}

-(void)removeFromView{
    
    [self removeFromSuperview];
}

@end

