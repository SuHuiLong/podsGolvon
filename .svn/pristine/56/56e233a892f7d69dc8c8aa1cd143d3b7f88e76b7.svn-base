//
//  dianZanModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/4/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicOrContent.h"

@interface dianZanModel : NSObject

/***  消息的类型 1：专访，2：评论，3：榜单，4：动态*/
@property (copy, nonatomic) NSString    *type;

@property (copy, nonatomic) NSString    *avator;        //头像

@property (copy, nonatomic) NSString    *clickid;       //点赞人的id

@property (copy, nonatomic) NSString    *uid;

@property (copy, nonatomic) NSString    *nickname;      //昵称

@property (copy, nonatomic) NSString    *time;          //时间

@property (copy, nonatomic) NSString    *cuvid;



//朋友圈
@property (copy, nonatomic) NSString    *hascontent;    //是否有文字内容 1 有(取dcontent字段)  0无(取pics字段)

@property (copy, nonatomic) NSString    *dcontent;

@property (copy, nonatomic) NSString *did;
//评论
//@property (copy, nonatomic) NSString    *comment_content;



//专访
@property (copy, nonatomic) NSString    *vid;

@property (copy, nonatomic) NSString    *vtitle;

@property (copy, nonatomic) NSString    *isrank;



@property (copy, nonatomic) NSArray<PicOrContent *>    *pics;



@end
