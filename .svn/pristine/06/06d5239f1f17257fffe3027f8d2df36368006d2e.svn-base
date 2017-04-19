//
//  GroupStatisticsViewController.h
//  podsGolvon
//
//  Created by SHL on 2016/10/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"

#import "EAFeatureItem.h"
#import "UIView+EAFeatureGuideView.h"

typedef void (^movetoPole)(NSString *poleNum);

@interface GroupStatisticsViewController : BaseViewController

//访问者nameid
@property(nonatomic,copy)NSString  *loginNameId;
//打球人的nameid
@property(nonatomic,copy)NSString  *nameUid;
//分组id
@property(nonatomic,copy)NSString  *groupId;
//记分状态 0:正在进行&未完成&&记分人 1:正在进行&未完成&非记分人 2:无效记分 3:有效记分且已完成
@property(nonatomic,assign)NSInteger  status;
//进入是否立即请求数据
@property(nonatomic,assign)BOOL  isLoadDta;


//数据源
@property(nonatomic,copy)NSDictionary  *dataDict;
//能否选T
@property(nonatomic,assign)BOOL  *canSelectT;
//返回填写标准杆
@property(nonatomic,copy)movetoPole movetoPole;
//是否需要返回主界面
@property(nonatomic,assign)BOOL needPopHome;

//设置bloc
-(void)setBlock:(movetoPole)block;

@end
