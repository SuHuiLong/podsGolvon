//
//  RulesTableViewCell.h
//  TabBar
//
//  Created by 李盼盼 on 16/7/28.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulesModel.h"

@interface RulesTableViewCell : UITableViewCell
/***  头像*/
@property (strong, nonatomic) UIImageView    *headerImage;
/***  排名照片*/
@property (strong, nonatomic) UIImageView    *rankImage;
/***  昵称*/
@property (strong, nonatomic) UILabel    *nickName;
/***  排名*/
@property (strong, nonatomic) UILabel    *rankLabel;
/***  场次*/
@property (strong, nonatomic) UILabel    *changCiLabel;
/***  点赞数*/
@property (strong, nonatomic) UILabel    *likeNum;
/***  所有用户的名次*/
@property (strong, nonatomic) UILabel    *allRankLabel;
@property (strong, nonatomic) UIImageView    *Vimage;


@property (strong, nonatomic) UIButton    *lickBtn;
@property (strong,nonatomic) RulesModel *model;

@property (nonatomic, copy) void(^lickBtnBlock)(RulesModel *model);

-(void)relayoutWithModel:(RulesModel *)model;
@end
