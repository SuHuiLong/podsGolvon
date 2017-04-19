//
//  Self_Fans_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_Fans_TableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation Self_Fans_TableViewCell

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
    
    _titleLabel = [[UILabel alloc]init];
//                   WithFrame:CGRectMake(WScale(21.3), HScale(6), ScreenWidth * 0.65, ScreenHeight * 0.027)];

    [self.contentView addSubview:_titleLabel];

    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(10)-0.5,ScreenWidth, 0.5)];
    line1.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line1];
    
    //关注
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(ScreenWidth - kWvertical(27)-kWvertical(44), 0, kWvertical(27)+kWvertical(44), HScale(11.1));
    [self.contentView addSubview:_followBtn];
    [_followBtn addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    _followImage = [UIImageView new];
    _followImage.frame = CGRectMake((_followBtn.width - kWvertical(27))/2,kHvertical(16) , kWvertical(27), kHvertical(36));
    [_followBtn addSubview:_followImage];
    
    
    //正在进行的标志
    _bezelImage = [[UIImageView alloc]init];
    _bezelImage.hidden = YES;
    _bezelImage.image = [UIImage imageNamed:@"scoringPlay_small"];
    _bezelImage.frame = CGRectMake(WScale(20.3), HScale(5.5)+HScale(0.6), kWvertical(15) , kWvertical(15));
    [self.contentView addSubview:_bezelImage];
    
    
    _playImage = [[UIImageView alloc]init];
    _playImage.image = [UIImage imageNamed:@"scoringCenter_small"];
    _playImage.frame = CGRectMake(WScale(20.60), HScale(5.8)+HScale(0.45), kWvertical(13) , kWvertical(13));
    _playImage.hidden = YES;
    [self.contentView addSubview:_playImage];
    
    _scroingLabel = [[UILabel alloc]init];
    _scroingLabel.frame = CGRectMake(_bezelImage.right +kWvertical(5), HScale(6), kWvertical(60), HScale(2.7));
    _scroingLabel.text = @"直播记分";
    _scroingLabel.hidden = YES;
    _scroingLabel.textColor = [UIColor grayColor];
    _scroingLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [self.contentView addSubview:_scroingLabel];
}

-(void)relayoutDataWithModel:(SelfFansModel *)model{
    
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
        _followImage.hidden = YES;
    }else{
        _followBtn.hidden = NO;
        _followImage.hidden = NO;
        if ([model.followState isEqualToString:@"1"]) {
            _followImage.image = [UIImage imageNamed:@"榜单已关注"];
        }else{
            
            _followImage.image = [UIImage imageNamed:@"addFollow(other)"];
        }

    }
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.frame = CGRectMake(0, 0, 100, 100);
    testLabel.text = model.follow_time;
    testLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [testLabel sizeToFit];
    
    _titleLabel.text = testLabel.text;
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    
    if ([model.groupStatr isEqualToString:@"1"]) {
        
        _bezelImage.hidden = NO;
        _playImage.hidden = NO;
        _scroingLabel.hidden = NO;

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
        
        _titleLabel.frame = CGRectMake(_followBtn.x-testLabel.width,(HScale(10) - HScale(2.7))/2, testLabel.width, HScale(2.7));
        _titleLabel.textAlignment = NSTextAlignmentRight;
        
    }else{
        
        _bezelImage.hidden = YES;
        _playImage.hidden = YES;
        _scroingLabel.hidden = YES;
        _titleLabel.frame = CGRectMake(WScale(21.3), HScale(6), ScreenWidth * 0.65, ScreenHeight * 0.027);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
}
-(void)buttonClick{
    
    if (self.followBtnBlock) {
        self.followBtnBlock(self.model);
    }
}


@end
