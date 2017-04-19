//
//  ScoreCardViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"
#import "CoreDataManager.h"
#import "ViewHistoryData.h"

@interface ScoreCardViewController : BaseViewController

/***  nameID*/
@property (strong, nonatomic) NSString    *nameID;
@property (strong, nonatomic) NSMutableArray    *dataArr;

@property (nonatomic, strong) CoreDataManager     *coreDataManager;//coreDataManager

@property (strong, nonatomic) ViewHistoryData      *userCoreData;

@property (assign, nonatomic) int popID;

@end
