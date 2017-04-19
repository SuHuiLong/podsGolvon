//
//  NewSelfCollectionViewCell.m
//  Golvon
//
//  Created by shiyingdong on 16/6/1.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "NewSelfCollectionViewCell.h"

@implementation NewSelfCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,self.contentView.frame.size.height)];

        _topImage.hidden = NO;

        [self.contentView addSubview:_topImage];
        
        
        UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.35;
        [self.contentView addSubview:maskView];
        
        
        _jifen = [[UILabel alloc]init];
        _jifen.hidden = YES;
        _jifen.backgroundColor = [UIColor clearColor];
        _jifen.textAlignment = NSTextAlignmentCenter;
        _jifen.font = [UIFont systemFontOfSize:kHorizontal(40)];
        [self.contentView addSubview:_jifen];
        
        
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        
        
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.height-HScale(6), self.contentView.frame.size.width, HScale(3.7))];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor whiteColor];
        _botlabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
        _botlabel.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        _botlabel.layer.shadowOpacity = 4;
        _botlabel.layer.shadowOffset = CGSizeMake(0, 2);
        [self.contentView addSubview:_botlabel];
        
        
        _circle = [[UIImageView alloc]init];
        [self.contentView addSubview:_circle];
        
        //    播放图片
        _playImage = [[UIImageView alloc]init];
        
        [self.contentView addSubview:_playImage];
        
        
        _playImage.hidden = YES;
        _circle.hidden = YES;
        
    }
    
    return self;
}

@end
