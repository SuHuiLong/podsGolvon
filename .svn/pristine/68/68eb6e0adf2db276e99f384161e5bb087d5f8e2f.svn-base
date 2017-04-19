//
//  RecommendTableViewCell.m
//  TabBar
//
//  Created by 李盼盼 on 16/8/5.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "UIView+Size.h"
#import "UIImageView+WebCache.h"

@interface RecommendTableViewCell()

/***  头像*/
@property (strong, nonatomic) UIImageView    *headerImage;
/***  昵称*/
@property (strong, nonatomic) UILabel    *nickName;
/***  签名*/
@property (strong, nonatomic) UILabel    *signature;

@end

@implementation RecommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    // 头像
    _headerImage = [UIImageView new];
    _headerImage.frame = CGRectMake(kWvertical(18),kWvertical(8), kWvertical(50), kWvertical(50));
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = kWvertical(50)/2;
    [self.contentView addSubview:_headerImage];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    //昵称
    _nickName = [UILabel new];

    [self.contentView addSubview:_nickName];
    
    //签名
    _signature = [UILabel new];
    [self.contentView addSubview:_signature];
    
    //关注
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(ScreenWidth - kWvertical(27)-kWvertical(44), kHvertical(12), kWvertical(27)+kWvertical(44), self.height);
    _followBtn.adjustsImageWhenHighlighted = NO;
    [_followBtn setImage:[UIImage imageNamed:@"addFollow(other)"] forState:(UIControlStateNormal)];
    [_followBtn setImage:[UIImage imageNamed:@"榜单已关注"] forState:(UIControlStateSelected)];
    [self.contentView addSubview:_followBtn];
    
    [_followBtn addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}
-(void)relayoutWithModel:(RecommendModel *)model{
    self.model = model;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.pictureurl] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    _Vimage.frame = CGRectMake(_headerImage.right - kWvertical(14), kHvertical(45), kWvertical(14), kWvertical(14));
    
    if ([model.interview_state isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }

    
    _nickName.text = model.nickname;
    _nickName.textColor = GPColor(38, 38, 38);
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _nickName.frame = CGRectMake(_headerImage.right + kWvertical(9), kHvertical(14), 200, kHvertical(20));
    [_nickName sizeToFit];
    
    _followBtn.selected = model.state;
    
    NSString *tempStr = model.signature;
    if ([tempStr isEqual:[NSNull null]]) {
        tempStr = @" ";
    }
    _signature.text = tempStr;
    
    _signature.textColor = GPColor(166, 166, 166);
    _signature.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _signature.frame = CGRectMake(_headerImage.right + kWvertical(9), kHvertical(36), 200, kHvertical(20));
}


-(void)buttonClick{
    
    if (self.followBtnBlock) {
        self.followBtnBlock(self.model);
    }
    
}


@end
