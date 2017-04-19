//
//  HomePageCollectionViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCardModel.h"
#import "UIImage+Addition.h"


@interface HomePageCollectionViewCell : UICollectionViewCell
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

@property (strong, nonatomic) UIImageView      *accessImageView;

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
@property (strong, nonatomic) UIImageView    *mask;


/***  正在进行打球的背景色*/
@property (strong, nonatomic) UIImageView    *playingImage;
/***  正在记分*/
@property (strong, nonatomic) UILabel    *scroingLabel;
/***  外圈*/
@property (strong, nonatomic) UIImageView    *bezelImage;
/***  内图*/
@property (strong, nonatomic) UIImageView    *playImage;


@property (strong, nonatomic) UIButton      *followBtn;


@property (strong, nonatomic) UIButton      *loadingBtn;

@property (copy, nonatomic) void(^LoadingBlock) (CollectionCardModel *model);

@property (strong, nonatomic) CollectionCardModel      *model;

-(void)relayoutWithModel:(CollectionCardModel *)model;

@end
