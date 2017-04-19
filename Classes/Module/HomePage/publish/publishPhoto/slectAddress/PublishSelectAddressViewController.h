//
//  PublishSelectAddressViewController.h
//  podsGolvon
//
//  Created by suhuilong on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"
#import "BallParkSelectModel.h"

typedef void(^selectAddress)(BallParkSelectModel *);

@interface PublishSelectAddressViewController : BaseViewController

@property(nonatomic,strong)selectAddress selectAddress;

@property (strong, nonatomic) NSMutableArray    *dataSouce;         //数据

@end
