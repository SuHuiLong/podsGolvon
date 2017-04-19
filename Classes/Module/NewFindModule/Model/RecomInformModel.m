//
//  RecomInformModel.m
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RecomInformModel.h"

@implementation RecomInformModel

+(RecomInformModel *)modelAddDictionary:(NSDictionary *)dic{
    RecomInformModel *model = [[RecomInformModel alloc] init];
    model.content = dic[@"content"];
    model.pic = dic[@"pic"];
    model.ID = dic[@"ID"];
    model.title = dic[@"title"];
    model.url = dic[@"url"];
    model.type = dic[@"type"];
    model.addts = dic[@"addts"];
    model.readnum = dic[@"readnum"];
    model.likestatr = [dic[@"likestatr"] integerValue];
    model.clikenum = dic[@"clikenum"];
    
    return model;
}
@end
