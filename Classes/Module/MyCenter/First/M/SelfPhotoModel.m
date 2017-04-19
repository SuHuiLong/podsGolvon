//
//  SelfPhotoModel.m
//  Golvon
//
//  Created by shiyingdong on 16/4/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SelfPhotoModel.h"

@implementation SelfPhotoModel

+(SelfPhotoModel *)pareFromDictionary:(NSDictionary *)dic{
    SelfPhotoModel *model = [[SelfPhotoModel alloc]init];
    model.SelfPhotoName = dic[@"picture_url"];
    model.photoDesc = dic[@"name_name"];
    return model;
}

@end
