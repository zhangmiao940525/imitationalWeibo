//
//  EmotionPageView.m
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionPageView.h"
#import "Emotion.h"
#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "EmotionTool.h"

@interface EmotionPageView ()

/** 点击表情按钮后弹出的放大镜 */
@property (nonatomic,strong)EmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic,weak)UIButton *deleteBtn;

@end

@implementation EmotionPageView

- (EmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [EmotionPopView popView];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. 删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        // 添加监听
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        // 2. 添加长按手势
        UIGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}
/**
 根据手指的位置找出所在的表情按钮
 */
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            
            // 已经找到手指所在的表情按钮了，没必要再往下遍历
            return btn;
        }
    }
    return nil;
}

/**
 在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    // 获得手指所在的表情按钮的位置
    CGPoint location = [recognizer locationInView:recognizer.view];
    EmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: //手指已经不在触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectedEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始
        case UIGestureRecognizerStateChanged:{ // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
        default:
            break;
    }
}

/**
 监听删除按钮点击
 */
- (void)deleteClick
{
    /**
     notificationName: The name of the notification.
     notificationSender: The object posting the notification
     */
    [NotificationCenter postNotificationName:EmotionDidDeletedNotification object:nil];
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    //NSLog(@"emotions = %zd",emotions.count);
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton *btn = [[EmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = emotions[i];
        
        // 监听按钮的点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// CUICatalog: Invalid asset name supplied: (null)
// 警告原因: 尝试去加载的图片不存在

- (void)layoutSubviews
{
    [super layoutSubviews];
    //内边距（四周）
    CGFloat inset = 5;
    NSUInteger count = self.emotions.count;
    
    CGFloat btnW = (self.width - 2 * inset) / EmotionMaxCols;
    CGFloat btnH = (self.height - inset) / EmotionMaxRows;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % EmotionMaxCols) * btnW;
        btn.y = inset + (i / EmotionMaxCols) * btnH;
        
    }
    
    // 删除按钮
    self.deleteBtn.width = btnW;
    self.deleteBtn.height = btnH;
    self.deleteBtn.x = self.width - 1.3 * inset - btnW;
    self.deleteBtn.y = self.height - btnH;
}
/**
 监听表情按钮的点击
 btn: 被点击的按钮
 */
- (void)btnClick:(EmotionButton *)btn
{
    // 显示popView
    [self.popView showFrom:btn];
    
    //等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    // 发出通知
    [self selectedEmotion:btn.emotion];

}

/**
 选中某个表情，发出通知
 emotion: 选中的表情
 */
- (void)selectedEmotion:(Emotion *)emotion
{
    // 将这个表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SelectedEmotionKey] = emotion;
    [NotificationCenter postNotificationName:EmotionDidSelectedNotification object:nil userInfo:userInfo];
}

@end
