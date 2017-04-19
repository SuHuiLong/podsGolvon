//
//  CollectionCardModel.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "CollectionCardModel.h"

@implementation CollectionCardModel

+(CollectionCardModel *)initWithDictionary:(NSDictionary *)dic{
    CollectionCardModel *model = [[CollectionCardModel alloc]init];
    
    model.interview_state = dic[@"vid"];
    model.access_amount   = dic[@"accesses"];
    model.follow_state    = [dic[@"isfollow"]integerValue];
    model.picture_url     = dic[@"avator"];
    model.pole_number     = dic[@"pole_number"];
    model.login_data      = dic[@"logintime"];
    model.siignature      = dic[@"sig"];
    model.group_id        = dic[@"gid"];
    model.nickname        = dic[@"nickname"];
    model.name_id         = dic[@"uid"];
    model.gender          = dic[@"gender"];
    model.work_content    = dic[@"work"];
    model.city            = dic[@"city"];
    model.province        = dic[@"province"];
    model.gnum            = dic[@"gnum"];
    return model;
}
@end
