//
//  AccountTool.m
//  Weibo
//
//  Created by ZHANGMIA on 7/18/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  处理帐号相关的所有操作: 存储帐号 、 取出帐号 、 验证帐号

#import "AccountTool.h"
#import "Account.h"

// 存储帐号的路径
#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool

/*
 存储帐号信息
 account: 帐号模型
 */
+ (void)saveAccount:(Account *)account
{
      // 自定义对象的存储必须用NSKeyedArchive
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}
/*
 返回帐号信息
 帐号模型（如果帐号过期，返回nil）
 */
+ (Account *)account
{
    // 加载模型
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    /* 验证账号是否过期 */
    
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate *expiresTime = [account.created_Time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    return account;
}
@end
