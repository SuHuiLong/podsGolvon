//
//  BallParkSelectModel.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/22.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "BallParkSelectModel.h"

@implementation BallParkSelectModel
+(BallParkSelectModel *)paresFromDictionary:(NSDictionary *)dic{
    BallParkSelectModel *model = [[BallParkSelectModel alloc]init];
    model.ballParkID           = dic[@"qiuchang_id"];
    model.name                 = dic[@"qiuchang_name"];
    model.logo                 = dic[@"qiuchang_logo"];
    model.historyBallParkID    = dic[@"qiuchangID"];
    return model;
}


@end
