//
//  ScoringModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/6.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "ScoringModel.h"

@implementation ScoringModel

+(ScoringModel *)pareFromWith:(NSDictionary *)dic{
    ScoringModel *model = [[ScoringModel alloc]init];
//    model.scorNum          = dic[@"zongchangshu"];
    model.gnum = dic[@"gnum"];
    model.poleNum          = dic[@"rodsum"];
    model.timeLabel        = dic[@"starttime"];
    model.ballPark         = dic[@"qname"];
    model.groupID          = dic[@"gcid"];
//    model.chengji_statr    = dic[@"chengji_statr"];
    model.isfinished = dic[@"isfinished"];
    model.istoday = dic[@"istoday"];
    return model;
}
@end
