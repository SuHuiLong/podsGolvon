//
//  ChildCommentModel.h
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildCommentModel : NSObject

@property (copy, nonatomic) NSString *comm_id;  //评论ID
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *comuid;
@property (copy, nonatomic) NSString *comnickname;
@property (copy, nonatomic) NSString *statr;    //0:评论  1:回复
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *compic;

@property (copy, nonatomic) NSString *replyuid; //回复
@property (copy, nonatomic) NSString *replynickname;

@property (copy, nonatomic) NSString *likenum;
@end
