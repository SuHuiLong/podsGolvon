//
//  InterviewTableViewCell.h
//  podsGolvon
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildInterviewModel.h"
#import "ChildCompetionData.h"
@interface InterviewTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel   *likeLabel;

@property (nonatomic, strong) UILabel   *visitorLabel;

@property (nonatomic, strong) UIImageView   *visitorImage;

@property (nonatomic, strong) UIImageView   *groundImage;

@property (nonatomic, strong) UILabel   *temp;
//专访
-(void)relayoutInterviewDataWithModel:(ChildInterviewModel *)model;
//活动
-(void)relayoutActivityDataWithModel:(ChildCompetionData *)model;
//其他
-(void)relayoutOtherviewDataWithModel:(ChildCompetionData *)model;
@end
