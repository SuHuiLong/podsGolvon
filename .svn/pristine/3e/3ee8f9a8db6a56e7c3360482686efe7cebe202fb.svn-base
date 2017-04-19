//
//  SupportTableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/8/11.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupportModel.h"

@interface SupportTableViewCell : UITableViewCell

/***  头像*/
@property (strong, nonatomic) UIImageView    *headerImage;
/***  昵称*/
@property (strong, nonatomic) UILabel    *nickname;
/***  时间*/
@property (strong, nonatomic) UILabel    *timeLabel;
/***  关注*/
@property (strong, nonatomic) UIButton    *followBtn;
/***  关注的图片*/
@property (strong, nonatomic) UIImageView    *followImage;

@property (strong, nonatomic) UIImageView    *Vimage;

/***  model*/
@property (strong, nonatomic) SupportModel    *model;

@property (nonatomic, copy) void(^setFollowBtnBlock)(SupportModel *model);

-(void)relayoutWithModel:(SupportModel *)model;
@end
