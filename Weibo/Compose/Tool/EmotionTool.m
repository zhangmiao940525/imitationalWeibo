//
//  EmotionTool.m
//  Weibo
//
//  Created by ZHANGMIA on 8/6/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

// 最近表情的存储帐号的路径
#define RencentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotion.archive"]

#import "EmotionTool.h"
#import "Emotion.h"

@implementation EmotionTool

static NSMutableArray *_recentEmotions;

+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RencentEmotionPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+ (void)addRecentEmotion:(Emotion *)emotion
{

    // 删除重复的表情
    [_recentEmotions removeObject:emotion];
    
    // 将表情放在数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RencentEmotionPath];
}

/**
 返回装着Emotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}

// 加载沙盒中的表情数据
//    NSMutableArray *emotions = (NSMutableArray *)[self recentEmotions];
//
//    if (emotions == nil) {
//        emotions = [NSMutableArray array];
//    }
//
//    for (int i = 0; i < emotions.count; i++) {
//        Emotion *e = emotions[i];
//        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString: emotion.code]) {
//            [emotions removeObject:e];
//            break;
//        }
//    }

//    for (Emotion *e in emotions) {
//        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString: emotion.code]) {
//            [emotions removeObject:e];
//            break;
//
//        }

@end
