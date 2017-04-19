//
//  BallParkTableViewCell.h
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallParkSelectModel.h"

@interface BallParkTableViewCell : UITableViewCell
@property (strong, nonatomic) UIView   *Backview;//图标背景
@property (strong, nonatomic) UIImageView   *imageIcon;  //球场图标
@property (strong, nonatomic) UILabel   *ballParkName;   //球场名字

//-(void)relayoutWithString:(NSString *)string;
//-(void)relayoutWithHistory:(NSString *)history;
-(void)relayoutWithModel:(id)model;
@end
