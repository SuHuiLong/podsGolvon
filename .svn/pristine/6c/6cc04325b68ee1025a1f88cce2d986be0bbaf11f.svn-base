//
//  LiuYanModel.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LiuYanModel.h"

@implementation LiuYanModel

+(LiuYanModel *)pareFromWithDictionary:(NSDictionary *)dic{
    LiuYanModel *model = [[LiuYanModel alloc]init];
    
    model.headerImageName = dic[@"picture_url"];
    model.nickName        = dic[@"nickname"];
    model.timeLabel       = dic[@"message_time"];
    model.titleLabel      = dic[@"message_content"];
    model.nameID          = dic[@"name_id"];
    return model;
}
@end
