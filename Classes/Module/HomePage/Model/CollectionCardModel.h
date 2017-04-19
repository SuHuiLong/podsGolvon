//
//  CollectionCardModel.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionCardModel : NSObject

@property (copy, nonatomic) NSString    *access_amount;     //访问量

@property (copy, nonatomic) NSString    *gender;            //性别

@property (copy, nonatomic) NSString    *group_id;          //记分组ID

@property (copy, nonatomic) NSString    *interview_state;   //专访状态

@property (copy, nonatomic) NSString    *login_data;        //登录时间

@property (copy, nonatomic) NSString    *name_id;           //nameID

@property (copy, nonatomic) NSString    *nickname;          //昵称

@property (copy, nonatomic) NSString    *picture_url;       //照片

@property (copy, nonatomic) NSString    *pole_number;       //杆数

@property (copy, nonatomic) NSString    *siignature;        //签名

@property (copy, nonatomic) NSString    *province;          //省

@property (copy, nonatomic) NSString    *city;              //市

@property (copy, nonatomic) NSString    *work_content;      //职业

@property (assign, nonatomic) BOOL    follow_state;

@property (copy, nonatomic) NSString    *gnum;              //几人记分


+(CollectionCardModel *)initWithDictionary:(NSDictionary *)dic;

@end
