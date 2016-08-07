//
//  Account.h
//  Weibo
//
//  Created by ZHANGMIA on 7/18/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

/** 用于调用access_token，接口获取授权后的access_token */
@property (nonatomic,copy)NSString *access_token;
/** access_tokende的生命周期，单位是秒数。*/
@property (nonatomic,copy)NSNumber *expires_in;
/** 当前授权用户的UID。*/
@property (nonatomic,copy)NSString *uid;
/** 用户的昵称。*/
@property (nonatomic,copy)NSString *name;
/** access_token帐号的创建时间。*/
@property (nonatomic,strong)NSDate *created_Time;

+ (instancetype)accountWithDic:(NSDictionary *)dic;

@end
