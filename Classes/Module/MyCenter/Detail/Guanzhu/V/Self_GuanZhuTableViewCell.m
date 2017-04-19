//
//  Self_GuanZhuTableViewCell.m
//  Golvon
//
//  Created by shiyingdong on 16/4/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_GuanZhuTableViewCell.h"


@implementation Self_GuanZhuTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _headerImage = [[UIButton alloc]initWithFrame:CGRectMake(WScale(3.2), HScale(1.8), WScale(13.3), WScale(13.3))];
    [self.contentView addSubview:_headerImage];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.frame = CGRectMake(_headerImage.right - kWvertical(12), HScale(7.5), kWvertical(14), kWvertical(14));
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    [self.contentView addSubview:_Vimage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(21.3), HScale(2.1), ScreenWidth * 0.464,ScreenHeight * 0.031)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(21.3), HScale(6), WScale(60), ScreenHeight * 0.027)];
    _titleLabel.hidden = YES;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(11.1)-0.5,ScreenWidth, 0.5)];
    line1.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line1];
    
    //关注
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(ScreenWidth - kWvertical(27)-kWvertical(44), kHvertical(12), kWvertical(27)+kWvertical(44), self.height);
    _followBtn.adjustsImageWhenHighlighted = NO;
    [_followBtn setImage:[UIImage imageNamed:@"addFollow(other)"] forState:(UIControlStateNormal)];
    [_followBtn setImage:[UIImage imageNamed:@"榜单已关注"] forState:(UIControlStateSelected)];
    [self.contentView addSubview:_followBtn];
    [_followBtn addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    //正在进行的标志
    _bezelImage = [[UIImageView alloc]init];
    _bezelImage.hidden = YES;
    _bezelImage.image = [UIImage imageNamed:@"scoringPlay_small"];
    _bezelImage.frame = CGRectMake(WScale(20.3), HScale(5.5)+HScale(0.6), kWvertical(15) , kWvertical(15));
    [self.contentView addSubview:_bezelImage];
    

    
    _playImage = [[UIImageView alloc]init];
    _playImage.image = [UIImage imageNamed:@"scoringCenter_small"];
    _playImage.frame = CGRectMake(WScale(20.60), HScale(5.8)+HScale(0.45), kWvertical(13), kWvertical(13));
    _playImage.hidden = YES;
    [self.contentView addSubview:_playImage];
    
    _scroingLabel = [[UILabel alloc]init];
    _scroingLabel.frame = CGRectMake(_bezelImage.right +kWvertical(5), _titleLabel.y, kWvertical(60), _titleLabel.height);
    _scroingLabel.text = @"直播记分";
    _scroingLabel.hidden = YES;
    _scroingLabel.textColor = [UIColor grayColor];
    _scroingLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [self.contentView addSubview:_scroingLabel];
    
}

-(void)relayoutDataWithModel:(Slef_GuanZhuModel *)model{
    
    self.model = model;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = WScale(13.3)/2;
    
    if ([model.user_interview isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
    _nameLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    
    if ([model.nameID isEqualToString:userDefaultId]) {

        _followBtn.hidden = YES;
        
    }else{
        
        _followBtn.hidden = NO;
        _followBtn.selected = model.isFollow;
        if (model.isFollow == YES) {
            _followBtn.selected = YES;
        }else{
            _followBtn.selected = NO;
        }
        
    }
    
    NSString *tempSig = model.siignature;
    if ([tempSig isEqual:[NSNull null]]) {
        tempSig = @" ";
    }
    
    if ([model.groupStatr isEqualToString:@"1"]) {
        
        _bezelImage.hidden = NO;
        _playImage.hidden = NO;
        _scroingLabel.hidden = NO;
        _titleLabel.hidden = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CABasicAnimation *rotationAnim = [CABasicAnimation animation];
            rotationAnim.keyPath = @"transform.rotation.z";
            rotationAnim.toValue = @(2 * M_PI);
            rotationAnim.duration = 5;
            rotationAnim.cumulative = YES;
            rotationAnim.repeatCount = HUGE_VALF;
            rotationAnim.removedOnCompletion = NO;
            
            [_bezelImage.layer addAnimation:rotationAnim forKey:nil];
        });
        
    }else{
        
        _bezelImage.hidden = YES;
        _playImage.hidden = YES;
        _scroingLabel.hidden = YES;
        _titleLabel.hidden = NO;
        _titleLabel.text = [NSString stringWithFormat:@"%@",tempSig];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    }
    
    
}

-(void)buttonClick{
    
    if (self.followBtnBlock) {
        self.followBtnBlock(self.model);
    }
    
}

@end
