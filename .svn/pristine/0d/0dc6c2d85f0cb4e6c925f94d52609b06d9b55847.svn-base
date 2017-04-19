//
//  FriendsterModel.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicMessageModel.h"
#import "LikeUsersModel.h"
#import "PictureModel.h"

@interface FriendsterModel : NSObject


@property (copy, nonatomic) NSString *content;            //发布的内容

@property (copy, nonatomic) NSString *pubtime;            //发布时间

@property (copy, nonatomic) NSString *nickname;           //昵称

@property (copy, nonatomic) NSString    *uid;               //用户ID

@property (copy, nonatomic) NSString *position;           //定位

@property (copy, nonatomic) NSString *avator;             //头像

@property (assign, nonatomic) BOOL isfocused;               //关注状态

@property (assign, nonatomic) BOOL isclicked;               //点赞状态

@property (copy, nonatomic) NSNumber *clicknum;         //点赞数

@property (copy, nonatomic) NSNumber *commetum;         //评论数

@property (copy, nonatomic) NSString *did;                //动态ID

@property (copy, nonatomic) NSString    *interview;       //专访状态

/***  这些集合是 dynamicMessage, Picture, LikeUsers 的model集合, 在本类的实现文件中指定对应的类型即可.*/

@property (strong, nonatomic) NSMutableArray<DynamicMessageModel*>    *commets;
@property (strong, nonatomic) NSMutableArray<LikeUsersModel*>    *clicks;
@property (copy, nonatomic) NSArray<PictureModel*>    *pics;


@end

