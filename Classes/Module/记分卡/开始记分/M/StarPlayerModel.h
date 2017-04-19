//
//  StarPlayerModel.h
//  Golvon
//
//  Created by shiyingdong on 16/8/12.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarPlayerModel : NSObject

@property (strong, nonatomic)NSString    *nick_name;//昵称
@property (strong, nonatomic) NSString   *name_id;//用户id
@property (strong, nonatomic) NSString   *meanPole;//平均杆
@property (strong, nonatomic) NSString   *picture_url;//头像


+(StarPlayerModel *)pareFrom:(NSDictionary *)dic;


@end
