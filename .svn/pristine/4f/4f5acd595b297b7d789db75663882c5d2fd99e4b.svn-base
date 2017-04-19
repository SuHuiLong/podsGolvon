//
//  XT_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiTongModel.h"

@interface XT_TableViewCell : UITableViewCell

//背景view

@property (strong, nonatomic) UIView      *groundView;

@property (strong, nonatomic) UILabel     *timeLabel;
//标题
@property (strong, nonatomic) UILabel     *titleLabel;
//发布者
@property (strong, nonatomic) UILabel     *nameLabel;
//内容
@property (strong, nonatomic) UILabel     *contentLabel;
//图片
@property (strong, nonatomic) UIImageView *system_picurl;

@property (strong, nonatomic) UIImageView *cornerImageView;

@property (strong, nonatomic) UIView      *lineView;

@property (strong, nonatomic) UILabel     *checkLabel;

@property (strong, nonatomic) UIButton      *deleBtn;

/***  更多*/
@property (strong, nonatomic) UIImageView    *moreImage;


@property (strong, nonatomic) XiTongModel      *model;

@property (copy, nonatomic) void(^deleteMessageBlock) (XiTongModel *model);

-(void)realyoutWithModel:(XiTongModel *)model;
@end
