//
//  TimeTool.h
//  podsGolvon
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
+(NSString *)string_TimeTransformToTimestamp:(NSString *)time withType:(int)type;
@end
