//
//  SlectMarksViewController.h
//  Golvon
//
//  Created by shiyingdong on 16/4/27.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)(NSArray*);

@class SlectMarksViewController;

@protocol SelectedMarksDelegate <NSObject>

-(void)chooseMarks:(NSMutableArray *)MarkArr;

@end

@interface SlectMarksViewController : UIViewController

@property (nonatomic,copy)backBlock back;
@property(nonatomic,copy)NSString *lableName;
@property(nonatomic,copy)NSArray *SelectMarkArry;

@property(nonatomic,strong)NSMutableArray *SelectMarkTitleArry;

@property(nonatomic,strong)NSMutableArray *markArry;
@property(nonatomic,strong)NSMutableArray *markTextArry;

@property (weak, nonatomic) id<SelectedMarksDelegate> delegate;

@end
