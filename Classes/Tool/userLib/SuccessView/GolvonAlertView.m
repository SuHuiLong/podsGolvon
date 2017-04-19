//
//  GolvonAlertView.m
//  podsGolvon
//
//  Created by SHL on 2016/11/8.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "GolvonAlertView.h"

@implementation GolvonAlertView
//是否继续记分
-(instancetype)initWithFrame:(CGRect)frame createContinueAlertViewBool:(BOOL)bol{
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized(self) {
            [self createContinueAlertView];
        }
    }
    return self;

}
//一般提示
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title leftBtn:(NSString *)leftStr right:(NSString *)rightStr{
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized(self) {
            _leftStr = leftStr;
            _rightStr = rightStr;
            _titleStr = title;
            [self createUI];
        }
    }
    return self;

}

//确认成绩
-(instancetype)initSureWithFrame:(CGRect)frame title:(NSString *)title leftBtn:(NSString *)leftStr right:(NSString *)rightStr{

    self = [super initWithFrame:frame];
    if (self) {
        @synchronized(self) {
            _leftStr = leftStr;
            _rightStr = rightStr;
            _titleStr = title;
            [self createSureUI];
        }
    }
    return self;

}

//缺少推杆
-(instancetype)initSureWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc leftBtn:(NSString *)leftStr right:(NSString *)rightStr{
    
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized(self) {
            _leftStr = leftStr;
            _rightStr = rightStr;
            _titleStr = title;
            _descStr = desc;
            [self createPoleUI];
        }
    }
    return self;
    
}
//周、月、年、最佳成绩提示
-(instancetype)initWithBestScoreAlertFrame:(CGRect)frame time:(NSString *)time desc:(NSString *)desc image:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized (self) {
            [self createBestView:time desc:desc image:imageName];
        }
    }
    return self;
}



//一般提示
-(void)createUI{

    UIView *backView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.5) frame:self.bounds];
    
    UIView *alertView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake((backView.width-kWvertical(279))/2, (backView.height-kHorizontal(125))/2, kWvertical(279), kHvertical(125))];
    
    _titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(4.5), kHvertical(26), kWvertical(270), kHvertical(25)) textColor:rgba(58,60,72,1) fontSize:kHorizontal(18) Title:_titleStr];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    _leftBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(23), kHvertical(77), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_leftStr];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _leftBtn.backgroundColor = localColor;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 2;

    
    _rightBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(147), kHvertical(77), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_rightStr];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_rightBtn setTitleColor:rgba(58,60,72,1) forState:UIControlStateNormal];
    _rightBtn.backgroundColor = WhiteColor;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 2;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = rgba(233,233,233,1).CGColor;
    
    
    [alertView addSubview:_titleLabel];
    [alertView addSubview:_leftBtn];
    [alertView addSubview:_rightBtn];
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = kHvertical(2);

    [backView addSubview:alertView];
    [self addSubview:backView];
}
//是否继续记分提示
-(void)createContinueAlertView{
    
    UIView *backView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.5) frame:self.bounds];

    UIView *alertView = [Factory createViewWithBackgroundColor:rgba(255,255,255,1) frame:CGRectMake((backView.width-kWvertical(211))/2, (backView.height-kHorizontal(288))/2, kWvertical(211), kHvertical(288))];
    _rightBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(69), kHvertical(28), kHvertical(73), kHvertical(73)) image:[UIImage imageNamed:@"createNewScore"] target:self selector:nil Title:nil];

    _leftBtn = [Factory createButtonWithFrame:CGRectMake(_rightBtn.x, kHvertical(156), kHvertical(73), kHvertical(73)) image:[UIImage imageNamed:@"continueScor"] target:self selector:nil Title:nil];
    UILabel *continueScorLabel = [Factory createLabelWithFrame:CGRectMake(0, _leftBtn.y_height + kHvertical(14), alertView.width, kHvertical(18)) textColor:rgba(49,49,49,1) fontSize:kHorizontal(13) Title:@"继续记分"];
    
    UILabel *createNewScoreLabel = [Factory createLabelWithFrame:CGRectMake(0, _rightBtn.y_height + kHvertical(14), alertView.width, kHvertical(18)) textColor:rgba(49,49,49,1) fontSize:kHorizontal(13) Title:@"重新记分"];
    
    [continueScorLabel setTextAlignment:NSTextAlignmentCenter];
    [createNewScoreLabel setTextAlignment:NSTextAlignmentCenter];
    
    [alertView addSubview:_leftBtn];
    [alertView addSubview:_rightBtn];
    [alertView addSubview:continueScorLabel];
    [alertView addSubview:createNewScoreLabel];
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = kHvertical(2);
    
    
    [self addSubview:backView];
    [self addSubview:alertView];
    self.userInteractionEnabled = YES;
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self addBlock];
        [self removeFromSuperview];
    }];
    [backView addGestureRecognizer:tap];
    
}

-(void)addBlock{
    if (_hideBolck) {
        self.hideBolck(@"1");
    }
}

-(void)setBlock:(hideBolck)block{
    self.hideBolck = block;
}


//确认成绩

-(void)createSureUI{

    UIView *backView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.5) frame:self.bounds];
    
    UIView *alertView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake((backView.width-kWvertical(302))/2, (backView.height-kHorizontal(165))/2, kWvertical(302), kHvertical(165))];

    _titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(4.5), kHvertical(26), alertView.width-kWvertical(9), kHvertical(80)) textColor:rgba(33,33,33,1) fontSize:kHorizontal(16) Title:_titleStr];
    _titleLabel.numberOfLines = 0;
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    _leftBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(34), kHvertical(105), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_leftStr];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _leftBtn.backgroundColor = localColor;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 2;
    
    
    _rightBtn = [Factory createButtonWithFrame:CGRectMake(alertView.width - kWvertical(144), kHvertical(105), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_rightStr];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_rightBtn setTitleColor:rgba(58,60,72,1) forState:UIControlStateNormal];
    _rightBtn.backgroundColor = WhiteColor;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 2;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = rgba(233,233,233,1).CGColor;
    
    
    [alertView addSubview:_titleLabel];
    [alertView addSubview:_leftBtn];
    [alertView addSubview:_rightBtn];
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = kHvertical(2);
    
    [backView addSubview:alertView];
    [self addSubview:backView];



}

//缺少推杆

-(void)createPoleUI{


    UIView *backView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.5) frame:self.bounds];
    
    UIView *alertView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake((backView.width-kWvertical(302))/2, (backView.height-kHorizontal(165))/2, kWvertical(302), kHvertical(165))];
    
    _titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(4.5), kHvertical(26), alertView.width-kWvertical(9), kHvertical(25)) textColor:rgba(33,33,33,1) fontSize:kHorizontal(16) Title:_titleStr];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, _titleLabel.y_height + kHvertical(9), alertView.width, kHvertical(20)) textColor:rgba(53,141,227,1) fontSize:kHorizontal(14) Title:_descStr];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    _leftBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(34), kHvertical(105), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_leftStr];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _leftBtn.backgroundColor = localColor;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 2;
    
    
    _rightBtn = [Factory createButtonWithFrame:CGRectMake(alertView.width - kWvertical(144), kHvertical(105), kWvertical(110), kHvertical(32)) target:self selector:nil Title:_rightStr];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_rightBtn setTitleColor:rgba(58,60,72,1) forState:UIControlStateNormal];
    _rightBtn.backgroundColor = WhiteColor;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 2;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = rgba(233,233,233,1).CGColor;
    
    
    [alertView addSubview:_titleLabel];
    [alertView addSubview:descLabel];
    [alertView addSubview:_leftBtn];
    [alertView addSubview:_rightBtn];
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = kHvertical(2);
    
    [backView addSubview:alertView];
    [self addSubview:backView];
}
//周、月、年、最佳成绩提示
-(void)createBestView:(NSString *)time desc:(NSString *)desc image:(NSString *)image{
    UIView *backView = [Factory createViewWithBackgroundColor:rgba(0,0,0,0.50) frame:self.bounds];
    
    UIView *alertView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake((backView.width-kWvertical(230))/2, (backView.height-kHorizontal(309))/2, kWvertical(230), kHvertical(309))];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = kHvertical(8);
    
    
    UIImageView *deleatView = [Factory createImageViewWithFrame:CGRectMake(alertView.x_width-kHvertical(15), alertView.y-kHvertical(15), kHvertical(30),kHvertical(30)) Image:[UIImage imageNamed:@"scoring-alertDeleat"]];
    deleatView.backgroundColor = ClearColor;
    
    UILabel *timeLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(57), alertView.width, kHvertical(17)) textColor:rgba(184,185,189,1) fontSize:kHorizontal(12) Title:time];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView *imageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(73), kHvertical(89), kWvertical(84), kHvertical(118)) Image:[UIImage imageNamed:image]];
    
    
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(231), alertView.width, kHvertical(18)) textColor:rgba(184,185,189,1) fontSize:kHorizontal(13) Title:desc];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    
    [descLabel sizeToFitSelf];
    descLabel.x = (alertView.width - descLabel.width)/2;
    
    CGFloat lableWidth = descLabel.width + kWvertical(10);
    
    UIView *leftLine = [Factory createViewWithBackgroundColor:rgba(184,185,189,1) frame:CGRectMake(kWvertical(33), kHvertical(239), (alertView.width - lableWidth - kWvertical(66))/2, 1)];
    UIView *rightLine = [Factory createViewWithBackgroundColor:rgba(184,185,189,1) frame:CGRectMake(kWvertical(33) + leftLine.width + lableWidth, kHvertical(239), leftLine.width, 1)];
    
    [alertView addSubview:timeLabel];
    [alertView addSubview:imageView];
    [alertView addSubview:descLabel];
    [alertView addSubview:leftLine];
    [alertView addSubview:rightLine];
    
    
    [self addSubview:backView];
    [self addSubview:alertView];
    [self addSubview:deleatView];
}


@end












