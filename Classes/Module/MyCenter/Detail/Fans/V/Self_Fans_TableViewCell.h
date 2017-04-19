//
//  Self_Fans_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfFansModel.h"
#import "UIButton+WebCache.h"

@interface Self_Fans_TableViewCell : UITableViewCell
@property (strong, nonatomic)UIButton *headerImage;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *titleLabel;

/***  正在记分*/
@property (strong, nonatomic) UILabel    *scroingLabel;
/***  外圈*/
@property (strong, nonatomic) UIImageView    *bezelImage;
/***  内图*/
@property (strong, nonatomic) UIImageView    *playImage;

/***  关注按钮*/
@property (strong, nonatomic) UIButton     *followBtn;
/***  关注的图片*/
@property (strong, nonatomic) UIImageView    *followImage;


@property (strong, nonatomic) UIImageView      *Vimage;

@property (strong, nonatomic) SelfFansModel    *model;
//
@property (nonatomic, copy) void(^followBtnBlock)(SelfFansModel *model);

-(void)relayoutDataWithModel:(SelfFansModel *)model;

@end
