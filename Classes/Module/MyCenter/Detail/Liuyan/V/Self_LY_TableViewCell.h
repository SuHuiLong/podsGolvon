//
//  Self_LY_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfLiuYanModel.h"

@interface Self_LY_TableViewCell : UITableViewCell

@property (strong, nonatomic)UIButton *headerImage;
@property (strong, nonatomic)UIButton *nameLabel;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UIView *line;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *reaply;

@property (strong, nonatomic) UIImageView      *Vimage;

-(void)realyoutWithModel:(SelfLiuYanModel *)model;

@end
