//
//  RankingListViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingListViewController : UIViewController

/***  有没有关注好友*/
@property (strong, nonatomic) NSString    *FriendsRankingStatr;
/***  没有打球纪录*/
@property (strong, nonatomic) UILabel    *noneRank;
@end
