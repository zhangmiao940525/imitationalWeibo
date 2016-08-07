//
//  EmotionPopView.m
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionPopView.h"
#import "Emotion.h"
#import "EmotionButton.h"

@interface EmotionPopView ()

@property (weak, nonatomic) IBOutlet EmotionButton *emotionBtn;

@end

@implementation EmotionPopView

- (void)showFrom:(EmotionButton *)button
{
    if (button == nil) return;
    // 给popView传递数据
    self.emotionBtn.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:window];
    
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
    
}

// 加载xib
+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}

@end
