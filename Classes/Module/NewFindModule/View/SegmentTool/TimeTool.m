//
//  TimeTool.m
//  podsGolvon
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 suhuilong. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
+(NSString *)string_TimeTransformToTimestamp:(NSString *)time withType:(int)type
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if(type == 1){
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else if(type == 2){
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if(type == 4){
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssss"];
    }
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate * date = [formatter dateFromString:time];
    NSString * nowtimeStr = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return nowtimeStr;
}
@end
