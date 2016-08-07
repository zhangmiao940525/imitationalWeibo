//
//  AccountTool.h
//  Weibo
//
//  Created by ZHANGMIA on 7/18/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
// 业务逻辑

@interface AccountTool : NSObject

/**
 *   存储帐号信息
 *   @param account 帐号模型
 */
+ (void)saveAccount:(Account *)account;

/**
*   返回帐号信息
*   @return 帐号模型 （如果帐号过期，返回nil）
*/
+(Account *)account;

@end
