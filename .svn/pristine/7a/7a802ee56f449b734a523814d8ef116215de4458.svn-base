//
//  Fans_CollectionViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/16.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FansModel.h"
#import "DownLoadDataSource.h"

@interface Fans_CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *fansImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *followBtn;

//关注状态
@property (strong, nonatomic)NSString *followState;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) NSInteger index;
//下载数据
@property (strong, nonatomic) DownLoadDataSource *loadData;
//nameID
@property (strong, nonatomic) NSString *nameId;

-(void)realodDataWith:(FansModel *)model;

@end
