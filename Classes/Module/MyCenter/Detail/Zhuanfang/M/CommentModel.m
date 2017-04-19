//
//  CommentModel.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(CommentModel *)pareWithDictionary:(NSDictionary *)dic{
    CommentModel *model = [[CommentModel alloc]init];
    model.photo = dic[@"picture_url"];
    model.comment = dic[@"comment_content"];
    model.nickName = dic[@"comment_name"];
    model.timeLabel = dic[@"comment_time"];
    model.zanLabel = dic[@"like_number"];
    model.comment_id = dic[@"comment_id"];
    model.name_id = dic[@"comment_nameid"];
    model.like_statr = dic[@"like_statr"];
    model.reply_comment_sta = dic[@"reply_comment_sta"];
    model.reply_name = dic[@"covercomment_name"];
    model.reply_nameId = dic[@"covercomment_id"];
    return model;
}
@end
