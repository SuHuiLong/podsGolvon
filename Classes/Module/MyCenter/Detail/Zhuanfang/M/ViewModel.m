//
//  ViewModel.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel
+(ViewModel *)pareWithDictionary:(NSDictionary *)dic{
    ViewModel *model = [[ViewModel alloc]init];
    model.headerImage = dic[@"picture_url"];
    model.nickName = dic[@"nickname"];
    model.timeLabel = dic[@"interview_title"];
    model.state = dic[@"code"];
    return model;
}
@end
