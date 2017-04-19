//
//  CharityModel.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/28.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "CharityModel.h"

@implementation CharityModel
+(CharityModel *)pareFromWithDictionary:(NSDictionary *)dic{
    CharityModel *model = [[CharityModel alloc]init];
    model.picture_url = dic[@"picture_url"];
    model.nickname = dic[@"nickname"];
    model.allCiShan = dic[@"allCiShan"];
    model.allChangShu = dic[@"allChangShu"];
    model.allUserNumber = dic[@"allUserNumber"];
    return model;
}
@end
