//
//  EmotionTool.h
//  Weibo
//
//  Created by ZHANGMIA on 8/6/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;

@interface EmotionTool : NSObject

+ (void)addRecentEmotion:(Emotion *)emotion;
+ (NSArray *)recentEmotions;

@end
