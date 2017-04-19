//
//  RulesModel.m
//  TabBar
//
//  Created by 李盼盼 on 16/8/2.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import "RulesModel.h"

@implementation RulesModel
+(RulesModel *)relayoutWithModel:(NSDictionary *)dic{
    
    RulesModel *model           = [[RulesModel alloc]init];
    model.RankingClickNumber    = dic[@"RankingClickNumber"];
    model.ClickRankStatr        = [dic[@"ClickRankStatr"] intValue];
    model.touxiang_url          = dic[@"touxiang_url"];
    model.zongChangCi           = dic[@"zongChangCi"];
    model.picture_url           = dic[@"picture_url"];
    model.rankNumber            = dic[@"rankNumber"];
    model.nickname              = dic[@"nickname"];
    model.name_id               = dic[@"name_id"];
    model.interview_state = dic[@"interview_idd"];
    return model;
}
@end
