//
//  AddGolferViewController.h
//  podsGolvon
//
//  Created by SHL on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SelectPlayerblock)(NSArray *playerArr);

@interface AddGolferViewController : BaseViewController


//选择block
@property(nonatomic,strong)SelectPlayerblock  SelectPlayerblock;
//已经选中的球员
@property(nonatomic,strong)NSMutableArray  *selectPlayerArray;


//点击操作
-(void)clickDone:(SelectPlayerblock)changeBLock;

@end
