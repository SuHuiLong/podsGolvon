//
//  NewDetailCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/1.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanFangModel.h"
#import "ScoringModel.h"
//#import "LiuYanModel.h"

@interface NewDetailCell : UITableViewCell
/**标题*/
@property (nonatomic ,strong)UILabel *title;
/**头像*/
@property (nonatomic ,strong)UIImageView *pictureURL;
/**时间*/
@property (nonatomic ,strong)UILabel *timeLabel;
/**描述*/
@property (nonatomic ,strong)UILabel *messageLabel;
/**照片名字*/
@property (nonatomic ,strong)NSString *pictureName;
/**杆数*/
@property (nonatomic ,strong)UILabel *poleNum;
/***  打球时间*/
@property (strong, nonatomic) NSString    *loadTime;


@property (nonatomic ,strong) UIImageView            *playImage;
@property (nonatomic ,strong) UIImageView            *circle;

-(void)relayoutWithDictionary:(ZhuanFangModel *)model;
-(void)relayOutWithScoringModel:(ScoringModel *)model;
//-(void)relayOutWithLiuYanModel:(LiuYanModel *)model;
@end
