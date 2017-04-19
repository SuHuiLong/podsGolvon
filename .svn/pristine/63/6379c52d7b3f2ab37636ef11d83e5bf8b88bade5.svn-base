//
//  FindAceTableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/25.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "FindAceTableViewCell.h"
#import "UIView+Size.h"

@implementation FindAceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _groundImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_groundImage];
    
    
    _timeImage = [[UIImageView alloc]init];
    _timeImage.image = [UIImage imageNamed:@"periods"];
    [self.contentView addSubview:_timeImage];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor whiteColor];
    [_timeImage addSubview:_timeLabel];
    
    
    _visitImage = [[UIImageView alloc]init];
    _visitImage.image = [UIImage imageNamed:@"发现_访问量"];
    [self.contentView addSubview:_visitImage];
    
    _visitNum = [[UILabel alloc]init];
    _visitNum.textAlignment = NSTextAlignmentLeft;
    _visitNum.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_visitNum];
    
    _describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(2.7), HScale(27.7), ScreenWidth - WScale(5.4), HScale(3.3))];
    _describeLabel.textAlignment = NSTextAlignmentLeft;
    _describeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_describeLabel];
}

-(void)relayoutWithModel:(FindAceModel *)model{
    
    [_groundImage setFindImageStr:model.grongImage];
    _groundImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(32.2));
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.aceTime];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.frame = CGRectMake(WScale(1.6), HScale(0.5), WScale(10.7), HScale(2.1));
    [_timeLabel sizeToFit];
    _timeImage.frame = CGRectMake(-_timeLabel.width+WScale(1.6), HScale(1.8), _timeLabel.width + WScale(3.2), HScale(3));
    dispatch_async(dispatch_get_main_queue(), ^{

    [UIView animateWithDuration:0.5 animations:^{
        _timeImage.frame = CGRectMake(0, HScale(1.8), _timeLabel.width + WScale(3.2), HScale(3));
    }];
    });
    
    UILabel *test = [[UILabel alloc]init];
    test.frame = CGRectMake(WScale(92.5), HScale(1.4), WScale(8), HScale(1.9));
    test.textAlignment = NSTextAlignmentCenter;
    test.text = model.red_number;
    test.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [test sizeToFit];
    
    _visitNum.text = test.text;
    _visitNum.frame = CGRectMake(ScreenWidth - test.width-5, test.y, test.width, test.height);
    _visitNum.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _visitNum.shadowColor = GPColor(26, 26, 26);
    _visitNum.shadowOffset = CGSizeMake(0, 1);
    _visitImage.frame = CGRectMake(_visitNum.left - WScale(4.3)-WScale(1.1), HScale(1.8), WScale(4.3), WScale(3));
    [_visitNum sizeToFit];
    
     
    _describeLabel.text = [NSString stringWithFormat:@"%@",model.describeLabel];
    _describeLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _describeLabel.shadowColor = GPColor(26, 26, 26);
    _describeLabel.shadowOffset = CGSizeMake(0, 1);
    
}

@end
