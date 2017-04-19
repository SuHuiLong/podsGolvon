//
//  FindAceViewController.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/23.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileUtils.h"
#import "StorageManager.h"
#import "CoreDataManager.h"
#import "ViewHistoryData.h"

@interface FindAceViewController : UIViewController

/**
 *  专访时间
 */
@property (strong, nonatomic) UILabel      *timeLabel;
@property (nonatomic, strong) CoreDataManager     *coreDataManager;//coreDataManager

@property (strong, nonatomic) ViewHistoryData      *userCoreData;

@end
