//
//  ChildRecomModel.m
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ChildRecomModel.h"

@implementation ChildRecomModel

+(ChildRecomModel *)modelAddDictionary:(NSDictionary *)dic{
    ChildRecomModel *model = [[ChildRecomModel alloc] init];
    model.addts = dic[@"addts"];
    model.ID = dic[@"ID"];
    model.pic = dic[@"pic"];
    model.title = dic[@"title"];
    model.readnum = dic[@"readnum"];
    model.url = dic[@"url"];
    model.type = dic[@"type"];
    model.clikenum = dic[@"clikenum"];
    model.content = dic[@"content"];
    model.endts = dic[@"endts"];
    model.likestatr = [dic[@"likestatr"] integerValue];
    return model;
}
@end
