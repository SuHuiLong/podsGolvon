//
//  FansModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "FansModel.h"

@implementation FansModel
+(FansModel *)paresFromDictionary:(NSDictionary *)dic{
    FansModel *model = [[FansModel alloc]init];
    
    model.nickName        = dic[@"nickname"];
    model.headerImageName = dic[@"picture_url"];
    model.signLabel       = dic[@"siignature"];
    model.nameid          = dic[@"name_id"];
    model.followState     = dic[@"follow_statr"];
    return model;
}
@end
