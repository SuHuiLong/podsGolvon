//
//  Liuyan_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuYanModel.h"

@interface Liuyan_TableViewCell : UITableViewCell

@property (strong, nonatomic)UIButton *headerImage;
@property (strong, nonatomic)UIButton *nameLabel;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UIView *line;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *reaply;

-(void)relayoutWithLY:(LiuYanModel *)model;

@end
