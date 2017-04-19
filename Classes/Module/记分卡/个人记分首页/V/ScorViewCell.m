//
//  ScorViewCell.m
//  单人记分
//
//  Created by 李盼盼 on 16/6/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ScorViewCell.h"
#import "ScorModel.h"

@implementation ScorViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //    杆数
    _poleNum = [[UILabel alloc]initWithFrame:CGRectMake(WScale(4.8), HScale(2.5), WScale(12.3), HScale(6.9))];
    _poleNum.hidden = YES;
    _poleNum.backgroundColor = GPColor(243, 243, 243);
    _poleNum.layer.masksToBounds = YES;
    _poleNum.layer.cornerRadius = 6;
    _poleNum.font = [UIFont systemFontOfSize:kHorizontal(25)];
    [self.contentView addSubview:_poleNum];
    
    //    球场
    _ballPark = [[UILabel alloc]init];
    _ballPark.frame = CGRectMake(WScale(19.7), HScale(2.7), WScale(68), HScale(3.1));
    _ballPark.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _ballPark.textColor = GPColor(41, 41, 41);
    [self.contentView addSubview:_ballPark];
    
    //    时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake(WScale(19.7), HScale(6.9), WScale(40), HScale(2.5));
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _timeLabel.textColor = GPColor(137, 137, 137);
    [self.contentView addSubview:_timeLabel];
    
    
    //    奖杯
    _scoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - WScale(5.1)-WScale(9.1), HScale(3.4), WScale(9.1), HScale(5.1))];
    _scoreImage.userInteractionEnabled = YES;
    _scoreImage.hidden = YES;
    _scoreImage.image = [UIImage imageNamed:@"最好成绩"];
    [self.contentView addSubview:_scoreImage];
    
    //    公益金额
    _money = [[UILabel alloc]init];
    _money.hidden = YES;
    _money.layer.masksToBounds = YES;
    _money.layer.cornerRadius = 2;
    _money.layer.borderColor = GPColor(212, 212, 212).CGColor;
    _money.layer.borderWidth = 1;
    [self.contentView addSubview:_money];
    
    
    _moneyNum = [[UILabel alloc]init];
    _moneyNum.textAlignment = NSTextAlignmentCenter;
    _moneyNum.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _moneyNum.textColor = GPColor(222, 61, 61);
    _moneyNum.frame = CGRectMake(WScale(5.1), HScale(0.3), WScale(8), HScale(2.5));
    [_money addSubview:_moneyNum];
    
    
    
    //    正在进行
    _underway = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-kWvertical(45), 0, kWvertical(45), HScale(11.8))];
    _underway.hidden = YES;
    UIImageView *underView = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(10), HScale(5), kWvertical(15), kHvertical(9))];
    underView.image = [UIImage imageNamed:@"退出箭头"];
    [_underway addSubview:underView];
    [self.contentView addSubview:_underway];
    
    //    播放图片
    
    _circle = [[UIImageView alloc]init];
    [self.contentView addSubview:_circle];
    
    _playImage = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_playImage];
    
    
    //    公益金额
    _moneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(1.1), HScale(0.3), WScale(3.2), HScale(1.8))];
    _moneyImage.image = [UIImage imageNamed:@"公益金额"];
    [_money addSubview:_moneyImage];
    
    
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(11.8)-0.5, ScreenWidth, 0.5)];
    _line.backgroundColor = GPColor(239, 239, 239);
    [self.contentView addSubview:_line];
    
    _line2 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(11.8)-1, ScreenWidth, 1)];
    _line2.backgroundColor = NAVLINECOLOR;
    _line2.hidden = YES;
    [self.contentView addSubview:_line2];
}
-(void)relayoutWithBestDictionary:(ScorModel *)dic{
    _scoreImage.hidden = NO;
    //    杆数
    _poleNum.hidden = NO;
    _poleNum.text = dic.zongganshu;
    _poleNum.textAlignment = NSTextAlignmentCenter;
    
    //    球场名称
    _ballPark.text = dic.qiuchang_name;

    //    时间
    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",dic.chuangjian_time];
    [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
    [time deleteCharactersInRange:NSMakeRange(0, 5)];
    [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
    _timeLabel.text = time;
    NSLog(@"最好的成绩%@",dic.chuangjian_time);

}
-(void)relayoutWithLoadingDictionary:(ScorModel *)dic{
    
    _poleNum.hidden = YES;
    
    _circle.image = [UIImage imageNamed:@"scoring正在进行－转"];
    _circle.frame = CGRectMake(WScale(4.8), HScale(2.5), kWvertical(44), kWvertical(44));
    _circle.userInteractionEnabled = YES;
    _circle.layer.masksToBounds = YES;
    _circle.layer.cornerRadius = kWvertical(22);
    
    _playImage.frame = CGRectMake(_circle.x+kWvertical(15), _circle.y+kHvertical(14), kWvertical(14), kHvertical(16));
    _playImage.image = [UIImage imageNamed:@"scoring正在进行－中心"];
    
    _circle.hidden = NO;
    if (![dic.groupStatr isEqualToString:@"1"]) {
        _playImage.image = [UIImage imageNamed:@"未完成"];
        _circle.hidden = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotationAnim = [CABasicAnimation animation];
        rotationAnim.keyPath = @"transform.rotation.z";
        rotationAnim.toValue = @(2 * M_PI);
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.cumulative = NO;
        [_circle.layer addAnimation:rotationAnim forKey:nil];
    });
    
    //    球场名称
    NSString *ParkName = dic.qiuchang_name;
    if ([ParkName isEqualToString:@"0"]) {
        ParkName = @"正在准备记分";
    }
    _ballPark.text = ParkName;

    //    时间
    _timeLabel.text = dic.ingStr;
    
    
//    _underway.userInteractionEnabled = YES;
//    _underway.layer.masksToBounds = YES;
//    _underway.layer.cornerRadius = 2;
//    _underway.layer.borderWidth = 1;
//    _underway.text = @"正在进行";
//    _underway.textAlignment = NSTextAlignmentCenter;
//    _underway.textColor = localColor;
//    _underway.font = [UIFont systemFontOfSize:kHorizontal(10)];
//    _underway.layer.borderColor = GPColor(212, 212, 212).CGColor;
    
}
-(void)relayoutWithDictionary:(ScorModel *)dic{
    _money.hidden = NO;
    //    杆数
    _poleNum.hidden = NO;
    _moneyImage.hidden = NO;
    _poleNum.text = dic.zongganshu;
    _poleNum.textAlignment = NSTextAlignmentCenter;
    
    //    球场名称
    _ballPark.text = dic.qiuchang_name;
    
    //    时间
    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",dic.chuangjian_time];
    [time replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [time replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [time replaceCharactersInRange:NSMakeRange(10, 1) withString:@"日"];

    [time deleteCharactersInRange:NSMakeRange(0, 5)];
    [time deleteCharactersInRange:NSMakeRange(6, time.length-6)];
    _timeLabel.text = time;

    
    
    

    _moneyNum.text = dic.charity;
    NSString *str1 = [NSString stringWithFormat:@"%@%@",dic.charity,@"元"];
    NSMutableAttributedString *attributed1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed1.length-1, 1)];
    _moneyNum.attributedText = attributed1;
    [_moneyNum sizeToFit];
    _money.frame = CGRectMake(ScreenWidth-WScale(13.1)-WScale(2.4), HScale(3), _moneyImage.frame.origin.x + _moneyImage.frame.size.width + _moneyNum.frame.size.width +5, HScale(2.5));
    if ([dic.charity isEqualToString:@"0"]) {
        _money.hidden = YES;
        _moneyNum.hidden = YES;
    }else{
        _money.hidden = NO;
        _moneyNum.hidden = NO;
    }
    
}

@end
