//
//  FindAceCollectionViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/23.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindAceModel.h"

@interface FindAceCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView   *groundImage;           //背景图片
@property (strong, nonatomic) UIImageView   *timeImage;             //专访时间背景
@property (strong, nonatomic) UIImageView   *commentImage;          //评论图标
@property (strong, nonatomic) UIImageView   *likeImage;             //点赞图标
@property (strong, nonatomic) UILabel       *timeLabel;             //专访时间
@property (strong, nonatomic) UILabel       *commentLabel;          //评论数
@property (strong, nonatomic) UILabel       *likeLabel;             //点赞数
@property (strong, nonatomic) UILabel       *describeLabel;         //描述


-(void)relayoutWithModel:(FindAceModel *)model;
@end
