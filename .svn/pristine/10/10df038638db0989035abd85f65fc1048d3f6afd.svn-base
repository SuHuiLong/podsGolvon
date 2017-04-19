//
//  Slef_GuanZhuModel.m
//  Golvon
//
//  Created by shiyingdong on 16/4/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Slef_GuanZhuModel.h"

@implementation Slef_GuanZhuModel

+(Slef_GuanZhuModel *)pareFromDictionary:(NSDictionary *)dic{
    Slef_GuanZhuModel *model = [[Slef_GuanZhuModel alloc]init];
    model.nameID = dic[@"name_id"];
    model.nickName = dic[@"nickname"];
    model.picture = dic[@"picture_url"];
    model.siignature = dic[@"siignature"];
    model.allPage = dic[@"allpage"];
    model.groupStatr = dic[@"groupStatr"];
    model.isFollow = [dic[@"follow_statr"]integerValue];
    model.groupID = dic[@"group_id"];
    model.gnum = dic[@"gnum"];
    model.user_interview = dic[@"vid"];
    return model;
}
@end
