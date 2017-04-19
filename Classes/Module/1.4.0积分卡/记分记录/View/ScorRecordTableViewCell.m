//
//  ScorRecordTableViewCell.m
//  podsGolvon
//
//  Created by SHL on 2016/10/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ScorRecordTableViewCell.h"

@implementation ScorRecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    
    
    //    杆数
    _poleNum = [[UILabel alloc]initWithFrame:CGRectMake(kWvertical(11), kHvertical(10), kHvertical(46), kHvertical(46))];
    _poleNum.hidden = YES;
    _poleNum.backgroundColor = GPColor(245, 245, 245);
    _poleNum.textColor = rgba(41,41,41,1);
    _poleNum.layer.masksToBounds = YES;
    _poleNum.layer.cornerRadius = kHvertical(23);
    _poleNum.font = [UIFont systemFontOfSize:kHorizontal(22)];
    [self.contentView addSubview:_poleNum];
    
    //    球场
    _ballPark = [[UILabel alloc]init];
    _ballPark.frame = CGRectMake(_poleNum.x_width + kWvertical(12), kHvertical(13), ScreenWidth - _poleNum.x_width - kWvertical(12) - kWvertical(82), HScale(3.1));
    _ballPark.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _ballPark.textColor = GPColor(41, 41, 41);
    [self.contentView addSubview:_ballPark];
    
    //    时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake(_ballPark.x, _ballPark.y_height + kHvertical(2), ScreenWidth/2, kHvertical(17));
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _timeLabel.textColor = rgba(174,174,174,1);
    [self.contentView addSubview:_timeLabel];

    //正在进行文字
    _underwayShareLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) textColor:BlackColor fontSize:kHorizontal(11) Title:@"分享记分"];
    [_underwayShareLabel sizeToFit];
    [_underwayShareLabel setTextAlignment:NSTextAlignmentCenter];

    _underwayShareLabel.frame = CGRectMake(ScreenWidth - kWvertical(14) - _underwayShareLabel.width - kWvertical(10), kHvertical(14), _underwayShareLabel.width+kWvertical(10), kHvertical(18));
    _underwayShareLabel.layer.masksToBounds = YES;
    _underwayShareLabel.layer.cornerRadius = 2.0f;
    _underwayShareLabel.layer.borderWidth = 1.0f;
    _underwayShareLabel.hidden = YES;
    
    _underwayShareLabel.textColor = BlackColor;
    _underwayShareLabel.backgroundColor = WhiteColor;
    _underwayShareLabel.layer.borderColor = rgba(53,141,227,1).CGColor;

    [self.contentView addSubview:_underwayShareLabel];
    
    //    公益金额
    _money = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) textColor:BlackColor fontSize:kHorizontal(12) Title:@"¥2.65"];
    [self.contentView addSubview:_money];
    
    //    播放图片
    _circle = [[UIImageView alloc]init];
    [self.contentView addSubview:_circle];

    _playImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_playImage];
   
    
    //线
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, kHvertical(65), ScreenWidth, kHvertical(3))];
    _line.backgroundColor = GPColor(238, 239, 241);
    [self.contentView addSubview:_line];
    
    _poleNum.hidden = YES;
    _money.hidden = YES;
    _circle.hidden = YES;

}

-(void)createScrollImage{
    
    //正在进行
    _playImage.frame = CGRectMake(kWvertical(29),kHvertical(25),kWvertical(15),kHvertical(18));
    _playImage.image = [UIImage imageNamed:@"scoring正在进行－中心"];
    _playImage.hidden = NO;
    
    _circle.image = [UIImage imageNamed:@"scoring正在进行－转"];
    _circle.frame = CGRectMake(kWvertical(12),kHvertical(11),kHvertical(44),kHvertical(44));
    _circle.userInteractionEnabled = YES;
    _circle.layer.masksToBounds = YES;
    _circle.layer.cornerRadius = HScale(6.9)/2;
    _circle.hidden = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotationAnim = [CABasicAnimation animation];
        rotationAnim.keyPath = @"transform.rotation.z";
        rotationAnim.toValue = @(2 * M_PI);
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.cumulative = NO;
        rotationAnim.autoreverses = NO;
        [_circle.layer addAnimation:rotationAnim forKey:nil];
    });

    
}


-(void)relayoutWithDictionary:(ScorRecordListModel *)model{
    _underwayShareLabel.textColor = BlackColor;
    _underwayShareLabel.backgroundColor = WhiteColor;
    

    _circle.hidden = YES;
    _playImage.hidden = YES;
    _poleNum.hidden = YES;
    _money.hidden = YES;
    
    //    球场名称
    NSString *ParkName = model.qname;
    _ballPark.text = ParkName;
    
    //    时间
    NSString *tm = model.tm;
//    if (tm.length>7) {
//        tm = [tm substringToIndex:6];
//    }
    _timeLabel.text = tm;
    _underwayShareLabel.hidden = NO;
    
    //    球场名称
    NSString *qname = model.qname;
    _ballPark.text = qname;

    
    NSString *status = model.status;
    if ([status isEqualToString:@"0"]) {
        _underwayShareLabel.text = @"正在进行";
        _underwayShareLabel.textColor = WhiteColor;
        _underwayShareLabel.backgroundColor = rgba(53,141,227,1);
        _underwayShareLabel.layer.borderColor = ClearColor.CGColor;
        
        [self createScrollImage];//正在进行
    }else if ([status isEqualToString:@"1"]){//已完成
        _underwayShareLabel.text = @"分享记分";
        _underwayShareLabel.textColor = rgba(53,141,227,1);
        _underwayShareLabel.backgroundColor = ClearColor;
        _underwayShareLabel.layer.borderColor = rgba(53,141,227,1).CGColor;
        _poleNum.hidden = NO;
        _money.hidden = NO;
        //金额
        NSString *charity = [NSString stringWithFormat:@"%@%@",@"¥",model.charity];
        _money.text = [NSString stringWithFormat:@"%@",charity];
        [_money sizeToFit];
        _money.frame = CGRectMake(ScreenWidth - kWvertical(14) - _money.width, kHvertical(35), _money.width, _money.height);
        
        //    杆数
        NSString *parnum = model.parnum;
        _poleNum.text = parnum;
        _poleNum.textAlignment = NSTextAlignmentCenter;
    }else if ([status isEqualToString:@"2"]){//无效记分
        _underwayShareLabel.text = @"无效记分";
        _underwayShareLabel.layer.borderColor = WhiteColor.CGColor;
        _poleNum.hidden = NO;
        //    杆数
        NSString *parnum = @"0";
        _poleNum.text = parnum;
        _poleNum.textAlignment = NSTextAlignmentCenter;
    }else if ([status isEqualToString:@"3"]){//
        _underwayShareLabel.text = @"未完成";
        _underwayShareLabel.layer.borderColor = WhiteColor.CGColor;
        _circle.image = [UIImage imageNamed:@"scoring_unfinish"];
        _circle.frame = CGRectMake(kWvertical(12),kHvertical(11),kHvertical(44),kHvertical(44));
        _circle.userInteractionEnabled = YES;
        _circle.layer.masksToBounds = YES;
        _circle.layer.cornerRadius = HScale(6.9)/2;
        _circle.hidden = NO;
    }else{
        NSLog(@"%@",model.status);
    
    }
    
    
}







@end






