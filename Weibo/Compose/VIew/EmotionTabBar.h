//
//  EmotionTabBar.h
//  Weibo
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  表情键盘底部的选项卡cg

#import <UIKit/UIKit.h>
@class EmotionTabBar;

typedef enum {
    EmotionTabBarButtonTypeRecent, // 最近
    EmotionTabBarButtonTypeDefault, // 默认
    EmotionTabBarButtonTypeEmoji, // emoji
    EmotionTabBarButtonTypeLxh, // 浪小花
}EmotionTabBarButtonType;

@protocol EmotionTabBarDelegate <NSObject>

@optional

- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectBtn:(EmotionTabBarButtonType)buttonType;

@end

@interface EmotionTabBar : UIView

@property (nonatomic,weak)id<EmotionTabBarDelegate> delegate;

@end
