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
//选中的是手机通讯录还是手动输入 1:手机联系人 2：手动输入第一位 3：手动输入第二位 4：手动输入第三位
@property(nonatomic,copy)NSString *addType;
//手机号码
@property(nonatomic,copy)NSString *phoneStr;

//加载数据
-(void)configData:(NSDictionary *)dict;
@end

