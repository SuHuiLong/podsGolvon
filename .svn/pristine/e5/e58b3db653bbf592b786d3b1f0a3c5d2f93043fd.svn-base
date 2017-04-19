//
//  CollectionHeader.h
//  我的 改1
//
//  Created by 李盼盼 on 16/5/26.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Size.h"
#import "MarkItem.h"

@interface CollectionHeader : UICollectionReusableView
@property (nonatomic, strong) UIImageView *backGroundImage;
@property (nonatomic, strong) UIImageView *sexImage;
@property (nonatomic, strong) UIImageView *headerImage;

@property (strong, nonatomic) UIImageView *Vimage;
@property (nonatomic, strong) UILabel     *subLayer;
@property (nonatomic, strong) UILabel     *groundLabel;
@property (nonatomic, strong) UILabel     *nickName;
@property (nonatomic, strong) UILabel     *ownMessage;
@property (nonatomic, strong) UILabel     *signature;
@property (nonatomic, strong) UILabel     *material;
@property (strong, nonatomic) NSArray     *adjArray;//粉丝，关注，留言

@property (strong, nonatomic) UIButton      *fansBtn;           //粉丝按钮
@property (strong, nonatomic) UIButton      *liuyanBtn;         //留言按钮
@property (strong, nonatomic) UIButton      *followBtn;         //关注按钮
@property (strong, nonatomic) UILabel       *changCi;           //场次
@property (strong, nonatomic) UILabel       *zhuaNiao;          //抓鸟
@property (strong, nonatomic) UILabel       *ciShan;            //慈善

//粉丝留言未读消息
@property (strong, nonatomic) UIView      *unReadFans;      //未读关注
@property (strong, nonatomic) UIView      *unReadMessage;   //未读留言


/**
 *  标签内容背景
 */
@property(nonatomic,strong)UIImageView *markGroundImage1;
@property(nonatomic,strong)UIImageView *markGroundImage2;
@property(nonatomic,strong)UIImageView *markGroundImage3;
@property(nonatomic,strong)UIImageView *markGroundImage4;
@property(nonatomic,strong)UIImageView *markGroundImage5;
@property(nonatomic,strong)UIImageView *markGroundImage6;

/**
 *  标签内容
 */
@property(nonatomic,strong)UILabel *markLabel1;
@property(nonatomic,strong)UILabel *markLabel2;
@property(nonatomic,strong)UILabel *markLabel3;
@property(nonatomic,strong)UILabel *markLabel4;
@property(nonatomic,strong)UILabel *markLabel5;
@property(nonatomic,strong)UILabel *markLabel6;

/**
 *  标签头
 */
@property(nonatomic,strong)UIImageView *markHeaderImage1;
@property(nonatomic,strong)UIImageView *markHeaderImage2;
@property(nonatomic,strong)UIImageView *markHeaderImage3;
@property(nonatomic,strong)UIImageView *markHeaderImage4;
@property(nonatomic,strong)UIImageView *markHeaderImage5;
@property(nonatomic,strong)UIImageView *markHeaderImage6;


/**
 *  存放标签的label
 */
@property (strong, nonatomic) UILabel                *markView1;
@property (strong, nonatomic) UILabel                *markView2;
@property (strong, nonatomic) UILabel                *markView3;
@property (strong, nonatomic) UILabel                *markView4;
@property (strong, nonatomic) UILabel                *markView5;
@property (strong, nonatomic) UILabel                *markView6;

@property (nonatomic,copy)    NSMutableArray        *markArry;              //存放标签的数据
@property (nonatomic, copy) NSArray<MarkItem *> *markItemsArray; ///< 标签工具集合

@property(nonatomic,copy)UILabel *readNum;
@property(nonatomic,copy)UIImageView *viewImage;
@property(nonatomic,copy)UIImageView *cheakStyle;
/**
 *  性别
 */
@property (strong, nonatomic) NSString      *sex;

/**
 *  线
 */
@property (strong, nonatomic) UIView      *line1;
@property (strong, nonatomic) UIView      *line2;
@property (strong, nonatomic) UIImageView     *pageViewImage;
@property (strong, nonatomic) UILabel         *pageViewLabel;

-(void)reloadData;

@end
