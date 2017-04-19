//
//  Rightmode.h
//  Golvon
//
//  Created by CYL－Mac on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rightmode : NSObject
/** 职业名称*/
@property (nonatomic,copy)NSString * work_content;
/** 行业*/
@property (nonatomic,copy)NSString * work_id;
+ (instancetype)RightWithDictionary:(NSDictionary *)dic;
@end
