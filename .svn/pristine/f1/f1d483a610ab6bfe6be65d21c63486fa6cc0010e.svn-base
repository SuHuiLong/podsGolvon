//
//  JobViewController.h
//  Golvon
//
//  Created by CYL－Mac on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadDataSource.h"

@class JobViewController;
@protocol JobViewControllerDelegate <NSObject>

-(void)selectedWorkname:(NSString *)workName WorkID:(NSString *)workID;

@end

typedef void(^ListBlock)(NSString*,NSString*);

@interface JobViewController : UIViewController
@property (strong, nonatomic)UIView *navView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *backBtn;
@property (strong, nonatomic)UIButton *finishBtn;

/** 保存职业*/
@property (nonatomic,strong)NSString  * jobLabel;

/**职业id*/
@property (nonatomic,copy)NSString * jobID;

@property (nonatomic, copy) NSString *controllerID;

@property (nonatomic,copy)ListBlock  jobBlock;

@property (nonatomic, weak) id<JobViewControllerDelegate> delegate;
@end
