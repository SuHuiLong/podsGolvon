//
//  HomePageScrollViewCell.h
//  podsGolvon
//
//  Created by suhuilong on 16/9/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCardModel.h"

@interface HomePageScrollViewCell : UIView
/***  封面*/
@property (strong, nonatomic) UIImageView *coverImage;
/***  性别*/
@property (strong, nonatomic) UIImageView *sexImage;
/***  正在进行*/
@property (strong, nonatomic) UIImageView *ingImage;
/***  专访*/
@property (strong, nonatomic) UIImageView *Vimage;
/***  访问量*/
@property (strong, nonatomic) UILabel    *accessMent;

/***  昵称*/
@property (strong, nonatomic) UILabel     *nickName;
/***  杆数*/
@property (strong, nonatomic) UILabel     *poleNumber;
/***  签名*/
@property (strong, nonatomic) UILabel    *siignature;
/***  市*/
@property (strong, nonatomic) UILabel    *address;
/***  职业*/
@property (strong, nonatomic) UILabel    *work;

/***  线*/
@property (strong, nonatomic) UIView    *line1;
/***  线*/
@property (strong, nonatomic) UIView    *line2;

/***  蒙版*/
@property (strong, nonatomic) UIImageView    *maskView;

-(void)relayoutWithModel:(CollectionCardModel *)model;

@end
