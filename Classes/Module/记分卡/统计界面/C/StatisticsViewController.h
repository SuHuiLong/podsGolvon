//
//  StatisticsViewController.h
//  JiFenKaDemo
//
//  Created by shiyingdong on 16/6/14.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController

@property(nonatomic,strong)NSArray    *nameArry;
@property(nonatomic,strong)NSArray    *nameIdArry;

/**
 *  0  加载进入本地数据
    1  已完成被记分进入
    2  被记分人查看正在进行记分
    3  查看别人已经完成的记分
    4  记分界面进入
    5  首页进入
 */
@property(nonatomic,assign)NSInteger  logInNumber;

@property(nonatomic,assign)NSString   *longInView;

@property (nonatomic,  copy) NSString *GroupId;


@property(nonatomic,assign)NSString   *userNameId;

/*
    0 不许要进入刷新
    1 进入需要刷新
 */

@property(nonatomic,assign)NSInteger   longinType;

@end
