//
//  ActivityDetailModel.h
//  podsGolvon
//
//  Created by apple on 2016/12/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *contacts;  //联系人
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *startts;
@property (copy, nonatomic) NSString *joinnum;
@property (copy, nonatomic) NSString *cost;
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) BOOL joinstatr;
@end
