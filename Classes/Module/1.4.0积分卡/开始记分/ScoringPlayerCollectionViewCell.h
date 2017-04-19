//
//  ScoringPlayerCollectionViewCell.h
//  podsGolvon
//
//  Created by SHL on 2016/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GolfersModel.h"
@interface ScoringPlayerCollectionViewCell : UICollectionViewCell
//头像
@property(nonatomic,copy)UIImageView  *headerImageView;
//name
@property(nonatomic,copy)UILabel  *nameLabel;

-(void)configData:(GolfersModel *)model;
@end
