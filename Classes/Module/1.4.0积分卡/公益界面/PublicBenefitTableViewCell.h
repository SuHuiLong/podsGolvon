//
//  PublicBenefitTableViewCell.h
//  podsGolvon
//
//  Created by SHL on 2016/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicBenefitModel.h"
@interface PublicBenefitTableViewCell : UITableViewCell

//排名
@property(nonatomic,copy)UILabel  *rankLabel;
//头像
@property(nonatomic,copy)UIImageView  *headerView;
//名字
@property(nonatomic,copy)UILabel  *nameLabel;
//金额
@property(nonatomic,copy)UILabel  *moneyLabel;
//  专访标志
@property (strong, nonatomic) UIImageView    *Vimage;


-(void)configModel:(PublicBenefitModel *)model;
@end
