//
//  MatchScrollView.m
//  podsGolvon
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "MatchScrollView.h"
#import "Factory.h"
@interface MatchScrollView()


@end

@implementation MatchScrollView

-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dict{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        _indexPoleData = dict;
        [self createUI];
    }
    return self;
}



#pragma mark - createView
-(void)createUI{
    _PolePoorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BOOL isSelect = NO;
    NSString *isSelectStr = [_indexPoleData objectForKey:@"isSelectStr"];
    if ([isSelectStr isEqualToString:@"1"]) {
        isSelect = YES;
    }
    _PolePoorButton.selected = isSelect;
    _ParLabelStr = [_indexPoleData objectForKey:@"Par"];
    
    [self createOperateView];
}


//操作成绩界面
-(void)createOperateView{
    
    __weak typeof(self) weakself = self;

    NSString *GrossLabelStr = [_indexPoleData objectForKey:@"gross"];
    NSString *PuttersStr = [_indexPoleData objectForKey:@"putters"];
    
    _PuttersReduce = [Factory createButtonWithFrame:CGRectMake(kWvertical(86), self.height - kHvertical(330), kWvertical(50), kHvertical(50)) NormalImage:@"scoring减－灰" SelectedImage:@"scoring减－蓝" target:self selector:nil];
    [_PuttersReduce setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(23), kWvertical(10), kWvertical(23), kWvertical(10))];
    
    UITapGestureRecognizer *PuttersReduceTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself PuttersReduceClick:_PuttersReduce];
    }];
    [_PuttersReduce addGestureRecognizer:PuttersReduceTap];

    UILabel *Putters = [Factory createLabelWithFrame:CGRectMake(0, self.height - kHvertical(317), ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(18.0f) Title:@"推杆"];
    
    [Putters setTextAlignment:NSTextAlignmentCenter];
    
    
    _PuttersAdd = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(135), _PuttersReduce.y, kWvertical(50), kHvertical(50)) NormalImage:@"scoring加－灰" SelectedImage:@"scoring加－蓝" target:self selector:nil];
    
    [_PuttersAdd setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(10), kWvertical(10), kHvertical(10), kWvertical(10))];
    UITapGestureRecognizer *PuttersAddTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself PuttersAddClick:_PuttersAdd];
    }];
    [_PuttersAdd addGestureRecognizer:PuttersAddTap];
    
    _GrossReduce = [Factory createButtonWithFrame:CGRectMake(kWvertical(86), _PuttersReduce.y_height+kHvertical(116), kWvertical(50), kHvertical(50)) NormalImage:@"scoring减－灰" SelectedImage:@"scoring减－蓝" target:self selector:nil];
    UITapGestureRecognizer *GrossReduceTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself GrossReduceClick:_GrossReduce];
    }];
    [_GrossReduce addGestureRecognizer:GrossReduceTap];

    [_GrossReduce setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(23), kWvertical(10), kWvertical(23), kWvertical(10))];
    
    _Gross = [Factory createLabelWithFrame:CGRectMake(0, Putters.y_height + kHvertical(141), ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:kHorizontal(18.0f) Title:@"总杆"];
    [_Gross setTextAlignment:NSTextAlignmentCenter];
    
    _GrossAdd = [Factory createButtonWithFrame:CGRectMake(_PuttersAdd.x, _GrossReduce.y, kWvertical(50), kHvertical(50)) NormalImage:@"scoring加－灰" SelectedImage:@"scoring加－蓝" target:self selector:nil];
    UITapGestureRecognizer *GrossAddTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself GrossAddClick:_GrossAdd];
    }];
    [_GrossAdd addGestureRecognizer:GrossAddTap];

    [_GrossAdd setContentEdgeInsets:UIEdgeInsetsMake(kHvertical(10), kWvertical(10), kHvertical(10), kWvertical(10))];
    
    
    _RoundView = [Factory createViewWithBackgroundColor:rgba(53,141,227,1) frame:CGRectMake(ScreenWidth/2 - kWvertical(60), Putters.y_height+kHvertical(10), kHvertical(120), kHvertical(120))];
    _RoundView.backgroundColor = rgba(53,141,227,1);
    _RoundView.layer.masksToBounds = YES;
    _RoundView.layer.cornerRadius = kWvertical(60);
    
    if ([GrossLabelStr isEqualToString:@"0"]) {
        GrossLabelStr = _ParLabelStr;
        _RoundView.backgroundColor = LightGrayColor;
    }
    
    _GrossLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(120)) textColor:WhiteColor fontSize:kHorizontal(72.0f) Title:GrossLabelStr];
    //    _ParLabel.text
    _Putters = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) textColor:WhiteColor fontSize:kHorizontal(25.0f) Title:PuttersStr];
    _ModifiedLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(8.0f), 0, kWvertical(46.0f), kHvertical(111))textColor:WhiteColor fontSize:kHorizontal(46.0f) Title:@"-"];
    [_ModifiedLabel setTextAlignment:NSTextAlignmentCenter];
    _ModifiedLabel.hidden = YES;
    [self sizeToFitLabel];
    
    _PuttersReduce.selected = YES;
    _PuttersAdd.selected = YES;
    _GrossReduce.selected = YES;
    _GrossAdd.selected = YES;
    
    if ([GrossLabelStr integerValue]==1) {
        _GrossReduce.selected = NO;
    }
    
    if ([GrossLabelStr integerValue]-[_ParLabelStr integerValue]==9) {
        _GrossAdd.selected = NO;
    }
    
    if ([PuttersStr integerValue]==0) {
        _PuttersReduce.selected = NO;
    }
    
    if ([PuttersStr integerValue]==10) {
        _PuttersAdd.selected = NO;
    }
    
    
    [self addSubview:Putters];
    [self addSubview:_PuttersReduce];
    [self addSubview:_PuttersAdd];
    
    [self addSubview:_Gross];
    [self addSubview:_GrossReduce];
    [self addSubview:_GrossAdd];
    
    [self addSubview:_RoundView];
    [_RoundView addSubview:_GrossLabel];
    [_RoundView addSubview:_Putters];
    [_RoundView addSubview:_ModifiedLabel];
}

//标准杆操作
-(void)ParLabelClick{
    NSInteger parNum = [_ParLabelStr integerValue];
    NSInteger GrossNum = [_GrossLabel.text integerValue];
    
    switch (parNum) {
        case 3:{
            parNum++;
            _GrossReduce.selected = YES;
        }break;
        case 4:{
            parNum++;
            _GrossReduce.selected = YES;
        }break;
        case 5:{
            parNum = 3;
            if (GrossNum<=-2) {
                _GrossLabel.text = @"-2";
                [self sizeToFitLabel];
                _GrossReduce.selected = NO;
            }
        }break;
        default:
            break;
    }
    _ParLabelStr = [NSString stringWithFormat:@"%ld",(long)parNum];
    
    [self addBlock];
}

//杆数-
-(void)GrossReduceClick:(UIButton *)btn{
    _GrossAdd.selected = YES;
    NSInteger GrossNum = [_GrossLabel.text integerValue];
    NSInteger ParLabelStr = [_ParLabelStr integerValue];
    if ([_RoundView.backgroundColor isEqual:LightGrayColor]) {
        _RoundView.backgroundColor = localColor;
        _GrossLabel.text = [NSString stringWithFormat:@"%ld",(long)ParLabelStr];
        if (_PolePoorButton.selected) {
            _GrossLabel.text = @"0";
        }
    }else{
        
        NSInteger canEditMin = 0;
        NSString  *Positive = @"";
        if (_PolePoorButton.selected) {
            if (ParLabelStr == 3) {
                canEditMin = -2;
            }else if (ParLabelStr == 4){
                canEditMin = -3;
            }else if (ParLabelStr == 5){
                canEditMin = -4;
            }
        }else{
            canEditMin = 1;
        }
        if (GrossNum<=canEditMin) {
            return;
        }
        btn.selected = YES;
        if (GrossNum==canEditMin + 1) {
            btn.selected = NO;
        }
        
        _GrossLabel.text = [NSString stringWithFormat:@"%@%ld",Positive,(long)GrossNum-1];;
    }
    
    [self sizeToFitLabel];
    [self addBlock];
    
    NSString *grossText = _GrossLabel.text;
    if (_PolePoorButton.selected) {
        grossText = [NSString stringWithFormat:@"%ld",[grossText integerValue] + [_ParLabelStr integerValue]];
    }
    NSString *puttersText = _Putters.text;
    if ([puttersText integerValue]>=[grossText integerValue]) {
        [self PuttersReduceClick:_PuttersReduce];
    }
}

//杆数+
-(void)GrossAddClick:(UIButton *)btn{
    _GrossReduce.selected = YES;
    NSInteger GrossNum = [_GrossLabel.text integerValue];
    NSInteger ParLabelStr = [_ParLabelStr integerValue];
    if ([_RoundView.backgroundColor isEqual:LightGrayColor]) {
        _RoundView.backgroundColor = localColor;
        _GrossLabel.text = [NSString stringWithFormat:@"%ld",(long)ParLabelStr];
        if (_PolePoorButton.selected) {
            _GrossLabel.text = @"0";
        }
    }else{
    NSInteger canEditMax = 12;
    NSString  *Positive = @"";
    if (ParLabelStr == 3) {
        canEditMax = 12;
    }else if(ParLabelStr == 4){
        canEditMax = 13;
    }else if(ParLabelStr == 5){
        canEditMax = 14;
    }
    
    if (_PolePoorButton.selected) {
        canEditMax = 9;
//        if (GrossNum>-1) {
//            Positive = @"+";
//        }
    }
    if (GrossNum>=canEditMax) {
        return;
    }
    btn.selected = YES;
    if (GrossNum==canEditMax-1) {
        btn.selected = NO;
    }
    _GrossLabel.text = [NSString stringWithFormat:@"%@%ld",Positive,(long)GrossNum+1];
   
    }
    [self sizeToFitLabel];
    [self addBlock];
    
}

//推杆-
-(void)PuttersReduceClick:(UIButton *)btn{
    if ([_RoundView.backgroundColor isEqual:LightGrayColor]) {
        [self GrossAddClick:_GrossAdd];
    }

    _PuttersAdd.selected = YES;
    NSInteger PuttersNum = [_Putters.text integerValue];
    if (PuttersNum==0) {
        return;
    }
    btn.selected = YES;
    if (PuttersNum==1) {
        btn.selected = NO;
    }
    _Putters.text = [NSString stringWithFormat:@"%ld",(long)PuttersNum-1];
    [self sizeToFitLabel];
    [self addBlock];
    
}


//推杆+
-(void)PuttersAddClick:(UIButton *)btn{
    if ([_RoundView.backgroundColor isEqual:LightGrayColor]) {
        [self GrossAddClick:_GrossAdd];
    }
    _PuttersReduce.selected = YES;
    NSInteger PuttersNum = [_Putters.text integerValue];
    if (PuttersNum==10) {
        return;
    }
    btn.selected = YES;
    if (PuttersNum==9) {
        btn.selected = NO;
    }
    _Putters.text = [NSString stringWithFormat:@"%ld",(long)PuttersNum+1];
    [self sizeToFitLabel];
    [self addBlock];
    
    
    NSString *grossText = _GrossLabel.text;
    if (_PolePoorButton.selected) {
        grossText = [NSString stringWithFormat:@"%ld",[grossText integerValue] + [_ParLabelStr integerValue]];
    }

    NSString *puttersText = _Putters.text;
    if ([puttersText integerValue]>=[grossText integerValue]) {
        
        [self GrossAddClick:_GrossAdd];
    }
    
    
}

//自适应文字大小
-(void)sizeToFitLabel{
    _ModifiedLabel.hidden = YES;
    CGFloat PuttersX = kWvertical(81.0f);
    _Putters.font = [UIFont systemFontOfSize:kHorizontal(25.f)];
    _GrossLabel.font = [UIFont systemFontOfSize:kHorizontal(72.0f)];
    NSString *GrossLabelText = _GrossLabel.text;
    NSInteger GrossLabelTnteger = [GrossLabelText integerValue];
    
    if (GrossLabelTnteger>9) {
        if (![GrossLabelText isEqualToString:@"0"]) {
            _GrossLabel.font = [UIFont systemFontOfSize:kHorizontal(58.0f)];
            PuttersX = kWvertical(85.0f);
        }
    }
    
    if (_PolePoorButton.selected) {
        PuttersX = kWvertical(84.0f);
    }
    
    NSString *PuttersText = _Putters.text;
    [_GrossLabel sizeToFit];
    
    _GrossLabel.frame = CGRectMake(kHvertical(120)/2 - _GrossLabel.width/2, 0, _GrossLabel.width, kHvertical(120));
    
    if (GrossLabelTnteger!=0&&_PolePoorButton.selected) {
        _ModifiedLabel.hidden = NO;
        if (GrossLabelTnteger>0) {
            _ModifiedLabel.text = @"+";
        }else{
            _ModifiedLabel.text = @"-";
        }
        _GrossLabel.frame = CGRectMake(0, 0, kWvertical(130), kHvertical(120));
    }
    
    _Putters.frame = CGRectMake(PuttersX, kHvertical(15), kWvertical(40), kHvertical(36));
    
    if ([PuttersText integerValue]==10) {
        _Putters.font = [UIFont systemFontOfSize:kHorizontal(22.f)];
        if ([GrossLabelText integerValue]>9||_PolePoorButton.selected) {
            if (![GrossLabelText isEqualToString:@"0"]) {
                _Putters.frame = CGRectMake(PuttersX, kHvertical(15), kWvertical(40), kHvertical(36));
            }
        }
    }
    
    if (_PolePoorButton.selected&&![GrossLabelText isEqualToString:@"0"]) {
        CGFloat textFont = _GrossLabel.font.pointSize;
        NSString *GrossReduce = _GrossLabel.text;
        GrossReduce = [GrossReduce substringToIndex:1];
        if ([GrossReduce isEqualToString:@"-"]) {
            [_GrossLabel setAttributedText:[self changeLabelWithText:_GrossLabel.text range:NSMakeRange(0, 1) normolFont:textFont changFont:kHorizontal(1)]];
        }
        [_GrossLabel setTextAlignment:NSTextAlignmentCenter];
    }
}

//是否距标准杆
//changePolePoorButton:sender Data:indexPoleData
-(void)changePolePoorButton:(UIButton *)btn Data:(NSDictionary *)dict{
    _indexPoleData = dict;
    
    _ParLabelStr = [_indexPoleData objectForKey:@"Par"];
    
    NSString *GrossStr = _GrossLabel.text;
    if (!GrossStr) {
        GrossStr = _ParLabelStr;
    }
    NSString *ParLabelStr = _ParLabelStr;
    NSInteger Difference = 0;
    _PolePoorButton.selected = btn.selected;
    _Gross.text = @"杆差";
    if (_PolePoorButton.selected) {
        _Gross.text = @"总杆";
        _PolePoorButton.selected = NO;
        Difference = [GrossStr integerValue] + [ParLabelStr integerValue];
    }else{
        _PolePoorButton.selected = YES;
        Difference = [GrossStr integerValue] - [ParLabelStr integerValue];
    }
    NSString *DifferenceStr = [NSString stringWithFormat:@"%ld",(long)Difference];
    _GrossLabel.text = DifferenceStr;
    [self sizeToFitLabel];
    [self changeClick];
    
    
    
    
    
}

//刷新数据
-(void)refreshData:(NSDictionary *)dict{
    _indexPoleData = dict;
    NSString *isSelectStr = [_indexPoleData objectForKey:@"isSelectStr"];

    
    _ParLabelStr = [_indexPoleData objectForKey:@"Par"];
    NSString *GrossLabelStr = [_indexPoleData objectForKey:@"gross"];
    NSString *PuttersStr = [_indexPoleData objectForKey:@"putters"];
    _GrossLabel.text = GrossLabelStr;
    if ([GrossLabelStr isEqualToString:@"0"]) {
        _GrossLabel.text = _ParLabelStr;
        _RoundView.backgroundColor = LightGrayColor;
    }else{
        _RoundView.backgroundColor = localColor;
    }
    _Putters.text = PuttersStr;

    NSInteger Difference = 0;
    if ([isSelectStr isEqualToString:@"1"]) {
        Difference = [_GrossLabel.text integerValue] - [_ParLabelStr integerValue];
        NSString *DifferenceStr = [NSString stringWithFormat:@"%ld",(long)Difference];
        _GrossLabel.text = DifferenceStr;
    }
    
    
    [self addBlock];
    [self sizeToFitLabel];
    NSInteger putterIndex = [_Putters.text integerValue];
    NSInteger grossIndex  = [_GrossLabel.text integerValue];
    NSInteger parIndex = [_ParLabelStr integerValue];
    
    if (_PolePoorButton.selected) {
        grossIndex  = grossIndex + parIndex;
    }
    if (grossIndex>=9+parIndex) {
        _GrossAdd.selected = NO;
        _GrossReduce.selected = YES;
    }else{
        _GrossAdd.selected = YES;
        if (grossIndex==1) {
            _GrossReduce.selected = NO;
        }
    }
    
    if (putterIndex>=9) {
        _PuttersAdd.selected = NO;
        _PuttersReduce.selected = YES;
    } else {
        _PuttersAdd.selected = YES;
        if (putterIndex==0) {
            _PuttersReduce.selected = NO;
        }
    }


}

/**
 *  设置不同label显示大小字体
 *
 *  @param Text       显示文字
 *  @param selectRang 选中改变文字的Rang
 *  @param normolFont 默认大小
 *  @param changFont  选中的大小
 *
 *  @return 改变过的文字
 */
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)Text range:(NSRange )selectRang normolFont:(CGFloat )normolFont changFont:(CGFloat)changFont
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:Text];
    UIFont *font = [UIFont systemFontOfSize:normolFont];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, selectRang.location)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:changFont] range:NSMakeRange(selectRang.location,selectRang.length)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(selectRang.location+selectRang.length, Text.length - (selectRang.location + selectRang.length))];
    return attrString;
}


#pragma mark - 设置block
//更换数据
-(void)addBlock{
    NSString *grossStr = _GrossLabel.text;
    
    if ([_RoundView.backgroundColor isEqual:LightGrayColor]) {
        grossStr = @"0";
    }else{
        if (_PolePoorButton.selected) {
            grossStr = [NSString stringWithFormat:@"%ld",[grossStr integerValue]+[_ParLabelStr integerValue]];
        }
    }

    NSDictionary *dict = @{
                           @"Gross":grossStr,
                           @"index":_indexLocation,
                           @"Putters":_Putters.text,
                           @"Par":_ParLabelStr,
                           };
    if (self.scroBlock !=nil) {
        self.scroBlock(dict);
    }
}
-(void)setBlock:(scroBlock)block{
    self.scroBlock = block;
}
//切换距标准杆
-(void)changeClick{
    NSDictionary *dict = @{
                           @"index":_indexLocation,
                           };
    if (self.changeBLock !=nil) {
        self.changeBLock(dict);
    }
}


@end
