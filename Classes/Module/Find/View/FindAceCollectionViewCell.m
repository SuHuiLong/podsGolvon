//
//  FindAceCollectionViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/23.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "FindAceCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation FindAceCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _groundImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_groundImage];
    
    
    _timeImage = [[UIImageView alloc]init];
    _timeImage.image = [UIImage imageNamed:@"期数icon"];
    [self.contentView addSubview:_timeImage];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor whiteColor];
    [_timeImage addSubview:_timeLabel];
    
    
    _commentImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(78.1), HScale(2.4), WScale(4), HScale(2.1))];
    _commentImage.image = [UIImage imageNamed:@"评论icon"];
    [self.contentView addSubview:_commentImage];
    
    _likeImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(89.3), HScale(2.1), WScale(3.5), HScale(2.1))];
    _likeImage.image = [UIImage imageNamed:@"点赞icon"];
    [self.contentView addSubview:_likeImage];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(82.9), HScale(2.1), WScale(5), HScale(2.5))];
    _commentLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _commentLabel.textColor = [UIColor whiteColor];
    _commentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_commentLabel];
    
    _likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-WScale(2.1)-WScale(5), HScale(2.1), WScale(5), HScale(2.5))];
    _likeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _likeLabel.textAlignment = NSTextAlignmentCenter;
    _likeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_likeLabel];
    
    _describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(2.7), HScale(27.7), ScreenWidth - WScale(5.4), HScale(3.3))];
    _describeLabel.textAlignment = NSTextAlignmentLeft;
    _describeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_describeLabel];
}

-(void)relayoutWithModel:(FindAceModel *)model{
    [_groundImage sd_setImageWithURL:[NSURL URLWithString:model.grongImage]];
    _groundImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(32.2));
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.aceTime];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.frame = CGRectMake(WScale(1.6), HScale(0.5), WScale(10.7), HScale(2.1));
    _timeImage.frame = CGRectMake(0, HScale(1.8), WScale(14.7), HScale(3));
    
    
    _commentLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
    _commentLabel.shadowColor = GPColor(26, 26, 26);
    _commentLabel.shadowOffset = CGSizeMake(0, 1);
    
    _likeLabel.text = [NSString stringWithFormat:@"%@",model.likeNum];
    _likeLabel.shadowColor = GPColor(26, 26, 26);
    _likeLabel.shadowOffset = CGSizeMake(0, 1);
    
    
    _describeLabel.text = [NSString stringWithFormat:@"%@",model.describeLabel];
    _describeLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _describeLabel.shadowColor = GPColor(26, 26, 26);
    _describeLabel.shadowOffset = CGSizeMake(0, 1);
    
}
@end
