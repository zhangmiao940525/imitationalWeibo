//
//  Status.h
//  Weibo
//
//  Created by ZHANGMIA on 7/19/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  微博模型

#import <Foundation/Foundation.h>
@class User;

@interface Status : NSObject

/** 微博ID */
@property (nonatomic,copy)NSString *idstr;
/** 微博信息的内容 */
@property (nonatomic,copy)NSString *text;

/** 微博作者的用户信息字段 详细 */
@property (nonatomic,strong)User *user;
/** 微博创建时间 */
@property (nonatomic,copy)NSString *created_at;
/** 微博来源 */
@property (nonatomic,copy)NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回"[]" */
@property (nonatomic,strong)NSArray *pic_urls;

/** 被转发的原微博信息字段。 当该微博为转发微博时返回 */
@property (nonatomic,strong)Status *retweeted_status;

/** 转发数 */
@property (nonatomic,assign)int reposts_count;
/** 评论数 */
@property (nonatomic,assign)int comments_count;
/** 表态数 */
@property (nonatomic,assign)int attitudes_count;

@end
