//
//  EmotionAttachment.m
//  Weibo
//
//  Created by ZHANGMIA on 8/6/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//


#import "EmotionAttachment.h"
#import "Emotion.h"

@implementation EmotionAttachment

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}

@end
