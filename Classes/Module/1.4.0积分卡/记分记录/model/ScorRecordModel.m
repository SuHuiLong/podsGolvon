//
//  ScorRecordModel.m
//  podsGolvon
//
//  Created by SHL on 2016/11/3.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ScorRecordModel.h"

@implementation ScorRecordModel


+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"list":ScorRecordListModel.class,
             };
}


@end
