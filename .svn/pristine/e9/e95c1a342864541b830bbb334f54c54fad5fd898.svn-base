//
//  InterviewMessageModel.m
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "InterviewMessageModel.h"

@implementation InterviewMessageModel

+(InterviewMessageModel *)modelWithDic:(NSDictionary *)dic{
    
    InterviewMessageModel *model = [[InterviewMessageModel alloc] init];
    model.title = dic[@"title"];
    model.isFocus = [dic[@"folstatr"] intValue];
    model.avator = dic[@"avator"];
    model.nickname = dic[@"nickname"];
    model.pole = dic[@"pole"];
    model.province = dic[@"province"];
    model.city = dic[@"city"];
    model.job = dic[@"job"];
    model.age = dic[@"age"];
    model.coverpic = dic[@"coverpic"];
    model.UID = dic[@"uid"];
    return model;
}
@end
