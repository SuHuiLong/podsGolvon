//
//  PublicBenefitModel.h
//  podsGolvon
//
//  Created by SHL on 2016/11/3.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicBenefitModel : NSObject
//头像
@property(nonatomic,copy)NSString  *avator;
//金额
@property(nonatomic,copy)NSString  *charity;
//昵称
@property(nonatomic,copy)NSString  *nickname;
//nameid
@property(nonatomic,copy)NSString  *uid;
//排名
@property(nonatomic,copy)NSString  *rank;
//是否加V
@property(nonatomic,copy)NSString  *vid;


-(void)configData:(NSDictionary *)dict;
@end
