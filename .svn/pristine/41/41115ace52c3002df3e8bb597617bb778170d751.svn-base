//
//  GolfersTableViewCell.h
//  podsGolvon
//
//  Created by apple on 2016/10/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GolfersModel.h"
#import "UserBallParkModel.h"
#import "PPPersonModel.h"

@interface GolfersTableViewCell : UITableViewCell
@property(nonatomic,copy)UIImageView  *headerImageView;//图片
@property(nonatomic,copy)UILabel  *nameLabel;//名字
@property(nonatomic,copy)UILabel  *phoneLabel;//手机号码
@property(nonatomic,strong)UIButton  *selectBtn;//选中按钮
@property(nonatomic,copy)UIView  *line;//下线

//球员列表
-(void)configModel:(GolfersModel *)model;
//球场列表
-(void)configParkModel:(UserBallParkModel *)model;
//通讯录列表
-(void)configAddressModel:(PPPersonModel *)model;

@end
