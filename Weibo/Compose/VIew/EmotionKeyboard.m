//
//  EmotionKeyboard.m
//  Weibo
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "Emotion.h"
#import "EmotionTool.h"

@interface EmotionKeyboard ()<EmotionTabBarDelegate>
/** 容纳表情内容的控件 */
//@property (nonatomic,weak)UIView *contentView;
/** 保存正在显示的listView */
@property (nonatomic,weak)EmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic,strong)EmotionListView *recentListView;
@property (nonatomic,strong)EmotionListView *defaultListView;
@property (nonatomic,strong)EmotionListView *emojiListView;
@property (nonatomic,strong)EmotionListView *lxhListView;

/** tabBar */
@property (nonatomic,weak)EmotionTabBar *tabBar;

@end

@implementation EmotionKeyboard

#pragma mark - 懒加载

- (EmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[EmotionListView alloc] init];
        // 加载沙盒数据
        self.recentListView.emotions =  [EmotionTool recentEmotions];
    }
    return _recentListView;
}

- (EmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        // 面向字典转为面向模型(字典数组 --> 模型数组)
        self.defaultListView.emotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}

- (EmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        // 面向字典转为面向模型(字典数组 --> 模型数组)
        self.emojiListView.emotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}

- (EmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        // 面向字典转为面向模型(字典数组 --> 模型数组)
        self.lxhListView.emotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}

#pragma mark -  初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. tabbar
        EmotionTabBar *tabBar = [[EmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 表情选中的通知
        [NotificationCenter addObserver:self selector:@selector(emotionDidSelect) name:EmotionDidSelectedNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelect
{
    self.recentListView.emotions = [EmotionTool recentEmotions];
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
       [super layoutSubviews];
    
    // 1. tabBar
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = self.width;
    
    // 2. 表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    
//    // 2. 表情内容
//    self.contentView.x = self.contentView.y = 0;
//    self.contentView.width = self.width;
//    self.contentView.height = self.tabBar.y;
//    
//    // 3. 设置listView的尺寸
//    UIView *child = [self.contentView.subviews lastObject];
//    child.frame = self.contentView.bounds;
    
    
}

#pragma mark - EmotionTabBar代理
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectBtn:(EmotionTabBarButtonType)buttonType
{
    // 移除contenView之前显示的控件 makeObjectsPerformSelector是让数组中的每个元素都调用removeFromSuperview方法
    //[self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换contentView上面的listView
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent:{ // 最近
            [self addSubview:self.recentListView];
            break;
        }
        case EmotionTabBarButtonTypeDefault:{ // 默认
            [self addSubview:self.defaultListView];
            break;
        }
        case EmotionTabBarButtonTypeEmoji:{ // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
        case EmotionTabBarButtonTypeLxh:{ // 浪小花
            [self addSubview:self.lxhListView];
            break;
        }
        default:
            break;
    }
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
//    // 重新计算子控件的frame(setNeedsLayout会自动调用layoutSubviews)
    [self setNeedsLayout];
}

@end
