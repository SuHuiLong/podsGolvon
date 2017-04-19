//
//  RankSelfHeader.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/20.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulesModel.h"

@interface RankSelfHeader : UITableViewHeaderFooterView
/***  头像*/
@property (strong, nonatomic) UIImageView    *headerImage;
/***  点赞照片*/
@property (strong, nonatomic) UIImageView    *likeImage;
/***  昵称*/
@property (strong, nonatomic) UILabel    *nickName;
/***  排名*/
@property (strong, nonatomic) UILabel    *rankLabel;
/***  场次*/
@property (strong, nonatomic) UILabel    *changCiLabel;
/***  点赞数*/
@property (strong, nonatomic) UILabel    *likeNum;
@property (strong, nonatomic) UIButton    *lickBtn;

@property (strong, nonatomic) UIImageView    *Vimage;

/***  没有打球*/
@property (strong, nonatomic) UILabel    *noneRank;

@property (strong, nonatomic) UIView      *lineView;

@property (strong,nonatomic) RulesModel *model;

@property (nonatomic, copy) void(^lickBtnBlock)(RulesModel *model);

-(void)relayoutWithModel:(RulesModel *)model;
@end
