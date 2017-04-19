//
//  ZhuanFangModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ZhuanFangModel.h"

@implementation ZhuanFangModel
+(ZhuanFangModel *)paresFromDictionary:(NSDictionary *)dic{
    ZhuanFangModel *model = [[ZhuanFangModel alloc]init];
    model.title = dic[@"title"];
    model.time  = dic[@"time"];
    model.image = dic[@"pic_url"];
    model.url = dic[@"url"];
    model.name = dic[@"name"];
    model.readnum = dic[@"readnum"];
    model.clicks = dic[@"clicks"];
    model.liked = [dic[@"liked"] integerValue];
    return model;
}
@end
