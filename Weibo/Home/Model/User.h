//
//  User.h
//  Weibo
//
//  Created by ZHANGMIA on 7/19/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>

typedef enum {
    UserVerifiedTypeNone = -1, // 没有任何认证
    UserVerifiedPersonal = 0, // 个人认证
    UserVerifiedOrgEnterprice = 2, // 企业官方认证
    UserVerifiedOrgMedia = 3, // 媒体官方认证
    UserVerifiedOrgWebsite = 5, // 网站官方认证
    UserVerifiedDaren = 220 // 微博达人
    
} UserVerifiedType;

@interface User : NSObject

/** 字符串型的用户UID */
@property (nonatomic,copy)NSString *idstr;
/** 用户名称 */
@property (nonatomic,copy)NSString *name;
/** 用户头像地址，50x50像素 */
@property (nonatomic,copy)NSString *profile_image_url;
/** 会员类型 值 > 2 才代表是会员*/
@property (nonatomic,assign)int mbtype;
/** 会员等级 */
@property (nonatomic,assign)int mbrank;

@property (nonatomic,assign, getter=isVip)BOOL vip;
/** 认证类型 */
@property (nonatomic,assign)UserVerifiedType verified_type;

@end
