//
//  HwNavigationController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "HwNavigationController.h"

@interface HwNavigationController ()

@end

@implementation HwNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}
/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这里push进来的viewController，不是第一个根控制器
        // 自动隐藏和显示tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highlightedImage:@"navigationbar_back_highlighted"];
        // 设置右边的更多按钮
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highlightedImage:@"navigationbar_more_highlighted"];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    /* 这里要用self，不是self.navigationController */
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
