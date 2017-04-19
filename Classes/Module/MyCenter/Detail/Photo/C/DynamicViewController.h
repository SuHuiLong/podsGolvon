//
//  DynamicViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/19.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewAlertView.h"
#import "FSTextView.h"

@interface DynamicViewController : UIViewController
/***  nameid*/
@property (copy, nonatomic) NSString    *nameid;

@property (strong, nonatomic) NSIndexPath      *currentInadexpath;
@property (assign, nonatomic) CGFloat    offSetY;
@property (assign, nonatomic) CGRect    headerRect;
@property (assign, nonatomic) int       row;
@property (assign, nonatomic) int       section;
@property (assign, nonatomic) int       cellHeght;


@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) NSInteger  operateIndex;
@end
