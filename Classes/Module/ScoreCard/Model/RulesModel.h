//
//  RulesModel.h
//  TabBar
//
//  Created by 李盼盼 on 16/8/2.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RulesModel : NSObject
/***  点赞状态*/
@property (assign, nonatomic) BOOL    ClickRankStatr;
/***  nameID*/
@property (strong, nonatomic) NSString    *name_id;
/***  昵称*/
@property (strong, nonatomic) NSString    *nickname;
/***  头像*/
@property (strong, nonatomic) NSString    *picture_url;
/***  排名点赞数*/
@property (strong, nonatomic) NSString    *RankingClickNumber;
/***  名次*/
@property (strong, nonatomic) NSString    *rankNumber;
/***  总场次*/
@property (strong, nonatomic) NSString    *zongChangCi;
/***  封面*/
@property (strong, nonatomic) NSString    *touxiang_url;

@property (copy, nonatomic) NSString    *interview_state;

+(RulesModel *)relayoutWithModel:(NSDictionary *)dic;
@end
