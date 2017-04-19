//
//  AddStartScoringTableViewCell.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "AddStartScoringTableViewCell.h"

@implementation AddStartScoringTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.contentView.backgroundColor = [UIColor whiteColor];

    //头像
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(12),kHvertical(15),kHvertical(28),kHvertical(28))];
//    _headView.backgroundColor = GPColor(235, 236, 237);
    _headView.image = [UIImage imageNamed:@"go-输入－默认"];
    
    //昵称
    _nameLabel = [[UITextField alloc] initWithFrame:CGRectMake(_headView.frame.origin.x + _headView.frame.size.width + kWvertical(13), kHvertical(19), WScale(56.8), kHvertical(21))];
    _nameLabel.textColor = GPColor(41, 41, 47);
    _nameLabel.placeholder = @"球友名字";
    _nameLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _nameLabel.tintColor = localColor;
    _nameLabel.returnKeyType = UIReturnKeyDone;
    
    //删除的按钮
    _deleatView = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(56), 0,kWvertical(56), kHvertical(57))];
    UIImageView *deleat = [[UIImageView alloc] initWithFrame:CGRectMake( kWvertical(28), kHvertical(24),kHvertical(11), kHvertical(11))];
    
    [_deleatView addSubview:deleat];
    
    [_deleatView setImage:[UIImage imageNamed:@"删除球员"] forState:UIControlStateNormal];
    _deleatView.hidden = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(12.6)-1, ScreenWidth, 1)];
    line.backgroundColor = GPColor(226, 226, 226);
    
    //昵称
    _NickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.frame.origin.x + _headView.frame.size.width + kWvertical(13), kHvertical(19), WScale(56.8), kHvertical(21))];
    _NickNameLabel.textColor = GPColor(41, 41, 47);
    _NickNameLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    
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
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_deleatView];
    [self.contentView addSubview:_NickNameLabel];
    
    // 底部线条
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:lineHeight]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomLineView)]];

    
    
}


-(void)pareModel:(StarPlayerModel *)model{
    _deleatView.hidden = NO;
    _nameLabel.hidden = YES;
    _headView.layer.masksToBounds = YES;
    _NickNameLabel.hidden = NO;

    _headView.layer.cornerRadius = kHvertical(14.5);
    if ([model.name_id isEqualToString:userDefaultId]) {
        _deleatView.hidden = YES;
    }
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.picture_url]placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    _NickNameLabel.text = model.nick_name;

 
}


-(void)pareTestModel:(StarPlayerModel *)model{
    NSString *nick_name = model.nick_name;
    _nameLabel.hidden = NO;
    _NickNameLabel.hidden = YES;
    _nameLabel.text = model.nick_name;

    if (nick_name.length==0) {
        _headView.image = [UIImage imageNamed:@"go-输入－默认"];
        _deleatView.hidden = YES;

    }else{
    _deleatView.hidden = NO;
    _headView.image = [UIImage imageNamed:@"go-输入－激活"];
    }
    
    
}





@end
