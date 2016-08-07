//
//  Status.m
//  Weibo
//
//  Created by ZHANGMIA on 7/19/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Status.h"
#import "Photo.h"
#import "NSDate+Extension.h"

@implementation Status

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls": [Photo class]};
}

/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */

- (NSString *)created_at
{
    // 转换日期格式类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 真机测试时需要指定locale标识符
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 获取当前时间
    NSDate *now = [NSDate date];
    // 实例化日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalenderUnit 枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天 显示昨天 HH:mm
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) { // 显示 x小时前
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 显示x分钟前
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else { // 显示刚刚
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
    } else {   // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [fmt stringFromDate:createDate];
    }
}

// source == <a href="http://app.weibo.com/t/feed/2llosp" rel="nofollow">OPPO_N1mini</a>

- (void)setSource:(NSString *)source
{
    //NSLog(@"%@",source);
    
    if ([source isEqualToString:@""]) {
        return;
    }
    
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
    
    _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    
    
}


@end
