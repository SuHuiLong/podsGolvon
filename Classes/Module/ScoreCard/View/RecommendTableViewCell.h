//
//  RecommendTableViewCell.h
//  TabBar
//
//  Created by 李盼盼 on 16/8/5.
//  Copyright © 2016年 ShanPengFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RecommendTableViewCell : UITableViewCell

/***  关注按钮*/
@property (strong, nonatomic) UIButton     *followBtn;

@property (strong, nonatomic) RecommendModel    *model;
@property (strong, nonatomic) UIImageView    *Vimage;
//
@property (nonatomic, copy) void(^followBtnBlock)(RecommendModel *model);

-(void)relayoutWithModel:(RecommendModel *)model;
@end
