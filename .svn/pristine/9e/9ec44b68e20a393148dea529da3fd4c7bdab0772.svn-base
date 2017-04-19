//
//  AddBallParkTableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/8/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallParkSelectModel.h"

@interface AddBallParkTableViewCell : UITableViewCell

/***  球场名称*/
@property (strong, nonatomic) UILabel    *ballParkName;
/***  删除按钮*/
@property (strong, nonatomic) UIButton    *deleBtn;
/***  模型*/
@property (strong, nonatomic) BallParkSelectModel    *model;
/***  删除*/
@property (copy, nonatomic) void(^deleteHistoryBallPark)(BallParkSelectModel *model);

-(void)relayoutWithModel:(BallParkSelectModel *)model;
@end
