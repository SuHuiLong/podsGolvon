//
//  FirstDetailModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/2.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "FirstDetailModel.h"

@implementation FirstDetailModel

+(FirstDetailModel *)paresFromDictionary:(NSDictionary *)dic{
    FirstDetailModel *model = [[FirstDetailModel alloc]init];
    model.nickName  = dic[@"nickname"];
    model.signature = dic[@"siignature"];
    model.address   = dic[@"cityName"];
    model.viewLabel = dic[@"access_amount"];
    model.picture   = dic[@"picture_url"];
    model.nameID    = dic[@"name_id"];
    return model;
}
@end
