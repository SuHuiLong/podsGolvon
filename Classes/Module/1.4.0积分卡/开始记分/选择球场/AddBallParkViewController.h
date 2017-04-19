//
//  AddBallParkViewController.h
//  Golvon
//
//  Created by 李盼盼 on 16/8/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearParkModel.h"

typedef void(^createNewPark)(NearParkModel *);

@interface AddBallParkViewController : UIViewController

//球场选择block
@property(nonatomic,strong)createNewPark newPark;

@end
