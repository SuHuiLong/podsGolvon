//
//  RulesTableViewCell.m
//  TabBar
//
//  Created by 李盼盼 on 16/7/28.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "RulesTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RulesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
        
    _rankLabel = [[UILabel alloc]init];
    _rankLabel.frame = CGRectMake(0, 0, kWvertical(36), kHvertical(55));
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    _rankLabel.textColor = textTintColor;
    [self.contentView addSubview:_rankLabel];
    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.frame = CGRectMake(kWvertical(36),(kHvertical(52-kHvertical(32)))/2, kWvertical(40), kWvertical(40));
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = kWvertical(40)/2;
    [self.contentView addSubview:_headerImage];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.frame = CGRectMake(_headerImage.right - kWvertical(10), kHvertical(35), kWvertical(12), kWvertical(12));
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    _nickName = [[UILabel alloc]init];
    _nickName.frame = CGRectMake(_headerImage.right + kWvertical(10), kHvertical(35)/2, kWvertical(200), kHvertical(20));
    _nickName.textColor = deepColor;
    [self.contentView addSubview:_nickName];
    
    
    _changCiLabel = [[UILabel alloc]init];
    _changCiLabel.textColor = textTintColor;
    _changCiLabel.textAlignment = NSTextAlignmentCenter;
    _changCiLabel.frame = CGRectMake(kWvertical(274), _nickName.y, kWvertical(30), kHvertical(20));
    [self.contentView addSubview:_changCiLabel];
    
    _lickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lickBtn.frame = CGRectMake(ScreenWidth - kWvertical(80), 0, kWvertical(80), kHvertical(55));
    [_lickBtn setImage:[UIImage imageNamed:@"场次点赞_默认"] forState:UIControlStateNormal];
    [_lickBtn setImage:[UIImage imageNamed:@"场次点赞_激活"] forState:UIControlStateSelected];
    _lickBtn.imageEdgeInsets = UIEdgeInsetsMake(kHvertical(24), kHvertical(30),0, 0);
    [_lickBtn addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _likeNum = [[UILabel alloc]init];
    
    [self.contentView addSubview:_lickBtn];
    [_lickBtn addSubview:_likeNum];
    
    
    _allRankLabel = [[UILabel alloc]init];
    _allRankLabel.frame = CGRectMake(0, 0, 30, self.contentView.height);
    _allRankLabel.hidden = YES;
    _allRankLabel.textColor = GPColor(61, 61, 61);
    _allRankLabel.textAlignment = NSTextAlignmentCenter;
    _allRankLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_allRankLabel];
  
    
    _rankImage = [[UIImageView alloc]init];
    _rankImage.frame = CGRectMake(kWvertical(9), kHvertical(16), kWvertical(18), kHvertical(22));
    _rankImage.hidden = YES;
    [self.contentView addSubview:_rankImage];
    
    if (Device >= 9.0) {
        
        _rankLabel.font = [UIFont fontWithName:Light size:kHorizontal(15)];
        _nickName.font = [UIFont fontWithName:Light size:kHorizontal(14)];
        _changCiLabel.font = [UIFont fontWithName:Light size:kHorizontal(16)];
        _likeNum.font = [UIFont fontWithName:Light size:kHorizontal(13)];

    }else{
        
        _rankLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        _nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
        _changCiLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
        _likeNum.font = [UIFont systemFontOfSize:kHorizontal(13)];

    }
}

-(void)relayoutWithModel:(RulesModel *)model{
    self.model = model;
    

//    排名
    _rankLabel.text = model.rankNumber;
//    头像
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url]placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    if ([model.interview_state isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
//    昵称
    _nickName.text = model.nickname;
    _nickName.textColor = GPColor(71, 71, 71);
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
    _changCiLabel.textAlignment = NSTextAlignmentCenter;
    [_changCiLabel sizeToFit];
    
    
    
//    点赞
    _likeNum.text = model.RankingClickNumber;
    _likeNum.frame = CGRectMake(kWvertical(14), kHvertical(12), _lickBtn.width, kHvertical(14));
   
    _lickBtn.selected = model.ClickRankStatr;
    if (_lickBtn.selected == YES) {
        
        _likeNum.textColor = GPColor(235, 79, 56);
    }else{
        
        _likeNum.textColor = textTintColor;
    }
    
    _likeNum.textAlignment = NSTextAlignmentCenter;
    _likeNum.font = [UIFont systemFontOfSize:kHorizontal(13)];

    
    if ([model.name_id isEqualToString:userDefaultId]) {
        
        if ([model.RankingClickNumber isEqualToString:@"0"]) {
            _likeNum.textColor = textTintColor;
            _lickBtn.selected = NO;
        }else{
            
            _likeNum.textColor = GPColor(233, 111, 112);
            _lickBtn.selected = YES;
        }
    }
   
    
}

-(void)buttonClick{
    
//    _lickBtn.selected = !_lickBtn.selected;
    if (self.lickBtnBlock) {
        self.lickBtnBlock(self.model);
    }
    
    
}

@end
