//
//  SelectMarkModel.m
//  Golvon
//
//  Created by shiyingdong on 16/4/27.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SelectMarkModel.h"

@implementation SelectMarkModel

+(SelectMarkModel *)ShlFromDictionary:(NSDictionary *)dic{
    SelectMarkModel *model = [[SelectMarkModel alloc] init];
    model.markId = [dic objectForKey:@"label_id"];
    model.markText = [dic objectForKey:@"label_content"];
    model.markGroup = [dic objectForKey:@"label_grouping"];
    return model;
}

@end
