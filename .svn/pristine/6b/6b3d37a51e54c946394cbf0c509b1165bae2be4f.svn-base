//
//  NewZhuanFangViewController.h
//  Golvon
//
//  Created by shiyingdong on 16/4/20.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VisionBlock) (BOOL isView);

@interface NewZhuanFangViewController : UIViewController

@property (strong, nonatomic)UIView *navView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *backBtn;
@property (strong, nonatomic)UIButton *share;

/**
 *  专访id
 */
@property (strong, nonatomic)NSString *interviewId;

/**
 *  专访者Id
 */
@property (strong, nonatomic)NSString *interviewerId;
/**
 *  专访者name
 */
@property (strong, nonatomic)NSString *interviewerName;

/**
 *  reaplyNameId
 */
@property (strong, nonatomic)NSString *reaplyNameId;
/**
 *  被回复人的昵称
 */
@property (strong, nonatomic)NSString *reaplyName;

@property (strong, nonatomic)NSString *followSelectNameId;
@property(nonatomic,copy)NSString  *htmlStr;

@property (strong, nonatomic) VisionBlock    block;
-(void)setBlock:(VisionBlock)block;


@end
