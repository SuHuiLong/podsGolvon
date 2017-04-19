//
//  AidViewController.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReadViewBlock) (BOOL isView);
@interface AidViewController : UIViewController

@property (assign, nonatomic) int   currenPage;    //
@property (strong, nonatomic) NSString   *followState;  //
/**
 *  专访者Id
 */
@property (strong, nonatomic)NSString *interviewerId;

@property (assign, nonatomic) int   photoArgument;    //照片的参数
@property (strong, nonatomic) NSString   *photoImage;  //照片
@property (strong, nonatomic) NSString   *photoImageO;  //照片
@property (strong, nonatomic) NSString   *photoImageT;  //照片
/**
 *  专访id
 */
@property (strong, nonatomic) NSString      *interviewid;
/**
 *  头像
 */
@property (strong, nonatomic) NSString      *picture_url;
/**
 *  uiview
 */
@property (strong, nonatomic) UIView      *line;



@property (strong, nonatomic) ReadViewBlock block;
-(void)setBlock:(ReadViewBlock)block;
@end
