//
//  SearchResultTableViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface SearchResultTableViewCell : UITableViewCell

/***  头像*/
@property (strong, nonatomic) UIImageView    *headerIcon;

@property (strong, nonatomic) UIImageView    *sexIcon;

@property (strong, nonatomic) UIImageView    *intviewIcon;

@property (strong, nonatomic) UILabel    *nickName;

@property (strong, nonatomic) UILabel    *poleLabel;

@property (strong, nonatomic) UILabel    *cityLabel;

-(void)relayoutWithModel:(SearchResultModel *)model;
@end
