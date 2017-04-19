//
//  RecomInteModel.m
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RecomInteModel.h"

@implementation RecomInteModel
+(RecomInteModel *)modelAddDictionary:(NSDictionary *)dic{
    RecomInteModel *model = [[RecomInteModel alloc] init];
    model.nickname = dic[@"nickname"];
    model.pic = dic[@"pic"];
    model.readnum = dic[@"readnum"];
    model.vid = dic[@"vid"];
    model.url = dic[@"url"];
    model.likestatr = [dic[@"likestatr"] integerValue];
    model.clikenum = dic[@"clikenum"];
    model.time = dic[@"time"];
    model.title = dic[@"title"];
    return model;
}
@end
