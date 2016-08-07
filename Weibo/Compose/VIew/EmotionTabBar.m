//
//  EmotionTabBar.m
//  Weibo
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionTabBar.h"
#import "EmotionTabBarButton.h"

@interface EmotionTabBar()

@property (nonatomic,weak)EmotionTabBarButton *selectedBtn;

@end

@implementation EmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:EmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:EmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:EmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:EmotionTabBarButtonTypeLxh];
    }
    return self;
}
/**
 *   创建一个按钮
 *
 *   @param title 按钮文字
 */
- (EmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(EmotionTabBarButtonType)buttonType
{
    // 创建按钮
    EmotionTabBarButton *btn = [[EmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn setTitle:title forState:UIControlStateNormal];
    // 添加按钮
    [self addSubview:btn];
    // 
    btn.tag = buttonType;
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if(self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        EmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)setDelegate:(id<EmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    // 选中“默认”按钮
    [self btnClick:(EmotionTabBarButton *)[self viewWithTag:EmotionTabBarButtonTypeDefault]];
}

/**
 按钮点击
 */
- (void)btnClick:(EmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectBtn:)])
    {
        [self.delegate emotionTabBar:self didSelectBtn:(EmotionTabBarButtonType)btn.tag];
    }
}

@end
