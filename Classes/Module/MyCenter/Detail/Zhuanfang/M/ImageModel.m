//
//  ImageModel.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
+(ImageModel *)pareWithDictionary:(NSDictionary *)dic{
    ImageModel *model = [[ImageModel alloc]init];
    model.imageurl = dic[@"picture_url"];
    model.viewCount = dic[@"red_number"];
    model.interViewUrl = dic[@"interview_url"];
    return model;
}
@end
