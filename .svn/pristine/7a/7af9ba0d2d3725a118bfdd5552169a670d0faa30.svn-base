//
//  NewSingleScroingScrollView.m
//  podsGolvon
//
//  Created by apple on 2016/10/10.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewSingleScroingScrollView.h"

@implementation NewSingleScroingScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - createView
-(void)createUI{
    _ParLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(140)) textColor:BlackColor fontSize:100.0f Title:@"3"];
    [_ParLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *PAR = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(118.0f), ScreenWidth, kHvertical(25.0f)) textColor:rgba(118,118,118,1) fontSize:kHorizontal(18.0f) Title:@"PAR"];
    [PAR setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *PuttersReduce = [Factory createButtonWithFrame:CGRectMake(kWvertical(86), self.height - kHvertical(330), kWvertical(50), kHvertical(50)) NormalImage:@"scoring减－灰" SelectedImage:@"scoring减－蓝" target:self selector:@selector(PuttersAddClick:)];
    [PuttersReduce setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(23), kWvertical(10), kWvertical(23), kWvertical(10))];
    
    
    UILabel *Putters = [Factory createLabelWithFrame:CGRectMake(0, self.height - kHvertical(317), ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(18.0f) Title:@"推杆"];

    [Putters setTextAlignment:NSTextAlignmentCenter];
    
    

    UIButton *PuttersAdd = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(135), PuttersReduce.y, kWvertical(50), kHvertical(50)) NormalImage:@"scoring加－灰" SelectedImage:@"scoring加－蓝" target:self selector:@selector(PuttersAddClick:)];
    [PuttersAdd setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(10), kWvertical(10), kHvertical(10), kWvertical(10))];
    
    
    
    UIButton *GrossReduce = [Factory createButtonWithFrame:CGRectMake(kWvertical(86), PuttersReduce.y_height+kHvertical(116), kWvertical(50), kHvertical(50)) NormalImage:@"scoring减－灰" SelectedImage:@"scoring减－蓝" target:self selector:@selector(GrossReduceClick:)];
    [GrossReduce setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(23), kWvertical(10), kWvertical(23), kWvertical(10))];

    UILabel *Gross = [Factory createLabelWithFrame:CGRectMake(0, Putters.y_height + kHvertical(141), ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(18.0f) Title:@"总杆"];
//    [Gross setFont:[UIFont boldSystemFontOfSize:kHorizontal(18.0f)]];
    [Gross setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *GrossAdd = [Factory createButtonWithFrame:CGRectMake(PuttersAdd.x, GrossReduce.y, kWvertical(50), kHvertical(50)) NormalImage:@"scoring加－灰" SelectedImage:@"scoring加－蓝" target:self selector:@selector(GrossAddClick:)];
    [GrossAdd setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(10), kWvertical(10), kHvertical(10), kWvertical(10))];

    
    
    UIView *RoundView = [Factory createViewWithBackgroundColor:rgba(53,141,227,1) frame:CGRectMake(ScreenWidth/2 - kWvertical(60), Putters.y_height+kHvertical(10), kHvertical(120), kHvertical(120))];
    RoundView.backgroundColor = rgba(53,141,227,1);
    RoundView.layer.masksToBounds = YES;
    RoundView.layer.cornerRadius = kWvertical(60);

    
    
    
    
    _GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(20), ScreenWidth, kHvertical(81)) textColor:WhiteColor fontSize:kHorizontal(68.0f) Title:@"10"];
    _Putters = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) textColor:WhiteColor fontSize:kHorizontal(25.0f) Title:@"9"];
    [self sizeToFitLabel];
    
    
    
    
    _PolePoorButton = [Factory createButtonWithFrame:CGRectMake(kWvertical(143) - kHvertical(8),Gross.y_height + kHvertical(35), kHvertical(32), kHvertical(32)) NormalImage:@"scoring距标准杆默认" SelectedImage:@"scoring距标准杆勾选" target:self selector:@selector(PolePoorButtonClick:)];
    [_PolePoorButton setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(8), kHvertical(8), kHvertical(8), kHvertical(8))];
    
    UILabel *PolePoorLabel = [Factory createLabelWithFrame:CGRectMake(_PolePoorButton.x_width, Gross.y_height + kHvertical(40), kWvertical(80), kHvertical(22)) textColor:rgba(169,169,169,1) fontSize:kHorizontal(16.0f) Title:@"距标准杆"];
    
    
//    [PuttersReduce setBackgroundColor:RandomColor];
//    [PuttersAdd setBackgroundColor:RandomColor];
//    [GrossReduce setBackgroundColor:RandomColor];
//    [GrossAdd setBackgroundColor:RandomColor];
//    [_PolePoorButton setBackgroundColor:RandomColor];
    PuttersAdd.selected = YES;
    GrossAdd.selected = YES;
    
    
    [self addSubview:_ParLabel];
    [self addSubview:PAR];
    
    [self addSubview:Putters];
    [self addSubview:PuttersReduce];
    [self addSubview:PuttersAdd];
    
    [self addSubview:Gross];
    [self addSubview:GrossReduce];
    [self addSubview:GrossAdd];
    
    [self addSubview:RoundView];
    [RoundView addSubview:_GrossLabel];
    [RoundView addSubview:_Putters];
    
    
    [self addSubview:_PolePoorButton];
    [self addSubview:PolePoorLabel];
    
}




#pragma mark - Action
//推杆+
-(void)GrossAddClick:(UIButton *)btn{


}
//推杆-
-(void)GrossReduceClick:(UIButton *)btn{
    
    
}
//杆数+
-(void)PuttersAddClick:(UIButton *)btn{
    
    
}
//杆数-
-(void)PuttersReduceClick:(UIButton *)btn{
    
    
}
//是否距标准杆
-(void)PolePoorButtonClick:(UIButton *)btn{
    
    
}



-(void)sizeToFitLabel{
    [_GrossLabel sizeToFit];
    _GrossLabel.frame = CGRectMake(kHvertical(120)/2 - _GrossLabel.width/2, _GrossLabel.y, _GrossLabel.width, _GrossLabel.height);
    
    _Putters.frame = CGRectMake(_GrossLabel.x_width, kHvertical(15), kWvertical(20), kHvertical(36));
    
    
    
}



@end









