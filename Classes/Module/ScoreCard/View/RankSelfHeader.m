//
//  RankSelfHeader.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/20.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RankSelfHeader.h"

@implementation RankSelfHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)createUI{
    
    
    _noneRank = [[UILabel alloc]init];
    _noneRank.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(52));
    _noneRank.text = @"您还未完成一场有效的打球记录";
    _noneRank.textAlignment = NSTextAlignmentCenter;
    _noneRank.textColor = GPColor(46, 46, 46);
    _noneRank.hidden = YES;
    _noneRank.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_noneRank];
    
    _rankLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_rankLabel];
    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.frame = CGRectMake(kWvertical(36),(kHvertical(52-kHvertical(32)))/2, kWvertical(38), kWvertical(38));
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = kWvertical(38)/2;
    [self.contentView addSubview:_headerImage];
    
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    _nickName = [[UILabel alloc]init];
    [self.contentView addSubview:_nickName];
    
    
    _changCiLabel = [[UILabel alloc]init];
    _changCiLabel.textColor = GPColor(245, 166, 35);
    [self.contentView addSubview:_changCiLabel];
    
    _lickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lickBtn.frame = CGRectMake(ScreenWidth - kWvertical(80), 0, kWvertical(80), self.contentView.height);
    [_lickBtn addTarget:self action:@selector(clickToLike) forControlEvents:UIControlEventTouchUpInside];
    _likeNum = [[UILabel alloc]init];
    
    _likeImage = [[UIImageView alloc]init];
    [self addSubview:_lickBtn];
    [_lickBtn addSubview:_likeImage];
    [_lickBtn addSubview:_likeNum];
    
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(0, kHvertical(57) - 5, ScreenWidth, 5);
    _lineView.backgroundColor = SeparatorColor;
    [self.contentView addSubview:_lineView];
    
}

-(void)relayoutWithModel:(RulesModel *)model{
    self.model = model;
    if (Device >=9.0) {
        _rankLabel.font = [UIFont fontWithName:Light size:kHorizontal(15)];
        _nickName.font = [UIFont fontWithName:Light size:kHorizontal(14)];
        _changCiLabel.font = [UIFont fontWithName:Light size:kHorizontal(16)];
        _likeNum.font = [UIFont fontWithName:Light size:kHorizontal(13)];
    }else{
        _rankLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        _nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
        _changCiLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
        _nickName.font = [UIFont systemFontOfSize:kHorizontal(13)];
    }
    
    //    排名
    UILabel *rankTest = [[UILabel alloc]init];
    rankTest.frame = CGRectMake(_headerImage.x +_headerImage.width + kWvertical(8), kHvertical(29), kWvertical(150), kHvertical(20));
    rankTest.text = [NSString stringWithFormat:@"第%@名",model.rankNumber];
    rankTest.textAlignment = NSTextAlignmentCenter;
    rankTest.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [rankTest sizeToFit];
    
    _rankLabel.text = rankTest.text;
    _rankLabel.frame = rankTest.frame;
    _rankLabel.textColor = GPColor(142, 142, 142);
    _rankLabel.font = rankTest.font;
    [_rankLabel sizeToFit];
    
    //    头像
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url]placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    
    _Vimage.frame = CGRectMake(_headerImage.right - kWvertical(10), kHvertical(35), kWvertical(12), kWvertical(12));
    if ([model.interview_state isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
    //    昵称
    _nickName.text = model.nickname;
    _nickName.textColor = GPColor(71, 71, 71);
    _nickName.frame = CGRectMake(_headerImage.right + kWvertical(8), kWvertical(8), kWvertical(150), kHvertical(20));
    [_nickName sizeToFit];
    
    //    场次
    CGFloat Y = (kHvertical(55) - kHvertical(33))/2;
    UILabel *changTest = [[UILabel alloc]init];
    changTest.frame = CGRectMake(kWvertical(284), Y+kHvertical(2), kWvertical(39), kHvertical(33));
    changTest.text = [NSString stringWithFormat:@"%@",model.zongChangCi];
    changTest.textAlignment = NSTextAlignmentCenter;
    changTest.font = [UIFont systemFontOfSize:kHorizontal(24)];
    [changTest sizeToFit];
    
    _changCiLabel.text = changTest.text;
    _changCiLabel.frame = CGRectMake(ScreenWidth - kWvertical(52) - changTest.width, Y+kHvertical(2), changTest.width, changTest.height);
    _changCiLabel.font = changTest.font;
    _changCiLabel.textColor = deepColor;
    _changCiLabel.textAlignment = NSTextAlignmentCenter;
    [_changCiLabel sizeToFit];

    
    if (self.superview.frame.size.height >= 667) {
        _likeNum.frame = CGRectMake(kWvertical(14), kHvertical(12), _lickBtn.width, kHvertical(14));
        
        _likeImage.frame = CGRectMake(kWvertical(49), kHvertical(31), kWvertical(12), kHvertical(12));
    }else{
        _likeNum.frame = CGRectMake(kWvertical(14), kHvertical(10), _lickBtn.width, kHvertical(14));
        
        _likeImage.frame = CGRectMake(kWvertical(47), kHvertical(28), WScale(4.2), HScale(2.2));
    }
    _likeNum.textAlignment = NSTextAlignmentCenter;
    
    _likeNum.text = model.RankingClickNumber;
    if ([model.RankingClickNumber isEqualToString:@"0"]) {
        _likeNum.textColor = GPColor(154, 154, 154);
    }else{
        
        _likeNum.textColor = GPColor(233, 111, 112);
    }
    _likeNum.font = [UIFont systemFontOfSize:kHorizontal(13)];
    
    if ([model.RankingClickNumber isEqualToString:@"0"]) {
        
        _likeImage.image = [UIImage imageNamed:@"场次点赞_默认"];
        
    }else{
        
        _likeImage.image = [UIImage imageNamed:@"场次点赞_激活"];
    }
    
}

-(void)clickToLike{
    
    if (self.lickBtnBlock) {
        self.lickBtnBlock(self.model);
    }
}

@end
