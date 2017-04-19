//
//  LocationTableViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsterModel.h"


@interface LocationTableViewCell : UITableViewCell
/***  定位图片*/
@property (strong, nonatomic) UIImageView *localImage;
/***  线*/
@property (strong, nonatomic) UIView    *line;
/***  地址*/
@property (strong, nonatomic) UILabel     *addressLabel;
/***  dianzan*/
@property (strong, nonatomic) UIButton    *likeBtn;
/***  评论*/
@property (strong, nonatomic) UIButton    *commentBtn;
/***  点赞状态*/
@property (assign, nonatomic) BOOL      state;
/***  model*/
@property (strong, nonatomic) FriendsterModel    *model;
@property (strong, nonatomic) void(^likeBtnBlock)(FriendsterModel *model);

- (void)relayoutWithModel:(FriendsterModel *)model;
@end
