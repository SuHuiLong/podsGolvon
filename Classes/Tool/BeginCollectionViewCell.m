//
//  BeginCollectionViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BeginCollectionViewCell.h"


@implementation BeginCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = WhiteColor;
        [self createSubview];
    }
    return self;
}

-(void)createSubview{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:kHorizontal(31)];
    _titleLabel.textColor = GPColor(17, 17, 17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.frame = CGRectMake(0, kHvertical(420), ScreenWidth, kHvertical(44));
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:kHorizontal(17)];
    _contentLabel.textColor = GPColor(52, 52, 52);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.frame = CGRectMake(0, kHvertical(466), ScreenWidth, kHvertical(44));
    [self.contentView addSubview:_contentLabel];
    
    _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registBtn.frame = CGRectMake((ScreenWidth - kWvertical(158))/2, _contentLabel.bottom + kHvertical(59), kWvertical(158), kHvertical(38));
    _registBtn.layer.borderWidth = 0.5f;
    _registBtn.layer.cornerRadius = 2.f;
    _registBtn.layer.borderColor = localColor.CGColor;
    [_registBtn setTitle:@"进入打球去" forState:UIControlStateNormal];
    [_registBtn setTitleColor:localColor forState:UIControlStateNormal];
    _registBtn.hidden = YES;
    [self.contentView addSubview:_registBtn];
    
}
-(void)relayoutImageWithName:(NSString *)imageName andTitle:(NSString *)title andContent:(NSString *)content{
    _imageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
    _contentLabel.text = content;
}
@end
