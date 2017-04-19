//
//  CharityModel.h
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/28.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharityModel : NSObject
/**
 *  头像
 */
@property (strong, nonatomic) NSString      *picture_url;
/**
 *  昵称
 */
@property (strong, nonatomic) NSString      *nickname;
/**
 *  场次
 */
@property (strong, nonatomic) NSString      *allChangShu;

/**
 *  人数
 */
@property (strong, nonatomic) NSString      *allUserNumber;

/**
 *  慈善
 */
@property (strong, nonatomic) NSString      *allCiShan;

+(CharityModel *)pareFromWithDictionary:(NSDictionary *)dic;
@end
