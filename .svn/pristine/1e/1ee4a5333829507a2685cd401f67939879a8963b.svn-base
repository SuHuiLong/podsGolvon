//
//  ScorViewCell.h
//  单人记分
//
//  Created by 李盼盼 on 16/6/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScorModel.h"

@interface ScorViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView            *playImage;
@property (nonatomic ,strong) UIImageView            *scoreImage;
@property (nonatomic ,strong) UIImageView            *circle;
@property (nonatomic ,strong) UILabel                *poleNum;
@property (nonatomic ,strong) UILabel                *ballPark;
@property (nonatomic ,strong) UILabel                *timeLabel;
@property (nonatomic ,strong) UIButton               *underway;
@property (strong, nonatomic) UILabel                *money;
@property (strong, nonatomic) UILabel                *moneyNum;
@property (strong, nonatomic) UIImageView            *moneyImage;
@property (strong, nonatomic) UIView    *line2;
@property (strong, nonatomic) UIView    *line;

/**
 *  积分统计
 */
-(void)relayoutWithDictionary:(ScorModel *)dic;
/**
 *  最好的成绩
 */
-(void)relayoutWithBestDictionary:(ScorModel *)dic;
/**
 *  正在进行
 */
-(void)relayoutWithLoadingDictionary:(ScorModel *)dic;
@end