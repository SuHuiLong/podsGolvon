//
//  Self_LY_ViewController.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Self_LY_ViewController : UIViewController

@property (strong, nonatomic)UITableView *tableView;


/**
 *  留言人的name
 */
@property (strong, nonatomic)NSString *loginNickName;
/**
 *  留言人的ID
 */
@property(nonatomic,strong)NSString *loginName_ID;
/**
 *  被留言人的name
 */
@property (strong, nonatomic)NSString *nickName;
/**
 *  被留言人的nameID
 */
@property (strong, nonatomic)NSString *nameID;
/**
 *  专访ID
 */
@property(strong,nonatomic)NSString *interviewId;

///**
// *  判断进入状态
// */
//@property(assign,nonatomic)NSInteger loginStyle;

/** 被回复人的昵称和ID*/
@property(assign, nonatomic)NSString *replyname;
@property(assign, nonatomic)NSString *replyid;




/**
 *  清除缓存的背景
 */
@property (strong, nonatomic) UIView      *memoryGround;
/**
 *  清除缓存的取消
 */
@property (strong, nonatomic) UIButton      *cancelBtn;
/**
 *  清除缓存的view
 */
@property (strong, nonatomic) UIView      *memoryView;

@end
