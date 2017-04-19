//
//  BallParkViewController.h
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearParkModel.h"
typedef void(^selectPlace)(NearParkModel *);

@interface BallParkViewController : UIViewController

//球场选择block
@property(nonatomic,strong)selectPlace selectPar;




@end
