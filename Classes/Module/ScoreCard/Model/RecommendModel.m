//
//  RecommendModel.m
//  TabBar
//
//  Created by 李盼盼 on 16/8/5.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

+(RecommendModel *)initWithFromDictionary:(NSDictionary *)dic{
    
    RecommendModel *model = [[RecommendModel alloc]init];
    
    model.nickname   = dic[@"nickname"];
    model.state      = [dic[@"GuanZhuZhaungTai"]integerValue];
    model.pictureurl = dic[@"picture_url"];
    model.signature  = dic[@"siignature"];
    model.nameID     = dic[@"name_id"];
    model.interview_state = dic[@"vid"];
    
    return model;
}

@end
