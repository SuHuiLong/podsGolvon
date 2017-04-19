//
//  RankListHeaderView.m
//  podsGolvon
//
//  Created by apple on 2017/1/13.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import "RankListHeaderView.h"
#import "RulesModel.h"

@interface RankListHeaderView ()

@property (nonatomic, strong) UIImageView   *championImageView;
@property (nonatomic, strong) UIImageView   *secondImageView;
@property (nonatomic, strong) UIImageView   *thirdImageView;

@property (nonatomic, strong) UILabel   *championName;
@property (nonatomic, strong) UILabel   *secondName;
@property (nonatomic, strong) UILabel   *thirdName;

@property (nonatomic, strong) UILabel   *championChang;
@property (nonatomic, strong) UILabel   *secondChang;
@property (nonatomic, strong) UILabel   *thirdChang;

@end
@implementation RankListHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)createUI{
    
//    规则
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(clickRules) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"规则" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, kWvertical(48), kHvertical(38));
    button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [button setTitleColor:textTintColor forState:UIControlStateNormal];
    [self addSubview:button];
//    第一名
    _championImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-kWvertical(35), kHvertical(26), kWvertical(70), kWvertical(70))];
    _championImageView.layer.masksToBounds = YES;
    _championImageView.layer.cornerRadius = kWvertical(35);
    _championImageView.backgroundColor = localColor;
    [self addSubview:_championImageView];
    
    
    _championName = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, kHvertical(114), ScreenWidth/3, kHvertical(20))];
    _championName.textColor = deepColor;
    _championName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _championName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_championName];
    
    _championChang = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, _championName.bottom, ScreenWidth/3, kHvertical(20))];
    _championChang.textAlignment = NSTextAlignmentCenter;
    _championChang.textColor = textTintColor;
    _championChang.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self addSubview:_championChang];
    
    _championBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _championBtn.frame = CGRectMake(ScreenWidth/3, _championChang.bottom, ScreenWidth/3, kHvertical(45));
    [_championBtn setImage:[UIImage imageNamed:@"场次点赞_默认"] forState:UIControlStateNormal];
    [_championBtn setImage:[UIImage imageNamed:@"场次点赞_激活"] forState:UIControlStateSelected];
    [_championBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [_championBtn setTitleColor:textTintColor forState:UIControlStateNormal];
    _championBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [_championBtn setTitleColor:GPColor(235, 79, 56) forState:UIControlStateSelected];
    [self addSubview:_championBtn];
    
//    第二名
    _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/3-kWvertical(60))/2, kHvertical(36), kWvertical(60), kWvertical(60))];
    _secondImageView.layer.masksToBounds = YES;
    _secondImageView.layer.cornerRadius = kWvertical(30);
    _secondImageView.backgroundColor = localColor;
    [self addSubview:_secondImageView];
    
    _secondName = [[UILabel alloc] initWithFrame:CGRectMake(0, kHvertical(114), ScreenWidth/3, kHvertical(20))];
    _secondName.textColor = deepColor;
    _secondName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _secondName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_secondName];
    
    _secondChang = [[UILabel alloc] initWithFrame:CGRectMake(0, _secondName.bottom, ScreenWidth/3, kHvertical(20))];
    _secondChang.textAlignment = NSTextAlignmentCenter;
    _secondChang.textColor = textTintColor;
    _secondChang.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self addSubview:_secondChang];
    
    _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondBtn.frame = CGRectMake(0, _secondChang.bottom, ScreenWidth/3, kHvertical(45));
    [_secondBtn setImage:[UIImage imageNamed:@"场次点赞_默认"] forState:UIControlStateNormal];
    [_secondBtn setImage:[UIImage imageNamed:@"场次点赞_激活"] forState:UIControlStateSelected];
    [_secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [_secondBtn setTitleColor:textTintColor forState:UIControlStateNormal];
    [_secondBtn setTitleColor:GPColor(235, 79, 56) forState:UIControlStateSelected];
    _secondBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];

    [self addSubview:_secondBtn];

    
//    第三名
    _thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/3-kWvertical(50))/2+_championName.right, kHvertical(46), kWvertical(50), kWvertical(50))];
    _thirdImageView.layer.masksToBounds = YES;
    _thirdImageView.layer.cornerRadius = kWvertical(25);
    _thirdImageView.backgroundColor = RedColor;
    [self addSubview:_thirdImageView];
    
    _thirdName = [[UILabel alloc] initWithFrame:CGRectMake(_championName.right, kHvertical(114), ScreenWidth/3, kHvertical(20))];
    _thirdName.textColor = deepColor;
    _thirdName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _thirdName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_thirdName];
    
    _thirdChang = [[UILabel alloc] initWithFrame:CGRectMake(_championChang.right, _thirdName.bottom, ScreenWidth/3, kHvertical(20))];
    _thirdChang.textAlignment = NSTextAlignmentCenter;
    _thirdChang.textColor = textTintColor;
    _thirdChang.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self addSubview:_thirdChang];
    
    
    _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdBtn.frame = CGRectMake(_championBtn.right, _thirdChang.bottom, ScreenWidth/3, kHvertical(45));

    [_thirdBtn setImage:[UIImage imageNamed:@"场次点赞_默认"] forState:UIControlStateNormal];
    [_thirdBtn setImage:[UIImage imageNamed:@"场次点赞_激活"] forState:UIControlStateSelected];
    [_thirdBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [_thirdBtn setTitleColor:textTintColor forState:UIControlStateNormal];
    [_thirdBtn setTitleColor:GPColor(235, 79, 56) forState:UIControlStateSelected];
    _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self addSubview:_thirdBtn];

    
}
-(void)relayoutHeaderDataWithArrar:(NSArray *)arr{
    self.modelArr = arr;
    RulesModel *model1 = arr[0];
    [_championImageView sd_setImageWithURL:[NSURL URLWithString:model1.picture_url]];
    _championName.text = model1.nickname;
    _championChang.text = model1.zongChangCi;
    _championBtn.selected = model1.ClickRankStatr;
    [_championBtn setTitle:model1.RankingClickNumber forState:UIControlStateNormal];
    
    
    RulesModel *model2 = arr[1];
    [_secondImageView sd_setImageWithURL:[NSURL URLWithString:model2.picture_url]];
    _secondName.text = model2.nickname;
    _secondChang.text = model2.zongChangCi;
    _secondBtn.selected = model2.ClickRankStatr;
    [_secondBtn setTitle:model2.RankingClickNumber forState:UIControlStateNormal];
    
    
    RulesModel *model3 = arr[2];
    [_thirdImageView sd_setImageWithURL:[NSURL URLWithString:model3.picture_url]];
    _thirdName.text = model3.nickname;
    _thirdChang.text = model3.zongChangCi;
    _thirdBtn.selected = model3.ClickRankStatr;
    [_thirdBtn setTitle:model3.RankingClickNumber forState:UIControlStateNormal];
    
}
@end
