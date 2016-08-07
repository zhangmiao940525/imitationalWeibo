//
//  AppDelegate.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthViewController.h"
#import "Account.h"
#import "AccountTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  1. 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    //  2.设置根控制器
    Account *account = [AccountTool account];
    
    if (account) { // 之前已经登录成功过
        [self.window switchRootViewController];
    } else {
        self.window.rootViewController = [[OAuthViewController alloc] init];
    }
    
    // 3. 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 1. 取消下载
    [manager cancelAll];
    
    // 2. 清除内存中的所有图片
    [manager.imageCache clearMemory];
}

// 很多重复代码 --> 将重复代码抽取到一个方法中
// 1. 相同的代码放到一个方法中
// 2. 不同的代码变成参数
// 3. 在使用到这段代码的这个地方调用方法，传递参数

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *   当app进入后台时调用
 *
 *   app的状态:
 *   1. 死亡状态: 没有打开app
 *   2. 前台运行状态
 *   3. 后台暂停状态: 停止一切动画 定时器 多媒体 联网操作， 很难再做其他操作
 *   4. 后台运行状态
 */

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 向操作系统申请后台运行的资格，能维持多久是不确定的
   __block  UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
       // 当申请的后台运行时间已经结束（过期），就会调用这个block
       
        // 赶紧结束任务
       [application endBackgroundTask:task];
    }];
    // 在 Info.plist中设置后台模式: Required background modes = App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的mp3文件，没有声音的
    // 循环播放
    
    // 以前的后台模式只要3种: 保持网络连接，多媒体应用， VOIP:网络电话
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//    UIViewController *vc1 = [[UIViewController alloc] init];
//    vc1.tabBarItem.title = @"首页";
//    vc1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
//     // 声明: 这张图片以后按照原始的样子显示出来，不要自动渲染成其他颜色
//    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"]
//                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc1.view.backgroundColor = HWRandomColor;
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123);
//    NSMutableDictionary *SelectTextAttrs = [NSMutableDictionary dictionary];
//    SelectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [vc1.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [vc1.tabBarItem setTitleTextAttributes:SelectTextAttrs forState:UIControlStateSelected];
//
//    UIViewController *vc2 = [[UIViewController alloc] init];
//    vc2.view.backgroundColor = HWRandomColor;
//    vc2.tabBarItem.title = @"消息";
//    vc2.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
//    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_center_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    [vc2.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [vc2.tabBarItem setTitleTextAttributes:SelectTextAttrs forState:UIControlStateSelected];
//
//    UIViewController *vc3 = [[UIViewController alloc] init];
//    vc3.view.backgroundColor =HWRandomColor;
//    vc3.tabBarItem.title = @"发现";
//    vc3.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
//    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [vc3.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [vc3.tabBarItem setTitleTextAttributes:SelectTextAttrs forState:UIControlStateSelected];
//
//
//    UIViewController *vc4 = [[UIViewController alloc] init];
//    vc4.view.backgroundColor = HWRandomColor;
//    vc4.tabBarItem.title = @"我";
//    vc4.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
//    vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [vc4.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [vc4.tabBarItem setTitleTextAttributes:SelectTextAttrs forState:UIControlStateSelected];

// tabbarVC.viewControllers = @[vc1,vc2,vc3,vc4];

@end
