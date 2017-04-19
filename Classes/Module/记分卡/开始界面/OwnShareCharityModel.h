//
//  OwnShareCharityModel.h
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/29.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnShareCharityModel : NSObject
/**
 *  头像
 */
@property (strong, nonatomic) NSString      *picture_url;
/**
 *  一场捐赠金额
 */
@property (strong, nonatomic) NSString      *charity;
/**
 *  本次成绩
 */
@property (strong, nonatomic) NSString      *zongganshu;
/**
 * 总共金额
 */
@property (strong, nonatomic) NSString      *cishan_jiner;
/**
 *  总共场次
 */
@property (strong, nonatomic) NSString      *zongchangshu;

@end
