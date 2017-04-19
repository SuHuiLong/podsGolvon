//
//  Fans_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fans_TableViewCell : UITableViewCell

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *fansView;
//用户ID
@property (strong, nonatomic) NSString *nameID;
//关注状态、
@property (strong, nonatomic) NSString *followstate;
/**
 *  请求数据
 */
@property (strong, nonatomic) NSMutableArray *fansData;


@property(strong, nonatomic)NSString *longInType;
- (instancetype)initWithNameID:(NSString *)nameID longInType:(NSString *)longInType;

@end
