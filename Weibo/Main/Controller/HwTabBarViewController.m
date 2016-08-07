//
//  HwTabBarViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "HwTabBarViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverTableViewController.h"
#import "ProfileViewController.h"
#import "HwNavigationController.h"
#import "HwTabBar.h"
#import "ComposeViewController.h"

@interface HwTabBarViewController ()<HwTabBarDelegate>

@end

@implementation HwTabBarViewController

+(void)initialize
{
    // 设置整个项目的所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置普通状态 --> text属性
    NSMutableDictionary *textAtr = [NSMutableDictionary dictionary];
    textAtr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAtr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAtr forState:UIControlStateNormal];
    // 设置不可用状态
    NSMutableDictionary *disableTextAtr = [NSMutableDictionary dictionary];
    disableTextAtr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disableTextAtr[NSFontAttributeName] = textAtr[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAtr forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1. 初始化子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    MessageViewController *messageCenter = [[MessageViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    DiscoverTableViewController *discover = [[DiscoverTableViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2. 更换系统自带的tabbar
    //self.tabBar = [[HwTabBar alloc] init];
   /* 上一句和下一句等价 KVC */
    HwTabBar *tabBar = [[HwTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
}
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    // childVc.tabBarItem.title = title; // 设置tabbar的文字
    // childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 声明: 这张图片以后按照原始的样子显示出来，不要自动渲染成其他颜色
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123);
    // 选中字体的颜色
    NSMutableDictionary *SelectTextAttrs = [NSMutableDictionary dictionary];
    SelectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:SelectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装一个导航控制器
    HwNavigationController *nav = [[HwNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - HwTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(HwTabBar *)tabBar
{
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    HwNavigationController *nav = [[HwNavigationController alloc] initWithRootViewController:compose];
    
    [self presentViewController:nav animated:YES completion:nil];
}
@end
