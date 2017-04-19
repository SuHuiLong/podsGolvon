//
//  NewDetailViewController.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/1.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReadBlcok) (BOOL isback);

@interface NewDetailViewController : UIViewController
/**ID*/
@property (nonatomic ,strong)NSString *nameID;
/**
 *  专访状态
 */
@property (strong, nonatomic)NSString *statue;
//专访这ID
@property (strong, nonatomic) NSString *interviewerId;

@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) int    login_state;

@property (copy, nonatomic) NSString *followState;

@property (strong,nonatomic)ReadBlcok block;//返回用作浏览量加一的block


-(void)setBlock:(ReadBlcok)block;

@end
