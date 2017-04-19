//
//  FriendsterTableViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsterModel.h"


@interface FriendsterTableViewCell : UITableViewCell

/***  评论人的昵称*/
@property (strong, nonatomic) UIButton    *commentNickname;
/***  回复人的昵称*/
@property (strong, nonatomic) UIButton    *replyNickname;
/***  头像*/
@property (strong, nonatomic) UIButton    *headerBtn;

@property (copy, nonatomic) void(^longpressBlock) (DynamicMessageModel *model);
@property (copy, nonatomic) void(^pressHeaderBlock) (DynamicMessageModel *model);

-(void)relayoutWithModel:(DynamicMessageModel *)model;

@end
