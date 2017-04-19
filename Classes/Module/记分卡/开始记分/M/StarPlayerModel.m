
//
//  StarPlayerModel.m
//  Golvon
//
//  Created by shiyingdong on 16/8/12.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "StarPlayerModel.h"

@implementation StarPlayerModel

+(StarPlayerModel *)pareFrom:(NSDictionary *)dic{
    
    StarPlayerModel *model = [[StarPlayerModel alloc]init];
    model.nick_name = dic[@"nick_name"];
    model.name_id = dic[@"name_id"];
    model.meanPole = dic[@"meanPole"];
    model.picture_url = dic[@"picture_url"];

    return model;
}

@end
