//
//  FindAceModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/23.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "FindAceModel.h"

@implementation FindAceModel
+(FindAceModel *)pareFromWithDictionary:(NSDictionary *)dic{
    FindAceModel *model = [[FindAceModel alloc]init];
    model.commentNum    = dic[@"comnumber"];
    model.likeNum       = dic[@"click_like_number"];
    model.describeLabel = dic[@"interview_miaoshu"];
    model.grongImage    = dic[@"picture_url"];
    model.interViewID   = dic[@"interview_id"];
    model.aceTime       = dic[@"interview_stage"];
    model.interViewerID = dic[@"interviewer_id"];
    model.nickname      = dic[@"nickname"];
    model.red_number    = dic[@"red_number"];
    model.htmlStr       = dic[@"interview_url"];

    return model;
}
@end
