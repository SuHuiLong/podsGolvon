//
//  ConsummateViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPProvince.h"
#import "JobViewController.h"


@class ConsummateViewController;

@protocol ConsummateDelegate <NSObject>

-(void)sendNameid:(NSString *)nameid;

@end

@interface ConsummateViewController : UIViewController

@property (copy, nonatomic) NSString    *work_fuStr;

@property (copy, nonatomic) NSString    *work_ziStr;

@property (copy, nonatomic) NSString    *work_fuID;

@property (copy, nonatomic) NSString    *work_ziID;

@property (copy, nonatomic) NSString    *provinceStr;

@property (copy, nonatomic) NSString    *cityStr;

@property (copy, nonatomic) NSString    *poleNumStr;

@property (copy, nonatomic) NSString    *name_id;

@property (weak, nonatomic) id<ConsummateDelegate> delegate;

@end
