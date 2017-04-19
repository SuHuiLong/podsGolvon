//
//  DZ_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dianZanModel.h"
#import "UIButton+WebCache.h"
#import "PicOrContent.h"

@interface DZ_TableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *headerBtn;
@property (strong, nonatomic) UIButton *nameBtn;
/***  类型*/
@property (strong, nonatomic) UILabel  *typeLabel;
@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UILabel  *timeLabel;


@property (strong, nonatomic) UIImageView    *Vimage;
@property (strong, nonatomic) UIImageView    *pictureImageView;
@property (strong, nonatomic) UIImageView    *imageViewO;
@property (strong, nonatomic) UIImageView    *imageViewT;
@property (strong, nonatomic) UIImageView    *imageViewS;


/***  line*/
@property (strong, nonatomic) UIView    *lineView;

@property (strong, nonatomic) dianZanModel    *model;


/***  点击头像跳转*/
@property (copy, nonatomic) void(^ClickHeaderBlock)    (dianZanModel *model);

@property (copy, nonatomic) void(^ClickNickNameBlock)    (dianZanModel *mdoel);

-(void)realyoutWithModel:(dianZanModel *)model;
@end
