//
//  ScorRecordModel.h
//  podsGolvon
//
//  Created by SHL on 2016/11/3.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScorRecordListModel.h"
@interface ScorRecordModel : NSObject
//年度总场数
@property(nonatomic,copy)NSString  *year;
//年度总场数
@property(nonatomic,copy)NSString  *totalgames;
//有效场次个数
@property(nonatomic,copy)NSString *completegames;
//本年平均杆
@property(nonatomic,copy)NSString  *avgrod;
//本年个人最好成绩
@property(nonatomic,copy)NSString  *personalbest;
//本年度标ON率
@property(nonatomic,copy)NSString  *biaoonrate;
//页数
@property(nonatomic,copy)NSString  *pages;
//是否隐藏列表
@property(nonatomic,assign)BOOL hidenList;
//打球历史列表
@property(nonatomic,copy)NSArray<ScorRecordListModel *>  *list;


@end
