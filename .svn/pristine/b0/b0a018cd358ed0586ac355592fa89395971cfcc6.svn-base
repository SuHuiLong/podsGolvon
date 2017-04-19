//
//  StartScoringTableViewCell.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "StartScoringTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation StartScoringTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    //头像
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(12),kHvertical(15),kHvertical(28),kHvertical(28))];
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = kHvertical(14.5);
    _headView.backgroundColor = GPColor(235, 236, 237);
    
    //昵称
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.frame.origin.x + _headView.frame.size.width + kWvertical(13), kHvertical(19), WScale(56.8), kHvertical(21))];
    _NameLabel.textColor = GPColor(41, 41, 47);
    _NameLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    
    
    //删除的按钮
    _deleatView = [[UIButton alloc] initWithFrame:CGRectMake(kWvertical(339), HScale(5.1), WScale(4.3), HScale(2.2))];
    [_deleatView setImage:[UIImage imageNamed:@"删除球员"] forState:UIControlStateNormal];
    
    
    // 底部线
    CGFloat lineHeight = 1.f/[UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(.0f, .0f, lineHeight, lineHeight);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(lineHeight, lineHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, GPColor(247, 247, 247).CGColor);
    CGContextFillRect(context, rect);
    UIImage *lineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *bottomLineView = [[UIImageView alloc] initWithImage:lineImage];
    bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bottomLineView];
    
    
    
    [self.contentView addSubview:_selfLabel];
    [self.contentView addSubview:_headView];
    [self.contentView addSubview:_NameLabel];
    [self.contentView addSubview:_NumLabel];
    [self.contentView addSubview:_deleatView];
        
       // 底部线条
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:lineHeight]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomLineView)]];
}

-(void)pareModel:(StarPlayerModel *)model{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.picture_url]];
    _NameLabel.text = model.nick_name;
    _NumLabel.text = [NSString stringWithFormat:@"%@ 平均杆",model.meanPole];
}




@end
