//
//  HF_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "huiFuModel.h"
#import "UIButton+WebCache.h"
#import "CustomeLabel.h"

@interface HF_TableViewCell : UITableViewCell


@property (strong, nonatomic) UIButton        *headerBtn;
@property (strong, nonatomic) UIButton        *nameBtn;
@property (strong, nonatomic) huiFuModel      *model;
@property (copy, nonatomic) void(^clickHeadericonBlock) (huiFuModel *model);
@property (strong, nonatomic) UIImageView    *VimageView;
@property (copy, nonatomic) void(^clickNameBlock) (huiFuModel *model);
/**
 *  评论的内容
 */
@property (strong, nonatomic) UILabel         *titleLabel;

/**
 *  原来的内容
 */
@property (strong, nonatomic) CustomeLabel    *formatLabel;
/***  类型*/
@property (strong, nonatomic) UILabel         *typeLabel;
@property (strong, nonatomic) UILabel         *timeLabel;

-(void)relayoutWithModel:(huiFuModel *)model;

@end
