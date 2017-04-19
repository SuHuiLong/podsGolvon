//
//  ReviewPhotosViewController.h
//  podsGolvon
//
//  Created by suhuilong on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SelectIndexBlock)(NSMutableArray *selectArray);

@interface ReviewPhotosViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray  *dataArray;//数据
@property(nonatomic,strong)NSMutableArray  *selectDataArray;//选择照片数据源
@property(nonatomic,assign)NSInteger currenIndex;//开始位置
@property(nonatomic,copy)NSString  *titleStr;


//选择照片Block
@property(nonatomic,copy)SelectIndexBlock  selectIndexBlock;
//设置数据源
-(void)selectArray: (SelectIndexBlock)block;

//进入的Controller
@property(nonatomic,copy)NSString  *logInController;

//是否隐藏状态栏
@property(nonatomic,assign)BOOL     hidenTabBar;
@end
