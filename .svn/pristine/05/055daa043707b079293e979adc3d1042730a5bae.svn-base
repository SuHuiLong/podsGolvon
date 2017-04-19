//
//  NewDetailCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/1.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "NewDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation NewDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _title = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(0.7), WScale(15), HScale(2.4))];
    _title.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _title.textColor = RGB(68, 65, 79);
    _title.text = @"0";
    [self.contentView addSubview:_title];
    
    _pictureURL = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-WScale(22.1), HScale(1.2), WScale(14.9), HScale(8.4))];
    _pictureURL.userInteractionEnabled = YES;
    _pictureURL.hidden = YES;
    [self.contentView addSubview:_pictureURL];
    
    _poleNum = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-WScale(22.1), HScale(1.2), WScale(14.9), HScale(8.4))];
    _poleNum.userInteractionEnabled = YES;
    _poleNum.hidden = YES;
    _poleNum.text = @"0";
    [self.contentView addSubview:_poleNum];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(3.4), WScale(59), HScale(3))];
    _messageLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _messageLabel.text = @"0";
    [self.contentView addSubview:_messageLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(6.7), WScale(50), HScale(2.4))];
    _timeLabel.textColor = RGB(153, 149, 168);
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _timeLabel.text = 0;
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, (ScreenHeight - HScale(66.4))/3,ScreenWidth, 0.5)];
    line1.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line1];
    
    
    _circle = [[UIImageView alloc]init];
    [self.contentView addSubview:_circle];
    
    //    播放图片
    _playImage = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_playImage];
    
    
}
-(void)relayoutWithDictionary:(ZhuanFangModel *)model{
    _title.text = @"专访";
    _messageLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _pictureURL.hidden = NO;
    [_pictureURL sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    _pictureURL.contentMode = UIViewContentModeScaleAspectFill;
    _pictureURL.clipsToBounds = YES;
    _timeLabel.text = model.time;
    
}
-(void)relayOutWithScoringModel:(ScoringModel *)model{
    NSString *ballPark = [NSString stringWithFormat:@"%@",model.ballPark];
//    if ([ballPark isEqualToString:@"0"]) {
//        ballPark = @"正在准备记分";
//    }
    _messageLabel.text = ballPark;
    _timeLabel.text = model.timeLabel;
    
    if ([model.isfinished isEqualToString:@"0"]) {
        
        _circle.hidden = NO;
        _playImage.hidden = NO;
        _poleNum.hidden = YES;
        if ([model.istoday isEqualToString:@"0"]) {
            
            
            _playImage.frame = CGRectMake(ScreenWidth-WScale(22.1), HScale(1.2), WScale(14.9), HScale(8.4));
            _playImage.image = [UIImage imageNamed:@"未完成"];
            
  
        }else{
            
            
            _circle.image = [UIImage imageNamed:@"scoring正在进行－转"];
            _circle.frame = CGRectMake(ScreenWidth-WScale(20), kHvertical(15), kWvertical(44), kWvertical(44));
            _circle.userInteractionEnabled = YES;
            _circle.layer.masksToBounds = YES;
            _circle.layer.cornerRadius = kHvertical(22);
            
            _playImage.frame = CGRectMake(_circle.x+kWvertical(17), _circle.y+kHvertical(14), kWvertical(14), kHvertical(16));
            _playImage.image = [UIImage imageNamed:@"scoring正在进行－中心"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CABasicAnimation *rotationAnim = [CABasicAnimation animation];
                rotationAnim.keyPath = @"transform.rotation.z";
                rotationAnim.toValue = @(2 * M_PI);
                rotationAnim.repeatCount = MAXFLOAT;
                rotationAnim.duration = 5;
                rotationAnim.cumulative = YES;
                rotationAnim.removedOnCompletion = NO;

                [_circle.layer addAnimation:rotationAnim forKey:nil];
            });
            
        }
        
        
    }else{
        _circle.hidden = YES;
        _playImage.hidden = YES;
        _poleNum.hidden = NO;
        _poleNum.backgroundColor = RGB(224, 77, 72);
        _poleNum.text = [NSString stringWithFormat:@"%@",model.poleNum];
        _poleNum.textColor = [UIColor whiteColor];
        _poleNum.font = [UIFont systemFontOfSize:kHorizontal(40)];
        _poleNum.textAlignment = NSTextAlignmentCenter;
        _poleNum.adjustsFontSizeToFitWidth = YES;
    }
    
}

//-(void)relayOutWithLiuYanModel:(LiuYanModel *)model{
//    _poleNum.hidden = NO;
//    _pictureURL.hidden = NO;
//    [_pictureURL sd_setImageWithURL:[NSURL URLWithString:model.headerImageName] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
//    _messageLabel.text = model.titleLabel;
//    _timeLabel.text = model.timeLabel;
//}
@end
