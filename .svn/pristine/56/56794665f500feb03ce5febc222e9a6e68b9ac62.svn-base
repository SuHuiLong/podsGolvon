//
//  SelfLiuYanModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/10.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SelfLiuYanModel.h"

@implementation SelfLiuYanModel

+(SelfLiuYanModel *)pareFromDictionary:(NSDictionary *)dic{
    SelfLiuYanModel *model = [[SelfLiuYanModel alloc]init];
    model.messageContent = dic[@"message_content"];
    model.messageTime = dic[@"message_time"];
    model.nameID = dic[@"name_id"];
    model.picture = dic[@"picture_url"];
    model.nickname = dic[@"nickname"];
    model.allPage = dic[@"allpage"];
    model.reply_message_sta = dic[@"reply_message_sta"];
    model.covermessage_name = dic[@"cover_reply_nackname"];
    model.cover_reply_nameid = dic[@"cover_reply_nameid"];
    model.cover_reply_nackname = dic[@"cover_reply_nackname"];
    model.interview_state = dic[@"vid"];
    return model;
}

@end
