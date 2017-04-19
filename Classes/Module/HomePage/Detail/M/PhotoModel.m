//
//  PhotoModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel
+(PhotoModel *)pareFromDictionary:(NSDictionary *)dic{
    PhotoModel *model = [[PhotoModel alloc]init];
    model.photoName = dic[@"pic150Url"];
    model.name_id = dic[@"name_id"];
    return model;
}

@end
