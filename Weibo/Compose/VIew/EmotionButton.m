//
//  EmotionButton.m
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionButton.h"
#import "Emotion.h"

@implementation EmotionButton
/**
 *   当控件不是从xib、storyboard中调用时，就会调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
/**
 *   当控件是从xib、storyboard中调用时，就会调用这个方法
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
       [self setup];
    }
    return self;
}
/**
 *   这个方法在initWithCoder方法后 调用
 */
- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    // 按钮高亮的时候，不要调整图片为灰色
    self.adjustsImageWhenHighlighted = NO;
    
}

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    //
    if (emotion.png) { // 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // emotion.code: 十六进制 --> Emoji字符
        //NSString *emoji = [emotion.code emoji];
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
        
    }

}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    
//}

@end
