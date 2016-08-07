//
//  Account.m
//  Weibo
//
//  Created by ZHANGMIA on 7/18/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Account.h"

@implementation Account

// 用字典创建一个模型
+ (instancetype)accountWithDic:(NSDictionary *)dic
{
    Account *account = [[self alloc] init];
    account.access_token = dic[@"access_token"];
    account.uid = dic[@"uid"];
    account.expires_in = dic[@"expires_in"];
    // 获得帐号存储的时间 （access_token的产生时间）
    account.created_Time = [NSDate date];

    return account;
}

MJCodingImplementation

///**
// 当一个对象要归档（存）进沙盒时，就会调用这个方法
// 目的: 在这个方法中说明这个对象的哪些属性要存进沙盒
// encoder:编码
// */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.access_token forKey:@"access_token"];
//    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
//    [encoder encodeObject:self.uid forKey:@"uid"];
//    [encoder encodeObject:self.created_Time forKey:@"created_Time"];
//    [encoder encodeObject:self.name forKey:@"name"];
//}
///**
// 当一个对象要解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
// 目的: 在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
// decoder:解码
// */
//- (instancetype)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.access_token = [decoder decodeObjectForKey:@"access_token"];
//        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
//        self.uid = [decoder decodeObjectForKey:@"uid"];
//        self.created_Time = [decoder decodeObjectForKey:@"created_Time"];
//        self.name = [decoder decodeObjectForKey:@"name"];
//    }
//    return self;
//}

@end
