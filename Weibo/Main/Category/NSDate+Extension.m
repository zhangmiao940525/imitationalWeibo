//
//  NSDate+Extension.m
//  Weibo
//
//  Created by ZHANGMIA on 7/30/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

// 判断某个时间是否为今年
- (BOOL)isThisYear
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得年
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year == nowCmps.year;
}

// 判断某个时间是否昨天
- (BOOL)isYesterday
{
    // 获取现在的时间
    NSDate *now = [NSDate date];
    
    // date 2016-07-30 10:06:27 --> 2016-07-30  --> 2016-07-30 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 转换日期格式为字符串 yyyy-MM-dd
    NSString *dateStr = [fmt stringFromDate:self]; // 2016-07-30
    NSString *nowStr = [fmt stringFromDate:now];  // 2016-07-30
    
    // 转换字符串格式为日期 yyyy-MM-dd 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得年月日
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

// 判断某个时间是否为今天
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    //将日期转换为字符串
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}


@end
