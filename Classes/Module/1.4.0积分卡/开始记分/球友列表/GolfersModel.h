//
//  GolfersModel.h
//  podsGolvon
//
//  Created by SHL on 2016/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GolfersModel : NSObject
//用户昵称
@property(nonatomic,copy)NSString  *nickname;
//用户id
@property(nonatomic,copy)NSString  *uid;
//头像
@property(nonatomic,copy)NSString  *avator;
//是否选中
@property(nonatomic,assign)BOOL  isSelect;

//加载数据
-(void)configData:(NSDictionary *)dict;
@end

