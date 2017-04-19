//
//  MatchScrollView.h
//  podsGolvon
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^scroBlock)(NSDictionary *indexDict);
typedef void (^changeBLock)(NSDictionary *indexDict);



@interface MatchScrollView : UIView
//页面所在位置
@property(nonatomic,copy)NSString  *indexLocation;
//标准杆
@property(nonatomic,copy)NSString  *ParLabelStr;

//当前球洞所有数据
@property(nonatomic,strong)NSDictionary  *indexPoleData;

//总杆&&杆差
@property(nonatomic,copy)UILabel *Gross;
//推杆
@property(nonatomic,copy)UILabel  *Putters;
//总杆
@property(nonatomic,copy)UILabel  *GrossLabel;
//距标准杆按钮
@property(nonatomic,strong)UIButton  *PolePoorButton;
//推杆-
@property(nonatomic,strong)UIButton  *PuttersReduce;
//推杆+
@property(nonatomic,strong)UIButton  *PuttersAdd;
//总杆-
@property(nonatomic,strong)UIButton  *GrossReduce;
//总杆+
@property(nonatomic,strong)UIButton  *GrossAdd;
//加减符号
@property(nonatomic,strong)UILabel  *ModifiedLabel;
//杆数圆形背景
@property(nonatomic,copy)UIView *RoundView;
//修改数据Block
@property(nonatomic,strong)scroBlock  scroBlock;
//点击距标准杆
@property(nonatomic,strong)changeBLock  changeBLock;
//设置bloc
-(void)setBlock:(scroBlock)block;
//切换距标准杆
-(void)setChangeBLock:(changeBLock)changeBLock;

//初始化
-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dict;
//距标准杆点击
-(void)changePolePoorButton:(UIButton *)btn Data:(NSDictionary *)dict;
//更新
-(void)refreshData:(NSDictionary *)dict;
@end
