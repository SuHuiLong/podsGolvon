//
//  Self_GuanZhuViewController.h
//  Golvon
//
//  Created by shiyingdong on 16/4/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Self_GuanZhuViewController : UIViewController

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIView *navView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *backBtn;

@property(nonatomic,strong)NSString *name_id;

/**
 *  进入状态
 */
@property (nonatomic, assign)NSInteger login_state;
@end
