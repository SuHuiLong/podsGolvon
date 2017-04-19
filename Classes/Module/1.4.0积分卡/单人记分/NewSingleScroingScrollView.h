//
//  NewSingleScroingScrollView.h
//  podsGolvon
//
//  Created by apple on 2016/10/10.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSingleScroingScrollView : UIView

//标准杆
@property(nonatomic,copy)UILabel  *ParLabel;
//推杆
@property(nonatomic,copy)UILabel  *Putters;
//杆差
@property(nonatomic,copy)UILabel  *GrossLabel;
//距标准杆按钮
@property(nonatomic,strong)UIButton  *PolePoorButton;



@end
