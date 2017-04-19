//
//  RecomModel.h
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildRecomModel.h"
#import "RecomInteModel.h"
#import "RecomInformModel.h"

@interface RecomModel : NSObject

@property (copy, nonatomic) NSMutableArray<ChildRecomModel*>    *recommend;
@property (copy, nonatomic) NSMutableArray<RecomInteModel*>    *inte;
@property (copy, nonatomic) NSMutableArray<RecomInformModel*>    *information;


@end
