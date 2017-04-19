//
//  SupportModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/8/11.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "SupportModel.h"

@implementation SupportModel
+(SupportModel *)initWithFromDictionary:(NSDictionary *)dic{
    SupportModel *model = [[SupportModel alloc]init];
    
    model.picture     = dic[@"picture_url"];
    model.nickname    = dic[@"nickname"];
    model.time        = dic[@"InsertTime"];
    model.nameID      = dic[@"clickNameId"];
    model.followstate = dic[@"followState"];
    model.interview_state = dic[@"interview_state"];
    
    return model;
}


@end
