//
//  LikeTableViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsterModel.h"
#import "LikeUsersModel.h"


@interface LikeTableViewCell : UICollectionViewCell
/***  头像*/
@property (strong, nonatomic) UIImageView    *headerIcon;
@property (strong, nonatomic) UIImageView      *Vimage;

@property (strong, nonatomic) UILongPressGestureRecognizer      *pressLikeHeader;

@property (strong, nonatomic) LikeUsersModel      *model;

@property (copy, nonatomic) void(^pressHeaderBlock) (LikeUsersModel *model);

-(void)relayoutWithModel:(LikeUsersModel *)model;
@end
