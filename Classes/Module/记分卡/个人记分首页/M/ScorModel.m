//
//  ScorModel.m
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "ScorModel.h"

@implementation ScorModel

+(ScorModel *)pareFromWithDictionary:(NSDictionary *)dic{
    ScorModel *model = [[ScorModel alloc]init];
    
    model.chuangjian_time   = dic[@"chuangjian_time"];
    model.group_chengji_id  = dic[@"group_chengji_id"];
    model.qiuchang_name     = dic[@"qiuchang_name"];
    model.group_id          = dic[@"group_id"];
    model.zongganshu        = dic[@"zongganshu"];
    model.charity           = dic[@"charity"];
    model.ingStr            = dic[@"ingStr"];
    model.groupStatr        = dic[@"groupStatr"];
    return model;
}

@end
