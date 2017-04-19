//
//  ScoringModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/6.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoringModel : NSObject
/**分数*/
@property (nonatomic ,copy) NSString *scorNum;
/**球场*/
@property (nonatomic ,copy) NSString *ballPark;
/**时间*/
@property (nonatomic ,copy) NSString *timeLabel;
/**groupid*/
@property (copy, nonatomic) NSString *groupID;
/**杆数*/
@property (copy, nonatomic) NSString *poleNum;

@property (copy, nonatomic) NSString *gnum; //几人比赛


@property (copy, nonatomic) NSString *isfinished;       //完成状态
@property (copy, nonatomic) NSString *istoday;          //是否是今天
//@property (copy, nonatomic) NSString      *chengji_statr;

+(ScoringModel *)pareFromWith:(NSDictionary *)dic;
@end
