//
//  ActivityViewController.h
//  FindModule
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UINavigationController
@property (copy, nonatomic) NSString *type;
//是否能报名
@property (copy, nonatomic) NSString *joinstatr;
@end
