//
//  StartScoringTableViewCell.h
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarPlayerModel.h"

@interface StartScoringTableViewCell : UITableViewCell

/***  头像*/
@property(nonatomic,strong)UIImageView  *headView;
/***  昵称*/
@property(nonatomic,copy)UILabel      *NameLabel;
/***  杆数*/
@property(nonatomic,copy)UILabel      *NumLabel;
/***  删除按钮*/
@property(nonatomic,strong)UIButton     *deleatView;
/***  自己的标识符*/
@property(nonatomic,strong)UILabel      *selfLabel;
/***  线*/
@property(nonatomic,strong)UIView       *line;

/***  模型*/
@property (strong, nonatomic) NSDictionary    *dict;

-(void)pareModel:(StarPlayerModel *)model;

@end
