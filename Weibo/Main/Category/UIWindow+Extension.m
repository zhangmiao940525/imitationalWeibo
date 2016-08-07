//
//  UIWindow+Extension.m
//  Weibo
//
//  Created by ZHANGMIA on 7/19/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "HwTabBarViewController.h"
#import "NewFeatureViewController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    // 上一次使用的版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号 （从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //
    if ([currentVersion isEqualToString:lastVersion]) {
        self.rootViewController = [[HwTabBarViewController alloc] init];
    } else {
        self.rootViewController = [[NewFeatureViewController alloc] init];
        // 将当前版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
