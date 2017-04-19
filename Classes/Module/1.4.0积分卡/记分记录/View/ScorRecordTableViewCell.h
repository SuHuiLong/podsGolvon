//
//  ScorRecordTableViewCell.h
//  podsGolvon
//
//  Created by SHL on 2016/10/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScorRecordListModel.h"

@interface ScorRecordTableViewCell : UITableViewCell
//
@property (nonatomic ,strong) UIImageView            *playImage;

@property (nonatomic,   copy) UIImageView            *circle;
@property (nonatomic,   copy) UILabel                *poleNum;//杆数
@property (nonatomic,   copy) UILabel                *ballPark;//球场
@property (nonatomic,   copy) UILabel                *donePole;//已完成球洞
@property (nonatomic,   copy) UILabel                *timeLabel;//时间
@property (nonatomic,   copy) UIButton               *underwayShare;//正在进行&&分享
@property (nonatomic, strong) UILabel                *underwayShareLabel;//分享文字
@property (nonatomic,   copy) UILabel                *money;//金额
@property (nonatomic,   copy) UILabel                 *errorLabel;//未完成&&无效记分
@property (nonatomic,   copy) UIView                 *line;//底部线


//加载数据
-(void)relayoutWithDictionary:(ScorRecordListModel *)model;


//最好的成绩
-(void)relayoutWithBestDictionary:(ScorRecordListModel *)dic;


@end
