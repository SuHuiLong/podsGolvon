//
//  Self_GuanZhuTableViewCell.h
//  Golvon
//
//  Created by shiyingdong on 16/4/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Slef_GuanZhuModel.h"
#import "UIButton+WebCache.h"

@interface Self_GuanZhuTableViewCell : UITableViewCell
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


@property (strong, nonatomic) UIImageView      *Vimage;

@property (strong, nonatomic) Slef_GuanZhuModel    *model;
//
@property (nonatomic, copy) void(^followBtnBlock)(Slef_GuanZhuModel *model);

//-(void)relayoutWithModel:(Slef_GuanZhuModel *)model;

-(void)relayoutDataWithModel:(Slef_GuanZhuModel *)model;


@end
