//
//  SupportModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/8/11.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportModel : NSObject
/***  id*/
@property (strong, nonatomic) NSString    *nameID;
/***  时间*/
@property (strong, nonatomic) NSString    *time;
/***  头像*/
@property (strong, nonatomic) NSString    *picture;
/***  昵称*/
@property (strong, nonatomic) NSString    *nickname;
/***  关注*/
@property (strong, nonatomic) NSString    *followstate;
@property (copy, nonatomic) NSString    *interview_state;

+(SupportModel *)initWithFromDictionary:(NSDictionary *)dic;
@end
