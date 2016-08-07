//
//  HwTabBar.h
//  Weibo
//
//  Created by ZHANGMIA on 7/15/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HwTabBar;
/* HwTabBar继承自UITabBar，所以成为HwTabBar的代理， 也必须实现UITabBar的代理协议 */

@protocol HwTabBarDelegate <UITabBarDelegate>
@optional

- (void)tabBarDidClickPlusButton:(HwTabBar *)tabBar;

@end

@interface HwTabBar : UITabBar

@property (nonatomic,weak) id<HwTabBarDelegate> delegate;

@end
