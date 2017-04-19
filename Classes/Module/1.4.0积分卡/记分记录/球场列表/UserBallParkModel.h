//
//  UserBallParkModel.h
//  podsGolvon
//
//  Created by SHL on 2016/11/10.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBallParkModel : NSObject
//球场id
@property(nonatomic,copy)NSString  *qid;
//球场名
@property(nonatomic,copy)NSString  *qname;
//球场logo
@property(nonatomic,copy)NSString  *qlogo;
//分组title
@property(nonatomic,copy)NSString  *title;

@end
