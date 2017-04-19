//
//  FrendsImageTableViewCell.h
//  podsGolvon
//
//  Created by MAYING on 2016/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsterModel.h"
#import "YYControl.h"
#import "PhotoBrower.h"
#import "PhotoBrowCollectionView.h"

@interface FriendsImageTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    CGFloat _PICWIDHT;
    CGFloat _PICHEIGTH;
    CGSize contentSize;
    //图片数组
    NSMutableArray *_imageViewsArray;
    //图片链接数组
    NSMutableArray *_imageUrlArray;
    UIViewController *currentViewController;

}

@property (strong, nonatomic) PhotoBrowerLayoutModel      *layoutModel;


@property (strong, nonatomic) UIImageView *headerIcon;
@property (strong, nonatomic) UIImageView *Vicon;
@property (strong, nonatomic) UIImageView *addressImage;
/***  一张图*/
@property (strong, nonatomic) YYControl   *oneImage;
//多图
@property (nonatomic, strong) YYControl   *moreImage;
@property (nonatomic, strong) UIImageView  *baseView;

@property (strong, nonatomic) UIView      *line;
@property (strong, nonatomic) UIButton    *likeBtn;
@property (strong, nonatomic) UIButton    *commentBtn;
@property (strong, nonatomic) UILabel     *nickname;
@property (strong, nonatomic) UILabel     *timeLabel;
@property (strong, nonatomic) UILabel     *addressLabel;
@property (strong, nonatomic) UILabel     *content;
@property (copy, nonatomic  ) NSString    *type;

/***  删除角标*/
@property (strong, nonatomic) UIButton    *deleBtn;


@property (strong, nonatomic) UICollectionView           *likeView;
@property (strong, nonatomic) FriendsterModel            *model;
/**
 *  评论
 */
@property (copy, nonatomic) void(^commentBlock) (FriendsterModel *model);
/**
 *  点赞
 */
@property (copy, nonatomic) void(^likeBlock) (FriendsterModel *model);
/**
 *  删除
 */
@property (copy, nonatomic) void(^deleBlock) (FriendsterModel *model);


/***  跳转个人中心的button*/
@property (strong, nonatomic) UIButton    *turnBtn;
@property (copy, nonatomic) void(^clickHeaderIconBlock) (FriendsterModel *model);
@property (copy, nonatomic) void(^longpressHeaderImageBlock) (FriendsterModel *model);
@property (copy, nonatomic) void(^longpressHeader) (FriendsterModel *model);




@property (strong, nonatomic) UIButton      *followBtn;

@property (copy, nonatomic) void(^followBlock) (FriendsterModel *model);


/***  最新评论*/
@property (strong, nonatomic) UIView    *comlinView;

@property (strong, nonatomic) UIView      *pressView;
@property (strong, nonatomic) UILabel    *comLabel;
/***  view*/
@property (strong, nonatomic) UIView    *comView;


@property (strong, nonatomic) UIActionSheet      *longpressActionSheet;
@property (strong, nonatomic) UIActionSheet      *reportActionSheet;


//小组手举报按钮
@property (nonatomic,copy)UIButton *reportBtn;


//-(void)relayoutWithModel:(FriendsterModel *)model;
//-(void)relayoutWithNonePicModel:(FriendsterModel *)model;
//-(void)relayoutWithOnePicModel:(FriendsterModel *)model;
-(void)setDataWithModel:(FriendsterModel *)model;
-(UIViewController *)viewController:(UIView *)view;


@end
